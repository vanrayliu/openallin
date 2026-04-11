---
name: oa-team-exec
description: OpenAllIn /oa-team-exec 命令 — 团队并行执行
---

# /oa-team-exec — 团队并行执行

当用户输入 `/oa-team-exec` 时执行此技能。

## 工作流程

### 1. 读取团队计划
打开 `workspace/TEAM-PLAN.md`。

### 2. 创建 Git Worktrees
为每个成员创建独立的工作树：

```bash
# 示例：为 3 个成员创建 worktrees
git worktree add -b feature/member-1-task ../worktree-member-1 main
git worktree add -b feature/member-2-task ../worktree-member-2 main
git worktree add -b feature/member-3-task ../worktree-member-3 main
```

**命名规范**：
- 目录：`../worktree-<member-name>` 或 `../worktree-<task-name>`
- 分支：`feature/<task-name>` 或 `fix/<task-name>`

### 3. 并行执行
- 各成员在独立 worktree 中工作
- 通过 `workspace/journals/` 同步进度

```bash
# 成员 1 在自己的 worktree 工作
cd ../worktree-member-1
# ... 开发工作 ...
git add -A
git commit -m "feat: implement member-1 task"
git push origin feature/member-1-task

# 成员 2 在自己的 worktree 工作
cd ../worktree-member-2
# ... 开发工作 ...
git add -A
git commit -m "feat: implement member-2 task"
git push origin feature/member-2-task
```

### 4. 定期同步
- 合并完成的 worktree
- 解决冲突

```bash
# 回到主仓库
cd ../harness

# 合并成员 1 的分支
git checkout main
git merge feature/member-1-task

# 或通过 PR 合并（推荐）
cd ../worktree-member-1
gh pr create --title "Member 1 task" --body "..."

# PR 合并后，删除 worktree
cd ../harness
git worktree remove ../worktree-member-1
```

## 输出

- worktree 创建状态
- 各成员进度报告

## 状态同步

各成员在 `workspace/journals/` 目录记录进度：

```markdown
# workspace/journals/member-1.md

## 进度记录

### YYYY-MM-DD HH:MM
- 任务：实现登录功能
- 状态：进行中
- 进度：50%

### YYYY-MM-DD HH:MM
- 任务：登录功能完成
- 状态：已完成
- 待合并：是
```

## Worktree 管理

### 查看所有 Worktrees
```bash
git worktree list
```

输出示例：
```
/Users/moon/opencode/harness           abc1234 [main]
../worktree-member-1                   def5678 [feature/member-1-task]
../worktree-member-2                   ghi9012 [feature/member-2-task]
```

### 清理已完成的 Worktrees
```bash
# 删除指定 worktree
git worktree remove ../worktree-member-1

# 清理所有已删除的 worktree 记录
git worktree prune
```

## 冲突解决

当多个成员修改同一文件时：

```bash
# 成员 1 先合并
git checkout main
git merge feature/member-1-task

# 成员 2 合并时可能有冲突
git checkout main
git merge feature/member-2-task

# 如果有冲突，手动解决
# 查看冲突文件
git status

# 编辑冲突文件，选择保留的内容
# 然后提交
git add <conflicted-file>
git commit -m "merge: resolve conflicts with member-2-task"
```

## 注意事项

- 每个 worktree 独立，避免相互干扰
- 使用规范的分支名 `feature/<task-name>`
- 合并时引用分支名，不是目录名
- 定期合并以避免大幅偏离主分支
- 通过 journals 同步进度，避免重复工作
- 完成后及时删除 worktree 和分支

## 相关 Skills

- `/oa-team-plan` — 团队规划
- `/oa-team-verify` — 团队验证
- `/oa-worktree` — 单人 worktree 使用