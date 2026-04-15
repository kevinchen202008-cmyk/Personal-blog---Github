---
title: "Claude Code 源码泄露事件：架构设计深度剖析"
date: 2026-04-15
categories: [技术分析, AI工程]
tags: [Claude Code, AI Agent, 架构设计, 源码分析]
---

<style>
  .highlight pre, pre {
    background-color: #f6f8fa !important;
    padding: 16px !important;
    border-radius: 6px !important;
    overflow-x: auto !important;
  }
  .highlight code, p > code, li > code {
    background-color: #f6f8fa !important;
    padding: 2px 4px !important;
    border-radius: 4px !important;
    color: #24292e !important;
  }
  .highlight pre code, pre code {
    background-color: transparent !important;
    padding: 0 !important;
    color: inherit !important;
  }
</style>

# Claude Code 源码泄露事件：架构设计深度剖析

> 2026年3月31日，Anthropic 的 Claude Code CLI 源码因 npm 构建配置失误而意外泄露——59.8MB 的 source map 文件（`cli.js.map`）被遗留在生产包中，将整个内部代码库暴露在阳光下。本文基于各路研究者的逆向分析，为你还原这个"AI 代理标杆"的工程全貌。

---

## 📋 目录

- [事件回顾](#-事件回顾)
- [整体架构总览](#-整体架构总览)
- [核心：Agent Loop（查询引擎）](#-核心agent-loop查询引擎)
- [工具系统设计](#-工具系统设计)
- [权限与安全模型](#-权限与安全模型)
- [上下文管理与压缩](#-上下文管理与压缩)
- [Prompt 工程方法](#-prompt-工程方法)
- [未发布功能与路线图](#-未发布功能与路线图)
- [设计模式与工程启示](#-设计模式与工程启示)
- [参考资料](#-参考资料)

---

## 🎬 事件回顾

### 泄露了什么？

安全研究员 Chaofan Shou 在 X 上发布截图，揭示 Claude Code 的完整源码就藏在 npm 包的 `.map` 文件中。这不是黑客攻击，而是一个常见的构建失误——source map（调试用的映射文件）被遗漏在了生产包里。

| 指标 | 数据 |
|:-----|:-----|
| **版本** | `@anthropic-ai/claude-code` **v2.1.88** |
| **代码量** | ~512,000 行 TypeScript |
| **文件数** | 1,906 个核心文件（含生成文件约 4,600+） |
| **泄露入口** | `cli.js.map`（59.8 MB） |
| **存储位置** | 公开可访问的 Cloudflare R2 bucket |
| **语言/框架** | TypeScript (strict mode) / React 18 + Ink |

### 官方仓库 vs 泄露代码

官方 GitHub 仓库 (`anthropics/claude-code`) 仅仅是一个"插件外壳"，而泄露的代码包含了完整的核心引擎：

```
官方仓库（~279 文件）          泄露代码（4,600+ 文件）
┌──────────────────┐          ┌──────────────────────────┐
│  scripts/configs │          │  完整核心引擎              │
│  插件接口定义     │    vs    │  41 个工具实现             │
│  文档/示例       │          │  Agent Loop (1,729 行)    │
│                  │          │  权限系统 (52KB)           │
│                  │          │  API 通信层               │
│                  │          │  MCP 客户端 (119KB)        │
└──────────────────┘          └──────────────────────────┘
```

> ⚠️ **DMCA 后续**：Anthropic 对 GitHub 上的分析仓库发起了 DMCA 下架请求，但在下架前代码已被 fork **41,500+ 次**，Python 的 clean-room 重写版本在数小时内出现。代码被认为已永久流传。

---

## 🏗️ 整体架构总览

### 技术栈一览

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code 技术栈                        │
├─────────────┬───────────────────────────────────────────────┤
│  运行时      │  Bun（比 Node.js 启动更快，原生 TS 支持）      │
│  语言        │  TypeScript（strict mode）                    │
│  UI 框架     │  React 18 + Ink（终端渲染器）                  │
│  API 客户端  │  @anthropic-ai/sdk（多 Provider 支持）         │
│  协议层      │  MCP (@modelcontextprotocol/sdk)              │
│  CLI 框架    │  @commander-js/extra-typings                  │
│  校验        │  Zod v4（运行时 Schema 验证）                  │
│  状态管理    │  Zustand 风格 Store + React Context           │
│  功能开关    │  GrowthBook（A/B 测试 + 功能门控）             │
│  打包器      │  Bun Bundler（编译时死代码消除）               │
└─────────────┴───────────────────────────────────────────────┘
```

### 目录结构（37 个子目录）

```
src/
├── main.tsx                # 主入口（~1,400 行）—— 启动引导
├── QueryEngine.ts          # 对话循环编排器（~46KB）
├── Tool.ts                 # 工具类型定义
├── Task.ts                 # 任务生命周期管理
├── commands.ts             # 命令注册表
├── tools.ts                # 工具注册与工厂
├── context.ts              # 系统/用户上下文构建
├── cost-tracker.ts         # Token 用量与定价
│
├── commands/               # 101 个斜杠命令模块
├── tools/                  # 41 个工具实现
├── services/               # 核心服务（API、MCP、分析等）
├── components/             # React/Ink UI 组件（130+ 文件）
├── utils/                  # 工具函数（300+ 文件）
├── state/                  # 应用状态管理
├── types/                  # TypeScript 类型定义
├── hooks/                  # React Hooks
├── schemas/                # Zod 校验 Schemas
├── tasks/                  # 任务类型实现
├── entrypoints/            # 入口点定义（CLI、SDK、MCP）
├── bootstrap/              # 应用启动与全局状态
├── screens/                # 全屏 UI 布局
├── plugins/                # 插件系统
├── skills/                 # 自定义技能系统
├── coordinator/            # 多 Agent 协调（未发布）
├── bridge/                 # 远程控制桥接
├── assistant/              # Kairos 主动助手模式
├── voice/                  # 语音输入/输出
├── vim/                    # Vim 模式集成
├── remote/                 # 远程会话处理
├── server/                 # 服务端实现
└── ... (30+ more)
```

### 启动流程（`main.tsx`）

```
🚀 启动序列（10 步）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 ① 启动性能分析（startupProfiler）
    ↓
 ② MDM 原始读取预取（Mobile Device Management）
    ↓
 ③ Keychain 预取（macOS OAuth + API Key 并行读取）
    ↓
 ④ 功能标志初始化（Bun feature() 死代码消除）
    ↓
 ⑤ CLI 参数解析（Commander.js）
    ↓
 ⑥ 认证（API Key / OAuth / AWS Bedrock / GCP Vertex / Azure）
    ↓
 ⑦ GrowthBook 初始化（A/B 测试 & 功能开关）
    ↓
 ⑧ 策略限制 & 远程托管配置加载
    ↓
 ⑨ 工具/命令/技能/MCP 服务器注册
    ↓
 ⑩ REPL 启动（replLauncher.tsx）
```

---

## 🔄 核心：Agent Loop（查询引擎）

### `query.ts` —— 一个 1,729 行的 `while(true)` 循环

这是 Claude Code 的心脏。整个 Agent 循环的核心逻辑被封装在一个异步生成器函数中：

```typescript
export async function* query(
  params: QueryParams,
): AsyncGenerator<
  | StreamEvent        // 流式事件（Token 输出、工具开始/完成）
  | RequestStartEvent  // 请求开始
  | Message            // 消息
  | TombstoneMessage   // 删除标记
  | ToolUseSummaryMessage,
  Terminal             // 返回值：终止原因
>
```

#### 为什么用 Async Generator？

这是一个关键的架构选择。传统的 Agent 框架使用 EventEmitter 或回调模式，而 Claude Code 选择用 **异步生成器** 将三个通道统一到一个函数中：

```
┌─────────────────────────────────────────────────────────┐
│              async function* query()                    │
│                                                         │
│   yield  ──→  事件流（Token 输出、工具状态变更）          │
│   return ──→  终止原因（Terminal 类型）                   │
│   throw  ──→  错误传播                                   │
│                                                         │
│  消费者：for await (const event of query(...)) { ... }  │
└─────────────────────────────────────────────────────────┘
```

> 💡 **设计洞察**：与其用 EventEmitter + 回调 + Promise 混合模式，不如用一个生成器函数统一管理。代码更清晰，状态更可控，错误传播更自然。

### 循环执行流程

```
用户输入
    │
    ▼
┌──────────────────────────────────────────────────────┐
│  while (true) {                                      │
│                                                      │
│    ┌─────────────────────────────────────────┐       │
│    │  ① 构建上下文 & 消息                      │       │
│    │  ② 流式 API 请求                          │       │
│    │  ③ 收集 tool_use 块                      │       │
│    │  ④ 权限检查                               │       │
│    │  ⑤ 并行执行工具                           │       │
│    │  ⑥ 注入 tool_result 消息                  │       │
│    │  ⑦ 检查终止条件                           │       │
│    └─────────────────────────────────────────┘       │
│                                                      │
│    → 终止？──→ return Terminal(reason)               │
│    → 继续？──→ 回到循环顶部                          │
│  }                                                   │
└──────────────────────────────────────────────────────┘
    │
    ▼
返回终止原因
```

### 并行工具执行

当 Claude 在一次响应中返回多个 `tool_use` 块时，引擎会**并行执行**它们（在权限检查通过的前提下）。结果被收集后作为 `tool_result` 消息注入回对话。

### 成本感知的错误恢复

错误恢复遵循 **"最便宜的方法优先"** 原则：

```
错误恢复优先级（从便宜到昂贵）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  🆓 第 1 级：无需 API 调用的重试
     └─ 本地逻辑重试，不消耗 Token
  
  🆓 第 2 级：部分上下文
     └─ 上下文窗口溢出时，发送缩减后的上下文
  
  💰 第 3 级：模型降级
     └─ 过载时切换到更便宜的模型
  
  💰💰 第 4 级：指数退避（带抖动）
     └─ 限速时自动重试，间隔逐渐增大
```

> 在一个每次 API 调用都要花钱的系统里，"最便宜优先"不是优雅设计，而是**生存经济学**。

### 缓存编辑块钉选（Cache Edit Block Pinning）

当编辑已缓存的消息段落时，系统会"钉住"缓存边界，避免整个缓存前缀失效，从而在长对话中大幅降低成本。

---

## 🔧 工具系统设计

### 每个工具的统一结构

每个工具都是一个**自包含模块**，包含：

```
┌────────────────────────────────────┐
│           Tool Module              │
├────────────────────────────────────┤
│  📋 JSON Schema 输入校验（Zod v4）  │
│  🔐 权限模型（ask/allow/deny）      │
│  📊 进度追踪类型                    │
│  ⚠️  错误处理与用户提示             │
└────────────────────────────────────┘
```

### 完整工具清单（41 个）

#### 📂 文件操作（5 个）

| 工具 | 用途 |
|:-----|:-----|
| `FileReadTool` | 读取文件内容（支持行范围） |
| `FileWriteTool` | 创建或覆盖文件 |
| `FileEditTool` | 精确字符串替换编辑 |
| `GlobTool` | 基于模式的文件匹配 |
| `GrepTool` | 内容搜索（基于 ripgrep） |

#### ⚡ 代码执行（4 个）

| 工具 | 用途 |
|:-----|:-----|
| `BashTool` | 执行 Shell 命令（带超时） |
| `PowerShellTool` | 执行 PowerShell 命令（Windows） |
| `REPLTool` | 执行 Python 代码（仅内部） |
| `NotebookEditTool` | Jupyter Notebook 单元格操作 |

#### 🌐 网络与搜索（3 个）

| 工具 | 用途 |
|:-----|:-----|
| `WebFetchTool` | 获取并解析网页内容（静态 HTML） |
| `WebSearchTool` | 搜索互联网 |
| `ToolSearchTool` | 搜索可用的延迟加载工具 |

#### 🤖 Agent 与任务管理（8 个）

| 工具 | 用途 |
|:-----|:-----|
| `AgentTool` | 启动子代理进行并行工作 |
| `TaskCreateTool` | 创建后台任务 |
| `TaskGetTool` | 获取任务状态和结果 |
| `TaskUpdateTool` | 更新任务状态或描述 |
| `TaskListTool` | 列出所有任务及其状态 |
| `TaskStopTool` | 终止正在运行的任务 |
| `TaskOutputTool` | 流式读取任务输出 |
| `SendMessageTool` | 向正在运行的代理发送消息 |

#### 📋 规划与工作流（4 个）

| 工具 | 用途 |
|:-----|:-----|
| `EnterPlanModeTool` | 进入只读规划模式 |
| `ExitPlanModeTool` | 退出规划模式并提交审批 |
| `EnterWorktreeTool` | 创建独立 Git worktree |
| `ExitWorktreeTool` | 从 worktree 带回变更 |

#### 🔌 MCP 集成（4 个）

| 工具 | 用途 |
|:-----|:-----|
| `MCPTool` | 调用 MCP 服务器上的工具 |
| `McpAuthTool` | 与 MCP 服务器进行认证 |
| `ListMcpResourcesTool` | 列出 MCP 服务器资源 |
| `ReadMcpResourceTool` | 读取特定 MCP 资源 |

#### ⚙️ 配置与系统（7 个）

| 工具 | 用途 |
|:-----|:-----|
| `ConfigTool` | 读取/修改设置 |
| `SkillTool` | 执行用户定义的技能 |
| `AskUserQuestionTool` | 向用户提问以获取输入/澄清 |
| `BriefTool` | 生成会话摘要 |
| `TodoWriteTool` | 管理待办事项列表 |
| `SleepTool` | 暂停执行指定时长 |
| `LSPTool` | Language Server Protocol 集成 |

#### 👥 团队与远程（5 个）

| 工具 | 用途 |
|:-----|:-----|
| `TeamCreateTool` | 创建代理团队 |
| `TeamDeleteTool` | 删除代理团队 |
| `RemoteTriggerTool` | 触发远程任务执行 |
| `ScheduleCronTool` | 调度定时任务 |
| `SyntheticOutputTool` | 结构化响应的合成输出 |

### 工具调度流程

```
模型生成 tool_use 块
        │
        ▼
┌───────────────────────────────────────┐
│        权限检查管道                     │
│                                       │
│  ┌─────────────────────┐              │
│  │ 1. Deny 规则？       │──→ 立即阻止  │
│  │ 2. Allow 规则？      │──→ 静默执行  │
│  │ 3. Ask（默认）       │──→ 提示用户  │
│  └─────────────────────┘              │
└───────────────────────────────────────┘
        │
        ▼
   执行工具
        │
        ▼
   收集结果
        │
        ▼
注入为 tool_result 消息
```

> 💡 **关键洞察**：工具系统与模型在架构上是**分离**的。模型决定尝试什么，工具系统决定允许什么。一个被入侵的模型无法通过"说服"来绕过安全检查——Harness 根本不关心模型的说辞。

### 懒加载机制

`ToolSearchTool` 等工具实现了延迟加载——仅在需要时才加载，节省内存和启动时间。这由 Bun 的 `feature()` 打包系统门控。

---

## 🔐 权限与安全模型

### 8 层纵深防御架构

Claude Code 实现了**纵深防御**，包含 8 个独立的安全层：

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  L8  ═══ 服务端紧急关停（GrowthBook）                    │
│           Anthropic 可随时全局禁用功能                     │
│                                                         │
│  L7  ═══ 用户确认提示                                     │
│           敏感操作需交互式批准                             │
│                                                         │
│  L6  ═══ 文件系统沙箱                                     │
│           限制文件访问范围为项目目录                        │
│                                                         │
│  L5  ═══ 模式检测                                         │
│           基于正则的危险命令/模式检测                       │
│                                                         │
│  L4  ═══ 后台分类器（Sonnet 4.6）                         │
│           AI 分类器评估 "auto" 模式下的工具调用             │
│           只看用户请求 + 工具调用，不看模型说辞              │
│                                                         │
│  L3  ═══ 权限规则引擎                                     │
│           Deny/Ask/Allow 规则按工具调用评估                │
│                                                         │
│  L2  ═══ 工具注册门控                                     │
│           新工具默认阻塞状态，需显式启用                    │
│                                                         │
│  L1  ═══ 编译时死代码消除                                  │
│           如果代码不在二进制中，漏洞也不存在                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 6 级权限模式

| 模式 | 描述 | 安全等级 |
|:-----|:-----|:--------:|
| `default` | 大多数操作需确认 | 🟢 最安全 |
| `acceptEdits` | 自动允许文件编辑 | 🟡 |
| `plan` | 只读规划模式 | 🟢 |
| `auto` | 后台分类器评估安全性 | 🟡 |
| `dontAsk` | 跳过大多数确认 | 🟠 |
| `bypassPermissions` | 跳过所有检查 | 🔴 最便利 |

### 后台分类器的精妙设计

在 `auto` 模式下，Sonnet 4.6 分类器会评估每一个工具调用。关键在于它**看到什么**：

```
分类器输入                          分类器不看
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 用户的原始请求                    
✅ 正在尝试的工具调用                ❌ 模型的解释/说辞
```

> 这是一个深思熟虑的设计：模型无法用"有说服力的文字"来说服分类器放行。分类器评估的是**原始行动**，而非**理由包装**。

### 安全设计原则

1. **默认拒绝** — 没有显式 Allow 规则，访问即被拒绝
2. **不确定时提示用户，而非直接拒绝** — 用户拥有最终决定权
3. **纵深防御** — 没有单点故障，8 个独立层级
4. **服务端紧急关停** — 无需客户端更新即可全局禁用
5. **编译时消除** — 代码不存在，漏洞也不存在

---

## 📦 上下文管理与压缩

### 4 级上下文压缩策略

当对话上下文接近模型窗口限制时，系统按"最便宜优先"原则逐步升级：

```
压缩策略（从便宜到昂贵）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟢 Tier 1：微压缩（选择性修剪）
   ├─ 移除最不重要的消息，保留关键上下文
   └─ 无需 API 调用（免费）

🟢 Tier 2：会话记忆持久化
   ├─ 压缩前将必要状态保存到磁盘
   └─ 压缩后恢复

🟡 Tier 3：完整压缩（API 驱动）
   ├─ 通过 API 调用总结对话
   └─ 消耗 Token 但保留语义

🔴 Tier 4：硬截断
   ├─ 最后手段：丢弃最旧的消息
   └─ 信息丢失但系统继续运行
```

### CLAUDE.md 自动发现

上下文构建器会自动发现并合并来自多层级的 `CLAUDE.md` 文件：

```
项目根目录 / CLAUDE.md          ← 项目级指令
用户主目录 / CLAUDE.md          ← 用户偏好
全局配置 / CLAUDE.md            ← 全局设置
子目录 / CLAUDE.md              ← 局部覆盖
```

### Token 与成本追踪

`cost-tracker.ts` 为每个会话监控：

- 📊 Token 计数（输入/输出/缓存读/缓存写）
- 💲 USD 成本（基于模型特定定价表）
- ⏱️ 会话时长
- 🔍 Web 搜索请求计数
- 📝 文件变更指标

---

## 🧠 Prompt 工程方法

### 系统提示的分层架构

系统提示由多个层级构建而成：

```
┌─────────────────────────────────────────┐
│  基础系统提示                            │
│  （身份、能力、规则）                     │
├─────────────────────────────────────────┤
│  CLAUDE.md 内容                          │
│  （项目/用户指令）                        │
├─────────────────────────────────────────┤
│  环境上下文                              │
│  （操作系统、Shell、Git 状态、工作目录）   │
├─────────────────────────────────────────┤
│  权限上下文                              │
│  （允许/禁止的操作）                      │
├─────────────────────────────────────────┤
│  工具定义                                │
│  （每个工具的 JSON Schema）               │
├─────────────────────────────────────────┤
│  对话历史                                │
│  （消息、工具结果）                       │
└─────────────────────────────────────────┘
```

### 缓存策略

系统使用缓存感知策略来优化重复上下文。`CacheEditBlockPinning` 在编辑缓存段落时维护缓存边界，避免全量缓存失效。

### 工具描述的双重用途

每个工具的 JSON Schema 描述承担双重职责：
1. **机器可读**：输入校验
2. **人类可读**：告诉模型何时/如何使用该工具

### 自动压缩提示词

当上下文压缩触发时，专用提示词会在总结对话的同时保留：
- 活跃任务及其状态
- 关键决策
- 已修改的文件
- 当前工作上下文

---

## 🔮 未发布功能与路线图

泄露的代码暴露了 **44 个隐藏功能开关**（通过 GrowthBook 门控）。以下是最重要的发现：

### 🎤 语音模式（Voice Mode）

```typescript
// voice/voiceModeEnabled.ts
export function isVoiceModeEnabled(): boolean {
  return hasVoiceAuth() && isVoiceGrowthBookEnabled()
}
```

- 专用 `voice_stream` API 端点（独立于 Messages API）
- 仅限 OAuth 认证（API Key/Bedrock/Vertex 不可用）
- GrowthBook 紧急关停：`tengu_amber_quartz_disabled`

### 🎯 Coordinator 模式 —— 多 Agent 编排

这是最雄心勃勃的未发布功能。Coordinator **不直接写代码**——它是一个元编排器，负责分配任务给 Worker Agent：

```typescript
COORDINATOR_MODE_ALLOWED_TOOLS = new Set([
  'AgentTool',        // 启动 Worker
  'TaskStop',         // 终止 Worker
  'SendMessage',      // 与 Worker 通信
  'SyntheticOutput',  // 合并 Worker 结果
])
```

> Coordinator **不能执行 Bash、不能读取文件**。它只能管理 Worker——这是**最小权限原则**的极端应用。

```
┌─────────────────────────────────────────────────────┐
│                  Coordinator                         │
│           （API 网关 / 元编排器）                      │
│                                                      │
│    ❌ 不写代码   ❌ 不读文件   ❌ 不执行命令           │
│    ✅ 分配任务   ✅ 监控进度   ✅ 合并结果            │
│                                                      │
└──────────┬──────────┬──────────┬────────────────────┘
           │          │          │
     ┌─────▼──┐ ┌─────▼──┐ ┌─────▼──┐
     │Worker 1│ │Worker 2│ │Worker 3│
     │ 读写文件│ │ 执行命令│ │ 搜索代码│
     └────────┘ └────────┘ └────────┘
```

> 💡 这本质上是 **AI Agent 的微服务架构**：Coordinator 是 API 网关，分配请求到独立的 Worker 服务，每个 Worker 在隔离环境中运行。

### 🌟 Kairos —— 主动助手

希腊语"恰当时刻"——一种 **Claude 先行** 的模式：

| 功能标志 | 工具 | 能力 |
|:---------|:-----|:-----|
| `KAIROS` | `SendUserFileTool` | 主动向用户发送文件 |
| `KAIROS` | `PushNotificationTool` | 移动/桌面推送通知 |
| `KAIROS_GITHUB_WEBHOOKS` | `SubscribePRTool` | GitHub PR Webhook 订阅 |
| `PROACTIVE` | `SleepTool` | 后台等待（定时器） |

**场景示例**：GitHub PR 上有新评论 → `SubscribePRTool` 检测到 → 检查 CI 结果 → 发送通知："PR #123 收到评论，CI 失败了。这是你可能需要修复的内容。"

> Claude 在用户没有打开会话时也在工作。从编码助手到**自主软件工程代理**的转变。

### 🌐 Web 浏览器工具

```typescript
const WebBrowserTool = feature('WEB_BROWSER_TOOL')
  ? require('./tools/WebBrowserTool/WebBrowserTool.js').WebBrowserTool
  : null
```

真正的浏览器自动化（对比当前的静态 HTML 获取）。可能利用 Bun 的 WebView API 进行 SPA 页面交互。

### 🌉 Bridge —— 远程控制系统（33+ 文件）

从 Claude.ai 网页界面远程控制本地 Claude Code：

```
用户 ──→ OAuth 登录 claude.ai
           │
           ▼
      CCR API ──→ 订阅 + GrowthBook 门控检查
           │
           ▼
   本地 Claude Code ──→ 获取 environment_id + environment_secret
           │
           ▼
   认证隧道建立（WebSocket）
           │
           ▼
   浏览器 → Bridge API → 本地工具执行 → 结果返回
```

**会话隔离通过 Git worktree**：每个远程会话在独立工作目录中运行，从根本上消除合并冲突。

### 战略方向

```
┌─────────────────────────────────────────────────────────┐
│                Claude Code 战略演进                      │
│                                                         │
│   CLI 工具  ──────────────────→  多设备多代理平台        │
│   被动响应  ──────────────────→  主动监控                │
│   纯文本交互 ─────────────────→  语音 + 浏览器自动化     │
│   单代理    ──────────────────→  Agent Swarm（群体智能）  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 设计模式与工程启示

### 1️⃣ Async Generator 作为 Agent 循环

使用 `async function*` 作为查询循环，将事件流、终止和错误处理统一到一个通道。对于复杂的多步骤 Agent 工作流，这比 EventEmitter 或回调模式更优雅。

### 2️⃣ 编译时死代码消除

```typescript
const assistantModule = feature('KAIROS')
  ? require('./assistant/index.js')
  : null;
```

Bun 的 `feature()` 函数启用条件导入，在打包时解决。如果功能标志关闭，整个模块树从二进制中消除。双重目的：
- **安全性**：未发布的代码在外部构建中确实不存在
- **性能**：更小的二进制体积，更快的启动

### 3️⃣ 成本感知设计贯穿始终

- 错误恢复：免费选项优先
- 上下文压缩：无 API 方法优先
- 工具加载：尽可能懒加载/延迟
- 缓存管理：钉住边界避免失效

### 4️⃣ 分类器门控

后台 AI 分类器只看用户请求 + 工具调用，不看模型的"解释"。防止模型通过"说服"绕过自身的安全门。这是一个**安全对抗设计**的典范。

### 5️⃣ Git Worktree 作为会话隔离单元

用 Git worktree 作为远程会话的隔离单元——利用现有基础设施（Git）实现文件系统级隔离，开销比容器/VM 低得多。**务实工程的典范**。

### 6️⃣ React 在终端中（Ink）

在终端应用中使用 React 18 + Ink 看似过度设计，但当你看到 UI 复杂度时就理解了：权限对话框、流式输出、多面板布局、实时进度条。声明式组件模型在这一复杂度下确实值得。

### 7️⃣ 微服务模式应用于 AI Agent

Coordinator 模式将微服务原则应用于 AI：编排器不直接执行逻辑，Worker 独立运行，共享状态通过 Scratchpad 传递，每个 Worker 在隔离中运行。

### 8️⃣ 两级认证

标准（OAuth）vs 增强（OAuth + 可信设备令牌 JWT）——根据操作敏感度分级认证，而非对所有操作要求最高级别认证。

---

## 📚 参考资料

### 主要分析来源

1. **Jonas Kim** — *Claude Code Exposed: Anatomy of an Agentic AI Through an npm Source Map Leak*（2026.03.31）
   - [bits-bytes-nn.github.io](https://bits-bytes-nn.github.io/insights/agentic-ai/2026/03/31/claude-code-architecture-analysis.html)

2. **ComeOnOliver/claude-code-analysis** — GitHub 逆向分析文档
   - [github.com/ComeOnOliver/claude-code-analysis](https://github.com/ComeOnOliver/claude-code-analysis)

3. **Tech Insider / Marcus Chen** — *Anthropic Claude Code Source Code Leak: Full Analysis*（2026.04.03）
   - [tech-insider.org](https://tech-insider.org/anthropic-claude-code-source-code-leak-npm-2026/)

4. **WaveSpeed AI** — *Claude Code Agent Harness: Architecture Breakdown*（2026.04.06）
   - [wavespeed.ai](https://wavespeed.ai/blog/posts/claude-code-agent-harness-architecture/)

### 社区分析

- Reddit r/LocalLLaMA 讨论帖
- GitHub fork 和分析仓库（DMCA 前 41,500+ forks）
- 多篇 dev.to 技术拆解

### 官方文档

- [Anthropic Claude Code 文档](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Agent SDK](https://code.claude.com/docs/en/agent-sdk/)

---

> *本文档基于公开可用的分析来源整理。所有代码示例和架构细节均标注原始研究者。Claude Code 是 Anthropic PBC 的产品。*
>
> *最后更新：2026 年 4 月 15 日*
