# Setup Guide for Publishing

This guide covers the manual steps needed to publish the Recursive Decomposition Skill to GitHub.

---

## Pre-Publication Checklist

### 1. Create the Logo

You need a logo for `assets/logo.png`. Options:

**Option A: Generate with AI**
```
Prompt for image generation:
"A minimalist logo showing recursive branching patterns,
like a tree splitting into smaller trees.
Purple and blue gradient colors.
Clean, modern, tech aesthetic.
Square format, transparent background."
```

**Option B: Use a simple SVG**
Create `assets/logo.svg` with nested squares or fractal pattern.

**Option C: Text-based placeholder**
Use a tool like [shields.io](https://shields.io) to create a badge-style logo.

**Dimensions:** 200x200px minimum, square aspect ratio

---

### 2. Create GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Repository name: `recursive-decomposition-skill`
3. Description: `Claude Code skill for handling long-context tasks through recursive decomposition`
4. Visibility: **Public**
5. Do NOT initialize with README (we have one)
6. Click **Create repository**

---

### 3. Push to GitHub

```bash
cd ~/recursive-decomposition-skill

# Initialize git
git init

# Add all files
git add .

# Initial commit
git commit -m "Initial release: Recursive Decomposition Skill v1.0.0

Based on Recursive Language Models paper (arXiv:2512.24601)
- Core SKILL.md with decomposition strategies
- Reference files for detailed patterns
- Example walkthroughs for codebase and document analysis

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"

# Add remote (replace massimodeluisa)
git remote add origin https://github.com/massimodeluisa/recursive-decomposition-skill.git

# Push
git branch -M main
git push -u origin main
```

---

### 4. Update README with Your Username

After creating the repo, update the README.md:

```bash
# Replace YOUR_GITHUB_USERNAME with your actual username
sed -i '' 's/YOUR_GITHUB_USERNAME/YOUR_ACTUAL_USERNAME/g' README.md
git add README.md
git commit -m "Update GitHub username in README"
git push
```

---

### 5. Screenshots to Capture

For a professional README, capture these screenshots:

#### Screenshot 1: Installation Success
```bash
claude plugin marketplace add massimodeluisa/recursive-decomposition-skill
claude plugin install recursive-decomposition@recursive-decomposition
```
**Capture:** Terminal showing successful installation message

#### Screenshot 2: Skill in Action
Run a test task:
```
"Analyze all Python files in this project for error handling patterns"
```
**Capture:** Claude's response showing recursive decomposition in action

#### Screenshot 3: Plugin List
```bash
claude plugin list
```
**Capture:** Shows recursive-decomposition installed

**Where to save:** `assets/screenshots/`

**Add to README:** Insert after the "What It Does" section:
```markdown
<p align="center">
  <img src="assets/screenshots/skill-in-action.gif" alt="Skill Demo" width="700">
</p>
```

---

### 6. Create a Release

1. Go to your repo → **Releases** → **Create a new release**
2. Tag: `v1.0.0`
3. Title: `v1.0.0 - Initial Release`
4. Description:
```markdown
## Recursive Decomposition Skill v1.0.0

First public release of the Recursive Decomposition Skill for Claude Code.

### Features
- Core decomposition strategies based on RLM research
- Automatic triggering for long-context tasks
- Parallel sub-agent execution
- Cost-performance optimization guidance

### Based On
[Recursive Language Models](https://arxiv.org/abs/2512.24601) (Zhang, Kraska, Khattab 2025)

### Installation
```bash
claude plugin marketplace add massimodeluisa/recursive-decomposition-skill
claude plugin install recursive-decomposition@recursive-decomposition
```
```

5. Click **Publish release**

---

### 7. Optional: Add Topics/Tags

On your repo page, click the gear icon next to "About" and add topics:
- `claude-code`
- `ai-agents`
- `llm`
- `recursive-decomposition`
- `long-context`
- `skills`

---

### 8. Test Installation from GitHub

After publishing, test the full flow:

```bash
# Remove local installation if exists
claude plugin uninstall recursive-decomposition

# Install from GitHub
claude plugin marketplace add massimodeluisa/recursive-decomposition-skill
claude plugin install recursive-decomposition@recursive-decomposition

# Restart Claude Code
# Then test with a task
```

---

## Verification Checklist

- [ ] Logo exists at `assets/logo.png`
- [ ] GitHub repo created and public
- [ ] All files pushed successfully
- [ ] README displays correctly on GitHub
- [ ] Installation works via marketplace
- [ ] Skill triggers on appropriate tasks
- [ ] Release created with tag v1.0.0

---

## Troubleshooting

### Plugin not found after install
Restart Claude Code completely (not just the conversation).

### Skill doesn't trigger
Check that your task description includes trigger phrases like:
- "analyze all files"
- "aggregate information"
- "search across the codebase"

### Marketplace add fails
Ensure the repo is public and the `.claude-plugin/marketplace.json` is valid JSON.

---

## File Locations Summary

```
~/recursive-decomposition-skill/     # Your local project
├── README.md                        # Update YOUR_GITHUB_USERNAME
├── assets/
│   └── logo.png                     # CREATE THIS
└── ...

GitHub: github.com/massimodeluisa/recursive-decomposition-skill
```
