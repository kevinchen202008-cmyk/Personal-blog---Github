# GitHub 项目优化 Todo Plan

> 基于 AI 技术专家分析报告生成 · 分析日期：2026-04-22  
> 账号：[@kevinchen202008-cmyk](https://github.com/kevinchen202008-cmyk)

---

## 📊 账号现状快照

| 指标 | 现状 | 目标 |
|------|------|------|
| 账号年龄 | 5.5 个月（2025-11 创建） | — |
| 公开仓库 | 24 个（8 原创 + 16 Fork） | 精简至高质量 |
| 关注者 | 0 | 建立技术影响力 |
| Profile 完整度 | bio / 公司 / 地区均为空 | 100% 填写 |
| 最成熟项目 | `automated-tool-compliance-scanning` | 继续深化 |

---

## 🗺️ 项目全景地图

### 原创项目（8 个）

```
核心技术项目
├── automated-tool-compliance-scanning  ★ 最成熟（Python + FastAPI + LLM Agent）
├── Android-and-IOS-program-GreenPrj   TypeScript 跨平台移动 App（BMAD）
├── bmad-opencode-execise-for-toolscan  TypeScript 工具扫描练习（1 star）
├── Local-dual-window-file-management-program  Python 本地文件管理器
└── mobile-app-for-ios-and-android     Java 记账 App

展示类项目
├── Personal-blog---Github             技术博客（Jekyll + GitHub Pages）
└── kevinchen202008-cmyk               GitHub Profile README
```

### Fork 项目（16 个）

```
AI Agent 框架研究（8 个）
├── hermes-agent          ← 有 2 个原创提交，深度参与
├── openclaw / opencode / codex / gastown
├── everything-claude-code / claw-code / learn-claude-code

Claude Code 源码分析（3 个，存在重复）
├── claude-code-2.1.88 / claude-code-2188 / claude-code-source-code

课程学习资料（4 个）
└── rag-in-action / mcp-in-action / ai-agents / a2a-in-action
```

---

## ✅ Todo 清单

### 🔴 立即执行（本周内）

#### 1. 完善 GitHub Profile

- [ ] 添加个人简介 Bio，例如：`AI Agent 开发者 | BMAD 实践者 | Python + TypeScript`
- [ ] 更新 `kevinchen202008-cmyk` Profile README，展示代表项目

#### 2. 修复 `automated-tool-compliance-scanning` 核心 BUG

- [ ] **修复 `compliance_engine.py` 的 TODO 占位符**
  - `assess_security()` 目前硬编码返回 `70.0`，所有工具安全评分相同，无实际意义
  - 方案 A：接入 [OSV.dev](https://osv.dev/docs/) 公开 API 查询已知漏洞
  - 方案 B：基于关键词规则评估（数据加密、访问控制、审计日志等维度）
- [ ] **合并 Dependabot PR**：`black` 依赖已有升级 PR（24.10.0 → 26.3.1）待合并

#### 3. 清理重复 Fork 仓库

- [ ] 3 个 Claude Code 源码 Fork 只保留 1 个最完整的（建议保留 `claude-code-2.1.88`）
  - [ ] 删除或归档 `claude-code-2188`
  - [ ] 删除或归档 `claude-code-source-code`
- [ ] 为已完成的课程 Fork 添加归档标记或删除
  - [ ] `rag-in-action`（2025-11 后无活动）
  - [ ] `mcp-in-action`（2025-11 后无活动）

---

### 🟡 近期重点（本月内）

#### 4. 向 hermes-agent 上游提 PR（★ 最有价值的一步）

- [ ] 将 `docs/deployment-aliyun-ecs.md`（ECS 部署指南）整理后提交 PR 至 [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- [ ] 将 `ARCHITECTURE.md`（系统架构 Wiki）提交 PR 至上游
- [ ] 这将成为你第一个**真实开源贡献记录**

#### 5. 完善 `automated-tool-compliance-scanning` 工程质量

- [ ] **为 `ai_client.py` 加重试保护**（防止 LLM API 偶发超时导致整个扫描失败）
  ```python
  # 引入 tenacity 重试装饰器
  from tenacity import retry, stop_after_attempt, wait_exponential
  
  @retry(stop=stop_after_attempt(3), wait=wait_exponential(min=1, max=10))
  async def generate_compliance_suggestions(self, ...): ...
  ```
- [ ] **升级 pyproject.toml 依赖版本约束**
  - `pytest==7.4.3` → `pytest>=8.0,<9`
  - `pytest-asyncio==0.21.1` → `pytest-asyncio>=0.26,<1`
  - 改用范围约束，避免手动跟版本
- [ ] 补充 `/docs` API 路由的访问说明和鉴权示例
- [ ] 为 `assess_license()` 和 `assess_data_privacy()` 补充单元测试

#### 6. 博客发布第一篇技术深度文章

- [ ] 题材建议（任选一篇开始）：
  - 《Hermes Agent 系统架构深度解析》（你的 ARCHITECTURE.md 已是草稿）
  - 《阿里云 ECS 上部署 AI Agent 网关：微信 + 飞书双平台实践》
- [ ] 在文章中链接对应 GitHub 项目，形成内容闭环

---

### 🟢 中期规划（1～3 个月）

#### 7. 聚焦一个 AI Agent 框架深耕

> 你已研究了 hermes-agent、openclaw、codex、opencode、gastown 等多个框架。
> **广泛浅研的价值已基本释放，现阶段应选定 1 个深入。**

- [ ] **推荐选择 hermes-agent**（理由：已有实质贡献，架构最复杂，Nous Research 背书）
- [ ] 在 `hermes-agent` fork 上持续跟进上游，保持 `main` 分支同步
- [ ] 为 hermes-agent 贡献至少 1 个新功能或 bug fix PR

#### 8. 为 `automated-tool-compliance-scanning` 添加 MCP 支持

- [ ] 将合规扫描能力包装为 **MCP Server**，让 Claude / Cursor 等 AI 工具可直接调用
  - 入口参考：你已学完 `mcp-in-action`，可直接上手
  - 参考文档：[MCP Server 开发指南](https://modelcontextprotocol.io/docs)
- [ ] 发布到 MCP 社区，增加项目曝光度

#### 9. `Android-and-IOS-program-GreenPrj` 明确状态

- [ ] 如已完成学习目标：在 README 中标注 `[已归档 · 学习项目]`
- [ ] 如计划继续开发：补充下一步 Roadmap，重新激活

#### 10. 建立个人技术影响力渠道

- [ ] 加入 [Nous Research Discord](https://discord.gg/NousResearch)，在 #hermes-agent 频道发言
- [ ] 关注并参与 Claude Code 社区（GitHub Discussions / Discord）
- [ ] 目标：让你的架构分析和部署指南被更多人看到

---

## 📈 技术成长时间线

```
2025-11  注册 GitHub，Fork 课程仓库（RAG、MCP、A2A）
           ↓ 课程学习阶段
2026-01  开始原创项目（移动 App、文件管理器）
           ↓ BMAD 方法论实践阶段
2026-02  深入 AI Agent 框架研究（大量 Fork）
           ↓ 框架研究阶段
2026-04  产出原创 Agent 项目（合规扫描 Agent）+ 架构分析文档
           ↓ 当前阶段：原创 Agent 开发
2026-05? 第一个上游 PR 合并，开源贡献记录建立  ← 下一个里程碑
2026-Q3? hermes-agent 核心贡献者 / MCP 生态发布  ← 中期目标
```

---

## 🏆 核心优先级总结

| 优先级 | 行动项 | 预期收益 |
|--------|--------|---------|
| P0 | 完善 GitHub Profile | 提升第一印象，增加可发现性 |
| P0 | 修复 compliance_engine TODO | 消除功能空洞，项目可真实使用 |
| P1 | hermes-agent 上游 PR | **第一个开源贡献记录**，影响力建立的起点 |
| P1 | ai_client 加重试保护 | 生产稳定性提升 |
| P1 | 博客发布技术文章 | 内容输出，建立个人品牌 |
| P2 | 清理重复 Fork | 仓库整洁，聚焦度提升 |
| P2 | MCP Server 封装 | 扩大项目应用场景 |
| P3 | 社区参与 | 长期影响力建设 |

---

> **核心建议**：你在 5 个月内完成了从课程学习 → 框架研究 → 原创项目的跨越，节奏出色。  
> 当前最大短板是**深度分散**（Fork 多但贡献少）和**核心功能占位**（TODO 未实现）。  
> 接下来的关键转折点：**做 1 个真实的上游 PR + 发 1 篇深度技术文章**。
