---
title: 双窗口文件管理程序 - 项目初始化
date: 2025-01-17 22:30:00 +0800
categories: [项目开发, Python]
tags: [python, git, 文件管理, 项目]
---

# 双窗口文件管理程序 - 项目初始化

今天开始了一个新项目：**本地双窗口文件管理程序**。

## 项目背景

在日常工作中，经常需要在不同文件夹之间复制、移动文件，Windows 自带的资源管理器虽然功能强大，但在某些场景下不够高效。因此决定开发一个双窗口的文件管理工具。

## 项目目标

- 🎯 双窗口界面，方便文件对比和操作
- 🎯 快速的文件浏览和搜索
- 🎯 常用文件操作（复制、移动、删除等）
- 🎯 支持快捷键操作
- 🎯 简洁美观的界面

## 技术选型

### 编程语言
选择 **Python**，原因：
- 开发效率高
- 丰富的标准库
- 跨平台支持

### GUI 框架
考虑了几个选项：
- **Tkinter** - Python 标准库，简单易用 ✅
- PyQt5 - 功能强大，但学习曲线陡峭
- Kivy - 适合移动端

最终选择 **Tkinter**，因为项目需求不复杂，Tkinter 完全够用。

## 今天的工作

### 1. Git 仓库初始化

```bash
# 初始化仓库
git init

# 配置用户信息
git config --global user.name "kevinchen202008-cmyk"
git config --global user.email "kevin.chen202008@gmail.com"

# 查看配置
git config --list
