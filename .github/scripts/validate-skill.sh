#!/usr/bin/env bash
# Validates the recursive-decomposition skill tree: frontmatter, size, links, manifests, prose.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/recursive-decomposition"
skill="$skill_dir/SKILL.md"
errors=0

fail() {
  printf 'ERROR: %s\n' "$1"
  errors=$((errors + 1))
}

if [ ! -f "$skill" ]; then
  fail "skills/recursive-decomposition/SKILL.md: missing"
else
  name="$(sed -n 's/^name: //p' "$skill" | head -1)"
  [ "$name" = "recursive-decomposition" ] || fail "SKILL.md: name must be recursive-decomposition (got '$name')"
  description="$(sed -n 's/^description: //p' "$skill" | head -1)"
  [ -n "$description" ] || fail "SKILL.md: description missing"
  case "$description" in
    \"*\") ;;
    *) fail "SKILL.md: description must be one double-quoted line" ;;
  esac
  length="$(printf '%s' "$description" | wc -m | tr -d ' ')"
  [ "$length" -le 1026 ] || fail "SKILL.md: description is $length chars, limit 1024"
  lines="$(wc -l < "$skill" | tr -d ' ')"
  [ "$lines" -lt 500 ] || fail "SKILL.md: $lines lines, must stay under 500"
  skill_version="$(sed -n 's/^  version: "\(.*\)"$/\1/p' "$skill" | head -1)"
  grep -o '\]([^)]*)' "$skill" | sed 's/^](//; s/)$//' | grep -v -E '^(https?://|#|mailto:)' | while read -r link; do
    [ -e "$skill_dir/${link%%#*}" ] || printf 'ERROR: SKILL.md: broken link %s\n' "$link"
  done | tee /tmp/validate-links.txt
  if [ -s /tmp/validate-links.txt ]; then errors=$((errors + $(wc -l < /tmp/validate-links.txt))); fi
fi

for manifest in "$root/.claude-plugin/plugin.json" "$root/.claude-plugin/marketplace.json"; do
  if [ ! -f "$manifest" ]; then
    fail "${manifest#"$root"/}: missing"
  elif ! jq . "$manifest" > /dev/null 2>&1; then
    fail "${manifest#"$root"/}: invalid JSON"
  fi
done
if [ -f "$root/.claude-plugin/plugin.json" ] && [ -f "$root/.claude-plugin/marketplace.json" ]; then
  plugin_name="$(jq -r '.name' "$root/.claude-plugin/plugin.json")"
  [ "$plugin_name" = "recursive-decomposition" ] || fail "plugin.json: name must be recursive-decomposition"
  plugin_version="$(jq -r '.version' "$root/.claude-plugin/plugin.json")"
  [ "${skill_version:-}" = "" ] || [ "$skill_version" = "$plugin_version" ] || fail "SKILL.md metadata.version ($skill_version) and plugin.json version ($plugin_version) differ"
  source="$(jq -r '.plugins[0].source' "$root/.claude-plugin/marketplace.json")"
  [ "$source" = "./" ] || fail "marketplace.json: plugins[0].source must be ./"
  entries="$(jq '.plugins | length' "$root/.claude-plugin/marketplace.json")"
  [ "$entries" = "1" ] || fail "marketplace.json: exactly one plugin entry expected"
  [ "$(jq '.plugins[0] | has("version")' "$root/.claude-plugin/marketplace.json")" = "false" ] || fail "marketplace.json: the plugin entry must not pin a version"
fi

for doc in "$root"/README.md "$root"/AGENTS.md "$root"/CONVENTIONS.md "$root"/CONTRIBUTING.md "$root"/CHANGELOG.md "$skill" "$skill_dir"/references/*.md; do
  [ -f "$doc" ] || continue
  if grep -q $'\xe2\x80\x94' "$doc"; then fail "${doc#"$root"/}: contains an em dash (U+2014)"; fi
done

if [ "$errors" -gt 0 ]; then
  exit 1
fi
printf 'OK\n'
