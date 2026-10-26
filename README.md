# Ruflo 一键部署指南

> 第三方部署指南 · 非 Ruflo 官方仓库。官方项目：[ruvnet/ruflo](https://github.com/ruvnet/ruflo)
> 内容来自官方文档（2026-10-26）。项目迭代快，请以[官方文档](https://github.com/ruvnet/ruflo#quick-start)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己拼 Agent 和记忆，让百度搭子一条命令把 Ruflo 的编排层初始化好。

⚠️ 需要 Node.js 20+。`npx ruflo init` 会往当前项目写 `.claude/`、`.claude-flow/`、`CLAUDE.md` 等文件，建议在独立项目目录里初始化。Claude Code 插件与 CLI 是两条不同的安装路径，不要混装。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/ruflo-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会检查 Node 版本，跑 ruflo init 在当前项目写入配置与 MCP 注册，最后确认版本，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## Ruflo 是什么？

Ruflo 是开源的面向编码 Agent 的集群编排与记忆层（协议：MIT，<img src="https://img.shields.io/github/stars/ruvnet/ruflo?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把单个编码 Agent 扩展成可协作的集群：98 个预置 Agent、60+ 命令、30 个技能，带向量记忆、MCP server、hooks 与后台 daemon；有 TUI 控制台和 Claude Code 插件两种入口。

- Agent：98 个预置角色，可组 swarm 协作
- 记忆：跨会话向量记忆与知识图谱
- 入口：Claude Code 插件 / CLI / MCP server / TUI
- 治理：路由、策略、成本与事件面板
- 规模：100+ Release，当前 v3.63.3

（来源：[官方仓库](https://github.com/ruvnet/ruflo)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 79.4k stars | 2025-06 建，16 个月持续迭代 |
| 功能面大 | 98 Agent、60+ 命令、30 技能 |
| 多种入口 | 插件、CLI、MCP、TUI 都有 |
| 记忆体系完整 | 向量库 + 知识图谱 + 跨会话 |
| 发版密集 | 100+ Release，修复快 |

| 需要注意 | 说明 |
|---|---|
| 会写项目文件 | init 会生成多份配置 |
| 概念很重 | swarm、memory、hooks 要学 |
| 两条路径易混 | 插件和 CLI 功能不一致 |
| Node 20+ | 旧环境要升级 |
| 质量参差 | 版本迭代快，偶有回归 |

> 以上基于官方文档与社区反馈整理（2026-10-26），以官方最新文档为准。

## 快速部署（官方方式）

```bash
node -e "const a=Number(process.versions.node.split('.')[0]); if (a < 20) { console.error('需要 Node.js 20 或更高版本'); process.exit(1) }"
npx -y ruflo@latest init
npx -y ruflo@latest --version
```

部署步骤来源：[https://github.com/ruvnet/ruflo#quick-start](https://github.com/ruvnet/ruflo#quick-start)

## 验证状态

| 场景 | 状态 |
|---|---|
| npm 包 ruflo 版本 3.63.3、engines.node >=20.0.0 已核对 | 已验证 2026-10-26 |
| Windows 上 npx ruflo@latest --version 实测输出 ruflo v3.63.3 | 已验证 2026-10-26 |
| 未执行 init（会往当前项目写配置，本机未实跑） | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

Ruflo 自带 MCP server，可注册到 Claude Code 等客户端。本仓库的 MCP 只提供安装、初始化与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-26）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\ruflo-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 初始化之后

1. 看控制台：`npx ruflo@latest tui`（脚本里可加 `--plain` 只输出一帧）
2. 在 Claude Code 里重启后输入 `/ruflo` 打开 cockpit
3. 注册 MCP：`claude mcp add claude-flow -- npx ruflo@latest mcp start`
4. 查看帮助：`npx ruflo@latest --help`

### 两条安装路径怎么选

| 路径 | 适合 | 代价 |
|---|---|---|
| Claude Code 插件 | 只想用几个斜杠命令 | 不写项目文件，但功能少 |
| `npx ruflo init` | 要完整集群、记忆、hooks、MCP | 会往项目里写配置 |

### 卸载与清理

- 插件：`/plugin uninstall ruflo-core@ruflo` 等
- CLI：删除项目里的 `.claude/`、`.claude-flow/`、`CLAUDE.md` 与相关 helpers

> ⚠️ 初始化会改项目配置。先在独立目录或新分支里试，确认 Diff 后再合并。

## 常见坑

- `curl | bash` 在 Windows 失败：改用 `npx ruflo@latest init`，原生 PowerShell 可用
- Node 版本不够：必须 20+
- 插件和 CLI 混装：功能与工具名会重复，选一条路径
- 工具名对不上：插件装的 MCP 工具带 `mcp__plugin_...` 前缀
- 不想污染项目：先在新分支或独立目录初始化
- TUI 打不开：确认终端支持交互，CI 里用 `tui --plain`
- 升级后行为变化：先看 Release 说明，再重跑 init

## 免责声明

本仓库为第三方指南，与 Ruflo 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-26），项目迭代快，请以[官方文档](https://github.com/ruvnet/ruflo#quick-start)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
