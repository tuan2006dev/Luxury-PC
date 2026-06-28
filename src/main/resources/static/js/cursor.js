(function () {
  // 1. Detect if touch device. If so, do not initialize custom cursor.
  const hasMouse = window.matchMedia("(pointer: fine)").matches;
  if (!hasMouse) return;

  // 2. Dynamically load CSS stylesheet relative to the script path
  const scriptUrl = document.currentScript ? document.currentScript.src : '';
  // Build base URL: from script src if available, otherwise use window.location.origin as fallback
  const baseUrl = scriptUrl
    ? scriptUrl.substring(0, scriptUrl.lastIndexOf('/js/'))
    : window.location.origin;
  const cssUrl = baseUrl + '/css/cursor.css';
  
  // Check if stylesheet is already loaded
  if (!document.querySelector(`link[href^="${cssUrl}"]`) && !document.querySelector('link[href*="cursor.css"]')) {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = cssUrl + '?v=3'; // Cache buster
    document.head.appendChild(link);
  }


  function initCursor() {
    let cursor = document.getElementById('cursor');
    let follower = document.getElementById('cursor-follower') || document.getElementById('cursor-f');

    // Dynamically inject cursor DOM if they do not exist
    if (!cursor) {
      cursor = document.createElement('div');
      cursor.id = 'cursor';
      cursor.className = 'cursor';
      document.body.appendChild(cursor);
    }
    if (!follower) {
      follower = document.createElement('div');
      follower.id = 'cursor-follower';
      follower.className = 'cursor-follower';
      document.body.appendChild(follower);
    }

    // Add classes for styling
    cursor.classList.add('cursor');
    // Ensure both IDs are supported by styling follower consistently
    follower.className = 'cursor-follower';

    // Add classes to hide default cursor
    document.body.classList.add('custom-cursor-enabled');

    let mouseX = 0, mouseY = 0;
    let followerX = 0, followerY = 0;
    let targetX = 0, targetY = 0;

    // 3. Easing & Rendering loop using requestAnimationFrame + translate3d
    function loop() {
      // Follower easing interpolation
      followerX += (targetX - followerX) * 0.12;
      followerY += (targetY - followerY) * 0.12;

      // Apply hardware accelerated translation
      cursor.style.transform = `translate3d(${mouseX}px, ${mouseY}px, 0) translate(-50%, -50%)`;
      follower.style.transform = `translate3d(${followerX}px, ${followerY}px, 0) translate(-50%, -50%)`;
      
      requestAnimationFrame(loop);
    }
    requestAnimationFrame(loop);

    // Track mouse movement
    document.addEventListener('mousemove', (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
      targetX = mouseX;
      targetY = mouseY;
    });

    document.addEventListener('mouseenter', (e) => {
      if (e.clientX !== undefined) {
        mouseX = e.clientX;
        mouseY = e.clientY;
        targetX = mouseX;
        targetY = mouseY;
        followerX = mouseX;
        followerY = mouseY;
      }
    });

    // Handle hovering states using mouseover event delegation
    document.addEventListener('mouseover', (e) => {
      const target = e.target.closest('a, button, input, select, textarea, [role="button"], .cat-card, .product-card, .btn-add-cart, .nav-cart, .reply-btn, .icon-btn, .clickable, .flash-product-card, .voucher-card, .vmodal-copy-btn, .voucher-modal-close, .nav-search-btn, .search-close, .search-tag, .search-result-item, .filter-chip, .sort-select, .profile-tab, .sb-item, .wl-card, .part-item, .btn-action, .nav-tab, .btn-primary, .btn-secondary, .method-card, .thumb, .add-to-cart-btn, .faq-question, .chat-send, .chat-close, .picker-item, .slot-header, .preset-card, .chat-chip, .builder-tab, .control-btn, .pay-card, .cstep, .rel-card');
      if (target) {
        cursor.classList.add('hover');
        follower.classList.add('hover');
      } else {
        cursor.classList.remove('hover');
        follower.classList.remove('hover');
      }
    });
  }

  // Ensure DOM is ready before injecting nodes
  if (document.readyState !== 'loading') {
    initCursor();
  } else {
    document.addEventListener('DOMContentLoaded', initCursor);
  }
})();
