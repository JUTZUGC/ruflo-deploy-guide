#!/usr/bin/env bash
set -euo pipefail
# Ruflo 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/ruvnet/ruflo#quick-start
# 更新日期：2026-10-28
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

node -e "const a=Number(process.versions.node.split('.')[0]); if (a < 20) { console.error('需要 Node.js 20 或更高版本'); process.exit(1) }"
npx -y ruflo@latest init
npx -y ruflo@latest --version

echo ""

echo "初始化完成：运行 npx ruflo@latest tui 打开控制台；在 Claude Code 里可用 /ruflo"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/ruvnet/ruflo#quick-start"
