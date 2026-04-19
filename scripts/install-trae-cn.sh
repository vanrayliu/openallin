#!/bin/bash

# OpenAllIn 安装脚本 - Trae 中文版
# 用于将 OpenAllIn 框架安装到 Trae CN IDE 项目中
#
# 重要说明：
# - 本脚本只读取源目录（HARNESS_DIR）的文件，不会修改源目录中的任何文件
# - 所有转换后的文件都写入目标目录的 .trae/ 子目录中
# - 源目录的 skills/、rules/、agents/ 保持原格式不变
#
# 用法:
#   bash scripts/install-trae-cn.sh                    # 安装到当前目录
#   bash scripts/install-trae-cn.sh --target dir      # 安装到指定目录
#   bash scripts/install-trae-cn.sh dir                # 安装到指定目录（简写）

set -e

# HARNESS_DIR 是脚本所在的源项目目录（只读）
HARNESS_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# 解析参数
TARGET="."
SKIP_NEXT=false

# Windows 路径兼容处理
convert_path_for_bash() {
  local p="$1"
  # 如果路径包含 Windows 风格的反斜杠，转换为正斜杠
  if [[ "$p" == *\\* ]]; then
    p="${p//\\//}"
  fi
  # 处理 Windows 盘符（d:/ → /d/ 或 /mnt/d/）
  if [[ "$p" =~ ^([a-zA-Z]):/ ]]; then
    local drive="${BASH_REMATCH[1]}"
    # 尝试 /mnt/x/ 格式（常见于 MSYS2/Git Bash 的某些配置）
    if [ -d "/mnt/${drive,,}${p#*:}" ]; then
      p="/mnt/${drive,,}${p#*:}"
    else
      # 使用 /x/ 格式
      p="/${drive,,}${p#*:}"
    fi
  fi
  echo "$p"
}

for arg in "$@"; do
  if [ "$SKIP_NEXT" = true ]; then
    TARGET="$arg"
    SKIP_NEXT=false
    continue
  fi
  if [ "$arg" = "--target" ] || [ "$arg" = "-t" ]; then
    SKIP_NEXT=true
    continue
  fi
  case "$arg" in
    --target=*)
      TARGET="${arg#*=}"
      ;;
    -t=*)
      TARGET="${arg#*=}"
      ;;
    *)
      if [ -d "$arg" ] || [ "$arg" = "." ]; then
        TARGET="$arg"
      fi
      ;;
  esac
done

# 转换 Windows 路径
TARGET="$(convert_path_for_bash "$TARGET")"

echo "🚀 OpenAllIn 安装程序 — Trae CN 版"
echo "===================================="
echo "目标目录: $TARGET"
echo ""

# 检测并阻止安装到 home 目录或根目录
EXPANDED_TARGET=$(eval echo "$TARGET")
HOME_DIR="$HOME"

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
  HOME_DIR="${USERPROFILE:-$HOME}"
fi

if [ "$EXPANDED_TARGET" = "$HOME_DIR" ] || [ "$EXPANDED_TARGET" = "/" ] || [ "$EXPANDED_TARGET" = "$HOME_DIR/" ]; then
  echo "❌ 不允许安装到 home 目录 ($HOME_DIR) 或根目录"
  echo ""
  echo "请在项目目录下运行安装："
  echo "  cd your-project && bash scripts/install-trae-cn.sh"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "❌ 目标目录不存在: $TARGET"
  exit 1
fi

cd "$TARGET"

echo "📁 正在安装 OpenAllIn 到 Trae CN..."
echo ""

# ============================================================
# Step 1: 复制公共基础文件
# ============================================================
echo "📋 Step 1: 复制公共基础文件..."

# 复制核心文件（已存在则跳过，不覆盖用户修改）
[ ! -f "AGENTS.md" ] && cp "$HARNESS_DIR/AGENTS.md" . && echo "  ✅ AGENTS.md" || echo "  ⏭️  AGENTS.md 已存在"
[ ! -f "project.md" ] && cp "$HARNESS_DIR/project.md" . && echo "  ✅ project.md" || echo "  ⏭️  project.md 已存在"

# 复制目录结构（-n 表示不覆盖已存在的文件）
if [ -d "$HARNESS_DIR/templates" ]; then
  cp -rn "$HARNESS_DIR/templates" . 2>/dev/null || true
  echo "  ✅ templates/"
fi

if [ -d "$HARNESS_DIR/scripts" ]; then
  cp -rn "$HARNESS_DIR/scripts" . 2>/dev/null || true
  echo "  ✅ scripts/"
fi

