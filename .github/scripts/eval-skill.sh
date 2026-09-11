#!/usr/bin/env bash
# Check eval fixtures and gold, or score an iteration directory of agent runs.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/recursive-decomposition"
evals_dir="$skill_dir/evals"
pdf_corpus="$evals_dir/files/mortgage-doc-rag"
errors=0

fail() {
  printf 'ERROR: %s\n' "$1"
  errors=$((errors + 1))
}

warn() {
  printf 'SKIP: %s\n' "$1"
}

require_json() {
  if [ ! -f "$1" ]; then
    fail "${1#"$root"/}: missing"
    return 1
  fi
  if ! jq . "$1" > /dev/null 2>&1; then
    fail "${1#"$root"/}: invalid JSON"
    return 1
  fi
  return 0
}

check_trigger_queries() {
  local f="$evals_dir/trigger-queries.json"
  require_json "$f" || return
  local n yes no
  n="$(jq '.queries | length' "$f")"
  yes="$(jq '[.queries[] | select(.should_trigger == true)] | length' "$f")"
  no="$(jq '[.queries[] | select(.should_trigger == false)] | length' "$f")"
  [ "$n" -ge 20 ] || fail "trigger-queries.json: want at least 20 queries, got $n"
  [ "$yes" -ge 10 ] || fail "trigger-queries.json: want at least 10 should-trigger, got $yes"
  [ "$no" -ge 10 ] || fail "trigger-queries.json: want at least 10 should-not-trigger, got $no"
}

check_evals_json() {
  local f="$evals_dir/evals.json"
  require_json "$f" || return
  [ "$(jq -r '.skill_name' "$f")" = "recursive-decomposition" ] || fail "evals.json: skill_name must be recursive-decomposition"
  local count
  count="$(jq '.evals | length' "$f")"
  [ "$count" -ge 1 ] || fail "evals.json: want at least 1 task, got $count"
}

check_pdf_corpus() {
  if [ ! -d "$pdf_corpus" ] || [ -z "$(find "$pdf_corpus" -iname '*.pdf' -print -quit 2>/dev/null)" ]; then
    warn "PDF submodule not initialised (git submodule update --init --depth 1 skills/recursive-decomposition/evals/files/mortgage-doc-rag)."
    return
  fi
  local gold="$evals_dir/gold/pdf-corpus.json"
  require_json "$gold" || return
  local min count bytes min_bytes largest
  min="$(jq -r '.min_pdfs' "$gold")"
  min_bytes="$(jq -r '.min_bytes' "$gold")"
  largest="$(jq -r '.largest_suffix' "$gold")"
  count="$(find "$pdf_corpus" -type f -iname '*.pdf' | wc -l | tr -d ' ')"
  bytes="$(find "$pdf_corpus" -type f -iname '*.pdf' -print0 | xargs -0 wc -c | tail -1 | awk '{print $1}')"
  [ "$count" -ge "$min" ] || fail "pdf corpus: want at least $min PDFs, found $count"
  [ "$bytes" -ge "$min_bytes" ] || fail "pdf corpus: want at least $min_bytes bytes, found $bytes"
  find "$pdf_corpus" -type f -name "$largest" | grep -q . || fail "pdf corpus: missing largest file $largest"
}

check() {
  check_trigger_queries
  check_evals_json
  require_json "$evals_dir/gold/pdf-corpus.json"
  check_pdf_corpus
  if [ "$errors" -gt 0 ]; then
    exit 1
  fi
  printf 'OK\n'
}

score_protocol() {
  local result="$1"
  local kind="$2"
  local mode="$3"
  [ "$mode" = "with_skill" ] || return 0
  local decomposed depth spawn
  decomposed="$(jq -r '.decomposed' "$result")"
  if [ "$kind" = "decompose" ]; then
    [ "$decomposed" = "true" ] || fail "${result#"$root"/}: decomposed should be true"
    depth="$(jq -r '.depth' "$result")"
    [ "$depth" = "1" ] || fail "${result#"$root"/}: depth should be 1, got $depth"
  fi
  spawn="$(jq -r '.subagents_spawned_subagents // false' "$result")"
  [ "$spawn" = "false" ] || fail "${result#"$root"/}: sub-agents must not spawn sub-agents"
}

