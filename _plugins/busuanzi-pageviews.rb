# frozen_string_literal: true

# Jekyll 插件：不蒜子浏览量统计
# 自动在页面中注入不蒜子统计代码
# 当 pageviews.provider 设置为 'busuanzi' 时自动启用

Jekyll::Hooks.register :site, :post_render do |site|
  # 检查是否启用不蒜子统计
  next unless site.config.dig('pageviews', 'provider') == 'busuanzi'
  
  # 不蒜子统计脚本
  busuanzi_script = <<~HTML
    <!-- 不蒜子浏览量统计 -->
    <script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
  HTML
  
  # 处理所有页面
  site.pages.each do |page|
    next unless page.output_ext == '.html'
    page.output = page.output.gsub('</head>', "#{busuanzi_script}\n</head>") if page.output
  end
  
  # 处理所有文章
  site.posts.docs.each do |post|
    next unless post.output_ext == '.html'
    post.output = post.output.gsub('</head>', "#{busuanzi_script}\n</head>") if post.output
  end
end
