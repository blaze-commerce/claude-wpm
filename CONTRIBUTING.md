# Contributing to Claude-WPM

Guidelines for maintaining a clean, professional Git history.

---

## Branch Naming

```
<type>/<short-description>
```

| Type | Use For | Example |
|------|---------|---------|
| `feature/` | New functionality | `feature/add-checkout-tests` |
| `fix/` | Bug fixes | `fix/cart-selector-timeout` |
| `hotfix/` | Urgent production fixes | `hotfix/security-patch` |
| `docs/` | Documentation only | `docs/update-readme` |
| `refactor/` | Code restructure (no new features) | `refactor/simplify-selectors` |
| `test/` | Adding/updating tests | `test/add-safari-coverage` |
| `chore/` | Maintenance, dependencies | `chore/update-playwright` |

**Examples:**
```bash
git checkout -b feature/add-new-skill
git checkout -b fix/hook-regex-error
git checkout -b docs/update-contributing
```

---

## Commit Messages (Conventional Commits)

We follow the [Conventional Commits](https://www.conventionalcommits.org/) standard.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(skills): add caching-optimizer skill` |
| `fix` | Bug fix | `fix(hooks): correct wp-config regex` |
| `docs` | Documentation | `docs(readme): add install command` |
| `style` | Formatting only | `style: fix indentation in selectors.ts` |
| `refactor` | Code restructure | `refactor(qa): simplify test fixtures` |
| `test` | Tests | `test(qa): add Safari checkout coverage` |
| `chore` | Maintenance | `chore: update dependencies` |
| `perf` | Performance | `perf(hooks): optimize file matching` |
| `ci` | CI/CD changes | `ci: add deploy-report workflow` |

### Scope (Optional)

The scope indicates which part of the codebase is affected:

| Scope | Area |
|-------|------|
| `qa` | QA testing framework |
| `hooks` | Safety hooks |
| `skills` | Specialist prompts |
| `commands` | CLI commands |
| `scripts` | Shell scripts |
| `readme` | README documentation |
| `plans` | Planning documents |

### Examples

```bash
# Simple feature
git commit -m "feat(qa): add checkout flow tests"

# Bug fix with scope
git commit -m "fix(hooks): correct regex for wp-config blocking"

# Documentation
git commit -m "docs(readme): add Claude Code install command"

# Chore without scope
git commit -m "chore: update Playwright to v1.42"

# With body for more context
git commit -m "fix(qa): resolve cart selector timeout

The cart table selector was too specific for themes with custom markup.
Updated to use more generic WooCommerce class selectors.

Closes #42"
```

### Quick Reference

```
feat:     New feature
fix:      Bug fix
docs:     Documentation
style:    Formatting (no code change)
refactor: Code restructure
test:     Tests
chore:    Maintenance
perf:     Performance
ci:       CI/CD
```

---

## Semantic Versioning

Releases follow [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH
```

| Version | When to Increment | Example |
|---------|-------------------|---------|
| **MAJOR** | Breaking changes | `v1.0.0` → `v2.0.0` |
| **MINOR** | New features (backwards compatible) | `v1.0.0` → `v1.1.0` |
| **PATCH** | Bug fixes only | `v1.0.0` → `v1.0.1` |

### Examples

| Change | Version Bump | New Version |
|--------|--------------|-------------|
| Initial release | - | `v1.0.0` |
| Fixed hook regex bug | PATCH | `v1.0.1` |
| Added new skill | MINOR | `v1.1.0` |
| Restructured entire folder layout | MAJOR | `v2.0.0` |

### When to Create a Release

**IMPORTANT:** Always create a new release after:
- **Critical bug fixes** (script failures, data loss risks) → Immediate PATCH release
- **Security fixes** → Immediate PATCH release
- **New features** → MINOR release when ready
- **Breaking changes** → MAJOR release

If you fix a bug in a script (like `update-premium-plugins.sh`) that could affect production sites, **create a patch release immediately** so users can pull the fix.

### Creating a Release

```bash
# 1. Ensure main is up to date
git checkout main
git pull origin main

# 2. Create annotated tag
git tag -a v1.1.0 -m "Release v1.1.0 - Added performance optimizer skill"

# 3. Push tag (triggers GitHub Actions to build deploy zip)
git push origin v1.1.0

# 4. Create GitHub Release with gh CLI
gh release create v1.1.0 --title "v1.1.0" --notes "Release notes here"

# Or go to GitHub Releases to add release notes manually
```

---

## Complete Workflow Example

```bash
# 1. Start from main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/add-safari-tests

# 3. Make changes...

# 4. Stage and commit with conventional format
git add .
git commit -m "feat(qa): add Safari browser tests for checkout"

# 5. Push branch
git push -u origin feature/add-safari-tests

# 6. Create Pull Request on GitHub
#    - Use descriptive title following conventional commits
#    - Add description of changes
#    - Request review if needed

# 7. After PR approved, merge to main
git checkout main
git pull origin main

# 8. Delete feature branch (optional)
git branch -d feature/add-safari-tests
git push origin --delete feature/add-safari-tests
```

---

## Pull Request Guidelines

### Title Format
Use conventional commit format for PR titles:
```
feat(qa): add Safari browser tests
fix(hooks): correct wp-config blocking regex
docs: update deployment instructions
```

### Description Template
```markdown
## Summary
Brief description of changes.

## Changes
- Added X
- Fixed Y
- Updated Z

## Testing
How was this tested?

## Related Issues
Closes #123
```

---

## Code Style

### TypeScript (QA Tests)
- Use TypeScript strict mode
- Prefer `const` over `let`
- Use meaningful variable names
- Add comments for complex logic only

### Shell Scripts
- Use `#!/bin/bash` shebang
- Add `set -e` for error handling
- Quote variables: `"$VAR"`
- Add comments for non-obvious commands

### Markdown
- Use ATX headers (`#`, `##`, `###`)
- One sentence per line (for better diffs)
- Use fenced code blocks with language identifiers

---

## Questions?

If unsure about conventions, check:
1. This document first
2. Recent commit history for examples
3. Ask in PR comments

---

*Last updated: 2026-01-26*
