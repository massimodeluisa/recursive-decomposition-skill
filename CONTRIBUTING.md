# Contributing to Recursive Decomposition Skills

We welcome contributions! This implementation of recursive decomposition strategies for Claude Code is open for improvements.

## Development Workflow

1.  **Fork & Clone**: Start by forking the repository.
2.  **Plugin Structure**: Understanding the `plugins/` directory layout.
3.  **Creating Skills**: Guidelines for writing `SKILL.md` files (clear triggers, concise instructions).

## Testing Changes

Before submitting, you **must** test your changes locally:

```bash
# Load the plugin from your local directory
claude --plugin-dir ./plugins/recursive-decomposition
```

- Verify that the skill triggers when appropriate (e.g., "analyze these 20 files").
- Verify that the decomposition strategy works as expected.

## Submission Guidelines

- **One Skill Per Pull Request**: Keep PRs focused.
- **Documentation**: Ensure `SKILL.md` frontmatter is correct.
- **Examples**: Provide a walkthrough in `examples/` if adding a complex new strategy.

## Code of Conduct

Be respectful and constructive.
