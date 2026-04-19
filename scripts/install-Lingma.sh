#!/bin/bash

# Lingma IDE 安装脚本
# 用法: 
#   bash scripts/install-Lingma.sh                    # 安装到当前目录
#   bash scripts/install-Lingma.sh --target dir      # 安装到指定目录
#   bash scripts/install-Lingma.sh dir                # 安装到指定目录（简写）

set -e

HARNESS_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# 解析参数
TARGET="."
SKIP_NEXT=false

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
  # Handle --target=value format
  case "$arg" in
    --target=*)
      TARGET="${arg#*=}"
      ;;
    -t=*)
      TARGET="${arg#*=}"
      ;;
    *)
      # 其他参数，检查是否是有效路径
      if [ -d "$arg" ] || [ "$arg" = "." ]; then
        TARGET="$arg"
      fi
      ;;
  esac
done

echo "🚀 Lingma IDE OpenAllIn 安装程序"
echo "=================================="
echo "目标目录: $TARGET"
echo ""

# 检测并阻止安装到 home 目录或根目录
EXPANDED_TARGET=$(eval echo "$TARGET")
if [ "$EXPANDED_TARGET" = "$HOME" ] || [ "$EXPANDED_TARGET" = "/" ] || [ "$EXPANDED_TARGET" = "$HOME/" ]; then
  echo "❌ 不允许安装到 home 目录 ($HOME) 或根目录"
  echo ""
  echo "请在项目目录下运行安装："
  echo "  cd your-project && bash scripts/install-Lingma.sh"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "❌ 目标目录不存在: $TARGET"
  exit 1
fi

cd "$TARGET"

# 复制公共文件
echo "📁 复制公共文件..."
[ ! -f "AGENTS.md" ] && cp "$HARNESS_DIR/AGENTS.md" .
[ ! -f "project.md" ] && cp "$HARNESS_DIR/project.md" .
cp -rn "$HARNESS_DIR/specs" . 2>/dev/null || true
cp -rn "$HARNESS_DIR/changes" . 2>/dev/null || true
cp -rn "$HARNESS_DIR/config" . 2>/dev/null || true
cp -rn "$HARNESS_DIR/workspace" . 2>/dev/null || true
cp -rn "$HARNESS_DIR/templates" . 2>/dev/null || true
cp -rn "$HARNESS_DIR/scripts" . 2>/dev/null || true

# 创建必要目录（确保完整性）
mkdir -p changes/archive tasks/archive

# 复制 .planning 目录（含所有文件）
if [ -d "$HARNESS_DIR/.planning" ]; then
  cp -rn "$HARNESS_DIR/.planning" . 2>/dev/null || true
  echo "  ✅ .planning/ 已复制"
fi

# 创建 .lingma 目录结构
echo ""
echo "🔧 安装到 Lingma IDE..."

mkdir -p .lingma/{skills,agents,rules}

# 复制 lib/ 目录（支持库）— 复制到项目根目录
if [ -d "$HARNESS_DIR/lib" ]; then
  cp -rn "$HARNESS_DIR/lib" . 2>/dev/null || true
  echo "  ✅ lib/ 支持库已复制"
fi

# 复制 rules — 添加 frontmatter 头
for rule_file in "$HARNESS_DIR/rules/"*.md; do
  [ -f "$rule_file" ] || continue
  rule_name=$(basename "$rule_file")
  
  if [ ! -f ".lingma/rules/$rule_name" ]; then
    # 添加 trigger: always_on frontmatter
    cat > ".lingma/rules/$rule_name" << EOF
---
trigger: always_on
---
$(cat "$rule_file")
EOF
    echo "  ✅ rule: $rule_name"
  fi
done

# 特别处理 project-context.md — 从模板复制
if [ ! -f ".lingma/rules/project-context.md" ]; then
  cat > ".lingma/rules/project-context.md" << 'EOF'
---
trigger: always_on
---
# 项目上下文加载规则

## 强制要求

**在开始任何开发任务之前,必须执行以下步骤:**

1. **读取项目上下文**: 使用 Read 工具读取 `project.md` 文件
2. **理解技术栈**: 记录项目使用的语言、框架、包管理器等
3. **了解架构模式**: 理解项目的架构风格、分层约定、数据流
4. **掌握编码规范**: 遵循项目的命名约定、文件格式、注释风格
5. **熟悉业务领域**: 了解领域术语、核心实体、业务流程

## 何时应用

此规则在所有情况下都适用,特别是:
- 开始新功能开发时
- 修复 bug 时
- 重构代码时
- 编写测试时
- 进行代码审查时

## 注意事项

- `project.md` 是项目的"世界观"锚点,包含所有必要的上下文信息
- 如果 `project.md` 中的信息不完整,请在完成后更新它
- 始终优先遵循 `project.md` 中定义的项目特定规范
- 当项目规范与通用最佳实践冲突时,以 `project.md` 为准
EOF
  echo "  ✅ rule: project-context.md (新建)"
fi

# 复制 skills — 转换为 <name>/SKILL.md 格式
for skill_file in "$HARNESS_DIR/skills/"*.md; do
  [ -f "$skill_file" ] || continue
  name=$(basename "$skill_file" .md)
  mkdir -p ".lingma/skills/$name"
  cp "$skill_file" ".lingma/skills/$name/SKILL.md"
  echo "  ✅ skill: $name"
done

# 复制 agents — 添加 YAML frontmatter
for agent_file in "$HARNESS_DIR/agents/"*.md; do
  [ -f "$agent_file" ] || continue
  agent_name=$(basename "$agent_file")
  name=$(basename "$agent_file" .md)
  
  if [ ! -f ".lingma/agents/$agent_name" ]; then
    # 提取 agent 的 description（从标题行提取角色描述）
    # 例如: "# Implementer Agent — 实现者" -> "实现者"
    description=$(head -n 1 "$agent_file" | sed 's/.*—\s*//' | xargs)
    
    # 如果提取失败，使用默认描述
    if [ -z "$description" ] || [ "$description" = "" ]; then
      description="AI Agent for $name"
    fi
    
    # 提取工具列表（从 ## 工具 部分）
    tools=$(sed -n '/^## 工具/,/^##/p' "$agent_file" | grep '^-' | sed 's/^- //' | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')
    
    # 如果没有找到工具，设置默认值
    if [ -z "$tools" ]; then
      tools="Read, Write, Edit, Bash, Grep, Glob"
    fi
    
    # 创建带 frontmatter 的文件
    cat > ".lingma/agents/$agent_name" << EOF
---
name: $name
description: $description
tools: $tools
---

$(cat "$agent_file")
EOF
    echo "  ✅ agent: $agent_name"
  fi
done

echo ""
echo "✅ Lingma IDE OpenAllIn 安装完成!"
echo ""
echo "已安装到: $TARGET"
echo ""
echo "下一步:"
echo "  1. 编辑 project.md 填入你的项目信息"
echo "  2. 启动 Lingma IDE"
echo "  3. 输入 /oa-propose <name> 开始第一个变更提案"
echo ""