score_pdf() {
  local result="$1"
  local gold="$evals_dir/gold/pdf-corpus.json"
  [ -f "$gold" ] || return
  local min count
  min="$(jq -r '.min_pdfs' "$gold")"
  count="$(jq -r '.pdf_count' "$result")"
  case "$count" in
    ''|null) fail "${result#"$root"/}: pdf_count missing" ;;
    *) [ "$count" -ge "$min" ] || fail "${result#"$root"/}: pdf_count $count < $min" ;;
  esac
  local suffix
  suffix="$(jq -r '.largest_suffix' "$gold")"
  jq -e --arg s "$suffix" '[.largest[]? | .path | endswith($s)] | any' "$result" > /dev/null \
    || fail "${result#"$root"/}: largest list should include $suffix"
}

score_one() {
  local name="$1"
  local kind="$2"
  local mode="$3"
  local result="$4"
  local optional="$5"
  local before="$errors"
  if [ ! -f "$result" ]; then
    if [ "$optional" = "true" ]; then
      printf '%s\t%s\tSKIP\n' "$name" "$mode"
      return
    fi
    if [ "$mode" = "with_skill" ]; then
      fail "missing $mode run for $name ($result)"
      printf '%s\t%s\tFAIL\n' "$name" "$mode"
    else
      warn "no $mode run for $name"
      printf '%s\t%s\tSKIP\n' "$name" "$mode"
    fi
    return
  fi
  if ! jq . "$result" > /dev/null 2>&1; then
    fail "${result#"$root"/}: invalid JSON"
  else
    score_protocol "$result" "$kind" "$mode"
    case "$name" in
      pdf-corpus) score_pdf "$result" ;;
    esac
  fi
  if [ "$errors" -gt "$before" ]; then
    printf '%s\t%s\tFAIL\n' "$name" "$mode"
  else
    printf '%s\t%s\tPASS\n' "$name" "$mode"
  fi
}

score() {
  local iter="${1:-}"
  if [ -z "$iter" ] || [ ! -d "$iter" ]; then
    printf 'usage: eval-skill.sh score <iteration-dir>\n' >&2
    exit 2
  fi
  require_json "$evals_dir/evals.json" || exit 1
  printf 'task\tmode\tresult\n'
  local n i name kind mode result optional
  local with_fail=0
  n="$(jq '.evals | length' "$evals_dir/evals.json")"
  i=0
  while [ "$i" -lt "$n" ]; do
    name="$(jq -r ".evals[$i].name" "$evals_dir/evals.json")"
    kind="$(jq -r ".evals[$i].kind" "$evals_dir/evals.json")"
    optional="$(jq -r '.evals['"$i"'].optional // false' "$evals_dir/evals.json")"
    for mode in with_skill without_skill; do
      result="$iter/eval-$name/$mode/outputs/result.json"
      errors=0
      score_one "$name" "$kind" "$mode" "$result" "$optional"
      if [ "$errors" -gt 0 ] && [ "$mode" = "with_skill" ] && [ "$optional" != "true" ]; then
        with_fail=$((with_fail + 1))
      fi
    done
    i=$((i + 1))
  done
  if [ "$with_fail" -gt 0 ]; then
    printf 'FAIL with_skill tasks: %s\n' "$with_fail"
    exit 1
  fi
  printf 'OK with_skill\n'
}

case "${1:-check}" in
  check) check ;;
  score) score "${2:-}" ;;
  *)
    printf 'usage: eval-skill.sh check | score <iteration-dir>\n' >&2
    exit 2
    ;;
esac
