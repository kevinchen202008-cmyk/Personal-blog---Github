/**
 * 不蒜子统计脚本
 * 用于显示页面浏览量和站点访问量
 * 需要在页面中引入此脚本，并在需要显示的地方添加对应的HTML元素
 */

(function() {
  // 等待DOM加载完成
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initBusuanzi);
  } else {
    initBusuanzi();
  }

  function initBusuanzi() {
    // 检查是否启用了不蒜子统计
    const pageviewsProvider = '{{ site.pageviews.provider }}';
    if (pageviewsProvider !== 'busuanzi') {
      return;
    }

    // 加载不蒜子脚本
    const script = document.createElement('script');
    script.async = true;
    script.src = '//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js';
    document.head.appendChild(script);

    // 显示浏览量容器（如果存在）
    const pagePvContainer = document.getElementById('busuanzi_container_page_pv');
    const sitePvContainer = document.getElementById('busuanzi_container_site_pv');
    
    if (pagePvContainer) {
      pagePvContainer.style.display = 'inline';
    }
    if (sitePvContainer) {
      sitePvContainer.style.display = 'inline';
    }
  }
})();
