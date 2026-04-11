---
name: oa-ship
description: OpenAllIn /oa-ship 命令 — 发布变更
---

# /oa-ship — 发布变更

当用户输入 `/oa-ship <phase>` 时执行此技能。

## 工作流程

### 1. 最终验证

**必须通过的检查**：
- 所有验证通过（来自 `/oa-verify`）
- 代码审查通过（来自 `/oa-review`）
- 安全检查通过（来自 `/oa-security`）
- CHANGELOG.md 已更新

**运行验证命令**：
```bash
# Lint 检查
npm run lint 2>/dev/null || ruff check . 2>/dev/null || echo "No lint command found"

# Typecheck 检查
npm run typecheck 2>/dev/null || mypy . 2>/dev/null || echo "No typecheck command found"

# 测试检查
npm run test 2>/dev/null || pytest 2>/dev/null || echo "No test command found"
```

如果验证失败，**阻止发布**并提示用户修复。

### 2. Git 操作

```bash
# 查看变更
git status
git diff

# 添加变更（推荐方式）
git add -A  # 添加所有变更（包括删除）
# 或更精确的方式
git add src/ lib/ tests/ docs/ CHANGELOG.md

# 提交变更
git commit -m "feat: <描述>"

# 推送到远程
git push origin main
```

**提交消息格式**：
```
feat: add new feature
fix: fix bug in module
refactor: refactor code structure
docs: update documentation
test: add tests
chore: update config
```

### 3. 创建 Pull Request

```bash
# 使用 gh CLI
gh pr create --title "feat: <描述>" --body "$(cat <<'EOF'
## Summary
- 变更点 1
- 变更点 2

## Test Plan
- 测试步骤 1
- 测试步骤 2
EOF
)"

# 或手动创建
# 打开 GitHub/GitLab 创建 PR
```

### 4. 输出结果

- PR 链接
- 变更摘要
- 下一步指引（`/oa-land`）

## 输出

- PR 链接
- 发布确认
- 验证结果摘要

## 验证失败处理

如果验证失败，输出：

```markdown
## ❌ 发布阻止

验证失败，请先修复以下问题：

### Lint 错误
- 文件: src/utils.js
- 错误: Unexpected trailing comma

### Typecheck 错误
- 文件: src/types.ts
- 错误: Type 'string' is not assignable to type 'number'

### 测试失败
- 测试: tests/auth.test.js
- 错误: Expected true, got false

### 下一步
1. 修复上述问题
2. 重新运行 `/oa-verify`
3. 确认所有验证通过后再次运行 `/oa-ship`
```

## 注意事项

- **必须验证通过**才能发布
- 使用 `git add -A` 而不是 `git add .`（后者不包括删除的文件）
- 提交前检查 CHANGELOG.md 是否更新
- 提交消息遵循 Conventional Commits 规范
- 推送失败时检查网络连接和权限

## 相关 Skills

- `/oa-verify` — 验证质量
- `/oa-review` — 代码审查
- `/oa-security` — 安全检查
- `/oa-land` — 部署验证