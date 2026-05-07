#!/usr/bin/env bash
set -euo pipefail

# 对指定目录及其子目录下所有 Python 文件执行 Ruff lint 和 format。
# 未指定目录时，默认使用脚本所在目录。

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CHECK_ONLY=0

print_help() {
  cat <<'EOF'
用法：
  ruff_lint_format.sh [选项] [目录]

说明：
  对指定目录及其子目录下所有 Python 文件执行 Ruff lint 和 format。
  未指定目录时，默认使用脚本所在目录。

选项：
  --check-only   只检查，不修改文件（ruff check + ruff format --check）
  -h, --help     显示帮助信息并退出
EOF
}

TARGET_DIR="$SCRIPT_DIR"
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check-only)
      CHECK_ONLY=1
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    -*)
      echo "错误：未知参数 $1" >&2
      echo "可用参数：--check-only, -h, --help" >&2
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#POSITIONAL_ARGS[@]} -gt 1 ]]; then
  echo "错误：最多只能指定一个目录参数" >&2
  exit 1
fi

if [[ ${#POSITIONAL_ARGS[@]} -eq 1 ]]; then
  TARGET_DIR="${POSITIONAL_ARGS[0]}"
fi

if ! command -v ruff >/dev/null 2>&1; then
  echo "错误：未找到 ruff，请先安装（例如：pip install ruff）" >&2
  exit 1
fi

if [[ ! -e "$TARGET_DIR" ]]; then
  echo "错误：目录不存在：$TARGET_DIR" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "错误：目标不是目录：$TARGET_DIR" >&2
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"

overall_exit_code=0
check_exit_code=0
format_exit_code=0

if [[ "$CHECK_ONLY" -eq 1 ]]; then
  echo "\$ ruff check \"$TARGET_DIR\""
  set +e
  ruff check "$TARGET_DIR"
  check_exit_code=$?
  set -e

  echo "\$ ruff format --check \"$TARGET_DIR\""
  set +e
  ruff format --check "$TARGET_DIR"
  format_exit_code=$?
  set -e
else
  echo "\$ ruff check --fix \"$TARGET_DIR\""
  set +e
  ruff check --fix "$TARGET_DIR"
  check_exit_code=$?
  set -e

  echo "\$ ruff format \"$TARGET_DIR\""
  set +e
  ruff format "$TARGET_DIR"
  format_exit_code=$?
  set -e
fi

if [[ "$check_exit_code" -ne 0 || "$format_exit_code" -ne 0 ]]; then
  overall_exit_code=1
fi

if [[ "$check_exit_code" -ne 0 ]]; then
  echo "检查阶段失败（exit code: $check_exit_code）" >&2
fi
if [[ "$format_exit_code" -ne 0 ]]; then
  echo "格式化阶段失败（exit code: $format_exit_code）" >&2
fi

if [[ "$overall_exit_code" -eq 0 ]]; then
  echo "完成：已处理目录 $TARGET_DIR"
else
  echo "完成：已处理目录 $TARGET_DIR，但存在失败项。" >&2
fi

exit "$overall_exit_code"
