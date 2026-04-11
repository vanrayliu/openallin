---
name: oa-validate
description: OpenAllIn /oa-validate 命令 — 验证规格文档格式
---

# /oa-validate — 验证规格文档格式

当用户输入 `/oa-validate <name>` 时执行此技能。

## 工作流程

### 1. 解析变更名称
- 从命令参数提取变更名称
- 格式：`/oa-validate add-user-login`

### 2. 验证目录结构
检查 `changes/<name>/` 是否包含：
- `proposal.md` ✓ 必需
- `design.md` — 可选
- `specs/` — 可选
- `tasks.md` ✓ 必需

### 3. 验证文档内容

#### proposal.md 必需内容
- 非空内容 ✓
- 包含"概述"章节 ✓
- 包含"验收标准"章节 ✓
- 包含"影响范围"章节 ✓

#### tasks.md 必需内容
- 非空内容 ✓
- 包含任务列表 ✓

### 4. 运行脚本验证（可选）

如果 `scripts/validate-spec.sh` 存在，运行它：
```bash
bash scripts/validate-spec.sh changes/<name>
```

**如果脚本不存在**，使用手动验证（见下方）。

### 5. 手动验证步骤（备选方案）

如果没有验证脚本，手动执行以下检查：

```markdown
## 手动验证清单

### 目录结构
- [ ] changes/<name>/ 目录存在
- [ ] proposal.md 文件存在
- [ ] tasks.md 文件存在

### proposal.md 内容
- [ ] 文件非空
- [ ] 包含概述章节
- [ ] 包含验收标准章节
- [ ] 包含影响范围章节
- [ ] 验收标准有具体条目

### tasks.md 内容
- [ ] 文件非空
- [ ] 包含任务列表
- [ ] 任务有明确的完成标准

### 格式检查
- [ ] Markdown 格式正确
- [ ] 无明显的语法错误
- [ ] 链接和引用有效
```

### 6. 输出结果
- 验证通过：输出 ✅ 并提示下一步
- 验证失败：列出所有问题并提供修复建议

## 输出

### 成功输出

```markdown
## ✅ 验证通过

### 检查结果
- 目录结构: ✓ 完整
- proposal.md: ✓ 内容完整
- tasks.md: ✓ 任务列表完整
- 格式检查: ✓ 正确

### 下一步
可以运行 `/oa-apply <name>` 执行任务清单
```

### 失败输出

```markdown
## ❌ 验证失败

### 问题列表

#### 问题 1: proposal.md 缺少验收标准
- 文件: changes/add-user-login/proposal.md
- 错误: 未找到"验收标准"章节
- 建议: 添加验收标准章节，列出具体的验收条件

#### 问题 2: tasks.md 内容为空
- 文件: changes/add-user-login/tasks.md
- 错误: 文件内容为空
- 建议: 添加任务列表，例如:
  ```markdown
  ## 任务列表
  - [ ] 创建用户模型
  - [ ] 实现登录 API
  - [ ] 添加前端登录表单
  ```

### 下一步
修复上述问题后重新运行 `/oa-validate <name>`
```

## 注意事项

- 使用 `set -e` 确保失败时停止
- 验证脚本可选，没有脚本时使用手动验证
- 时间使用 ISO 8601 格式 (UTC)
- 验证通过后才能进入 `/oa-apply`

## 相关 Skills

- `/oa-discuss` — 讨论需求细节（前置）
- `/oa-apply` — 执行任务清单（后置）
- `/oa-archive` — 归档变更（后置）