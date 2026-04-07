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

# 辅助函数：提取并去重合并指定 section 到目标文件
# 支持任意缩进级别的 Markdown 标题（^#{1,6}）
merge_section() {
  local spec_file="$1"
  local target_file="$2"
  local section_name="$3"   # ADDED | MODIFIED | REMOVED

  # 检查该 section 是否存在
  if ! grep -qE "^#{1,6} ${section_name} Requirements" "$spec_file"; then
    return
  fi

  echo "  ➕ 合并 ${section_name}: ${spec_file#$CHANGE_DIR/specs/}"

  # 收集目标文件中已有的 Requirement 名称
  local existing_reqs
  existing_reqs=$(awk '/^#{1,6} Requirement:/ {
    gsub(/^#{1,6} +/, "");
    print;
    found=1
  }
  /^#{1,6} [^R]/{ found=0 }
  /^#{1,6} Requirement:/{ if (found) next }
  found { sub(/^#{1,6} +/, ""); print }
  ' "$target_file" 2>/dev/null || true)

  # 提取该 section 的完整内容块（保留缩进）
  local section_content
  section_content=$(awk -v sect="${section_name}" '
    BEGIN { capturing=0 }
    # 匹配任意缩进的 "## ADDED/MODIFIED/REMOVED Requirements" 标题
    $0 ~ "^#{1,6} " sect " Requirements" {
      capturing=1;
      next;
    }
    capturing && $0 ~ "^#{1,6} (ADDED|MODIFIED|REMOVED) Requirements" {
      capturing=0;
      next;
    }
    capturing {
      print;
    }
  ' "$spec_file")

  # 按 Requirement 块逐个追加（去重：仅当该 Requirement 尚不存在时）
  local in_block=0
  local block_name=""
  local block_lines=""

  while IFS= read -r line; do
    # 检测 Requirement 标题行（支持任意缩进），统一为 ## 二级标题格式
    if echo "$line" | grep -qE '^#{1,6} Requirement:'; then
      # 先输出上一个块（如果存在且是新增的）
      if [ -n "$block_lines" ]; then
        printf '%s\n' "$block_lines" >> "$target_file"
      fi

      # 提取 Requirement 名称，并统一为 ## 二级标题
      # 使用 ERE（-E 标志），{1,6} 量词才能正确工作
      block_name=$(echo "$line" | sed -E 's/^#{1,6} +Requirement: +/Requirement: /')

      # 检查是否已存在于目标文件
      if echo "$existing_reqs" | grep -qF -- "$block_name"; then
        block_lines=""
        in_block=0
      else
        block_lines="## ${block_name}"
        in_block=1
        existing_reqs="${existing_reqs}${block_name}"$'\n'
      fi
    elif [ $in_block -eq 1 ]; then
      # 累积该块的内容行
      block_lines="${block_lines}"$'\n'"$line"
    fi
  done <<< "$section_content"

  # 输出最后一个块
  if [ -n "$block_lines" ]; then
    printf '%s\n' "$block_lines" >> "$target_file"
  fi
}

# 1. 合并增量规格
if [ -d "$CHANGE_DIR/specs" ]; then
  echo "📝 合并增量规格..."
  while IFS= read -r spec_file; do
    # 获取相对路径
    REL_PATH="${spec_file#$CHANGE_DIR/specs/}"
    REL_PATH="${REL_PATH%/spec.md}"
    TARGET_SPEC="$SPECS_DIR/$REL_PATH/spec.md"

    # 确保目标目录存在
    mkdir -p "$(dirname "$TARGET_SPEC")"

    # 确保目标文件存在
    [ -f "$TARGET_SPEC" ] || touch "$TARGET_SPEC"

    # 依次合并（去重）
    merge_section "$spec_file" "$TARGET_SPEC" "ADDED"
    merge_section "$spec_file" "$TARGET_SPEC" "MODIFIED"
    merge_section "$spec_file" "$TARGET_SPEC" "REMOVED"
  done < <(find "$CHANGE_DIR/specs" -name "spec.md")
fi

# 2. 移动到归档目录
echo "📁 移动到归档..."
mkdir -p "$ARCHIVE_DIR"
mv "$CHANGE_DIR"/* "$ARCHIVE_DIR/" 2>/dev/null || true
rmdir "$CHANGE_DIR" 2>/dev/null || true

echo "---"
echo "✅ 变更已归档到: $ARCHIVE_DIR"
