# 灵码 IDE 安装脚本说明

> 本文档说明 `install-Lingma.sh` 的功能、使用方法和安装内容。

---

## 使用方法

### 老项目（已有代码，引入 OpenAllIn）

```bash
# 1. 进入项目目录
cd your-project

# 2. 安装框架
bash /path/to/openallin/scripts/install-Lingma.sh

# 3. 编辑项目上下文
vim project.md
```

### 新项目（从零开始）

```bash
# 1. 创建项目目录
mkdir my-project && cd my-project

# 2. 克隆 OpenAllIn 到临时目录
git clone https://github.com/vanrayliu/openallin.git /tmp/openallin

# 3. 安装框架
bash /tmp/openallin/scripts/install-Lingma.sh

# 4. 编辑项目上下文
vim project.md

# 5. 清理临时文件
rm -rf /tmp/openallin
```

### 安装到指定目录

```bash
bash scripts/install-Lingma.sh --target /path/to/project
# 或简写
bash scripts/install-Lingma.sh /path/to/project
```

---

## 脚本执行内容

### install-Lingma.sh（一站式安装）

**职责**：将 OpenAllIn 框架文件安装到目标项目，并转换为灵码 IDE 格式。

**执行内容**：

| 步骤  | 操作                                    | 说明                      |
| --- | --------------------------------------- | ----------------------- |
| 1   | 复制 AGENTS.md                            | AI 工具统一入口               |
| 2   | 复制 project.md                           | 项目上下文模板                 |
| 3   | 复制 specs/                               | 系统规格目录                  |
| 4   | 复制 changes/                             | 变更提案目录                  |
| 5   | 复制 config/                              | 配置模板                    |
| 6   | 复制 workspace/                           | 项目记忆模板                  |
| 7   | 复制 templates/                           | 模板库                     |
| 8   | 复制 scripts/                             | 工具脚本                    |
| 9   | 复制 lib/                                 | 支持库                     |
| 10  | 复制 .planning/                           | 规划上下文（含 config.json）    |
| 11  | 创建 changes/archive/                     | 已归档变更目录                 |
| 12  | 创建 tasks/archive/                       | 已归档任务目录                 |
| 13  | 创建 .lingma/                             | 灵码 IDE 配置目录             |
| 14  | 转换 rules → .lingma/rules/               | 添加 `trigger: always_on`   |
| 15  | 转换 skills → .lingma/skills/             | 转为 `<name>/SKILL.md` 格式 |
| 16  | 转换 agents → .lingma/agents/             | 添加 YAML frontmatter       |
| 17  | 创建 project-context.md                   | 项目上下文加载规则               |

---

## 安装后的目录结构

```
project/
├── AGENTS.md                      # AI 工具统一入口
├── project.md                     # 项目上下文（需编辑）
├── .lingma/
│   ├── rules/
│   │   ├── coding-standards.md    # 编码规范（trigger: always_on）
│   │   ├── security-rules.md      # 安全规则（trigger: always_on）
│   │   ├── commit-rules.md        # 提交规范（trigger: always_on）
│   │   ├── review-rules.md        # 审查规则（trigger: always_on）
│   │   └── project-context.md     # 项目上下文加载规则
│   ├── skills/
│   │   ├── oa-propose/SKILL.md
│   │   ├── oa-apply/SKILL.md
│   │   ├── oa-discuss/SKILL.md
│   │   └── ...                    # 所有 oa-* 技能
│   └── agents/
│       ├── implementer.md         # 带 YAML frontmatter
│       ├── reviewer.md
│       └── ...
├── specs/                         # 系统规格
│   ├── auth/spec.md
│   ├── api/spec.md
│   └── ui/spec.md
├── changes/
│   └── archive/                   # 已归档变更
├── tasks/
│   └── archive/                   # 已归档任务
├── workspace/                     # 项目记忆
│   └── journals/
├── config/                        # 配置模板
├── .planning/                     # 规划上下文
│   └── config.json
└── templates/                     # 模板库
```

---

## 格式转换说明

### Rules 转换

原始规则文件直接复制，添加 frontmatter：

```yaml
---
trigger: always_on
---
```

### Skills 转换

原始技能文件转换为 `<name>/SKILL.md` 格式：

```
.lingma/skills/
├── oa-propose/
│   └── SKILL.md
├── oa-apply/
│   └── SKILL.md
└── ...
```

### Agents 转换

原始 Agent 文件添加 YAML frontmatter：

```yaml
---
name: implementer
description: 实现者
tools: Read, Write, Edit, Bash, Grep, Glob
---
```

---

## 与原版脚本对比

| 原版（install.sh） | 灵码版（install-Lingma.sh） |
| ----------------- | -------------------------- |
| 支持 10 种工具       | 仅支持灵码 IDE                |
| 需要配合 init.sh    | 一站式安装，无需额外脚本            |
| rules/ 直接复制     | 添加 `trigger: always_on`    |
| skills/ 直接复制    | 转为 `<name>/SKILL.md` 格式  |
| agents/ 直接复制    | 添加 YAML frontmatter       |
| 包含 hooks 配置     | 无 hooks                    |

---

## 常见问题

### Q: 需要运行 init.sh 吗？

**A**: 不需要。`install-Lingma.sh` 已包含所有必要的目录和文件创建逻辑，是一站式安装脚本。

### Q: 重复运行会覆盖已有文件吗？

**A**: 不会。脚本使用条件检查（`[ ! -f "..." ]`），已存在的文件不会覆盖。

### Q: 安装脚本会修改源目录吗？

**A**: 不会。脚本只读取源目录（HARNESS_DIR），所有修改都写入目标目录。

### Q: 如何更新已安装的框架？

**A**: 重新运行 `install-Lingma.sh`，脚本会跳过已存在的文件，只安装新增的内容。

---

## 在灵码 IDE 中使用

1. 用灵码 IDE 打开项目目录
2. 确认 `.lingma/` 目录已创建并包含 rules、skills、agents
3. 编辑 `project.md` 填入项目信息
4. 开始使用！

### 快速开始

```
输入: "我想加个功能"     → 自动触发 oa-propose
输入: "讨论一下需求"      → 自动触发 oa-discuss
输入: "开始实现"          → 自动触发 oa-apply
```
