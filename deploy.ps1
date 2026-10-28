# Ruflo 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/ruvnet/ruflo#quick-start
# 更新日期：2026-10-28
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

node -e "const a=Number(process.versions.node.split('.')[0]); if (a < 20) { throw new Error('需要 Node.js 20 或更高版本') }"
npx.cmd -y ruflo@latest init
npx.cmd -y ruflo@latest --version

Write-Host ''

Write-Host '初始化完成：运行 npx ruflo@latest tui 打开控制台；在 Claude Code 里可用 /ruflo'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/ruvnet/ruflo#quick-start'
