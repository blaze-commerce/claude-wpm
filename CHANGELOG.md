# Changelog

All notable changes to Claude WPM are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Documentation site migrated to Astro Starlight (industry standard)
- WordPress Agent Skills reference (13 skills from [WordPress/agent-skills](https://github.com/WordPress/agent-skills))
- Documentation pages: getting-started, guides, reference
- `.gitignore` in docs to exclude `CHANGELOG.md` from deployment

### Fixed
- `update-premium-plugins.sh` update-all loop aborting on PHP warnings (set -e issue)
- One plugin failure no longer stops the entire batch update

---

## [v1.3.1] - 2026-01-29

### Added
- Maintenance mode integration in `update-premium-plugins.sh` (auto-enable before, auto-disable after)
- Additional premium plugin patterns: `astra-addon`, `ultimate-elementor`, `oxygen`, `oxy-*`, `oxyultimate*`
- `CHANGELOG.md` for tracking issues, fixes, and dates

### Fixed
- Live site not in maintenance mode during premium plugin updates
- Premium plugins not updating due to missing patterns in detection

---

## [v1.3.0] - 2026-01-29

### Added
- **Mandatory maintenance mode** before and after ALL site updates
- Two-tier maintenance approach: ASE Pro (preferred) with custom `.maintenance` fallback
- Visual output summary with box formatting and status icons
- CDN warning when using custom maintenance fallback
- Maintenance mode functions in `blz-wpm.sh`
- Step 0 (Enable Maintenance Mode) and Step 6 (Disable Maintenance Mode) in `/wpm` workflow
- Status icons reference table in `wpm.md`
- Conditional warning boxes for premium plugins, WP 2FA, and Oxygen Builder

### Fixed
- shellcheck SC2016 warning for intentional single quotes in PHP code

### Changed
- Updated `wpm.md` with comprehensive visual output templates
- Updated `blz-wpm.sh` with visual summary output
- Updated `README.md` with maintenance mode documentation

### Security
- WooCommerce sites now protected from failed orders during updates (maintenance mode required)

---

## [v1.2.4] - 2026-01-28

### Added
- `-y/--yes` flag to `update-claude-wpm.sh` for non-interactive updates
- VERSION file reading priority in `audit-wpm.sh`

### Changed
- Separated maintenance commands in docs for easy copy-paste

---

## [v1.2.0] - 2026-01-27

### Added
- `audit-wpm.sh` script to compare local vs repo files
- `check-version.sh` script to check for updates
- `update-claude-wpm.sh` script for auto-updating from GitHub releases
- FILE_MAPPING.md as single source of truth for deployment
- GitHub Actions workflow for automated releases
- Security check workflow with shellcheck validation

---

## [v1.1.0] - 2026-01-25

### Added
- Premium plugin updater script (`update-premium-plugins.sh`)
- Auto-detection of premium plugins not in repo
- Missing plugins manifest file generation

---

## [v1.0.0] - 2026-01-20

### Added
- Initial release of Claude WPM
- WordPress maintenance command (`/wpm`)
- Safety hooks for dangerous commands
- Skills: wordpress-master, php-pro, security-auditor, database-administrator
- Premium plugin update workflow via private Git repo
- Plugin inventory tracking in CLAUDE.md

---

## Issue Tracking

| Date | Issue | Fix | Version |
|------|-------|-----|---------|
| 2026-02-04 | update-all aborting on PHP warnings (Freemius SDK) | Disabled set -e during plugin loop | Unreleased |
| 2026-01-29 | Live site not in maintenance mode during premium plugin updates | Added maintenance mode to `update-premium-plugins.sh` | v1.3.1 |
| 2026-01-29 | Premium plugins (astra-addon, ultimate-elementor) not detected | Added missing patterns to PREMIUM_PATTERNS array | v1.3.1 |
| 2026-01-29 | shellcheck SC2016 failing CI | Added shellcheck disable comment for intentional single quotes | v1.3.0 |
| 2026-01-29 | WooCommerce orders failing during updates | Made maintenance mode mandatory in /wpm workflow | v1.3.0 |

---

## Migration Notes

### Upgrading to v1.3.x

1. **Maintenance mode is now mandatory** - The `/wpm` command and `update-premium-plugins.sh` will automatically enable/disable maintenance mode
2. **ASE Pro recommended** - For best results with Kinsta CDN, install Admin Site Enhancements Pro
3. **Visual output** - Output format has changed to use box formatting with status icons

### Upgrading to v1.2.x

1. Run `bash .claude/scripts/audit-wpm.sh` to check for missing files
2. Run `bash .claude/scripts/update-claude-wpm.sh -y` to auto-update

---

**Maintained by Blaze Commerce**