if [ -d "$HARNESS_DIR/workspace" ]; then
  cp -rn "$HARNESS_DIR/workspace" . 2>/dev/null || true
  echo "  ✅ workspace/"
fi

if [ -d "$HARNESS_DIR/config" ]; then
  cp -rn "$HARNESS_DIR/config" . 2>/dev/null || true
  echo "  ✅ config/"
fi

if [ -d "$HARNESS_DIR/lib" ] && [ ! -d "lib" ]; then
  cp -rn "$HARNESS_DIR/lib" . 2>/dev/null || true
  echo "  ✅ lib/"
fi

# ============================================================
# Step 2: 创建 .trae 目录结构
# ============================================================
echo ""
echo "📂 Step 2: 创建 .trae 目录结构..."

mkdir -p .trae/rules
mkdir -p .trae/skills
echo "  ✅ .trae/rules/"
echo "  ✅ .trae/skills/"

# ============================================================
# Step 3: 将 rules 转为 Trae 项目规则格式
# ============================================================
echo ""
echo "📏 Step 3: 安装项目规则..."

convert_rule_to_trae() {
  local source_file="$1"
  local rule_name="$2"
  local always_apply="$3"
  local description="$4"
  local globs="$5"

  local target_file=".trae/rules/${rule_name}.md"

  if [ -f "$target_file" ]; then
    echo "  ⏭️  $rule_name 已存在，跳过"
    return
  fi

  local content
  content=$(cat "$source_file")

  if [ "$always_apply" = "true" ]; then
    cat > "$target_file" << EOF
---
alwaysApply: true
---

$content
EOF
  else
    cat > "$target_file" << EOF
---
alwaysApply: false
description: "$description"
EOF
    if [ -n "$globs" ]; then
      echo "globs: \"$globs\"" >> "$target_file"
    fi
    cat >> "$target_file" << EOF
---

$content
EOF
  fi

  echo "  ✅ rule: $rule_name (alwaysApply: $always_apply)"
}

convert_rule_to_trae "$HARNESS_DIR/rules/coding-standards.md" "coding-standards" "true" "" ""
convert_rule_to_trae "$HARNESS_DIR/rules/commit-rules.md" "commit-rules" "false" "生成 Git 提交信息时自动遵循的规范" ""
convert_rule_to_trae "$HARNESS_DIR/rules/security-rules.md" "security-rules" "true" "" ""
convert_rule_to_trae "$HARNESS_DIR/rules/review-rules.md" "review-rules" "false" "进行代码审查或质量检查时使用" ""

# ============================================================
# Step 4: 创建 OpenAllIn 核心引导规则
# ============================================================
echo ""
echo "🔗 Step 4: 创建 OpenAllIn 核心引导规则..."

if [ ! -f ".trae/rules/openallin-bootstrap.md" ]; then
  cat > ".trae/rules/openallin-bootstrap.md" << 'RULEEOF'
---
alwaysApply: true
---

# OpenAllIn 框架规则

> 每次新对话开始，**先读取** `project.md`。

## 核心原则

1. 规格先行 — 需求对齐再写代码
2. 证据优先 — 验证输出再声称成功
3. 上下文清洁 — 拆小任务，阶段分离
4. 文件即记忆 — 状态持久化到文件

## 项目结构

| 路径 | 用途 |
|------|------|
| `project.md` | 项目上下文 |
| `specs/` | 系统规格 |
| `changes/` | 变更提案 |
| `changes/archive/` | 已归档变更 |
| `workspace/` | 项目记忆 |
| `.trae/skills/` | 技能 |
| `.trae/rules/` | 规则 |

## 常用命令

| 触发词 | 技能 |
|--------|------|
| "加功能" | `/oa-propose` |
| "讨论" | `/oa-discuss` |
| "实现" | `/oa-apply` |
| "审查" | `/oa-review` |
| "安全" | `/oa-security` |

## 工作流

- **轻量**：propose → apply → verify → 归档
- **阶段**：discuss → plan → execute → verify → ship
- **团队**：team-plan → team-exec → team-verify

## 规格格式

```
## Requirement: 需求名
系统 MUST/SHOULD <行为>

#### Scenario: 场景
- GIVEN 前置
- WHEN 触发
- THEN 结果
```
RULEEOF
  echo "  ✅ openallin-bootstrap.md (alwaysApply: true)"
fi

# ============================================================
# Step 5: 转换技能为 Trae SKILL.md 格式
# ============================================================
echo ""
echo "⚡ Step 5: 安装技能（转换为 Trae SKILL.md 格式）..."

