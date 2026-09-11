# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.2.0] - 2026-09-11

### Added

- Added a PDF path: anydoc first, then Firecrawl parse for OCR.
- Added a 63 MB eval submodule (tccao/mortgage-doc-rag, 131 PDFs) and a bash scorer.

### Changed

- Triggered on dense work even when the input fits the window.
- Capped recursion at depth 1: sub-agents answer and do not spawn sub-agents.

## [1.1.0] - 2026-08-28

### Added

- Added the skills CLI install path, the bash validator and the GitHub Actions workflow.
- Added CONVENTIONS.md, CHANGELOG.md and a short AGENTS.md; CLAUDE.md is now a symlink to it.
- Added the social preview image, its HTML source and light and dark logo variants under assets/.

### Changed

- Moved the skill to the root plugin layout: `skills/recursive-decomposition/` with the plugin manifest at the repository root.
- Rewrote SKILL.md with a trigger-based description, a six-step protocol, rules and agent-agnostic tool names.
- Restructured the README around install, usage, how it works and acknowledgments.

### Removed

- Removed the `plugins/` directory and the plugin README.

## [1.0.1] - 2026-01-25

### Fixed

- Corrected the skill structure and the YAML frontmatter.

## [1.0.0] - 2026-01-16

### Added

- Initial release of the recursive-decomposition skill and its references.
