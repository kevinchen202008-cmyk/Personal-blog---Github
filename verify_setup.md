# 配置验证检查清单

使用此清单验证评论系统和浏览量统计是否正确配置。

## 🔍 配置验证步骤

### 1. 检查 `_config.yml` 配置

打开 `_config.yml` 文件，验证以下配置：

#### 评论系统配置（第 114-140 行）

```yaml
comments:
  provider: giscus  # ✅ 应该是 'giscus'
  giscus:
    repo: kevinchen202008-cmyk/kevinchen202008-cmyk.github.io  # ✅ 已配置
    repo_id: # ⚠️ 需要从 giscus.app 获取并填入
    category: # ⚠️ 需要从 giscus.app 获取并填入
    category_id: # ⚠️ 需要从 giscus.app 获取并填入
    mapping: pathname  # ✅ 已配置
    strict: "0"  # ✅ 已配置
    input_position: bottom  # ✅ 已配置
    lang: zh-CN  # ✅ 已配置
    reactions_enabled: "1"  # ✅ 已配置
```

**检查项：**
- [ ] `provider` 设置为 `giscus`
- [ ] `repo` 已正确填写
- [ ] `repo_id` 已填入（从 giscus.app 获取）
- [ ] `category` 已填入（从 giscus.app 获取）
- [ ] `category_id` 已填入（从 giscus.app 获取）

#### 浏览量统计配置（第 78-82 行）

```yaml
pageviews:
  provider: busuanzi  # ✅ 应该是 'busuanzi'
```

**检查项：**
- [ ] `provider` 设置为 `busuanzi`

### 2. 检查文件结构

验证以下文件是否存在：

**必需文件：**
- [ ] `_plugins/busuanzi-pageviews.rb` - Jekyll 插件
- [ ] `_includes/busuanzi-pageviews.html` - 页面浏览量组件
- [ ] `_includes/busuanzi-siteviews.html` - 站点访问量组件

**文档文件（可选）：**
- [ ] `COMMENTS_AND_VIEWS_SETUP.md` - 配置指南
- [ ] `QUICK_START.md` - 快速开始
- [ ] `IMPLEMENTATION_SUMMARY.md` - 实现总结
- [ ] `NEXT_STEPS.md` - 下一步操作

### 3. 检查 GitHub 仓库设置

访问仓库设置页面：
```
https://github.com/kevinchen202008-cmyk/kevinchen202008-cmyk.github.io/settings
```

**检查项：**
- [ ] Discussions 功能已启用（Settings → General → Features → Discussions）

### 4. 本地测试（可选但推荐）

1. **安装依赖**
   ```bash
   bundle install
   ```

2. **启动本地服务器**
   ```bash
   bundle exec jekyll serve
   ```

3. **访问本地站点**
   ```
   http://localhost:4000
   ```

4. **检查功能**
   - [ ] 访问任意文章页面
   - [ ] 检查页面源代码，确认不蒜子脚本已注入（搜索 `busuanzi`）
   - [ ] 检查评论框是否显示（需要 Giscus 配置完整）

### 5. 在线验证

部署到 GitHub Pages 后：

1. **检查构建状态**
   - 访问：https://github.com/kevinchen202008-cmyk/kevinchen202008-cmyk.github.io/actions
   - [ ] 最新构建状态为绿色（成功）

2. **访问文章页面**
   - 访问任意文章，例如：
     ```
     https://kevinchen202008-cmyk.github.io/posts/my-first-blog/
     ```

3. **验证评论功能**
   - [ ] 页面底部显示 Giscus 评论框
   - [ ] 可以使用 GitHub 账号登录
   - [ ] 可以发表评论
   - [ ] 可以回复评论

4. **验证浏览量统计**
   - [ ] 打开浏览器开发者工具（F12）
   - [ ] 查看 Network 标签
   - [ ] 刷新页面
   - [ ] 确认有请求到 `busuanzi.ibruce.info`
   - [ ] 等待几分钟后，浏览量数字应该更新

### 6. 浏览器控制台检查

按 F12 打开开发者工具，检查：

**控制台（Console）标签：**
- [ ] 没有 JavaScript 错误
- [ ] 没有与 Giscus 相关的错误
- [ ] 没有与不蒜子相关的错误

**网络（Network）标签：**
- [ ] `giscus.app` 的请求成功（如果配置了 Giscus）
- [ ] `busuanzi.ibruce.info` 的请求成功

**元素（Elements）标签：**
- [ ] 页面 `<head>` 中包含不蒜子脚本：
  ```html
  <script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
  ```
- [ ] 页面底部包含 Giscus 评论框（如果配置了）

## ❌ 常见问题检查

### 问题 1：评论框不显示

**可能原因：**
1. GitHub Discussions 未启用
2. Giscus 配置参数不完整
3. `_config.yml` 语法错误
4. GitHub Pages 构建失败

**解决方法：**
- 检查 GitHub 仓库设置
- 重新获取 Giscus 配置参数
- 验证 YAML 语法
- 查看 GitHub Actions 构建日志

### 问题 2：浏览量不显示

**可能原因：**
1. Jekyll 插件未正常工作
2. 主题不支持自动显示
3. 统计数据尚未加载

**解决方法：**
- 检查 `_plugins/busuanzi-pageviews.rb` 文件是否存在
- 检查页面源代码确认脚本已注入
- 等待几分钟让统计数据加载
- 手动添加显示位置（使用 include 文件）

### 问题 3：GitHub Pages 构建失败

**可能原因：**
1. `_config.yml` YAML 语法错误
2. Jekyll 插件有语法错误
3. 依赖问题

**解决方法：**
- 使用 YAML 验证工具检查语法
- 检查 Ruby 插件语法
- 查看构建日志中的具体错误信息

## ✅ 验证完成标准

当以下所有项都完成时，配置即成功：

- [ ] `_config.yml` 配置正确
- [ ] 所有必需文件存在
- [ ] GitHub Discussions 已启用
- [ ] Giscus 配置参数已填入
- [ ] 代码已推送到 GitHub
- [ ] GitHub Pages 构建成功
- [ ] 文章页面显示评论框
- [ ] 可以发表和回复评论
- [ ] 浏览量统计正常工作

## 📞 获取帮助

如果遇到问题：

1. 查看详细文档：
   - `COMMENTS_AND_VIEWS_SETUP.md` - 详细配置指南
   - `NEXT_STEPS.md` - 下一步操作指南

2. 检查官方文档：
   - [Giscus 官方文档](https://giscus.app/zh-CN)
   - [Chirpy 主题文档](https://github.com/cotes2020/jekyll-theme-chirpy/wiki)

3. 查看 GitHub Issues：
   - 在仓库中创建 Issue 描述问题
