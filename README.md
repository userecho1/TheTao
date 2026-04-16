# TheTao 道

> 大道至简 — 一个基于 Copilot 原生能力的 AI 助手元认知系统。

## 理念

不预设身份，不硬编规则。从交互中感知需求、识别模式、涌现能力。

**一生二，二生三，三生万物** — 高频模式自然演化为 skill，专项协作领域自然演化为 agent，无需预先规划。

## 架构

```
TheTao/
└── .copilot/                        # 完整配置（同步镜像至 ~/.copilot/）
    ├── copilot-instructions.md      # 道核 — 元认知协议
    ├── agents/
    │   ├── discourse.agent.md       # 多视角讨论 agent
    │   └── wiki-maintainer.agent.md # Wiki 知识管理 agent
    └── skills/
        ├── wiki-inbox/SKILL.md      # 收件箱管理
        ├── wiki-ingest/SKILL.md     # 文档消化入库
        ├── wiki-query/SKILL.md      # 知识检索与综合
        ├── wiki-lint/SKILL.md       # Wiki 健康检查
        └── wiki-graph/SKILL.md      # 知识图谱构建
```

## 核心模块

### 道核 (`copilot-instructions.md`)

元认知协议，定义五个阶段：

| 阶段 | 职责 |
|------|------|
| **感知** | 读取项目记忆 → wiki 索引 → 用户记忆，识别上下文 |
| **判断** | 证据先行，最小行动，安全硬约束 |
| **行动** | 持续推进到完成或受阻 |
| **记忆** | 三层记忆写入与索引维护 |
| **进化** | 重复模式 → skill，专项领域 → agent |

### 三层记忆（Copilot 原生 memory 工具）

| 层级 | 路径 | 作用域 | 物理位置 |
|------|------|--------|----------|
| 项目记忆 | `/memories/repo/` | 随工作区自动切换 | `workspaceStorage/<id>/...` |
| 用户记忆 | `/memories/` | 跨所有工作区持久 | `globalStorage/GitHub.copilot-chat/...` |
| 会话记忆 | `/memories/session/` | 会话结束自动清理 | 同项目记忆目录 |

关键文件：
- `/memories/repo/wiki-refs.md` — 当前项目关联的 wiki 知识索引
- `/memories/index.md` — 跨项目知识快速检索入口
- `/memories/evolution-log.md` — 进化审计日志

### Agents

- **discourse** — 四视角讨论（Developer / Architect / PM / Critic），用于复杂决策的多角度评估
- **wiki-maintainer** — Wiki 知识管理路由器，按意图分发到 5 个 wiki skill

Agent 通过 `runSubagent` 工具调用（非 `@` 语法）。

### Skills

5 个 wiki 工作流 skill，后端数据目录：`D:\resource\llm-wiki-agent`

| Skill | 功能 |
|-------|------|
| wiki-inbox | 管理待处理文档收件箱 |
| wiki-ingest | 消化源文档 → 提取知识 → 创建/更新 wiki 页面 |
| wiki-query | 搜索 wiki 并综合带引用的回答 |
| wiki-lint | 检查 wiki 结构与语义健康 |
| wiki-graph | 从 wiki 页面构建知识图谱并可视化 |

## MCP 集成

MCP（Model Context Protocol）可无缝扩展工具能力。配置方式：

```jsonc
// 全局配置：Ctrl+Shift+P → "MCP: Open User Configuration"
// 项目配置：.vscode/mcp.json
{
  "servers": {
    "example-server": {
      "command": "npx",
      "args": ["-y", "@example/mcp-server"]
    }
  }
}
```

- 安装后 Copilot 自动发现 MCP 工具，对话中可直接使用
- 也可在 Extensions 视图搜索 `@mcp` 在 Gallery 中安装
- MCP 提供的 tools/resources/prompts 将自动进入 Copilot 的工具列表
- 道核无需修改 — MCP 工具与内置工具地位相同，判断阶段自动选用

## 与用户级配置的关系

本仓库是 `~/.copilot/` 用户级配置的版本控制镜像：

| 本仓库 | 用户级 |
|--------|--------|
| `.copilot/copilot-instructions.md` | `~/.copilot/copilot-instructions.md` |
| `.copilot/agents/*.agent.md` | `~/.copilot/agents/*.agent.md` |
| `.copilot/skills/*/SKILL.md` | `~/.copilot/skills/*/SKILL.md` |

修改后需手动同步。用户级配置对所有工作区全局生效。

## 部署

```powershell
# 从仓库同步到用户级配置
Copy-Item -Path ".copilot\copilot-instructions.md" -Destination "$env:USERPROFILE\.copilot\" -Force
Copy-Item -Path ".copilot\agents\*" -Destination "$env:USERPROFILE\.copilot\agents\" -Force
Get-ChildItem ".copilot\skills" -Directory | ForEach-Object {
    $dest = "$env:USERPROFILE\.copilot\skills\$($_.Name)"
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force }
    Copy-Item "$($_.FullName)\*" -Destination $dest -Force
}
```
