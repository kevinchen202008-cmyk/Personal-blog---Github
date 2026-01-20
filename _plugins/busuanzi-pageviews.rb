# frozen_string_literal: true

# Jekyll 插件：不蒜子浏览量统计
# - 在所有 HTML 页面中自动注入不蒜子统计脚本
# - 在文章和页面正文底部插入「本文阅读量」和「全站访问量」显示区
# 当 pageviews.provider 设置为 'busuanzi' 时自动启用

Jekyll::Hooks.register :site, :post_render do |site|
  # 检查是否启用不蒜子统计
  next unless site.config.dig('pageviews', 'provider') == 'busuanzi'
  
  # 不蒜子统计脚本（放到 <head> 里）
  busuanzi_script = <<~HTML
    <!-- 不蒜子浏览量统计 -->
    <script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
  HTML

  # 页面底部显示区域（阅读量 + 全站访问量）
  counters_html = <<~HTML
    <div class="busuanzi-counters" style="margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted, #6c757d);">
      <span id="busuanzi_container_page_pv">
        本文阅读量 <span id="busuanzi_value_page_pv"></span> 次
      </span>
      <span id="busuanzi_container_site_pv" style="margin-left: 1.5rem;">
        全站访问量 <span id="busuanzi_value_site_pv"></span> 次
      </span>
    </div>
  HTML
  
  # 处理所有页面（如首页、标签页等）
  site.pages.each do |page|
    next unless page.output_ext == '.html'

    next unless page.output

    # 注入不蒜子脚本到 </head> 前
    page.output = page.output.gsub('</head>', "#{busuanzi_script}\n</head>")

    # 在页面主体末尾追加统计信息
    if page.output.include?('</main>')
      page.output = page.output.gsub('</main>', "#{counters_html}\n</main>")
    else
      page.output << counters_html
    end
  end
  
  # 处理所有文章
  site.posts.docs.each do |post|
    next unless post.output_ext == '.html'

    next unless post.output

    # 注入不蒜子脚本到 </head> 前
    post.output = post.output.gsub('</head>', "#{busuanzi_script}\n</head>")

    # 在文章末尾追加统计信息（优先放在 </article> 前）
    if post.output.include?('</article>')
      post.output = post.output.gsub('</article>', "#{counters_html}\n</article>")
    else
      post.output << counters_html
    end
  end
end
