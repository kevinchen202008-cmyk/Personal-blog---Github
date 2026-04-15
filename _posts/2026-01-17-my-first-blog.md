---
title: "我的技术博客搭建之旅：从零到一的完整指南"
date: 2026-01-17
categories: [博客搭建, 技术分享]
tags: [GitHub Pages, Jekyll, Chirpy, 博客搭建]
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

# 我的技术博客搭建之旅：从零到一的完整指南

> 搭建个人技术博客是每个开发者成长路上的重要一步。它不仅是记录学习过程、分享技术经验的平台，更是展示项目成果、提升表达能力的绝佳机会。本文将详细介绍我如何从零开始搭建自己的技术博客，以及在这个过程中学到的宝贵经验。

---

## 📋 目录

- [💡 为什么要写博客？](#-为什么要写博客)
- [🛠️ 博客搭建过程](#️-博客搭建过程)
- [📂 我的项目](#-我的项目)
- [🧰 技术栈](#-技术栈)
- [📋 下一步计划](#-下一步计划)
- [✅ 总结与收获](#-总结与收获)

---

## 💡 为什么要写博客？

1. **📝 记录学习过程** - 把学到的知识整理成文章，加深理解
2. **🤝 分享技术经验** - 帮助遇到同样问题的人
3. **🎯 展示项目成果** - 记录自己的项目开发历程
4. **📈 提升表达能力** - 通过写作提高技术表达能力

```
博客的价值与收益
┌─────────────────────────────────────────────────────────────┐
│                    个人技术博客的价值                        │
├─────────────────────────────────────────────────────────────┤
│                    对个人的价值                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  知识沉淀   │  │  技能提升   │  │  职业发展   │         │
│  │  • 学习记录 │  │  • 表达能力 │  │  • 作品展示 │         │
│  │  • 经验总结 │  │  • 思维整理 │  │  • 行业影响 │         │
│  │  • 问题解决 │  │  • 写作技巧 │  │  • 人脉积累 │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│                    对社区的贡献                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  知识分享   │  │  经验传递   │  │  问题解答   │         │
│  │  • 技术文章 │  │  • 最佳实践 │  │  • 踩坑记录 │         │
│  │  • 教程指南 │  │  • 项目复盘 │  │  • 解决方案 │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ 博客搭建过程

### 选择方案

经过对比，我选择了 **GitHub Pages + Jekyll + Chirpy 主题**：

- ✅ **完全免费** - 无需支付任何费用
- ✅ **无需服务器** - GitHub 提供免费托管
- ✅ **使用 Git 管理** - 版本控制方便
- ✅ **Markdown 写作** - 专注内容创作
- ✅ **主题美观** - Chirpy 主题现代简洁

### 搭建步骤

```
博客搭建流程图
┌─────────────────────────────────────────────────────────────┐
│                    博客搭建流程                              │
├─────────────────────────────────────────────────────────────┤
│  ① 准备工作                                                │
│    • 注册 GitHub 账号                                       │
│    • 安装 Git 和 Ruby                                       │
│    • 了解 Markdown 基础语法                                 │
│    ↓                                                        │
│  ② 创建仓库                                                │
│    • 从 Chirpy Starter 模板创建仓库                         │
│    • 命名规则：username.github.io                           │
│    • 克隆到本地                                             │
│    ↓                                                        │
│  ③ 配置博客                                                │
│    • 修改 _config.yml 配置文件                              │
│    • 设置个人信息和网站标题                                 │
│    • 配置评论系统和统计                                     │
│    ↓                                                        │
│  ④ 创建内容                                                │
│    • 在 _posts 目录创建文章                                 │
│    • 使用 Markdown 编写内容                                 │
│    • 添加 Front Matter 元数据                               │
│    ↓                                                        │
│  ⑤ 部署上线                                                │
│    • 提交代码到 GitHub                                      │
│    • 自动构建和部署                                         │
│    • 访问 https://username.github.io                        │
└─────────────────────────────────────────────────────────────┘
```

#### 详细步骤：

1. **从 Chirpy Starter 模板创建仓库**
   - 访问 [Chirpy Starter](https://github.com/cotes2020/chirpy-starter)
   - 点击 "Use this template" 创建自己的仓库

2. **克隆到本地**
   ```bash
   git clone https://github.com/你的用户名/你的仓库名.git
   cd 你的仓库名
   ```

3. **配置 `_config.yml`**
   ```yaml
   title: 你的博客标题
   tagline: 你的博客描述
   url: "https://你的用户名.github.io"
   timezone: Asia/Shanghai
   lang: zh-CN
   ```

4. **写第一篇文章**
   ```markdown
   ---
   title: "我的第一篇博客"
   date: 2026-01-17
   categories: [技术分享]
   tags: [博客, 开始]
   ---
   
   # 我的第一篇博客
   
   这是我的第一篇技术博客文章...
   ```

5. **推送到 GitHub**
   ```bash
   git add .
   git commit -m "Initial blog setup"
   git push origin main
   ```

---

## 📂 我的项目

最近在开发一个**双窗口文件管理程序**，使用 Python 实现。

**项目地址**：[GitHub - Local-dual-window-file-management-program](https://github.com/kevinchen202008-cmyk/Local-dual-window-file-management-program)

后续会在博客中分享开发过程和技术细节。

---

## 🧰 技术栈

目前主要学习和使用的技术：

| 类别 | 技术 | 说明 |
|------|------|------|
| **编程语言** | Python | 主要开发语言 |
| **版本控制** | Git / GitHub | 代码管理和协作 |
| **前端** | HTML, CSS, JavaScript | 基础 Web 技术 |
| **工具** | VS Code, PyCharm | 开发环境和 IDE |
| **框架** | PyQt5 | 桌面应用开发 |
| **部署** | GitHub Pages | 博客和项目展示 |

---

## 📋 下一步计划

- [ ] 完善博客配置（评论系统、统计等）
- [ ] 写项目开发日志
- [ ] 分享学习笔记
- [ ] 整理技术文档
- [ ] 添加更多项目展示
- [ ] 优化博客 SEO

---

## ✅ 总结与收获

搭建博客的过程让我学到了很多：

- **🔧 Git 的基本使用** - 版本控制的重要性
- **🌐 GitHub Pages 的配置** - 静态网站托管
- **📝 Jekyll 的工作原理** - 静态网站生成器
- **✍️ Markdown 的高级用法** - 高效的内容创作

> 💡 **关键收获**：搭建个人博客不仅是技术能力的体现，更是持续学习和分享的开始。通过博客，我能够系统地整理知识、记录成长轨迹，并与更广泛的开发者社区建立联系。

期待在这里记录更多的学习和成长！

---

**如果你也想搭建自己的博客，欢迎参考我的经验！**

> 🔗 **相关资源**：
> - [GitHub Pages 官方文档](https://pages.github.com/)
> - [Jekyll 官方文档](https://jekyllrb.com/)
> - [Chirpy 主题文档](https://github.com/cotes2020/jekyll-theme-chirpy)
> - [Markdown 语法指南](https://www.markdownguide.org/)