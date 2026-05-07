#!/usr/bin/env bash

set -e

pip install ruff
pip install pre-commit
pre-commit install

EXTENSIONS=(
  "charliermarsh.ruff"
  "ms-python.python"
)

install_extensions() {
  local cli="$1"
  local app_name="$2"

  if command -v "$cli" >/dev/null 2>&1; then
    echo "Installing extensions for ${app_name}..."
    for ext in "${EXTENSIONS[@]}"; do
      "$cli" --install-extension "$ext" --force || true
    done
  else
    echo "${app_name} CLI not found, skipping."
  fi
}

install_extensions "code" "VSCode"
install_extensions "cursor" "Cursor"