convert_skill_to_trae() {
  local skill_file="$1"
  local skill_name
  skill_name=$(basename "$skill_file" .md)

  local target_dir=".trae/skills/$skill_name"
  local target_file="$target_dir/SKILL.md"

  if [ -f "$target_file" ]; then
    echo "  ⏭️  $skill_name 已存在，跳过"
    return
  fi

  mkdir -p "$target_dir"

  local content
  content=$(cat "$skill_file")

  local yaml_name
  local yaml_desc
  local body

  # Extract YAML frontmatter fields
  yaml_name=$(echo "$content" | sed -n '/^---$/,/^---$/{ /^name: */{ s/^name: *//p } }' | head -1)
  if [ -z "$yaml_name" ]; then
    yaml_name="$skill_name"
  fi

  yaml_desc=$(echo "$content" | sed -n '/^---$/,/^---$/{ /^description: */{ s/^description: *//p } }' | head -1)
  if [ -z "$yaml_desc" ]; then
    yaml_desc="OpenAllIn $skill_name 命令"
  fi

  # Extract body: everything after the second --- line
  # Skip first --- block (YAML frontmatter), get content after second ---
  body="$(echo "$content" | awk 'BEGIN{c=0} /^---$/{c++; if(c>=2){found=1; next}} found{print}')"

  local usage_scenarios="当用户在对话中提及相关操作时自动触发"

  case "$skill_name" in
    oa-propose)
      usage_scenarios="当用户说'我想加个功能'、'我要新增'、'创建一个变更'、'/oa-propose'时触发"
      ;;
    oa-apply)
      usage_scenarios="当用户说'开始实现'、'执行任务'、'/oa-apply'时触发"
      ;;
    oa-validate)
      usage_scenarios="当用户说'验证规格'、'检查格式'、'/oa-validate'时触发"
      ;;
    oa-archive)
      usage_scenarios="当用户说'归档变更'、'合并规格'、'/oa-archive'时触发"
      ;;
    oa-discuss)
      usage_scenarios="当用户说'讨论需求'、'讨论一下'、'/oa-discuss'时触发"
      ;;
    oa-plan)
      usage_scenarios="当用户说'规划任务'、'拆分任务'、'/oa-plan'时触发"
      ;;
    oa-execute)
      usage_scenarios="当用户说'开始执行'、'执行任务'、'/oa-execute'时触发"
      ;;
    oa-verify)
      usage_scenarios="当用户说'验证'、'检查质量'、'/oa-verify'时触发"
      ;;
    oa-ship)
      usage_scenarios="当用户说'发布'、'创建PR'、'提交代码'、'/oa-ship'时触发"
      ;;
    oa-review)
      usage_scenarios="当用户说'代码审查'、'检查代码质量'、'/oa-review'时触发"
      ;;
    oa-security)
      usage_scenarios="当用户说'安全检查'、'安全审计'、'/oa-security'时触发"
      ;;
    oa-land)
      usage_scenarios="当用户说'部署'、'上线'、'/oa-land'时触发"
      ;;
    oa-brainstorming)
      usage_scenarios="当用户说'头脑风暴'、'创意讨论'、'/oa-brainstorming'时触发"
      ;;
    oa-debugging)
      usage_scenarios="当用户说'调试'、'修复bug'、'/oa-debugging'时触发"
      ;;
    oa-tdd)
      usage_scenarios="当用户说'测试驱动'、'先写测试'、'/oa-tdd'时触发"
      ;;
    oa-writing-plans)
      usage_scenarios="当用户说'写计划'、'任务规划'、'/oa-writing-plans'时触发"
      ;;
    oa-worktree)
      usage_scenarios="当用户说'创建分支'、'隔离环境'、'/oa-worktree'时触发"
      ;;
    oa-ui-design)
      usage_scenarios="当用户说'UI设计'、'界面设计'、'/oa-ui-design'时触发"
      ;;
    oa-qa-browser)
      usage_scenarios="当用户说'浏览器测试'、'Playwright测试'、'/oa-qa-browser'时触发"
      ;;
    oa-benchmark)
      usage_scenarios="当用户说'性能测试'、'基准测试'、'/oa-benchmark'时触发"
      ;;
    oa-team-plan)
      usage_scenarios="当用户说'团队规划'、'多人任务分配'、'/oa-team-plan'时触发"
      ;;
    oa-team-exec)
      usage_scenarios="当用户说'团队执行'、'并行开发'、'/oa-team-exec'时触发"
      ;;
    oa-team-verify)
      usage_scenarios="当用户说'团队验证'、'质量检查'、'/oa-team-verify'时触发"
      ;;
    *)
      usage_scenarios="当用户在对话中提及相关操作时自动触发"
      ;;
  esac

  cat > "$target_file" << EOF
