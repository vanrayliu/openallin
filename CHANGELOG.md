# Changelog

All notable changes to this project will be documented in this file.

## [v1.3.0] - 2026-04-10

### Added
- **Auto-detect 10+ CLI tools**: OpenCode, Claude Code, Cursor, Codex, OpenClaw, Gemini CLI, Windsurf, Kilo Code, Augment, Zed
- **/oa-tdd command**: Test-driven development workflow (Red-Green-Refactor cycle)
- **Comprehensive User Guide**:
  - Chinese version: `USAGE.md` (1174 lines, 9 chapters)
  - English version: `USAGE_EN.md` (1178 lines, 9 chapters)
- **Natural language installation guide**: Install OpenAllIn via AI assistant with Git URL
- **Natural language usage guide**: Use OpenAllIn with natural language instead of commands
  - 15+ natural language phrases quick reference
  - When to use commands vs natural language comparison table
  - Good/poor expression examples

### Changed
- **Updated README.md**: Added user guide links at the top
- **Updated QUICKREF.md**: All 17 commands listed
- **Updated AGENTS.md**: Consistent command examples

### Fixed
- **Skills directory structure**: Corrected from nested to flat structure (`proposal.md` not `proposal/proposal.md`)
- **README.md skills count**: Fixed mismatch (16 → 17)
- **USAGE.md duplicate content**: Removed duplicate Q11 and Q12
- **Natural language installation**: Now requires Git URL (e.g., `https://github.com/vanrayliu/openallin`)

### Documentation
- All documents now consistent: 17 skills, 9 chapters, 10+ supported CLI tools
- Total documentation: 2000+ lines

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
