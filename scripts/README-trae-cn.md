# Trae CN 安装与初始化脚本说明

> 本文档说明 `install-trae-cn.sh` 和 `init-trae-cn.sh` 的功能、使用方法和区别。

---

## 使用顺序

按照 [USAGE.md](../USAGE.md) 的设计，Trae CN 项目应遵循以下顺序：

```
1. install-trae-cn.sh  →  安装框架
2. init-trae-cn.sh     →  初始化项目
```

---

## 脚本职责划分

### install-trae-cn.sh（安装框架）

**职责**：将 OpenAllIn 框架文件安装到目标项目，转换为 Trae CN 格式。

**执行内容**：

| 步骤  | 操作                         | 说明                  |
| --- | -------------------------- | ------------------- |
| 1   | 复制 AGENTS.md               | AI 工具统一入口           |
| 2   | 复制 project.md              | 项目上下文模板             |
| 3   | 复制 templates/              | 模板库                 |
| 4   | 复制 scripts/                | 工具脚本                |
| 5   | 复制 workspace/              | 项目记忆模板              |
| 6   | 复制 config/                 | 配置模板                |
| 7   | 复制 lib/                    | 支持库                 |
| 8   | 创建 .trae/rules/            | Trae 规则目录           |
| 9   | 转换 rules → .trae/rules/    | 添加 YAML frontmatter |
| 10  | 创建 .trae/skills/           | Trae 技能目录           |
| 11  | 转换 skills → .trae/skills/  | 转为 SKILL.md 格式      |
| 12  | 转换 agents → .trae/rules/   | Agent 转为规则文件        |
| 13  | 创建 .trae/skill-config.json | 技能配置                |

**不执行**：

- 不创建项目目录（specs/、changes/、tasks/）
- 不创建状态文件（STATE.md、ROADMAP.md）
- 不创建配置文件（settings.json、memory.json）

---

### init-trae-cn.sh（初始化项目）

**职责**：为已安装框架的项目创建项目专属的目录结构和配置文件。

**前提**：已运行 `install-trae-cn.sh`（会检查 `.trae/` 目录是否存在）

**执行内容**：

| 步骤  | 操作                       | 说明            |
| --- | ------------------------ | ------------- |
| 1   | 创建 specs/                | 系统规格目录        |
| 2   | 创建 changes/archive/      | 已归档变更         |
| 3   | 创建 tasks/archive/        | 已归档任务         |
| 4   | 创建 workspace/journals/   | 会话日志          |
| 5   | 创建 .planning/            | 规划上下文         |
| 6   | 创建 workspace/STATE.md    | 当前状态          |
| 7   | 创建 workspace/ROADMAP.md  | 项目路线图         |
| 8   | 创建 config/settings.json  | 框架配置（Trae 路径） |
| 9   | 创建 config/memory.json    | 学习记忆          |
| 10  | 创建 config/instincts.json | 模式库           |
| 11  | 创建 .planning/config.json | 规划配置          |

**不执行**：

- 不复制框架文件（AGENTS.md、rules、skills）
- 不转换任何文件格式

---

## 使用方法

### 老项目（已有代码，引入 OpenAllIn）

```bash
# 1. 进入项目目录
cd your-project

# 2. 安装框架
bash /path/to/openallin/scripts/install-trae-cn.sh

# 3. 初始化项目
bash scripts/init-trae-cn.sh

# 4. 编辑项目上下文
vim project.md
```

### 新项目（从零开始）

```bash
# 1. 创建项目目录
mkdir my-project && cd my-project

# 2. 克隆 OpenAllIn 到临时目录
git clone https://github.com/vanrayliu/openallin.git /tmp/openallin

# 3. 安装框架
bash /tmp/openallin/scripts/install-trae-cn.sh

# 4. 初始化项目
bash scripts/init-trae-cn.sh

# 5. 编辑项目上下文
vim project.md

# 6. 清理临时文件
rm -rf /tmp/openallin
```

### 安装到指定目录

```bash
# 安装到指定目录
bash scripts/install-trae-cn.sh --target /path/to/project

# 初始化指定目录
bash scripts/init-trae-cn.sh --target /path/to/project
```

---

## 功能对比

| 功能                         | install-trae-cn.sh | init-trae-cn.sh |
| -------------------------- |:------------------:|:---------------:|
| 复制 AGENTS.md               | ✅                  | ❌               |
| 复制 project.md              | ✅                  | ❌               |
| 复制 templates/              | ✅                  | ❌               |
| 复制 scripts/                | ✅                  | ❌               |
| 复制 workspace/              | ✅                  | ❌               |
| 复制 config/                 | ✅                  | ❌               |
| 复制 lib/                    | ✅                  | ❌               |
| 转换 rules → .trae/rules/    | ✅                  | ❌               |
| 转换 skills → .trae/skills/  | ✅                  | ❌               |
| 转换 agents → .trae/rules/   | ✅                  | ❌               |
| 创建 .trae/skill-config.json | ✅                  | ❌               |
| 创建 specs/                  | ❌                  | ✅               |
| 创建 changes/archive/        | ❌                  | ✅               |
| 创建 tasks/archive/          | ❌                  | ✅               |
| 创建 workspace/journals/     | ❌                  | ✅               |
| 创建 .planning/              | ❌                  | ✅               |
| 创建 workspace/STATE.md      | ❌                  | ✅               |
| 创建 workspace/ROADMAP.md    | ❌                  | ✅               |
| 创建 config/settings.json    | ❌                  | ✅               |
| 创建 config/memory.json      | ❌                  | ✅               |
| 创建 config/instincts.json   | ❌                  | ✅               |
| 创建 .planning/config.json   | ❌                  | ✅               |

---

## 常见问题

### Q: 可以只运行一个脚本吗？

**A**: 不可以。两个脚本职责不同：

- `install-trae-cn.sh` 安装框架文件（rules、skills、agents）
- `init-trae-cn.sh` 创建项目文件（状态、配置、目录）

必须按顺序运行两个脚本才能完整设置项目。

### Q: init-trae-cn.sh 检测到未安装框架会怎样？

**A**: 会提示先运行 `install-trae-cn.sh`，并询问是否继续。输入 `y` 可跳过检查继续初始化。

### Q: 重复运行会覆盖已有文件吗？

**A**: 不会。两个脚本都使用条件检查（`[ ! -f "..." ]`），已存在的文件不会覆盖。

### Q: 安装脚本会修改源目录吗？

**A**: 不会。`install-trae-cn.sh` 只读取源目录（HARNESS_DIR），所有修改都写入目标目录。

---

## 与原版脚本对比

| 原版（OpenCode/Claude）  | Trae CN 版                  |
| -------------------- | -------------------------- |
| `install.sh`         | `install-trae-cn.sh`       |
| `init.sh`            | `init-trae-cn.sh`          |
| rules/ 目录            | .trae/rules/ 目录            |
| skills/*.md          | .trae/skills/*/SKILL.md    |
| agents/ 目录           | .trae/rules/agent-*.md     |
| skills_dir: "skills" | skills_dir: ".trae/skills" |
