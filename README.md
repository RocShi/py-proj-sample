# py-proj-sample

Python 工程化示例项目：

- 使用 `ruff` 做代码检查与格式化
- 使用 `pre-commit` 统一本地提交前检查
- 提供一键安装脚本与批量 lint/format 脚本

## 1. 环境要求

- Python 3.10+
- `pip`
- `bash`（用于运行 `install.sh` 和 `run_lint_format.sh`）
- 可选：`code`（VSCode CLI）与 `cursor`（Cursor CLI）

> 在 Windows 上建议用 Git Bash 或 WSL 执行 `.sh` 脚本。

## 2. 快速开始

```bash
./install.sh
```

该脚本会：

1. 安装项目开发依赖
2. 执行 `pre-commit install`
3. 如果检测到 VSCode/Cursor CLI，则安装这两个扩展：
   - `charliermarsh.ruff`
   - `ms-python.python`

## 3. 代码检查与格式化

### 常规模式（会自动修复）

```bash
./run_lint_format.sh
```

### 只检查不改文件

```bash
./run_lint_format.sh --check-only
```

### 指定目录

```bash
./run_lint_format.sh path/to/your/code
```

## 4. Pre-commit 使用

手动执行全部 hooks：

```bash
pre-commit run --all-files
```

仅在提交时自动触发：

```bash
git commit -m "your message"
```

## 5. 项目文件说明

- `install.sh`：安装开发环境、注册 pre-commit、安装编辑器扩展
- `run_lint_format.sh`：批量执行 `ruff check` 与 `ruff format`
- `.pre-commit-config.yaml`：本地 hook 配置
- `pyproject.toml`：`ruff` 配置
