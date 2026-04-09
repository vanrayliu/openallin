#!/bin/bash

# OpenAllIn 卸载脚本
# 用法: bash scripts/uninstall.sh [--force]

set -e

echo "🗑️  OpenAllIn 卸载程序"
echo "======================"

# 检查是否在项目目录（不应该在 home）
EXPANDED_PWD=$(eval echo "$PWD")
if [ "$EXPANDED_PWD" = "$HOME" ] || [ "$EXPANDED_PWD" = "/" ]; then
  echo "❌ 不允许在 home 目录或根目录卸载"
  exit 1
fi

FORCE=false
if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
  FORCE=true
fi

echo "目标目录: $PWD"
echo ""

# 需要删除的文件和目录
OPENALLIN_FILES=(
  "AGENTS.md"
  "CLAUDE.md"
  "project.md"
)

OPENALLIN_DIRS=(
  ".claude"
  ".opencode"
  "config"
  "rules"
  "skills"
  "agents"
  "hooks"
  "scripts"
  "specs"
  "templates"
  "tasks"
  "workspace"
  ".planning"
  "changes"
)

# 检查是否真的安装了 OpenAllIn
installed=false
for dir in "${OPENALLIN_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    installed=true
    break
  fi
done

if [ "$installed" = false ]; then
  echo "⚠️  未检测到 OpenAllIn 安装"
  exit 0
fi

if [ "$FORCE" = false ]; then
  echo "将要删除以下文件和目录："
  echo ""
  for file in "${OPENALLIN_FILES[@]}"; do
    if [ -f "$file" ]; then
      echo "  📄 $file"
    fi
  done
  for dir in "${OPENALLIN_DIRS[@]}"; do
    if [ -d "$dir" ]; then
      echo "  📁 $dir/"
    fi
  done
  echo ""
  read -p "确认卸载? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 0
  fi
fi

echo "🗑️  开始卸载..."

# 删除文件
for file in "${OPENALLIN_FILES[@]}"; do
  if [ -f "$file" ]; then
    rm "$file"
    echo "  ✅ 删除: $file"
  fi
done

# 删除目录
for dir in "${OPENALLIN_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    rm -rf "$dir"
    echo "  ✅ 删除: $dir/"
  fi
done

# 清理可能的备份文件
rm -f *.bak.* 2>/dev/null || true
find . -name "*.bak.??????_??????" -delete 2>/dev/null || true

# 清理全局 settings.json 中的 OpenAllIn hooks
if [ -f "$HOME/.claude/settings.json" ] && command -v jq >/dev/null 2>&1; then
  if jq -e '.hooks.SessionStart[] | select(.hooks[].command | contains("session-start.js"))' "$HOME/.claude/settings.json" >/dev/null 2>&1; then
    echo ""
    echo "🧹 清理全局 settings.json 中的 OpenAllIn hooks..."
    BAK_FILE="$HOME/.claude/settings.json.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.claude/settings.json" "$BAK_FILE"
    
    jq 'del(.hooks.SessionStart, .hooks.SessionEnd, .hooks.PreToolUse, .hooks.PostToolUse)' \
      "$HOME/.claude/settings.json" > "$HOME/.claude/settings.json.tmp" && \
      mv "$HOME/.claude/settings.json.tmp" "$HOME/.claude/settings.json"
    
    echo "  ✅ 已清理 $HOME/.claude/settings.json"
    echo "  📦 备份已保存: $BAK_FILE"
  fi
fi

echo ""
echo "✅ OpenAllIn 已卸载"
echo ""
echo "注意: 如果需要重新安装，克隆仓库后运行："
echo "  bash scripts/install.sh claude"
