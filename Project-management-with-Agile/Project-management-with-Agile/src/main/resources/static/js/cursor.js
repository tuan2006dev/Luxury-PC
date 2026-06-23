(function () {
  // 1. Detect if touch device. If so, do not initialize custom cursor.
  const hasMouse = window.matchMedia("(pointer: fine)").matches;
  if (!hasMouse) return;

  // 2. Dynamically load CSS stylesheet relative to the script path
  const scriptUrl = document.currentScript ? document.currentScript.src : '';
  if (scriptUrl) {
    const baseUrl = scriptUrl.substring(0, scriptUrl.lastIndexOf('/js/'));
    const cssUrl = baseUrl + '/css/cursor.css';
    
    // Check if stylesheet is already loaded
    if (!document.querySelector(`link[href="${cssUrl}"]`)) {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = cssUrl;
      document.head.appendChild(link);
    }
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
    let isHidden = true; // start hidden to avoid jumpy init

    // 3. Easing & Rendering loop using requestAnimationFrame + translate3d
    function loop() {
      if (!isHidden) {
        // Follower easing interpolation
        followerX += (targetX - followerX) * 0.12;
        followerY += (targetY - followerY) * 0.12;

        // Apply hardware accelerated translation
        cursor.style.transform = `translate3d(${mouseX}px, ${mouseY}px, 0) translate(-50%, -50%)`;
        follower.style.transform = `translate3d(${followerX}px, ${followerY}px, 0) translate(-50%, -50%)`;
      }
      requestAnimationFrame(loop);
    }
    requestAnimationFrame(loop);

    // Track mouse movement
    document.addEventListener('mousemove', (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
      targetX = mouseX;
      targetY = mouseY;

      if (isHidden) {
        isHidden = false;
        cursor.classList.remove('hidden');
        follower.classList.remove('hidden');
        // Instantly snap follower to mouse position on first move to prevent slow catch up from (0,0)
        followerX = mouseX;
        followerY = mouseY;
      }
    });

    // Handle mouse leaving and entering viewport boundaries
    document.addEventListener('mouseleave', () => {
      isHidden = true;
      cursor.classList.add('hidden');
      follower.classList.add('hidden');
    });

    document.addEventListener('mouseenter', () => {
      isHidden = false;
      cursor.classList.remove('hidden');
      follower.classList.remove('hidden');
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
