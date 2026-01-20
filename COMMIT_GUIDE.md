# 提交代码指南

## 📦 准备提交

当前有以下文件需要提交：

### 修改的文件
- `_config.yml` - 已配置评论系统和浏览量统计

### 新增的文件
- `_plugins/busuanzi-pageviews.rb` - 不蒜子统计插件
- `_includes/busuanzi-pageviews.html` - 页面浏览量组件
- `_includes/busuanzi-siteviews.html` - 站点访问量组件
- `assets/js/busuanzi.js` - 辅助 JavaScript
- `COMMENTS_AND_VIEWS_SETUP.md` - 详细配置指南
- `QUICK_START.md` - 快速开始指南
- `IMPLEMENTATION_SUMMARY.md` - 实现总结
- `NEXT_STEPS.md` - 下一步操作指南
- `verify_setup.md` - 配置验证清单
- `COMMIT_GUIDE.md` - 本文件

## 🚀 提交步骤

### 方法一：使用 Git 命令（推荐）

1. **添加所有更改的文件**
   ```bash
   git add _config.yml
   git add _plugins/
   git add _includes/
   git add assets/
   git add *.md
   ```

2. **提交更改**
   ```bash
   git commit -m "feat: 添加评论系统和浏览量统计功能

   - 配置 Giscus 评论系统（基于 GitHub Discussions）
   - 实现不蒜子浏览量统计
   - 添加 Jekyll 插件自动注入统计脚本
   - 添加配置文档和操作指南"
   ```

3. **推送到 GitHub**
   ```bash
   git push origin main
   ```

### 方法二：使用 Git GUI 工具

如果您使用 VS Code、GitHub Desktop 或其他 Git GUI 工具：

1. 打开工具，查看更改的文件
2. 选择所有相关文件
3. 填写提交信息：
   ```
   feat: 添加评论系统和浏览量统计功能

   - 配置 Giscus 评论系统（基于 GitHub Discussions）
   - 实现不蒜子浏览量统计
   - 添加 Jekyll 插件自动注入统计脚本
   - 添加配置文档和操作指南
   ```
4. 点击提交（Commit）
5. 点击推送（Push）

## ⚠️ 提交前检查

在提交之前，请确认：

- [ ] `_config.yml` 中的 Giscus 配置参数已填入（repo_id、category_id 等）
  - 如果还没有填入，可以先提交代码，稍后再更新配置
- [ ] 所有文件都已保存
- [ ] 没有语法错误

## 📝 提交后的操作

提交代码后：

1. **等待 GitHub Pages 构建**
   - 访问：https://github.com/kevinchen202008-cmyk/kevinchen202008-cmyk.github.io/actions
   - 查看构建状态

2. **完成 Giscus 配置**（如果还没完成）
   - 按照 `NEXT_STEPS.md` 中的步骤获取配置参数
   - 更新 `_config.yml`
   - 再次提交并推送

3. **验证功能**
   - 按照 `verify_setup.md` 中的清单验证功能

## 🔄 如果 Giscus 配置参数还未获取

如果您还没有从 giscus.app 获取配置参数，可以：

**选项 1：先提交代码，稍后更新配置**
- 先提交当前代码
- 按照 `NEXT_STEPS.md` 获取 Giscus 配置参数
- 更新 `_config.yml` 后再次提交

**选项 2：先完成配置，再提交**
- 按照 `NEXT_STEPS.md` 完成 Giscus 配置
- 更新 `_config.yml`
- 一次性提交所有更改

两种方式都可以，推荐选项 1，因为浏览量统计功能已经可以立即使用。
