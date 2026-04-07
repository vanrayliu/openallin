#!/bin/bash

# 变更归档脚本
# 将已完成的变更合并到主规格并归档

set -e

CHANGE_NAME="${1:-}"
CHANGES_DIR="${2:-changes}"
SPECS_DIR="${3:-specs}"

if [ -z "$CHANGE_NAME" ]; then
  echo "用法: $0 <change-name> [changes-dir] [specs-dir]"
  exit 1
fi

CHANGE_DIR="$CHANGES_DIR/$CHANGE_NAME"
ARCHIVE_DIR="$CHANGES_DIR/archive/$(date +%Y-%m-%d)-$CHANGE_NAME"

if [ ! -d "$CHANGE_DIR" ]; then
  echo "❌ 变更目录不存在: $CHANGE_DIR"
  exit 1
fi

echo "📦 归档变更: $CHANGE_NAME"
echo "---"

# 1. 合并增量规格
if [ -d "$CHANGE_DIR/specs" ]; then
  echo "📝 合并增量规格..."
  find "$CHANGE_DIR/specs" -name "spec.md" | while read -r spec_file; do
    # 获取相对路径
    REL_PATH="${spec_file#$CHANGE_DIR/specs/}"
    REL_PATH="${REL_PATH%/spec.md}"
    TARGET_SPEC="$SPECS_DIR/$REL_PATH/spec.md"

    # 确保目标目录存在
    mkdir -p "$(dirname "$TARGET_SPEC")"

    # 处理 ADDED
    if grep -q "^## ADDED Requirements" "$spec_file"; then
      echo "  ➕ 合并 ADDED: $REL_PATH"
      # 提取 ADDED 到文件末尾或下一个 ## 开头的 section
      awk '/^## ADDED Requirements/{found=1; next} found && /^## (MODIFIED|REMOVED) Requirements/{found=0} found' "$spec_file" >> "$TARGET_SPEC" 2>/dev/null || true
    fi

    # 处理 MODIFIED
    if grep -q "^## MODIFIED Requirements" "$spec_file"; then
      echo "  🔄 合并 MODIFIED: $REL_PATH"
      awk '/^## MODIFIED Requirements/{found=1; next} found && /^## REMOVED Requirements/{found=0} found' "$spec_file" >> "$TARGET_SPEC" 2>/dev/null || true
    fi

    # 处理 REMOVED
    if grep -q "^## REMOVED Requirements" "$spec_file"; then
      echo "  ➖ 合并 REMOVED: $REL_PATH"
      awk '/^## REMOVED Requirements/{found=1; next} found' "$spec_file" >> "$TARGET_SPEC" 2>/dev/null || true
    fi
  done
fi

# 2. 移动到归档目录
echo "📁 移动到归档..."
mkdir -p "$ARCHIVE_DIR"
mv "$CHANGE_DIR"/* "$ARCHIVE_DIR/" 2>/dev/null || true
rmdir "$CHANGE_DIR" 2>/dev/null || true

echo "---"
echo "✅ 变更已归档到: $ARCHIVE_DIR"
