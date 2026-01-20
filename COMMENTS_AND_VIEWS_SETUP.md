# 评论系统和浏览量统计配置指南

本文档说明如何配置博客的评论系统和浏览量统计功能。

## 一、评论系统配置（Giscus）

### 1. 启用 GitHub Discussions

1. 访问你的 GitHub 仓库：`https://github.com/kevinchen202008-cmyk/kevinchen202008-cmyk.github.io`
2. 进入 **Settings** → **General** → **Features**
3. 勾选 **Discussions** 选项，启用 Discussions 功能

### 2. 安装 Giscus App

1. 访问 [Giscus 官网](https://giscus.app)
2. 使用 GitHub 账号登录
3. 按照页面提示填写以下信息：
   - **Repository**: `kevinchen202008-cmyk/kevinchen202008-cmyk.github.io`
   - **Repository ID**: 系统会自动获取（复制保存）
   - **Category**: 选择一个分类或创建新分类
   - **Category ID**: 系统会自动获取（复制保存）
   - **Mapping**: 选择 `pathname`（推荐）
   - **Discussion term**: 选择 `pathname`
   - **Theme**: 选择 `preferred_color_scheme`（跟随系统主题）
   - **Language**: 选择 `zh-CN`

### 3. 配置 _config.yml

在 `_config.yml` 文件中，找到 `comments.giscus` 部分，填入从 Giscus 获取的信息：

```yaml
comments:
  provider: giscus
  giscus:
    repo: kevinchen202008-cmyk/kevinchen202008-cmyk.github.io
    repo_id: # 从 giscus.app 获取并填入
    category: # 从 giscus.app 获取并填入
    category_id: # 从 giscus.app 获取并填入
    mapping: pathname
    strict: "0"
    input_position: bottom
    lang: zh-CN
    reactions_enabled: "1"
```

### 4. 验证配置

1. 保存 `_config.yml` 文件
2. 提交并推送到 GitHub
3. 等待 GitHub Pages 自动构建完成
4. 访问任意一篇博客文章，在文章底部应该能看到评论框

## 二、浏览量统计配置（不蒜子）

### 1. 配置说明

不蒜子统计已经配置完成，无需额外注册或配置。系统会自动统计：
- **页面浏览量**：每篇文章的阅读次数
- **站点访问量**：整个博客的总访问次数

### 2. 显示位置

浏览量统计会在以下位置显示：
- 文章页面：显示该文章的阅读量
- 首页/列表页：显示站点总访问量（如果主题支持）

### 3. 配置选项

在 `_config.yml` 中，`pageviews.provider` 已设置为 `busuanzi`：

```yaml
pageviews:
  provider: busuanzi
```

如果需要切换到其他统计服务（如 GoatCounter），可以修改此配置。

## 三、功能说明

### 评论功能特性

- ✅ 基于 GitHub Discussions，无需第三方服务
- ✅ 支持 Markdown 格式评论
- ✅ 支持回复评论（嵌套回复）
- ✅ 支持表情反应（👍、❤️ 等）
- ✅ 支持 GitHub 账号登录评论
- ✅ 评论数据存储在 GitHub，安全可靠

### 浏览量统计特性

- ✅ 无需注册，开箱即用
- ✅ 自动统计页面访问量
- ✅ 统计站点总访问量
- ✅ 数据实时更新
- ✅ 隐私友好（不收集个人信息）

## 四、常见问题

### Q: 评论框不显示？
A: 检查以下几点：
1. 是否在 GitHub 仓库中启用了 Discussions
2. `_config.yml` 中的 `comments.provider` 是否设置为 `giscus`
3. Giscus 配置信息是否完整（repo_id、category_id 等）
4. 文章 front matter 中 `comments: true`（默认已启用）

### Q: 浏览量不显示？
A: 检查以下几点：
1. `_config.yml` 中的 `pageviews.provider` 是否设置为 `busuanzi`
2. 等待几分钟让统计数据加载
3. 检查浏览器控制台是否有 JavaScript 错误

### Q: 如何禁用某篇文章的评论？
A: 在文章的 front matter 中添加：
```yaml
---
comments: false
---
```

## 五、其他评论系统选项

如果不想使用 Giscus，Chirpy 主题还支持：

1. **Utterances**（基于 GitHub Issues）
   - 配置简单，但功能较少
   - 适合不想启用 Discussions 的用户

2. **Disqus**（第三方服务）
   - 功能丰富，但需要注册
   - 可能有广告

详细配置方法请参考 [Chirpy 主题文档](https://github.com/cotes2020/jekyll-theme-chirpy/wiki)。
