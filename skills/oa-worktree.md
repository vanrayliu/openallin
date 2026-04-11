---
name: oa-worktree
description: OpenAllIn /oa-worktree 命令 — Git Worktree 隔离
---

# /oa-worktree — Git Worktree 隔离

当用户输入 `/oa-worktree` 时执行此技能。

## 工作流程

### 1. 检查当前状态
- 查看现有 worktrees
- 检查分支状态

### 2. 创建新 Worktree
```bash
# 创建新分支和新 worktree
git worktree add -b feature/<name> ../worktree-<name> main

# 示例：创建 feature/add-login 的 worktree
git worktree add -b feature/add-login ../worktree-add-login main
```

### 3. 切换到 Worktree
```bash
cd ../worktree-<name>

# 示例
cd ../worktree-add-login
```

### 4. 工作完成后
```bash
# 在 worktree 中完成工作并提交
cd ../worktree-<name>
git add -A
git commit -m "feat: add login feature"
git push origin feature/<name>

# 回到主仓库
cd ../harness

# 合并分支回主分支
git checkout main
git merge feature/<name>

# 或通过 PR 合并（推荐）
gh pr create --title "Add login feature" --body "..."

# 删除 worktree（合并成功后）
git worktree remove ../worktree-<name>

# 删除分支（可选，PR 已合并会自动删除）
git branch -d feature/<name>
```

## 输出

- 新 worktree 路径
- 分支名称
- 工作指引

## 常用命令

### 查看 Worktrees
```bash
git worktree list
```

### 删除 Worktree
```bash
# 删除指定 worktree
git worktree remove ../worktree-<name>

# 强制删除（有未提交更改）
git worktree remove --force ../worktree-<name>
```

### 清理 Worktree 信息
```bash
# 清理已删除的 worktree 记录
git worktree prune
```

## 注意事项

- 使用 worktree 隔离功能开发
- 避免在主分支直接开发
- 完成工作后及时合并和清理
- 分支名使用 `feature/<name>` 或 `fix/<name>` 格式
- 合并时引用正确的分支名 `feature/<name>`，不是 worktree 目录名

## 相关 Skills

- `/oa-team-exec` — 团队并行执行（使用多个 worktrees）
- `/oa-plan` — 规划任务
- `/oa-execute` — 执行任务