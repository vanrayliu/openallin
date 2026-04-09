# Changelog

All notable changes to this project will be documented in this file.

## [v1.2.0] - 2026-04-09

### Added
- **10+ CLI Tools Support**: OpenCode, Claude Code, Cursor, Codex, OpenClaw, Gemini CLI, Windsurf, Kilo Code, Augment, Zed
- **Auto-detection**: Automatically detect current CLI environment when no tool specified
- **Environment variable detection**: OPENCODE, CLAUDE_CODE, CURSOR, CODEX, OPENCLAW, GEMINI_CLI, WINDSURF, KILO, AUGMENT, ZED

### Changed
- **Flattened skills structure**: `skills/oa-*.md` (single file per command)
- **Skills installation format**: `<name>/SKILL.md` for CLI tool compatibility
- **Unified command format**: All commands use `/oa-` prefix (not `/oa:`)

### Fixed
- Clean up old flat skill files before installing new format
- Install skills with correct `<name>/SKILL.md` wrapper for Claude Code/OpenCode
- Documentation consistency: all docs reference correct 16 commands

## [v1.1.0] - 2026-04-09

### Added
- **16 Command Skills**: oa-propose, oa-apply, oa-validate, oa-archive, oa-discuss, oa-plan, oa-execute, oa-verify, oa-ship, oa-team-plan, oa-team-exec, oa-team-verify, oa-worktree, oa-brainstorming, oa-debugging, oa-writing-plans
- **Multi-round Iteration Design**:
  - oa-brainstorming: 5-round brainstorming (intent → boundary → environment → solution → confirm)
  - oa-debugging: 5-round debugging (reproduce → hypothesize → locate → fix → prevent)
  - oa-writing-plans: 4-round planning (understand → refine → risk → confirm)
  - oa-discuss: 5-round discussion with round summary and user decision
- **uninstall.sh**: Complete uninstallation with global settings.json cleanup

### Changed
- **Consolidated skills structure**: All skills in `skills/oa-*/` (universal source for all CLI tools)
- **Updated install.sh**: Copies from `skills/oa-*/` to tool-specific directories
- **Updated AGENTS.md**: Command list matches actual 16 oa-* skills

### Fixed
- Prevent duplicate hooks on re-install
- Always backup config files before modification
- Reject installation to home or root directory
- Convert old-format hooks to new format when merging
- Claude Code settings.json merge preserves user hooks with backup

## [v1.0.0] - 2026-04-08

### Added
- **Bilingual Support**: README.md (English/Chinese), README_zh.md (Chinese only)
- **6-Layer Architecture**: Workspace, Orchestration, Execution, Enhancement, Skills, Spec
- **5 Agent Roles**: planner, implementer, reviewer, debugger, researcher
- **4 Rule Sets**: coding-standards, security-rules, commit-rules, review-rules
- **4 Event Hooks**: session-start, session-end, pre-tool-use, post-tool-use
- **Multi-Platform Installation**: OpenCode, Claude Code, Cursor, Codex support
- **Delta Spec System**: Incremental spec changes with ADDED/MODIFIED/REMOVED
- **Example Change**: add-user-login with complete proposal, design, specs, tasks

### Features
- Pure text/Shell/JSON implementation (no external dependencies)
- Works offline
- Language-agnostic (any programming language/framework)
- Progressive adoption (each layer independently optional)

### Scripts
- `init.sh`: Initialize new project with OpenAllIn structure
- `install.sh`: One-click installation for multiple AI tools
- `validate-spec.sh`: Validate spec format compliance
- `archive-change.sh`: Archive completed changes and merge to main specs
- `uninstall.sh`: Complete uninstallation