---
name: $yaml_name
description: $yaml_desc
---

# $yaml_name

## 描述

$yaml_desc

## 使用场景

$usage_scenarios

$body
EOF

  echo "  ✅ skill: $skill_name"
}

for skill_file in "$HARNESS_DIR/skills/oa-"*.md; do
  [ -f "$skill_file" ] || continue
  convert_skill_to_trae "$skill_file"
done

# ============================================================
# Step 6: 创建 Agent 规则（Trae 没有 agents/ 目录，转为规则）
# ============================================================
echo ""
echo "🤖 Step 6: 安装 Agent 角色定义（转为 Trae 规则格式）..."

convert_agent_to_rule() {
  local agent_file="$1"
  local agent_name
  agent_name=$(basename "$agent_file" .md)

  local target_file=".trae/rules/agent-${agent_name}.md"

  if [ -f "$target_file" ]; then
    echo "  ⏭️  agent-$agent_name 已存在，跳过"
    return
  fi

  local content
  content=$(cat "$agent_file")

  cat > "$target_file" << EOF
---
alwaysApply: false
description: "定义 ${agent_name} Agent 的职责、工具权限和工作流程。在多 Agent 协作场景中使用。"
---

# ${agent_name} Agent 角色定义

$content
EOF

  echo "  ✅ agent: $agent_name (转为规则)"
}

for agent_file in "$HARNESS_DIR/agents/"*.md; do
  [ -f "$agent_file" ] || continue
  convert_agent_to_rule "$agent_file"
done

# ============================================================
# Step 7: 创建技能配置
# ============================================================
echo ""
echo "⚙️ Step 7: 创建技能配置..."

if [ ! -f ".trae/skill-config.json" ]; then
  cat > ".trae/skill-config.json" << 'EOF'
{
  "skills": [],
  "disabled_skills": []
}
EOF
  echo "  ✅ .trae/skill-config.json"
fi

# ============================================================
# 完成
# ============================================================
echo ""
echo "✅ OpenAllIn 安装到 Trae CN 完成!"
echo ""
echo "已安装到: $(pwd)"
echo ""
echo "📂 安装的内容:"
echo "  ├── AGENTS.md               # AI 工具统一入口（Trae 兼容）"
echo "  ├── project.md              # 项目全局上下文"
echo "  ├── .trae/"
echo "  │   ├── rules/              # Trae 项目规则（含 alwaysApply 配置）"
echo "  │   │   ├── openallin-bootstrap.md  ← 始终生效的核心规则"
echo "  │   │   ├── coding-standards.md     ← 编码规范"
echo "  │   │   ├── security-rules.md       ← 安全规则"
echo "  │   │   ├── commit-rules.md         ← 提交规范"
echo "  │   │   ├── review-rules.md         ← 审查规则"
echo "  │   │   └── agent-*.md              ← Agent 角色定义"
echo "  │   ├── skills/             # Trae 项目技能（23 个 oa-* 命令）"
echo "  │   │   ├── oa-propose/SKILL.md"
echo "  │   │   ├── oa-apply/SKILL.md"
echo "  │   │   ├── oa-discuss/SKILL.md"
echo "  │   │   └── ..."
echo "  │   └── skill-config.json   # 技能配置"
echo "  ├── templates/              # 模板库"
echo "  ├── scripts/                # 工具脚本"
echo "  ├── workspace/              # 项目记忆（模板）"
echo "  ├── config/                 # 配置模板"
echo "  └── lib/                    # 支持库"
echo ""
echo "📌 下一步：运行初始化脚本"
echo "  bash scripts/init-trae-cn.sh"
echo ""
echo "🔧 在 Trae CN 中使用:"
echo ""
echo "  1. 用 Trae CN 打开此项目目录"
echo "  2. 进入 设置 > 规则和技能"
echo "  3. 确认项目规则和技能已自动加载（alwaysApply: true 的规则已启用）"
echo "  4. 在 导入设置 中，打开 '将 AGENTS.md 包含在上下文中' 开关"
echo "  5. 在 导入设置 中，打开 '启用 .agents 技能目录' 开关（可选）"
echo "  6. 开始使用！"
echo ""
echo "💡 快速开始:"
echo "  输入: '我想加个用户登录功能'  → 自动触发 oa-propose"
echo "  输入: '讨论一下需求'          → 自动触发 oa-discuss"
echo "  输入: '开始实现'              → 自动触发 oa-apply"
echo ""
echo "📖 更多信息: 参见 AGENTS.md, ARCHITECTURE.md, WORKFLOW.md"
echo ""
