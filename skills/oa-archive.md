---
name: oa-archive
description: OpenAllIn /oa-archive 命令 — 归档变更并合并到规格库
---

# /oa-archive — 归档变更并合并到规格库

当用户输入 `/oa-archive <name>` 时执行此技能。

## 工作流程

### 1. 解析变更名称
- 从命令参数提取变更名称
- 格式：`/oa-archive add-user-login`

### 2. 验证变更完成
- 检查 `changes/<name>/tasks.md` 中所有任务是否完成
- 如果有未完成任务，提示用户先完成

### 3. 运行归档脚本（可选）

如果 `scripts/archive-change.sh` 存在，运行它：
```bash
bash scripts/archive-change.sh <name>
```

**如果脚本不存在**，使用手动归档步骤（见下方）。

### 4. 手动归档步骤（备选方案）

如果没有归档脚本，手动执行以下步骤：

#### 4.1 合并 specs 到规格库
```bash
# 如果有 specs/ 目录
if [ -d "changes/<name>/specs" ]; then
  cp -r changes/<name>/specs/* specs/
fi
```

#### 4.2 更新变更状态
```bash
# 创建归档目录（如果不存在）
mkdir -p changes/archive

# 移动变更到归档目录
mv changes/<name> changes/archive/<name>-$(date +%Y%m%d)
```

#### 4.3 更新 CHANGELOG.md

在 `CHANGELOG.md` 添加新条目：
```markdown
## YYYY-MM-DD - <name>

### Added
- 新功能描述

### Changed
- 变更描述

### Fixed
- 修复描述

### Impact
- 影范围: [模块/组件]
```

#### 4.4 Git 提交
```bash
git add specs/ changes/archive/ CHANGELOG.md
git commit -m "archive: merge <name> to specs"
git push origin main
```

### 5. 清理
- 确认归档完成后，变更已移动到 `changes/archive/`
- 可以保留归档记录，或定期清理旧归档

## 输出

### 成功输出

```markdown
## ✅ 归档完成

### 操作记录
- specs 合并: ✓ (如果有 specs 目录)
- 归档移动: ✓ changes/<name> → changes/archive/<name>-YYYYMMDD
- CHANGELOG 更新: ✓
- Git 提交: ✓

### 归档位置
- changes/archive/<name>-YYYYMMDD/

### CHANGELOG 条目
## YYYY-MM-DD - <name>
- 描述变更内容
- 影响范围

### 下一步
变更已归档，可以开始新的变更提案
```

### 失败输出

```markdown
## ❌ 归档失败

### 问题
- tasks.md 中有未完成的任务:
  - [ ] 任务 1
  - [ ] 任务 2

### 下一步
1. 先运行 `/oa-apply <name>` 完成未完成任务
2. 确认所有任务完成后再运行 `/oa-archive <name>`
```

## 手动归档清单

```markdown
## 手动归档清单

### 前置检查
- [ ] 所有 tasks.md 任务已完成
- [ ] 所有验证已通过
- [ ] 代码已合并到主分支

### 归档步骤
- [ ] 复制 specs/ 内容到 specs/ 目录
- [ ] 移动 changes/<name> 到 changes/archive/<name>-YYYYMMDD
- [ ] 更新 CHANGELOG.md
- [ ] Git 提交归档变更

### 后置检查
- [ ] specs/ 目录包含新规格
- [ ] changes/archive/ 包含归档记录
- [ ] CHANGELOG.md 已更新
- [ ] Git 已提交并推送
```

## 注意事项

- 归档前确保所有任务已完成
- 归档脚本可选，没有脚本时使用手动步骤
- 归档后保留历史记录在 `changes/archive/`
- 定期清理旧归档（可选）
- 时间使用 ISO 8601 格式 (UTC)

## 相关 Skills

- `/oa-apply` — 执行变更任务清单（前置）
- `/oa-validate` — 验证规格文档格式（前置）
- `/oa-propose` — 创建变更提案（新的变更）