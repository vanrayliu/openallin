# Git Worktree Isolation — Git Worktree 隔离

> 在开始需要与当前工作区隔离的功能开发之前使用此技能。

## 何时使用

- 开始新功能开发
- 执行实施计划
- 需要并行开发多个功能
- 需要干净的实验环境

## 工作流

### Step 1: 准备工作区
```bash
# 创建 worktree
git worktree add ../<feature-name>-worktree -b <feature-branch>

# 或使用智能目录选择
# 如果当前目录是主分支，在相邻目录创建
# 如果当前目录已有 worktree，创建新的
```

### Step 2: 验证隔离
```bash
# 确认分支正确
git branch --show-current

# 确认与主分支隔离
git log --oneline -1
```

### Step 3: 开发
- 在隔离的 worktree 中开发
- 不受主分支变更影响
- 可以随时切换回主分支

### Step 4: 合并
```bash
# 开发完成后
git add . && git commit -m "<message>"
git push origin <feature-branch>

# 清理 worktree
git worktree remove ../<feature-name>-worktree
```

## 注意事项

- 每个 worktree 是独立的文件系统
- 共享 .git 目录，节省空间
- 不要同时在多个 worktree 修改同一文件
- 完成后及时清理 worktree
