# 快速开始指南

## 🚀 5分钟完成配置

### 第一步：启用评论系统（Giscus）

1. **启用 GitHub Discussions**
   - 访问：https://github.com/kevinchen202008-cmyk/kevinchen202008-cmyk.github.io/settings
   - 滚动到 **Features** 部分
   - 勾选 **Discussions** 复选框
   - 点击 **Save changes**

2. **获取 Giscus 配置**
   - 访问：https://giscus.app/zh-CN
   - 填写以下信息：
     - Repository: `kevinchen202008-cmyk/kevinchen202008-cmyk.github.io`
     - 其他选项保持默认即可
   - 点击 **Generate script**
   - 复制页面显示的配置信息

3. **更新配置文件**
   - 打开 `_config.yml` 文件
   - 找到 `comments.giscus` 部分（约第 131 行）
   - 填入从 Giscus 获取的参数：
     ```yaml
     giscus:
       repo: kevinchen202008-cmyk/kevinchen202008-cmyk.github.io
       repo_id: # 粘贴从 giscus.app 获取的 repo_id
       category: # 粘贴从 giscus.app 获取的 category
       category_id: # 粘贴从 giscus.app 获取的 category_id
       mapping: pathname
       strict: "0"
       input_position: bottom
       lang: zh-CN
       reactions_enabled: "1"
     ```

4. **提交并推送**
   ```bash
   git add _config.yml
   git commit -m "配置 Giscus 评论系统"
   git push
   ```

5. **等待部署**
   - GitHub Pages 会自动构建（约 1-2 分钟）
   - 访问任意文章页面，底部应显示评论框

### 第二步：验证浏览量统计

✅ **已完成！** 浏览量统计已自动配置，无需额外操作。

- 统计脚本会自动加载
- 访问文章页面后，浏览量会自动统计
- 数据会在几分钟内显示

### 验证功能

1. **评论功能**
   - 访问任意文章页面
   - 滚动到页面底部
   - 应该能看到 Giscus 评论框
   - 使用 GitHub 账号登录后可以发表评论

2. **浏览量统计**
   - 刷新页面几次
   - 等待几分钟
   - 浏览量数字应该会更新

## ❓ 遇到问题？

### 评论框不显示？

1. 检查 GitHub Discussions 是否已启用
2. 检查 `_config.yml` 中的 `comments.provider` 是否为 `giscus`
3. 检查 Giscus 配置参数是否完整
4. 查看浏览器控制台是否有错误信息

### 浏览量不显示？

1. 检查 `_config.yml` 中的 `pageviews.provider` 是否为 `busuanzi`
2. 等待几分钟让统计数据加载
3. 检查浏览器控制台是否有 JavaScript 错误

### 需要帮助？

- 查看详细配置文档：`COMMENTS_AND_VIEWS_SETUP.md`
- 查看实现总结：`IMPLEMENTATION_SUMMARY.md`
- 访问 [Giscus 官方文档](https://giscus.app/zh-CN)

## 📝 下一步

- [ ] 完成 Giscus 配置
- [ ] 测试评论功能
- [ ] 测试回复功能
- [ ] 验证浏览量统计
- [ ] 自定义评论样式（可选）
