---
title: "Claude Code 完全新手指南（2026 版）：从入门到精通"
date: 2026-04-14
categories: [开发者工具, AI]
tags: [Claude Code, AI Agent, 终端工具, 效能提升]
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

很多开发者用了 Claude Code 一段时间后，感觉「好像也没那么神奇」——写出来的代码时对时错，改着改着把不该动的文件也改了，长时间对话后回答开始偏题。问题不在工具本身，在于缺少一套正确的使用框架。

这份《Claude Code 完全新手指南》共 12 章，从最基础的安装配置讲起，深入 Agent Loop 工作原理、上下文管理策略、CLAUDE.md 项目记忆配置，再到 Subagents 专用子代理、Hooks 自动化触发器、Worktree 并行任务隔离等进阶功能，最后提供三套直接可用的实战 SOP：老项目重构如何在不破坏线上功能的前提下分步推进、新需求如何从一句话变成可执行规格文档再到并行开发交付、全新项目如何从架构决策到 CI/CD 接入一次做对。附 30 余个提示词模板，所有内容均基于 2026 年最新版本。

---

## 📋 目录

- [第一章  认识 Claude Code](#-第一章--认识-claude-code)
- [第二章  安装与账号配置](#-第二章--安装与账号配置)
- [第三章  核心概念](#-第三章--核心概念)
- [第四章  快速入门——30 分钟第一个任务](#-第四章--快速入门30-分钟第一个任务)
- [第五章  CLAUDE.md——给 Claude 持久记忆](#-第五章--claudemd给-claude-持久记忆)
- [第六章  完整命令速查手册](#-第六章--完整命令速查手册)
- [第七章  进阶技巧](#-第七章--进阶技巧)
- [第八章  Subagents——独立上下文的专用助手](#-第八章--subagents独立上下文的专用助手)
- [第九章  Hooks——自动化触发器](#-第九章--hooks自动化触发器)
- [第十章  Worktree——并行任务隔离](#-第十章--worktree并行任务隔离)
- [第十一章  实战 SOP](#-第十一章--实战-sop)
- [第十二章  常见错误与避坑指南](#-第十二章--常见错误与避坑指南)

---

> **Claude Code 完全新手指南** — 从 0 到真正用好 AI 编程 Agent
> *安装 · 配置 · 实战 SOP · Subagents · Hooks · 最佳实践 · 2026*

---

## 🎯 第一章  认识 Claude Code {#第一章--认识-claude-code}

### 1.1  一句话理解

Claude Code 是 Anthropic 基于 Claude 模型打造的终端 AI 编程 Agent。它不是聊天机器人，也不是代码补全插件——它是一个可以直接操作你代码仓库的 AI 软件工程师：

•理解整个代码库（多文件、多语言、多层依赖）

•自主规划任务，跨文件编写和修改代码

•执行 Shell 命令、运行测试、验证结果

•处理 Git 工作流（commit / PR / merge conflict）

•通过 MCP 协议连接数据库、API 等外部工具

 


> 💡 **核心认知——你的角色转变**  
> Claude Code 最核心的变化：你的角色从「写代码」变成「描述需求 + 设定边界 + 审查结果」。  Claude 越能干，你越要注意：给清晰边界和验证标准，是用好它的关键。没有边界，它会改出你不想要的代码；没有验证标准，它不知道什么叫做对。

### 1.2  与 AI IDE 的核心区别

|  |  |  |  |
| --- | --- | --- | --- |
| 工具 | 本质 | 使用方式 | 最适合场景 |
| Claude Code | CLI Agent | 终端命令行 | Repo 级自动化、大规模重构、DevOps |
| Cursor | AI IDE | 编辑器（内联） | 逐行辅助、实时补全、单文件精细操作 |
| Windsurf | AI IDE | 编辑器（内联） | 代码上下文感知、内联建议 |
| Claude.ai 网页版 | AI 聊天 | 浏览器 | 轻量查询、移动端、无需安装 |

 


> 💡 **两者互补，不是替代**  
> Cursor 适合精细的逐行操作，Claude Code 适合大任务自动化。很多高阶开发者同时使用两者：Claude Code 负责大块任务，Cursor 负责精细打磨。

### 1.3  Claude Code 能力全景

|  |  |
| --- | --- |
| 能力类别 | 具体能力 |
| 代码开发 | 读懂整个 repo → 按需求写代码 → 跨多文件实现功能 → 安装依赖 |
| 调试修复 | 复现 bug → 追踪根因 → 修改代码 → 运行测试验证 |
| 重构升级 | JS→TS 迁移、框架版本升级、模块化拆分、架构调整 |
| 测试自动化 | 为现有代码补写单元测试、集成测试，修复失败用例 |
| Git 工作流 | 生成 commit message、解决冲突、创建 PR、代码审查 |
| 文档生成 | README、API 文档、CHANGELOG、架构说明 |
| 外部集成 | 通过 MCP 查询数据库、调用 API、控制浏览器 |
| CI/CD 自动化 | 配合 GitHub Actions 做自动代码审查和流水线生成 |

 

## 📦 第二章  安装与账号配置 {#第二章--安装与账号配置}

### 2.1  订阅要求

Claude Code 需要付费订阅，无免费版本：

|  |  |  |
| --- | --- | --- |
| 方案 | 说明 | 适合人群 |
| Claude Pro | claude.ai 订阅，包含 Claude Code 访问权限 | 个人开发者、初学者 |
| Claude Max | 更高用量上限 + 高峰期优先 + 新功能优先体验 | 重度日常使用者 |
| API 按量付费 | Anthropic Console 充值，按 token 计费 | 评估阶段、轻量使用 |
| Team / Enterprise | 团队协作 + 共享 CLAUDE.md + 管理后台 | 开发团队 |

 


> 📌 **新手建议**  
> 先充值约 20 美元 API 额度，用自己真实工作流评估 1-2 周，再决定是否订阅 Max。  登录地址：claude.com 或 console.anthropic.com

### 2.2  系统要求

•操作系统：macOS 12+、Linux（Ubuntu 20.04+ / Debian 10+）、Windows 原生或 WSL2

•网络：需要互联网连接（模型调用为云端 API）

•强烈建议：项目目录是 Git 仓库（Claude Code 深度集成 Git 工作流）

•可选：安装 gh CLI（brew install gh），让 Claude 直接创建 issue、开 PR、读 PR 评论

 

### 2.3  安装方法

macOS / Linux / WSL（推荐）

```bash
# 官方安装脚本——无需 Node.js，安装后自动后台更新

curl -fsSL https://claude.ai/install.sh | bash

 

# 验证安装

claude --version

 

# Homebrew 安装（需手动升级）

brew install --cask claude-code

brew upgrade --cask claude-code   # 手动升级

```

Windows

```powershell
# 方式一：PowerShell 一键安装（推荐）

irm https://claude.ai/install.ps1 | iex

 

# 方式二：WinGet（需手动升级）

winget install Anthropic.ClaudeCode

winget upgrade Anthropic.ClaudeCode   # 手动升级

```

IDE 插件集成

•VS Code：扩展市场搜索「Claude Code」安装，支持 @ 引用文件（含行号范围）、内联 Diff、多标签并行对话

•JetBrains（IDEA / PyCharm / WebStorm）：JetBrains Marketplace 安装，启动快捷键 Cmd+Esc (Mac) / Ctrl+Esc (Windows)，支持可视化 diff

 


> ⚠️ **JetBrains 注意事项**  
> 若 ESC 无法中断操作，进入 Settings → Tools → Terminal，取消勾选「Move focus to the editor with Escape」。远程开发时，插件需装在远程主机上而非本地客户端。

### 2.4  首次登录

```bash
cd ~/your-project

claude                  # 首次启动，弹出浏览器授权

claude /doctor          # 运行诊断，确认一切正常
```

完成 OAuth 授权后凭证本地保存，后续无需重复登录。API Key 方式见附录。

 

## 🧠 第三章  核心概念 {#第三章--核心概念}

### 3.1  Agent Loop（代理循环）

Claude Code 采用循环代理模式——不是一问一答，而是持续执行直到任务完成：

```
用户输入需求
    │
    ▼
┌──────────────────────────────────────────────────┐
│  Agent Loop（循环直到任务完成）                     │
│                                                  │
│   ① 收集上下文 → 读取文件、搜索代码、运行命令       │
│        │                                         │
│   ② 规划任务 → 分析做什么、顺序、影响范围          │
│        │                                         │
│   ③ 执行操作 → 编辑文件、Shell 命令、MCP 工具      │
│        │                                         │
│   ④ 验证结果 → 运行测试、检查错误                  │
│        │                                         │
│   ⑤ 自我纠正 → 失败则返回 ③ 重新执行              │
│        │                                         │
│   完成？──→ 返回结果                              │
│   未完成？──→ 返回 ① 继续循环                     │
└──────────────────────────────────────────────────┘
    │
    ▼
用户审查结果（随时可 Ctrl+C 暂停并重新引导）
```

 

循环重复，直到任务完成或你按 Ctrl+C 中断。你可以在任何时候暂停并重新引导方向。

### 3.2  上下文是有限资源

这是使用 Claude Code 最重要的认知之一。上下文窗口（约 20 万 token）会消耗你说的每一句话、Claude 读取的每个文件、每个命令的输出，以及压缩后的历史摘要。上下文一旦过长，Claude 就会开始「遗忘」前面的指令，输出质量明显下降。

|  |  |  |
| --- | --- | --- |
| 命令 | 作用 | 何时使用 |
| /clear | 清空全部对话历史 | 切换任务前（必须养成习惯） |
| /compact [说明] | 智能压缩历史，保留摘要 | 上下文超过 70% 时，或 /compact 保留 API 变更 |
| /context | 可视化显示上下文使用比例 | 长时间工作时随时检查 |
| /cost | 查看当前会话 token 用量 | 了解成本，优化使用习惯 |

 


> 💡 **重要原则**  
> 同一个问题修正超过两次，直接 /clear 用更精确的提示重新开始。新会话 + 好提示 > 长会话 + 累积修正。

### 3.3  三种权限模式

|  |  |  |  |
| --- | --- | --- | --- |
| 模式 | 触发方式 | 行为 | 适用场景 |
| Normal Mode（默认） | 默认启动 | 重大操作前弹窗请求批准 | 日常开发任务 |
| Plan Mode | Shift+Tab 两次 / /plan | 只读分析，不执行任何修改 | 复杂任务先分析再执行 |
| Auto-Accept | --dangerously-skip-permissions | 自动批准所有操作 | CI/CD 等完全自动化场景 |

 


> 💡 **权限白名单配置**  
> 频繁使用的安全命令可加入白名单，避免反复弹窗：

// .claude/settings.json

{

  "permissions": {

    "allow": [

      "Bash(git:\*)",

      "Bash(pnpm:\*)",

      "Bash(./gradlew:\*)"

    ]

  }

}

 

### 3.4  模型选择策略

|  |  |  |  |
| --- | --- | --- | --- |
| 模型 | 定位 | 适用场景 | 切换命令 |
| Claude Sonnet 4.6 | 默认，综合最优 | 80% 日常编码任务 | 无需切换 |
| Claude Opus 4.6 | 最强推理能力 | 复杂架构设计、难以定位的 bug | /model opus |
| Claude Haiku | 最快，最省费用 | 简单查询、预算受限场景 | /model haiku |

```bash
# 启动时指定模型
claude --model claude-opus-4-6
```


 

```bash
# 会话内切换（支持简写）
> /model opus
> /model sonnet
> /model haiku
```
  
## 🚀 第四章  快速入门——30 分钟第一个任务 {#第四章--快速入门30-分钟第一个任务}


### 4.1  启动与基本对话

```bash
cd ~/my-project          # 进入真实项目目录
claude                   # 启动

# 第一步：让 Claude 了解你的项目
> 这个项目是做什么的？给我结构概览和技术栈总结。
```
### 4.2  四种基础输入方式

|  |  |  |
| --- | --- | --- |
| 方式 | 用法示例 | 说明 |
| 自然语言 | 帮我在 src/utils.js 添加一个格式化日期的函数 | 最常用，直接描述需求 |
| @ 文件引用 | @src/api/users.js 这里的分页逻辑有 bug | 精确指定文件，减少干扰 |
| ! Shell 执行 | !git status 然后告诉我有哪些未提交的改动 | 执行命令并纳入上下文 |
| 粘贴错误 | [粘贴报错] → 帮我修复这个错误 | 直接粘贴终端报错，Claude 分析根因 |

 


> 💡 **@ 引用进阶用法**  
> @auth                      # 模糊匹配文件名  @src/components/           # 引用整个目录  @UserService.java#50-80    # 引用特定行范围  @terminal                  # 引用最近一次终端输出

### 4.3  第一个完整任务：从零创建 Todo API

1. **创建项目并启动**

```bash
mkdir todo-api && cd todo-api && git init
claude
```

2. **让 Claude 先规划再动手**

```bash
> 用 Node.js + Express 创建一个 Todo REST API，
  包含增删改查接口、参数验证和错误处理。
  先告诉我你的实现计划，等我确认后再写代码。
```

3. **确认计划后执行，再添加数据库**

```bash
> 方案可以，开始实现，做完跑测试。
> 添加 SQLite 数据库支持，将内存存储迁移到数据库。
```

4. **自动补写测试并提交**

```bash
> 为所有接口写 Jest 单元测试，先写失败测试，
  测试能正确运行后再修复让测试通过。
> 运行所有测试确保通过，然后用规范的 commit message 提交。
```

 


> 🎯 **核心体验**  
> 整个过程 Claude 自主规划、编写、验证，你只需要描述需求和审查结果。这就是 Agentic 编程的本质——你是工程师，Claude 是执行者。

## 💾 第五章  CLAUDE.md——给 Claude 持久记忆 {#第五章--claudemd给-claude-持久记忆}

### 5.1  什么是 CLAUDE.md？

CLAUDE.md 是 Claude Code 每次启动时自动读取的配置文件，让 Claude 始终了解你的规范，无需每次重新解释。

|  |  |  |
| --- | --- | --- |
| 文件位置 | 作用范围 | 适合存放的内容 |
| 项目根目录/CLAUDE.md | 当前项目，提交到 git | 技术栈、编码规范、常用命令、架构说明（团队共享） |
| .claude/CLAUDE.md | 当前项目（更整洁） | 同上，推荐结构 |
| CLAUDE.local.md | 当前项目，不提交 | 个人本地配置，不共享给团队 |
| ~/.claude/CLAUDE.md | 全局，所有项目 | 个人习惯、语言偏好、通用工作流 |

 

### 5.2  快速创建

```bash
# 在会话中执行，Claude 自动分析项目生成模板

> /init

# 生成后手动补充你最重要的规范

```
### 5.3  专业 CLAUDE.md 模板

```markdown
# 项目名称 - Claude 工作指南

 

## 项目概述

一句话描述项目用途和边界。

 

## 技术栈

- 后端：Spring Boot 3.x, Java 17, MyBatis Plus

- 前端：React 18, TypeScript, Ant Design

- 数据库：MySQL 8.0（OLTP）

- 缓存：Redis（会话和热点数据）

- 包管理：pnpm

 

## 常用命令

- 启动后端：./gradlew bootRun

- 启动前端：cd frontend && pnpm dev

- 跑单个测试：./gradlew test --tests 'UserServiceTest'

- 数据库迁移：./gradlew flywayMigrate

 

## 代码规范（与默认不同的部分）

- 所有 API 返回用 Result统一包装

- Service 层只包含业务逻辑，不直接操作数据库

- 禁止在 Controller 层写业务逻辑

- API 路径用 kebab-case，JSON 属性用 camelCase

 

## 禁止事项

- IMPORTANT: 不要修改 prisma/migrations/ 下的文件

- IMPORTANT: 所有数据库改动通过 Flyway Migration 文件

- 安装新 npm 包时必须在回复中说明原因

 

## 分支与 PR 规范

- 功能分支：feature/xxx

- 修复分支：bugfix/xxx

- commit 格式：feat(模块): 描述 / fix(模块): 描述
```

### 5.4  写作原则

•写规则而非故事：「使用命名导出」比「我们团队历史上选择命名导出，因为……」更有效

•聚焦「Claude 最容易弄错的事」，不需要把所有内容都写进去

•重要规则加强调：「IMPORTANT:」或「YOU MUST」，让 Claude 不会忽略

•「禁止事项」比「建议事项」更有价值，明确红线比模糊偏好更有效

•定期维护：技术栈或规范变化时及时更新

 

### 5.5  Skills（按需加载的知识片段）

Skills 是项目特定的知识片段，比 CLAUDE.md 更模块化，按需调用而非每次全量读取：

```bash
# 创建 Skill 目录

mkdir -p .claude/skills/api-conventions

# 创建 Skill 文件（.claude/skills/api-conventions/SKILL.md）

```
---

name: api-conventions

description: REST API 设计规范，在讨论或生成 API 时使用

---

 

- URL 用 kebab-case：/api/user-profiles

- JSON 用 camelCase：{ "userName": "..." }

- 列表接口必须分页

- 版本放 URL：/v1/, /v2/

  

## 📖 第六章  完整命令速查手册 {#第六章--完整命令速查手册}

### 6.1  启动参数

|  |  |
| --- | --- |
| 命令 | 说明 |
| claude | 默认启动（交互模式） |
| claude --model opus / sonnet / haiku | 启动时指定模型 |
| claude --permission-mode plan | 以 Plan Mode 启动 |
| claude --worktree feature-xxx | 在隔离 Worktree 中启动 |
| claude --continue | 继续最近一次对话 |
| claude --resume | 选择历史对话恢复 |
| claude --from-pr 123 | 从指定 PR 恢复会话 |
| claude --dangerously-skip-permissions | 跳过所有权限检查（仅限 CI/CD） |

 

### 6.2  Headless 模式（非交互）

```bash
claude -p "解释项目结构"                     # 单次查询后退出

claude -p "列出所有 API 接口" --output-format json  # JSON 格式输出

cat error.log | claude -p "分析这个错误的根因"        # 管道输入

git diff HEAD | claude -p "审查这次改动有无安全隐患"  # 结合 git

 

```

### 6.3  会话内命令

|  |  |
| --- | --- |
| 命令 | 说明 |
| /clear | 清空对话历史（切换任务前必须执行） |
| /compact [说明] | 压缩对话：/compact 保留数据库 schema 和 API 变更 |
| /context | 可视化查看上下文窗口使用情况 |
| /cost | 查看当前会话 token 用量 |
| /export | 将当前对话导出为文件 |
| /rename [名称] | 给当前会话命名，方便后续恢复 |
| /rewind | 打开回退菜单（同 Esc+Esc） |
| /model [名称] | 切换模型 |
| /config | 打开设置界面 |
| /permissions | 管理工具权限白名单 |
| /doctor | 运行健康检查 |
| /init | 分析当前项目，生成 CLAUDE.md 模板 |
| /memory | 查看 Claude 自动保存的项目记忆 |
| /hooks | 查看已配置的自动化钩子 |
| /mcp | 管理 MCP 服务器连接 |
| /agents | 管理 Subagents |
| /install-github-app | 安装 GitHub Actions 集成 |
| /bug | 向 Anthropic 报告 bug |
| /vim | 开启 Vim 键位绑定模式 |
| /exit | 退出 Claude Code |

 

### 6.4  键盘快捷键

|  |  |
| --- | --- |
| 快捷键 | 功能 |
| Shift + Tab（两次） | 进入 Plan Mode |
| Ctrl + C | 中断当前操作 |
| Ctrl + G | 用系统编辑器编写多行提示词，保存后发送 |
| Ctrl + B | 将运行中的任务切到后台（释放前台交互） |
| Alt + T | 切换 Extended Thinking（扩展思维模式） |
| Esc | 中断当前操作 |
| Esc + Esc | 打开回退菜单 |
| ↑ / ↓ 方向键 | 浏览历史输入记录 |
| ! + 命令 | 直接执行 Shell 命令 |
| @ + 文件名 | 引用文件加入上下文 |

 

## ⚡ 第七章  进阶技巧 {#第七章--进阶技巧}

### 7.1  Plan Mode 的正确姿势

5.按 Shift+Tab 两次进入 Plan Mode（提示符会变化）

6.描述你要做的事，让 Claude 分析影响面和执行步骤

7.仔细审查输出的规划，可以继续追问某个步骤

8.确认无误后，按 Shift+Tab 切回 Normal Mode 执行

 


> 💡 **探索 → 规划 → 执行 三步法**  
> Step 1（Plan Mode）：分析现有实现，给我一个方案  Step 2（确认）：方案可以，开始实现  Step 3（自动）：Claude 执行，完成后跑测试验证  复杂功能始终先「describe → plan → approve → implement」，避免改了一大堆再回头

### 7.2  黄金提示词公式


> 🎯 **提示词黄金公式：【目标】+【位置】+【验证】+【约束】**  
> 示例：  「为 @src/api/users.ts 中的 getUserById 函数添加 Redis 缓存，    缓存有效期 5 分钟，使用现有的 @src/lib/redis.ts 客户端。    实现后运行 pnpm test 确保所有测试通过，    禁止修改函数签名和返回类型，解决根本问题而不是压制错误。」

|  |  |  |
| --- | --- | --- |
| 要素 | 好的示例 | 差的示例 |
| 目标 | 为 getUserById 添加 Redis 缓存 | 优化代码 |
| 位置 | @src/api/users.ts + @src/lib/redis.ts | （不指定） |
| 验证 | 运行 pnpm test 确保通过 | （不要求验证） |
| 约束 | 禁止修改函数签名，解决根本问题 | （不加限制） |

 

### 7.3  描述症状，不是猜测原因

|  |  |
| --- | --- |
| 差的问法 | 好的问法 |
| 修复登录 bug | 用户反馈会话超时后登录失败。检查 @src/auth/ 下的认证流程，特别是 token 刷新逻辑。先写失败测试复现，再修复，修完跑测试验证。 |
| 修复构建错误 | pnpm build 失败，错误如下：[粘贴错误信息]。修复并验证构建成功，解决根本原因，不要只压制错误。 |
| 加测试 | 给 @src/utils/dateUtils.ts 写测试。参考 @src/\_\_tests\_\_/stringUtils.test.ts 的风格。覆盖：空输入、无效格式、时区问题。 |

 

### 7.4  MCP 服务器集成

|  |  |  |
| --- | --- | --- |
| MCP 服务器 | 能力 | 添加命令 |
| Context7 | 实时获取第三方库最新文档，避免用过时 API | claude mcp add context7 npx @context7/mcp |
| Playwright | 控制浏览器做自动化测试 | claude mcp add playwright npx '@playwright/mcp@latest' |
| Sentry | 直接读取线上报错 | claude mcp add sentry --transport http https://mcp.sentry.dev/mcp |
| GitHub | 查看 issue、创建 PR | claude mcp add github npx @github/mcp |
| PostgreSQL | 直接查询数据库 | claude mcp add postgres npx @postgresql/mcp |

```bash
# 添加后在对话中直接使用

> 用 Playwright 打开 https://example.com，截图并分析页面结构

 
```
```bash
claude mcp list                # 查看已添加的服务器

```
## 🤖 第八章  Subagents——独立上下文的专用助手 {#第八章--subagents独立上下文的专用助手}

### 8.1  什么是 Subagent？

Subagent 是在独立上下文窗口里运行的专用 AI 助手，有自定义的系统提示和工具权限限制。它的核心价值在于：

•隔离大量输出——测试报告、搜索结果不会污染主会话上下文

•强制工具限制——只读代理无法写文件，安全可控

•并行探索——多个 Subagent 同时在不同模块并行调查

•跨会话记忆——开启 memory 让 Subagent 记住项目模式

 

### 8.2  内置 Subagent 类型

|  |  |  |  |
| --- | --- | --- | --- |
| 类型 | 模型 | 工具权限 | 适用场景 |
| Explore（探索） | Haiku（快速） | 只读（无 Write/Edit） | 文件发现、代码搜索、技术债扫描 |
| Plan（规划） | 继承主会话 | 只读 | Plan Mode 下的代码库研究 |
| General（通用） | 继承主会话 | 全部工具 | 复杂研究、多步操作 |

 

### 8.3  创建自定义 Subagent

在 .claude/agents/ 目录创建 .md 文件，Claude 会自动发现并按需调用：

```bash
# 项目级 Subagent（提交到 git，团队共享）
mkdir -p .claude/agents
 
# 用户级 Subagent（所有项目可用）
mkdir -p ~/.claude/agents
 
# 或者在会话中用命令管理
> /agents
 
示例一：代码审查 Subagent
```markdown
```markdown
```markdown
```bash
# 文件：.claude/agents/code-reviewer.md

```
---
name: code-reviewer
description: 代码审查专家。代码修改后主动使用。
tools: Read, Grep, Glob, Bash
model: inherit
---
 
你是资深代码审查专家。
 
调用时：
1. 运行 git diff 查看最近变更
2. 聚焦修改的文件立即开始审查
 
按优先级组织反馈：
- [严重] 必须修复，存在 bug 或安全漏洞
- [警告] 应该修复
- [建议] 可考虑改进
 
给出每个问题的具体位置和修复示例。
 
> **示例二：调试专家 Subagent**

```markdown
# 文件：.claude/agents/debugger.md
---
name: debugger
description: 调试专家。遇到问题主动使用。
tools: Read, Edit, Bash, Grep, Glob
---
 
你是调试专家，专注根因分析。
 
调用时：
1. 捕获错误消息和堆栈
2. 识别复现步骤
3. 定位失败位置
4. 实现最小修复
5. 验证解决方案
 
修根本问题，不是症状。
提供根因解释、诊断证据、具体修复、测试方法、预防建议。
 
> **示例三：安全审查 Subagent（带 Hook 验证）**

```markdown
# 文件：.claude/agents/security-reviewer.md
---
name: security-reviewer
description: 安全审查专家。新增 API 或用户数据操作后自动使用。
tools: Read, Grep, Glob, Bash
model: inherit
---
 
你是专注安全的后端代码审查专家。
 
审查重点：
- [CRITICAL] 未鉴权的接口
- [CRITICAL] SQL 注入风险（直接拼接 SQL 字符串）
- [HIGH]     敏感数据写入日志（密码、token、PII）
- [HIGH]     越权访问（用户 A 访问用户 B 的数据）
- [MEDIUM]   输入验证缺失
 
给出每个问题的具体位置和修复示例。
 
```


```


```


### 8.4  Subagent 使用模式

|  |  |  |
| --- | --- | --- |
| 模式 | 示例提示词 | 适用场景 |
| 独立探索 | 用 subagent 分析 @src/order/ 目录，给我技术债报告，只分析不修改 | 生成大量输出的调查任务 |
| 并行研究 | 用独立 subagent 并行研究认证、数据库和 API 三个模块 | 多模块同时了解 |
| 链式调用 | 先用 code-reviewer 找性能问题，再用 debugger 修复 | 多阶段处理 |
| 后台运行 | 按 Ctrl+B 将任务切到后台 | 长时间运行的任务，释放前台 |

 

### 8.5  Subagent 配置字段参考

|  |  |  |
| --- | --- | --- |
| 字段 | 说明 | 示例值 |
| name | Subagent 名称 | code-reviewer |
| description | 何时调用的描述（Claude 据此判断时机） | 代码修改后主动使用 |
| tools | 允许使用的工具列表 | Read, Grep, Glob, Bash |
| model | 使用的模型 | inherit（继承主会话）/ sonnet / opus / haiku |
| memory | 跨会话记忆范围 | user / project（开启后记住发现的模式） |

 
```


## 🔗 第九章  Hooks——自动化触发器 {#第九章--hooks自动化触发器}

### 9.1  什么是 Hooks？

Hooks 是在特定事件发生时自动执行的 Shell 命令，让 Claude Code 的操作触发外部自动化行为，无需手动干预。

|  |  |  |
| --- | --- | --- |
| Hook 类型 | 触发时机 | 典型用途 |
| PreToolUse | 工具调用前 | 验证、拦截危险操作 |
| PostToolUse | 工具调用后 | 自动格式化、自动 Lint、通知 |
| Notification | Claude 需要介入时 | 系统通知提醒 |

 

### 9.2  实用 Hooks 配置示例

① 文件修改后自动 Lint

```json
// .claude/settings.json

{

  "hooks": {

    "PostToolUse": [

      {

        "matcher": "Edit|Write",

        "hooks": [

          {

            "type": "command",

            "command": "npm run lint -- --fix --quiet",

            "timeout": 30000

          }

        ]

      }

    ]

  }

}
```

 

② 文件修改后自动跑测试

```json
// 适合在重构阶段使用，每次改动立即验证

{

  "hooks": {

    "PostToolUse": [

      {

        "matcher": "Edit|Write",

        "hooks": [

          {

            "type": "command",

            "command": "./gradlew test --tests \"OrderServiceTest\" -q 2>&1 | tail -5",

            "timeout": 60000

          }

        ]

      }

    ]

  }

}
```

 

③ 任务完成后系统通知（macOS）

```json
{

  "hooks": {

    "Notification": [

      {

        "hooks": [

          {

            "type": "command",

            "command": "osascript -e 'display notification \"Claude 需要你的介入\" with title \"Claude Code\"'"

          }

        ]

      }

    ]

  }

}
```

 

④ Java 编译后实时检查错误

```json
// 后端开发时，每次文件改动立即编译验证

{

  "hooks": {

    "PostToolUse": [

      {

        "matcher": "Edit|Write",

        "hooks": [

          {

            "type": "command",

            "command": "./gradlew compileJava -q 2>&1 | grep -E 'error:|warning:' | head -20 || true",

            "timeout": 30000

          }

        ]

      }

    ]

  }

}
```

 

 

> 📌 **Hooks 使用原则**  
> Hooks 命令要快（30 秒内），避免阻塞 Claude 的工作流。  用 matcher 精确匹配触发条件，避免每次操作都触发耗时命令。  调试 Hooks 时，先用 echo 命令测试触发时机是否正确。
## 🌿 第十章  Worktree——并行任务隔离 {#第十章--worktree并行任务隔离}

### 10.1  什么是 Worktree？

Worktree 基于 Git 的 worktree 功能，让你在独立的目录中对同一仓库的不同分支并行工作，每个 Claude 会话有独立的代码副本，互不干扰。

•同时开发多个功能：功能 A 和 bug 修复并行进行

•隔离风险：实验性改动失败可以直接丢弃，不影响主分支

•Writer / Reviewer 双会话：一个会话写代码，另一个会话全新上下文做代码审查

 

### 10.2  基本用法

```bash
# 在隔离 Worktree 中启动（自动创建 .claude/worktrees/ 目录）
claude --worktree feature-auth
 
# 同时在两个终端运行
# 终端 1：
claude --worktree feature-user-export
 
# 终端 2：
claude --worktree bugfix-login-timeout
 
```


### 10.3  Writer / Reviewer 双会话模式

用两个会话分别负责实现和审查，避免「自己审自己」的偏见：

```bash
# 终端 1：实现会话（Worktree 中开发）

claude --worktree feature-payment

> 实现支付模块，完成后告诉我

# 终端 2：审查会话（全新上下文，不带实现过程）

claude

> 审查 @src/payment/ 下最近一次 git commit 的改动，

  重点检查：边界情况、安全隐患、与现有代码风格一致性。

  给出必须修复 / 建议修复 / 可选改进三级反馈。
```

  

## 📋 第十一章  实战 SOP {#第十一章--实战-sop}

以下三套 SOP 覆盖开发中最常见的场景，可直接复用。每套 SOP 都经过实际项目验证，核心思路是：先建安全网，再动代码；每次只动一小块，每块都可验证。

### 11.1  SOP A：老项目重构

适用场景：接手历史包袱重的老系统，在不破坏线上功能的前提下逐步改善代码质量。

|  |  |  |
| --- | --- | --- |
| 阶段 | 目标 | 关键操作 |
| Phase 0  摸底 | 只读探索，生成技术债地图 | Plan Mode + Subagent 扫描，产出 tech-debt-report.md |
| Phase 1  安全网 | 先补测试，固定现有行为 | 覆盖公开方法，设置 Hook 自动跑测试 |
| Phase 2  规划 | 制定分步计划 | Plan Mode 生成重构清单，人工审核后存档 |
| Phase 3  执行 | Worktree 隔离，每步验证 | 每个 Step 独立 Worktree，Writer/Reviewer 互审 |
| Phase 4  收尾 | 全量对比验证 | 测试对比 + 公开 API 签名检查 + 创建 PR |

 

Phase 0：摸底提示词模板

```bash
claude --permission-mode plan

> 用 subagent 分析 @src/main/java/com/example/order/ 目录，
  给我一份技术债报告，包含：
  1. 代码行数和文件数量
  2. 超过 300 行的类（逐个列出）
  3. 重复代码模式（超过 3 处的）
  4. 缺少测试覆盖的核心逻辑

  5. 直接依赖数据库/外部服务的地方（硬编码、非接口调用）

  只分析，不修改任何文件。

 

```bash
# 分析完成后保存报告

> 把这份报告保存到 .claude/tech-debt-report.md

 

Phase 1：补测试提示词模板

> 分析 @OrderService.java 的所有公开方法，

  给每个方法写集成测试。

  要求：

  1. 测试现有行为，包括已知边界情况

  2. 覆盖正常路径和异常路径

  3. 不要 mock 数据库层（用 H2 内存库）

  4. 参考 @src/test/ 下已有测试的风格

  写完跑测试，报告覆盖率。

 

Phase 2：规划提示词模板

claude --permission-mode plan

> 分析 @OrderService.java（847 行），

  结合 @.claude/tech-debt-report.md，制定重构计划。

  约束：

  - 每步保持公开 API 不变（调用方零改动）

  - 每步可独立测试和提交

  - 不引入新框架或依赖

  - 按依赖顺序排列（先基础类，再业务服务）

  格式：## Step N: [名称] - 目标 / 影响文件 / 验证方式 / 估时

 

Phase 3：执行提示词模板

claude --worktree refactor-step1

> 执行 @.claude/refactor-plan.md 里的 Step 1。

  规则：

  - 只改 Step 1 涉及的文件

  - 改完立即跑相关测试

  - 测试全过才能提交

  - 提交格式：refactor: [步骤描述]

 


> ⚠️ **老项目重构最常见陷阱**  
> 跳过测试直接重构 → 没有安全网，改坏了无法察觉  单次改动太多文件 → 出问题无法定位是哪步引入的  在主分支上直接改 → 失败无法回滚，影响线上  重构时顺手修 bug → 职责混淆，出问题分不清是重构还是 bug 修复导致的

### 11.2  SOP B：快速需求迭代

适用场景：产品提出新需求，需要 1-2 天内开发完成并上线。核心是：先把需求写清楚，再评估影响面，最后并行开发提速。

|  |  |  |
| --- | --- | --- |
| 阶段 | 目标 | 时间估计 |
| Phase 0  需求规格化 | 把一句话需求变成可执行 SPEC 文档 | 5-10 分钟 |
| Phase 1  影响面评估 | 知道要动哪些文件，有没有潜在风险 | 5 分钟 |
| Phase 2  并行开发 | 前后端 Worktree 并行进行 | 并行节省 30-50% 时间 |
| Phase 3  互审 | 新会话全新上下文做审查 | 15 分钟 |
| Phase 4  交付 | 创建 PR + 通知 | 10 分钟 |

 

Phase 0：需求访谈提示词

```bash
> 我需要开发一个新功能：[一句话描述]
  在开始实现之前，先逐一问我几个问题，把细节搞清楚：
  - 用户场景和使用路径
  - 边界情况和异常处理
  - 与现有功能的交互关系
  - 非功能性要求（性能、权限等）
  - 明确不在本次范围内的东西
  每次只问一个问题，等我回答后再问下一个。
  全部澄清后，把结果写成 .claude/specs/[功能名].md
```

 

Phase 1：影响面评估提示词

```bash
claude --permission-mode plan

> 分析 @.claude/specs/[功能名].md 描述的需求，
  评估实现这个功能需要改动哪些文件：
  1. 需要新建的文件（列出路径）
  2. 需要修改的现有文件（路径 + 改动原因）
  3. 需要新增的数据库字段/表
  4. 受影响的测试文件
  5. 潜在风险点（可能意外影响的功能）
  不要开始实现，只需要评估。
```

 

Phase 3：审查提示词（新会话）

# 新会话，不带任何之前上下文

claude

> 审查这个 PR 的改动（新功能实现，不是重构）。

  功能规格：@.claude/specs/[功能名].md

  请重点检查：

  1. 是否完整实现了 SPEC 的所有验收标准

  2. 权限控制（是否有未鉴权的接口）

  3. 输入验证（前后端都要有）

  4. 错误处理（网络错误、服务端错误的展示）

  5. 性能（N+1 查询、不必要的全量加载）

  输出：[必须修复] / [建议修复] / [可选] 三级反馈。

 
```


### 11.3  SOP C：全新项目研发

适用场景：从零开始建新项目/服务。核心是：先把「规则」写进项目，让 Claude 从第一行代码起就遵循这些规则。

|  |  |  |
| --- | --- | --- |
| 阶段 | 目标 | 关键操作 |
| Phase 0  架构决策 | ADR 文档化，早期决策有据可查 | 生成 docs/adr/ 文件，CLAUDE.md 引用它 |
| Phase 1  项目脑初始化 | CLAUDE.md + Subagents + Hooks 一次配齐 | /init 后手动补充，创建项目专属 Subagent |
| Phase 2  骨架生成 | Plan Mode 确认后生成，先跑通再实现 | 目录结构 + 依赖 + 第一个 Feature 骨架 |
| Phase 3  迭代开发 | 每个功能走完整的特性循环 | SPEC → Plan → Code → Verify → Commit |
| Phase 4  CI/CD 接入 | 从第一天就有自动化流水线 | GitHub Actions + Claude PR 审查 |

 

特性开发标准循环（可无限复用）

9.开新 Worktree：claude --worktree feature-[功能名]

10.需求规格化（5-10 分钟）：访谈 → 生成 SPEC.md

11.规划（Shift+Tab 进入 Plan Mode）：列出改动文件清单

12.实现（Normal Mode）：每个类写完立即编译验证

13.验证（10 分钟）：跑测试 → Subagent 安全审查 → 检查规范

14.提交：feat(模块): 描述 + 详细说明

 

GitHub Actions CI 配置生成提示词

```bash
> 为这个 Spring Boot 项目生成 GitHub Actions CI 配置：
  1. 触发条件：PR 提 main/develop 分支时
  2. 步骤：检出代码 → Java 17 环境（缓存 Gradle） →
           启动 MySQL（service container） →
           Flyway 迁移 → 运行测试 → 生成测试报告
  3. 失败时在 PR 评论中输出失败测试名称
  保存到 .github/workflows/ci.yml
```

 

## ⚠️ 第十二章  常见错误与避坑指南 {#第十二章--常见错误与避坑指南}

### 12.1  使用习惯类错误

 

❌ 不清空上下文就切换任务


> 💡 **问题**  
> 完成任务后不执行 /clear 直接开始新任务。Claude 被历史信息干扰，给出不相关甚至矛盾的回答。


> 💡 **解决**  
> 每次切换任务前执行 /clear，养成习惯。同一问题修正超过两次，直接 /clear 用更精确的提示重新开始。

❌ 提示词太模糊


> 💡 **问题**  
> 「帮我优化代码」→ Claude 做了你意想不到的大规模改动，难以回滚。


> 🎯 **解决**  
> 使用黄金提示词公式：目标 + 文件位置 + 验证标准 + 约束条件，四要素缺一不可。

❌ 不先规划就执行大改动


> 💡 **问题**  
> 多文件重构直接执行，不了解影响范围，出了问题难以定位。


> 💡 **解决**  
> 改动超过 3 个文件，先用 Plan Mode（Shift+Tab）看清规划后再执行。

❌ 完全信任 AI 不审查输出


> 💡 **问题**  
> 直接 accept 所有改动，不做代码审查，尤其业务逻辑和安全相关部分。


> 💡 **解决**  
> AI 生成的代码必须经过人工审查，重点看：边界条件、错误处理、权限检查。始终让 Claude 改完后运行测试验证。

❌ 不配置 CLAUDE.md


> 💡 **问题**  
> 每次对话都重新解释技术栈、规范、背景，浪费大量 token 和时间。


> 💡 **解决**  
> 新项目第一件事执行 /init，让 Claude 生成 CLAUDE.md 模板，然后手动补充最重要的规范。

### 12.2  技术配置类错误

 

❌ CLAUDE.md 写太长，重要规则被淹没


> 💡 **问题**  
> CLAUDE.md 几百行，Claude 无法有效注意到关键规则。


> 💡 **解决**  
> 精简 CLAUDE.md，只留「Claude 最容易弄错的事」。  重要规则加「IMPORTANT:」或「YOU MUST:」强调。  复杂流程转移到 Skills，按需加载。

❌ Claude 读了太多不必要的文件


> 💡 **问题**  
> 调查问题时没限定范围，Claude 扫描整个 repo，上下文快速耗尽。


> 💡 **解决**  
> 用 @ 精确引用文件而非整个目录。  用 Plan Mode 先评估影响面。  复杂探索任务改用 Subagent，不污染主会话。

### 12.3  故障排除速查

|  |  |
| --- | --- |
| 症状 | 解决方案 |
| 权限弹窗频繁 | /permissions 白名单常用命令，或配置 settings.json 的 allow 列表 |
| 上下文溢出 / 回答偏题 | /compact 保留关键信息，或 /clear 重新开始 |
| 不遵循 CLAUDE.md 规范 | /memory 确认文件已被加载，检查路径是否正确，重要规则加 IMPORTANT 强调 |
| 安装失败或启动报错 | claude /doctor 运行诊断 |
| 回答质量变差 | /model opus 切换更强模型 |
| token 消耗过快 | 用 -p 做纯查询；精确 @ 引用文件；定期 /compact |
| ESC 无法中断（JetBrains） | Settings → Tools → Terminal，取消 Move focus to editor with Escape |

 

## 附录  速查卡与配置参考

A. 完整斜杠命令速查

|  |  |
| --- | --- |
| 命令 | 说明 |
| /clear | 清空对话历史 |
| /compact [说明] | 压缩对话，可选保留关键信息 |
| /context | 查看上下文使用比例 |
| /cost | 查看 token 用量 |
| /export | 导出当前对话 |
| /rename [名称] | 给会话命名 |
| /rewind | 回退到历史状态 |
| /model [名称] | 切换模型 |
| /config | 打开设置 |
| /permissions | 管理工具权限 |
| /doctor | 健康检查 |
| /init | 生成 CLAUDE.md 模板 |
| /memory | 查看自动记忆 |
| /hooks | 查看 Hooks 配置 |
| /mcp | 管理 MCP 服务器 |
| /agents | 管理 Subagents |
| /install-github-app | 安装 GitHub 集成 |
| /login / /logout | 账号管理 |
| /bug | 报告 Bug |
| /vim | 开启 Vim 模式 |
| /exit | 退出 |

 

B. 专业级全局配置参考

// ~/.claude/settings.json（全局配置）

{

  "permissions": {

    "defaultMode": "default",

    "allow": [

      "Bash(git:\*)",

      "Bash(npm:\*)",

      "Bash(pnpm:\*)",

      "Bash(node:\*)",

      "Bash(./gradlew:\*)"

    ]

  }

}

 

// .claude/settings.json（项目级配置）

{

  "permissions": {

    "defaultMode": "plan"

  },

  "hooks": {

    "PostToolUse": [

      {

        "matcher": "Edit|Write",

        "hooks": [

          {

            "type": "command",

            "command": "npm run lint -- --fix --quiet",

            "timeout": 30000

          }

        ]

      }

    ]

  }

}

 

C. 推荐 .claude/ 目录结构

```text
.claude/

├── settings.json          # 权限 + Hooks 配置

├── CLAUDE.md              # 项目级记忆（或放根目录）

├── agents/                # 自定义 Subagents

│   ├── code-reviewer.md

│   ├── debugger.md

│   └── security-reviewer.md

├── skills/                # 按需加载的知识片段

│   └── api-conventions/

│       └── SKILL.md

├── specs/                 # 功能需求规格

│   └── user-export.md

└── worktrees/             # Worktree（自动生成，可 .gitignore）

 

```

### D. 官方资源

• [完整文档（含中文）：code.claude.com/docs](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)

• [Anthropic Console：console.anthropic.com](https://console.anthropic.com)

• [社区资源：github.com/hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)

• [Anthropic 官方 YouTube：安装演示和功能介绍视频](https://www.youtube.com/@Anthropic)

 

 

---

> *感谢阅读本指南！本文基于 Claude Code 2026 年最新版本编写。如有更新或勘误，欢迎通过 GitHub Issue 反馈。*
