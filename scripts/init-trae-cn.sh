#!/bin/bash

# OpenAllIn 初始化脚本 - Trae CN 版
# 在 Trae CN 新项目根目录运行此脚本
# 前提：已运行 install-trae-cn.sh 安装框架
# 用法:
#   bash scripts/init-trae-cn.sh                    # 初始化当前目录
#   bash scripts/init-trae-cn.sh --target dir       # 初始化指定目录
#   bash scripts/init-trae-cn.sh dir                # 初始化指定目录（简写）

set -e

HARNESS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${1:-.}"

# 解析参数
SKIP_NEXT=false
for arg in "$@"; do
  if [ "$SKIP_NEXT" = true ]; then
    TARGET_DIR="$arg"
    SKIP_NEXT=false
    continue
  fi
  if [ "$arg" = "--target" ] || [ "$arg" = "-t" ]; then
    SKIP_NEXT=true
    continue
  fi
  case "$arg" in
    --target=*|-t=*)
      TARGET_DIR="${arg#*=}"
      ;;
    *)
      if [ -d "$arg" ] || [ "$arg" = "." ]; then
        TARGET_DIR="$arg"
      fi
      ;;
  esac
done

echo "🚀 OpenAllIn 初始化 — Trae CN 版"
echo "================================"

# 检查目标目录
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ 目标目录不存在: $TARGET_DIR"
  exit 1
fi

cd "$TARGET_DIR"

# 检查是否已安装框架
if [ ! -d ".trae" ]; then
  echo "⚠️  未检测到 .trae/ 目录，请先运行安装脚本："
  echo "  bash scripts/install-trae-cn.sh"
  echo ""
  echo "是否继续初始化？(y/N)"
  read -r response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi

# ============================================================
# Step 1: 创建项目目录结构
# ============================================================
echo "📁 创建目录结构..."

# 核心目录
mkdir -p changes/archive
mkdir -p tasks/archive
mkdir -p workspace/journals
mkdir -p .planning

# 复制 specs 目录（含子目录和文件）
if [ -d "$HARNESS_DIR/specs" ]; then
  cp -rn "$HARNESS_DIR/specs" . 2>/dev/null || true
  echo "  ✅ specs/ (已复制)"
fi

echo "  ✅ changes/archive/"
echo "  ✅ tasks/archive/"
echo "  ✅ workspace/journals/"
echo "  ✅ .planning/"

# ============================================================
# Step 2: 创建状态文件
# ============================================================
echo ""
echo "📊 创建状态文件..."

if [ ! -f "workspace/STATE.md" ]; then
  cat > workspace/STATE.md << EOF
# 当前状态

> 最后更新: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## 当前任务
无活跃任务

## 进度
OpenAllIn (Trae CN) 已初始化

## 待确认事项
无
EOF
  echo "  ✅ workspace/STATE.md"
fi

if [ ! -f "workspace/ROADMAP.md" ]; then
  cat > workspace/ROADMAP.md << 'EOF'
# 项目路线图

## 规格状态
| 模块 | 状态 | 最后更新 |
|------|------|---------|
| - | - | - |

## 变更状态
| 变更 | 状态 | 阶段 |
|------|------|------|
| - | - | - |

## 任务状态
| 任务 | 状态 | 负责人 |
|------|------|--------|
| - | - | - |
EOF
  echo "  ✅ workspace/ROADMAP.md"
fi

# ============================================================
# Step 3: 创建配置文件
# ============================================================
echo ""
echo "⚙️ 创建配置文件..."

if [ ! -f "config/settings.json" ]; then
  cat > config/settings.json << 'EOF'
{
  "version": "1.0.0",
  "mode": "interactive",
  "granularity": "standard",
  "model_profile": "balanced",
  "features": {
    "spec_driven": true,
    "phase_execution": true,
    "team_orchestration": false,
    "security_hooks": true,
    "memory_persistence": true,
    "continuous_learning": false
  },
  "limits": {
    "max_thinking_tokens": 10000,
    "autocompact_pct": 50,
    "subagent_model": "haiku",
    "max_parallel_tasks": 3,
    "ralph_loop_max_iterations": 5
  },
  "paths": {
    "specs_dir": "specs",
    "changes_dir": "changes",
    "skills_dir": ".trae/skills",
    "rules_dir": ".trae/rules",
    "tasks_dir": "tasks",
    "workspace_dir": "workspace",
    "planning_dir": ".planning"
  }
}
EOF
  echo "  ✅ config/settings.json"
fi

if [ ! -f "config/memory.json" ]; then
  cat > config/memory.json << 'EOF'
{
  "project_decisions": [],
  "learned_patterns": [],
  "recurring_issues": [],
  "team_conventions": [],
  "last_updated": null
}
EOF
  echo "  ✅ config/memory.json"
fi

if [ ! -f "config/instincts.json" ]; then
  cat > config/instincts.json << 'EOF'
{
  "instincts": [],
  "version": "1.0.0",
  "description": "直觉/模式库 — 从会话中自动提取的可靠模式",
  "schema": {
    "instinct": {
      "id": "string",
      "pattern": "string",
      "context": "string",
      "confidence": "number (0-1)",
      "times_used": "number",
      "created_at": "ISO date",
      "updated_at": "ISO date"
    }
  }
}
EOF
  echo "  ✅ config/instincts.json"
fi

if [ ! -f ".planning/config.json" ]; then
  cat > ".planning/config.json" << 'EOF'
{
  "mode": "interactive",
  "granularity": "standard",
  "model_profile": "balanced"
}
EOF
  echo "  ✅ .planning/config.json"
fi

# ============================================================
# 完成
# ============================================================
echo ""
echo "✅ OpenAllIn (Trae CN) 初始化完成!"
echo ""
echo "已安装到: $(pwd)"
echo ""
echo "📂 创建的内容:"
echo "  ├── specs/                  # 系统规格"
echo "  ├── changes/                # 变更提案"
echo "  ├── tasks/                  # 任务驱动"
echo "  ├── workspace/"
echo "  │   ├── STATE.md            # 当前状态"
echo "  │   ├── ROADMAP.md          # 项目路线图"
echo "  │   └── journals/           # 会话日志"
echo "  ├── config/"
echo "  │   ├── settings.json       # 框架配置"
echo "  │   ├── memory.json         # 学习记忆"
echo "  │   └── instincts.json      # 模式库"
echo "  └── .planning/"
echo "      └── config.json         # 规划配置"
echo ""
echo "🔧 在 Trae CN 中使用:"
echo "  1. 用 Trae CN 打开此项目"
echo "  2. 规则和技能已自动加载"
echo "  3. 编辑 project.md 填入项目信息"
echo ""
echo "💡 快速开始:"
echo "  输入: '我想加个功能'  → 自动触发 oa-propose"
echo "  输入: '讨论需求'      → 自动触发 oa-discuss"
echo "  输入: '开始实现'      → 自动触发 oa-apply"
echo ""
