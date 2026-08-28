# Contributing

Thanks for improving the `recursive-decomposition` skill.

> Rules live in [CONVENTIONS.md](./CONVENTIONS.md). Agent entrypoint: [AGENTS.md](./AGENTS.md).

## Before you start

1. Read CONVENTIONS.md.
2. Branch from an up-to-date `main`: `fix/...`, `feat/...`, `docs/...`.
3. Confirm the toolchain: bash, jq, Node 22 (`npx`), `claude` CLI (optional, for `claude plugin validate`).

## What to contribute

| Welcome | Needs an issue first |
|---------|----------------------|
| Corrections that cite the paper or a reproducible test | Changing the protocol or the thresholds |
| New worked examples under `references/` | Adding executable scripts to the skill |
| Shorter, clearer wording | Splitting the skill into several skills |
| Agent-specific notes that stay out of the skill body | Non-English content |

## Verify

```bash
bash .github/scripts/validate-skill.sh
npx -y skills@latest add . -l
claude plugin validate .
```

## Pull request

- One topic per PR.
- English description: what changed and the source of every new claim.
- CI must be green.

## License

Contributions are licensed under the repository [MIT license](./LICENSE).
