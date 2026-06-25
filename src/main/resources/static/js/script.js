/* ============================================
   APEX PC — JavaScript
   Features: Loader, cursor, navbar scroll,
   cart, stats counter, testimonial slider,
   newsletter toast, product wishlist
============================================ */

// =========================================
// LOADER
// =========================================
document.addEventListener('DOMContentLoaded', () => {
  const searchInput = document.getElementById('search-input');
  if (searchInput) {
    searchInput.value = '';
    // also hide clear button if present
    const searchClearBtn = document.getElementById('search-clear');
    if (searchClearBtn) searchClearBtn.classList.remove('visible');
  }
  
  setTimeout(() => {
    const loader = document.getElementById('loader');
    if (loader) loader.classList.add('hidden');
    const hero = document.querySelector('.hero');
    if (hero) hero.classList.add('loaded');
  }, 500); // reduced timeout for better UX
});


// =========================================
// NAVBAR SCROLL
// =========================================
const navbar = document.getElementById('navbar');
if (navbar) {
  window.addEventListener('scroll', () => {
    if (window.scrollY > 80) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  });
}

// =========================================
// CART STATE
// =========================================
let cart = {};

function updateCartUI() {
  const cartCount = document.getElementById('cart-count');
  const cartItemsEl = document.getElementById('cart-items');
  const cartTotalEl = document.getElementById('cart-total');

  const totalItems = Object.keys(cart).length;
  const totalPrice = Object.values(cart).reduce((s, i) => s + i.price * i.qty, 0);

  if (cartCount) {
    cartCount.textContent = totalItems;
  }

  if (cartItemsEl) {
    if (totalItems === 0) {
      cartItemsEl.innerHTML = '<p class="cart-empty">Giỏ hàng của bạn đang trống.</p>';
    } else {
      cartItemsEl.innerHTML = Object.entries(cart).map(([id, item]) => `
        <div class="cart-item">
          <div class="cart-item-name">${item.name}</div>
          <div class="cart-item-qty">
            <button data-action="dec" data-id="${id}" aria-label="Giảm">−</button>
            <span class="cart-item-count">${item.qty}</span>
            <button data-action="inc" data-id="${id}" aria-label="Tăng">+</button>
          </div>
          <div class="cart-item-price">${formatVND(item.price * item.qty)}</div>
        </div>
      `).join('');

      // Bind qty buttons
      cartItemsEl.querySelectorAll('button[data-action]').forEach(btn => {
        btn.addEventListener('click', () => {
          const id = btn.dataset.id;
          const action = btn.dataset.action;
          if (action === 'inc') {
            let maxStock = cart[id].stock !== undefined && cart[id].stock !== null ? cart[id].stock : 5;
            if (cart[id].qty >= maxStock) {
              showToast(`quá số lượng sản phẩm hiện có (chỉ còn ${maxStock})`);
              return;
            }
            cart[id].qty++;
          } else {
            cart[id].qty--;
            if (cart[id].qty <= 0) delete cart[id];
          }
          updateCartUI();
          syncSidebarCartWithServer(id, cart[id] ? cart[id].qty : 0);
        });
      });
    }
  }

  if (cartTotalEl) {
    cartTotalEl.textContent = formatVND(totalPrice);
  }
}

function formatVND(num) {
  return (num || 0).toLocaleString('vi-VN') + '₫';
}

async function syncSidebarCartWithServer(id, quantity) {
  try {
    const formData = new FormData();
    formData.append('id', id);
    if (quantity > 0) {
      formData.append('quantity', quantity);
      await fetch('/cart/update', { method: 'POST', body: formData });
    } else {
      await fetch('/cart/remove', { method: 'POST', body: formData });
    }
  } catch (err) {
    console.error('Lỗi đồng bộ server:', err);
  }
}

async function loadCartFromServer() {
  try {
    const response = await fetch('/api/cart');
    const serverCart = await response.json();
    cart = {}; // Reset local cart
    for (const [id, item] of Object.entries(serverCart)) {
      cart[id] = {
        name: item.name,
        price: item.price,
        qty: item.quantity,
        stock: item.stock
      };
    }
    updateCartUI();
  } catch (err) {
    console.error('Lỗi khi tải giỏ hàng từ server:', err);
  }
}

async function addToCart(id, name, price) {
  try {
    // Gọi server để đồng bộ
    await fetch(`/cart/add?id=${id}&name=${encodeURIComponent(name)}&price=${price}&quantity=1`, {
      method: 'POST'
    });
    
    // Sau đó tải lại trạng thái mới nhất từ server
    await loadCartFromServer();
    
    showToast(`✓ Đã thêm "${name}" vào giỏ hàng`);
    openCart();
  } catch (err) {
    console.error('Lỗi khi thêm vào giỏ hàng:', err);
    showToast('❌ Lỗi khi thêm sản phẩm');
  }
}

// Gọi tải giỏ hàng khi load trang
document.addEventListener('DOMContentLoaded', loadCartFromServer);

// =========================================
// CART DRAWER
// =========================================
const cartDrawer = document.getElementById('cart-drawer');
const cartOverlay = document.getElementById('cart-overlay');

function openCart() {
  if (cartDrawer) cartDrawer.classList.add('open');
  if (cartOverlay) cartOverlay.classList.add('visible');
  document.body.style.overflow = 'hidden';
}
function closeCart() {
  if (cartDrawer) cartDrawer.classList.remove('open');
  if (cartOverlay) cartOverlay.classList.remove('visible');
  document.body.style.overflow = '';
}

const navCartBtn = document.getElementById('nav-cart');
const cartCloseBtn = document.getElementById('cart-close');
const btnCheckout = document.getElementById('btn-checkout');
if (navCartBtn) navCartBtn.addEventListener('click', (e) => {
  e.preventDefault();
  openCart();
});
if (cartCloseBtn) cartCloseBtn.addEventListener('click', closeCart);
if (cartOverlay) cartOverlay.addEventListener('click', closeCart);
if (btnCheckout) btnCheckout.addEventListener('click', () => {
  if (Object.keys(cart).length === 0) {
    showToast('Giỏ hàng trống. Hãy thêm sản phẩm trước!');
    return;
  }
  window.location.href = '/checkout';
});

// Add-to-cart buttons
document.querySelectorAll('.btn-add-cart').forEach(btn => {
  btn.addEventListener('click', () => {
    const id = btn.dataset.id;
    const name = btn.dataset.name;
    const price = parseInt(btn.dataset.price);
    addToCart(id, name, price);
  });
});

// =========================================
// TOAST
// =========================================
let toastTimeout;
function showToast(msg) {
  const toast = document.getElementById('toast');
  if (toast) {
    toast.textContent = msg;
    toast.classList.add('show');
    clearTimeout(toastTimeout);
    toastTimeout = setTimeout(() => {
      toast.classList.remove('show');
    }, 3000);
  }
}

// =========================================
// WISHLIST
// =========================================
document.querySelectorAll('.product-wishlist').forEach(btn => {
  btn.addEventListener('click', function () {
    const isWished = this.dataset.wished === '1';
    if (isWished) {
      this.textContent = '♡';
      this.dataset.wished = '0';
      this.style.color = '';
    } else {
      this.textContent = '♥';
      this.dataset.wished = '1';
      this.style.color = '#c9a84c';
      showToast('♥ Đã thêm vào danh sách yêu thích');
    }
  });
});

// =========================================
// STATS COUNTER
// =========================================
function animateCounters() {
  const counters = document.querySelectorAll('.stat-num');
  counters.forEach(counter => {
    const target = parseInt(counter.dataset.target);
    const duration = 2000;
    const start = performance.now();
    function update(now) {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      // Ease out
      const eased = 1 - Math.pow(1 - progress, 3);
      const value = Math.round(eased * target);
      counter.textContent = value.toLocaleString('vi-VN');
      if (progress < 1) requestAnimationFrame(update);
      else counter.textContent = target.toLocaleString('vi-VN');
    }
    requestAnimationFrame(update);
  });
}

// Intersection Observer for stats
const statsSection = document.querySelector('.stats');
if (statsSection) {
  let statsAnimated = false;
  const statsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting && !statsAnimated) {
        statsAnimated = true;
        animateCounters();
      }
    });
  }, { threshold: 0.4 });
  statsObserver.observe(statsSection);
}

// =========================================
// TESTIMONIAL SLIDER
// =========================================
const testiCards = document.querySelectorAll('.testi-card');
const dotBtns = document.querySelectorAll('.dot-btn');
let currentTesti = 0;
let testiInterval;

function goToTesti(idx) {
  if (testiCards.length === 0) return;
  testiCards[currentTesti].classList.remove('active');
  dotBtns[currentTesti].classList.remove('active');
  currentTesti = idx;
  testiCards[currentTesti].classList.add('active');
  dotBtns[currentTesti].classList.add('active');
}

function startTestiAuto() {
  if (testiCards.length === 0) return;
  testiInterval = setInterval(() => {
    goToTesti((currentTesti + 1) % testiCards.length);
  }, 5000);
}
startTestiAuto();

dotBtns.forEach((btn, i) => {
  btn.addEventListener('click', () => {
    clearInterval(testiInterval);
    goToTesti(i);
    startTestiAuto();
  });
});

// =========================================
// NEWSLETTER FORM
// =========================================
const newsletterForm = document.getElementById('newsletter-form');
if (newsletterForm) {
  newsletterForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const email = document.getElementById('newsletter-email').value;
    if (email) {
      showToast('✓ Đăng ký thành công! Chào mừng bạn đến với LUXURY PC.');
      document.getElementById('newsletter-email').value = '';
    }
  });
}

// =========================================
// SCROLL REVEAL ANIMATIONS
// =========================================
const revealTargets = document.querySelectorAll(
  '.product-card, .cat-card, .build-feat, .stat-item, .testi-slider'
);

const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry, i) => {
    if (entry.isIntersecting) {
      setTimeout(() => {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
      }, i * 80);
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

revealTargets.forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(30px)';
  el.style.transition = 'opacity 0.7s ease, transform 0.7s ease';
  revealObserver.observe(el);
});

// =========================================
// CATEGORY FILTER (simple highlight)
// =========================================
document.querySelectorAll('.cat-card').forEach(card => {
  card.addEventListener('click', () => {
    const cat = card.dataset.cat;
    showToast(`Đang xem danh mục: ${card.querySelector('.cat-name').textContent}`);
    // Scroll to products
    document.getElementById('products').scrollIntoView({ behavior: 'smooth' });
  });
});

// =========================================
// HERO PARALLAX
// =========================================
window.addEventListener('scroll', () => {
  const heroImg = document.getElementById('hero-img');
  if (heroImg && window.scrollY < window.innerHeight) {
    heroImg.style.transform = `scale(1.05) translateY(${window.scrollY * 0.15}px)`;
  }
});

// =========================================
// BUILD PC BUTTON
// =========================================
// Handled naturally via href links in the HTML


// =========================================
// FLASH SALE COUNTDOWN (from database or fallback 6h)
// =========================================
(function initCountdown() {
  // Use backend-provided endTime, fallback to 6 hours from now
  const endTime = (window.flashSaleEndTime && window.flashSaleEndTime > 0)
      ? window.flashSaleEndTime
      : Date.now() + 6 * 60 * 60 * 1000;

  function pad(n) { return String(n).padStart(2, '0'); }

  function updateCountdown() {
    const now = Date.now();
    const remaining = Math.max(0, endTime - now);

    const totalSec = Math.floor(remaining / 1000);
    const hours = Math.floor(totalSec / 3600);
    const minutes = Math.floor((totalSec % 3600) / 60);
    const seconds = totalSec % 60;

    const hEl = document.getElementById('fs-hours');
    const mEl = document.getElementById('fs-minutes');
    const sEl = document.getElementById('fs-seconds');

    if (hEl) hEl.textContent = pad(hours);
    if (mEl) mEl.textContent = pad(minutes);
    if (sEl) sEl.textContent = pad(seconds);

    if (remaining <= 0) {
      clearInterval(countdownInterval);
    }
  }

  updateCountdown();
  const countdownInterval = setInterval(updateCountdown, 1000);
})();

// =========================================
// VOUCHER MODAL (dynamic from data attributes)
// =========================================
const modalOverlay = document.getElementById('voucher-modal-overlay');
const modalClose = document.getElementById('voucher-modal-close');
const copyBtn = document.getElementById('vmodal-copy-btn');

function openVoucherModal(cardEl) {
  const code = cardEl.dataset.voucher || '';
  const desc = cardEl.dataset.desc || '';
  const apply = cardEl.dataset.apply || 'Tất cả sản phẩm';
  const expire = cardEl.dataset.expire || 'Không giới hạn';
  const limit = cardEl.dataset.limit || 'Không giới hạn';
  const pctEl = cardEl.querySelector('.voucher-pct');
  const typeEl = cardEl.querySelector('.voucher-type');

  document.getElementById('vmodal-badge').textContent = typeEl ? typeEl.textContent : 'Giảm Giá';
  document.getElementById('vmodal-pct').textContent = pctEl ? pctEl.textContent : '';
  document.getElementById('vmodal-code').textContent = code;
  document.getElementById('vmodal-desc').textContent = desc;
  document.getElementById('vmodal-apply').textContent = apply;
  document.getElementById('vmodal-expire').textContent = expire;
  document.getElementById('vmodal-limit').textContent = limit;
  if (copyBtn) copyBtn.dataset.code = code;

  modalOverlay.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeVoucherModal() {
  modalOverlay.classList.remove('open');
  document.body.style.overflow = '';
}

// Open modal on voucher card click
document.querySelectorAll('.voucher-card').forEach(card => {
  card.addEventListener('click', () => {
    openVoucherModal(card);
  });
});

// Close modal
if (modalClose) modalClose.addEventListener('click', closeVoucherModal);
if (modalOverlay) modalOverlay.addEventListener('click', (e) => {
  if (e.target === modalOverlay) closeVoucherModal();
});

// Copy code button
if (copyBtn) copyBtn.addEventListener('click', () => {
  const code = copyBtn.dataset.code || '';
  if (navigator.clipboard) {
    navigator.clipboard.writeText(code).then(() => {
      showToast(`✓ Đã sao chép mã: ${code}`);
    });
  } else {
    showToast(`✓ Mã voucher: ${code}`);
  }
});

// =========================================
// PRODUCT CATALOG DATA (for search)
// =========================================
let productCatalog = [];

async function loadProductCatalog() {
  try {
    const response = await fetch('/api/products');
    productCatalog = await response.json();
  } catch (error) {
    console.error('Lỗi khi tải dữ liệu sản phẩm:', error);
  }
}

// Khởi chạy việc lấy dữ liệu khi trang HTML vừa tải xong
document.addEventListener('DOMContentLoaded', loadProductCatalog);

// =========================================
// SEARCH OVERLAY
// =========================================
const searchOverlay = document.getElementById('search-overlay');
const navSearchBtn = document.getElementById('nav-search-btn');
const searchCloseBtn = document.getElementById('search-close');
const searchInput = document.getElementById('search-input');
const searchClearBtn = document.getElementById('search-clear');
const searchResults = document.getElementById('search-results');

function openSearch() {
  searchOverlay.classList.add('open');
  document.body.style.overflow = 'hidden';
  setTimeout(() => searchInput.focus(), 350);
}
function closeSearch() {
  searchOverlay.classList.remove('open');
  document.body.style.overflow = '';
  searchInput.value = '';
  searchClearBtn.classList.remove('visible');
  searchResults.innerHTML = '<p class="search-hint">Nhập từ khóa để tìm kiếm sản phẩm LUXURY PC.</p>';
}

navSearchBtn.addEventListener('click', openSearch);
searchCloseBtn.addEventListener('click', closeSearch);
searchOverlay.addEventListener('click', (e) => {
  if (e.target === searchOverlay) closeSearch();
});
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && searchOverlay.classList.contains('open')) closeSearch();
});

// Live search input
searchInput.addEventListener('input', () => {
  const q = searchInput.value.trim().toLowerCase();
  if (q.length > 0) {
    searchClearBtn.classList.add('visible');
  } else {
    searchClearBtn.classList.remove('visible');
  }
  renderSearchResults(q);
});

searchClearBtn.addEventListener('click', () => {
  searchInput.value = '';
  searchClearBtn.classList.remove('visible');
  searchResults.innerHTML = '<p class="search-hint">Nhập từ khóa để tìm kiếm sản phẩm LUXURY PC.</p>';
  searchInput.focus();
});

// Quick tag click
document.querySelectorAll('.search-tag').forEach(tag => {
  tag.addEventListener('click', () => {
    const q = tag.dataset.query.toLowerCase();
    searchInput.value = tag.dataset.query;
    searchClearBtn.classList.add('visible');
    renderSearchResults(q);
    searchInput.focus();
  });
});

function renderSearchResults(query) {
  if (!query) {
    searchResults.innerHTML = '<p class="search-hint">Nhập từ khóa để tìm kiếm sản phẩm LUXURY PC.</p>';
    return;
  }
  const matches = productCatalog.filter(p =>
    p.name.toLowerCase().includes(query) ||
    p.cat.toLowerCase().includes(query)
  );

  if (matches.length === 0) {
    searchResults.innerHTML = `<p class="search-no-result">Không tìm thấy sản phẩm phù hợp với "<em>${query}</em>"</p>`;
    return;
  }

  searchResults.innerHTML = `
    <div class="search-result-grid">
      ${matches.map(p => `
        <div class="search-result-item" style="cursor:pointer;" onclick="window.location.href='${p.productUrl || '/products'}'">
          <div class="sri-icon" style="padding: 0; display: flex; align-items: center; justify-content: center; overflow: hidden; border-radius: 4px; border: 1px solid rgba(201,168,76,0.2);">
            <img src="${p.image}" alt="${p.name}" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.src='/images/placeholder.png';">
          </div>
          <div class="sri-info">
            <div class="sri-name">${p.name}</div>
            <div class="sri-cat">${p.cat}</div>
          </div>
          <div class="sri-price">${p.price}</div>
        </div>
      `).join('')}
    </div>
  `;
}

// =========================================
// FILTER & SORT BAR
// =========================================
const filterChips = document.querySelectorAll('.filter-chip');
const sortSelect = document.getElementById('sort-select');
const resultCount = document.getElementById('result-count');
const productsGrid = document.getElementById('products-grid');

let activeCategory = 'all';
let activeSort = 'default';

function applyFilterAndSort() {
  const cards = Array.from(productsGrid.querySelectorAll('.product-card'));

  // Step 1: Filter by category
  let filtered = cards.filter(card => {
    if (activeCategory === 'all') return true;
    return card.dataset.cat === activeCategory;
  });
  const hidden = cards.filter(c => !filtered.includes(c));

  // Hide non-matching
  hidden.forEach(c => {
    c.classList.add('hidden-by-filter');
    c.classList.remove('filter-fade-in');
  });

  // Step 2: Sort visible cards
  filtered.sort((a, b) => {
    const priceA = parseInt(a.dataset.price) || 0;
    const priceB = parseInt(b.dataset.price) || 0;
    const popA = parseInt(a.dataset.popularity) || 0;
    const popB = parseInt(b.dataset.popularity) || 0;
    if (activeSort === 'price-asc') return priceA - priceB;
    if (activeSort === 'price-desc') return priceB - priceA;
    if (activeSort === 'popular') return popB - popA;
    if (activeSort === 'newest') return Math.random() - 0.5; // UI demo only
    return 0; // default — leave original order
  });

  // Re-append in sorted order with animation
  filtered.forEach((card, i) => {
    card.classList.remove('hidden-by-filter');
    card.classList.remove('filter-fade-in');
    // Force reflow
    void card.offsetWidth;
    card.classList.add('filter-fade-in');
    card.style.animationDelay = `${i * 60}ms`;
    productsGrid.appendChild(card);
  });

  // Update count
  if (resultCount) resultCount.textContent = filtered.length;
  
  if (filtered.length === 0) {
    if(typeof showToast === 'function') showToast('Không tìm thấy sản phẩm phù hợp với bộ lọc!');
  }
}

// Category chip click
filterChips.forEach(chip => {
  chip.addEventListener('click', () => {
    filterChips.forEach(c => c.classList.remove('active'));
    chip.classList.add('active');
    activeCategory = chip.dataset.cat;
    applyFilterAndSort();
  });
});

// Sort select change
if (sortSelect) {
  sortSelect.addEventListener('change', () => {
    activeSort = sortSelect.value;
    applyFilterAndSort();
  });
}

// LOGIN
async function login() {

  const email = document.getElementById("login-email").value;
  const password = document.getElementById("login-pw").value;

  const data = {
    email: email,
    password: password
  };

  try {
    const response = await fetch("/api/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    });

    const result = await response.json();

    if (result != null) {
      alert("Đăng nhập thành công!");
      window.location.href = "/";
    } else {
      alert("Sai email hoặc mật khẩu!");
    }

  } catch (error) {
    console.error(error);
    alert("Lỗi kết nối server");
  }
}

// REGISTER
async function register() {

  const firstname = document.getElementById("reg-fname").value;
  const lastname = document.getElementById("reg-lname").value;
  const email = document.getElementById("reg-email").value;
  const phone = document.getElementById("reg-phone").value;
  const password = document.getElementById("reg-pw").value;

  const data = {
    firstName: firstname,
    lastName: lastname,
    email: email,
    phone: phone,
    password: password
  };

  try {

    const response = await fetch("/api/register", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    });

    const result = await response.json();

    if (result) {
      alert("Đăng ký thành công!");
    } else {
      alert("Đăng ký thất bại!");
    }

  } catch (error) {
    console.error(error);
    alert("Lỗi server");
  }
}

// =========================================
// SCROLL FADE IN & WISHLIST
// =========================================
const fadeObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('fade-in-up-visible');
      fadeObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.1, rootMargin: "0px 0px -50px 0px" });

document.querySelectorAll('.product-card').forEach(card => {
  card.classList.add('fade-in-up-hidden');
  fadeObserver.observe(card);
});

window.addToWishlist = function(btn, id) {
  event.preventDefault();
  event.stopPropagation();
  btn.style.color = 'var(--gold)';
  btn.innerHTML = '♥';
  if(typeof showToast === 'function') showToast('Đã thêm sản phẩm vào danh sách yêu thích!');
};

// =========================================
// LANGUAGE TOGGLE & DYNAMIC TRANSLATIONS
// =========================================
let translations = {};
const reportedKeys = new Set();

window.t = function(key, defaultValue) {
    const lang = localStorage.getItem('lang') || 'vi';
    return (translations[lang] && translations[lang][key]) || defaultValue;
};

window.toggleLangMenu = function(event) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    const menu = document.getElementById('lang-dropdown-menu');
    if (menu) {
        menu.classList.toggle('show');
    }
};

window.selectLanguage = function(lang, event) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    const menu = document.getElementById('lang-dropdown-menu');
    if (menu) {
        menu.classList.remove('show');
    }
    window.setLanguage(lang);
};

window.setLanguage = function(lang) {
    localStorage.setItem('lang', lang);
    
    // Toggle active state in language selector (if exists)
    document.querySelectorAll('.lang-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.lang === lang);
    });

    const langText = document.getElementById('current-lang-text');
    if (langText) {
        langText.textContent = lang.toUpperCase();
    }

    document.querySelectorAll('[data-translate]').forEach(el => {
        const key = el.getAttribute('data-translate');
        if (translations[lang] && translations[lang][key]) {
            const val = translations[lang][key];
            if (el.children.length === 0) {
                el.textContent = val;
            } else {
                let textNode = Array.from(el.childNodes).find(node => node.nodeType === Node.TEXT_NODE);
                if (textNode) {
                    textNode.nodeValue = val;
                }
            }
        } else {
            window.reportMissingKey(key, el.textContent.trim());
        }
    });

    document.querySelectorAll('[data-translate-placeholder]').forEach(el => {
        const key = el.getAttribute('data-translate-placeholder');
        if (translations[lang] && translations[lang][key]) {
            el.setAttribute('placeholder', translations[lang][key]);
        }
    });

    // Invoke page-specific hooks (e.g. rebuild pc slots or checkout calculation)
    if (typeof window.onLanguageChange === 'function') {
        window.onLanguageChange(lang);
    }
};

window.reportMissingKey = function(key, defaultValue) {
    if (!key || !defaultValue || reportedKeys.has(key)) return;
    reportedKeys.add(key);

    fetch('/api/translations/missing', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ key: key, defaultValue: defaultValue })
    }).catch(err => console.warn("Lỗi gửi báo cáo dịch tự động:", err));
};

window.loadTranslations = async function() {
    const savedLang = localStorage.getItem('lang') || 'vi';
    const cachedData = localStorage.getItem('translations_cache');
    if (cachedData) {
        try {
            translations = JSON.parse(cachedData);
            window.setLanguage(savedLang);
        } catch (e) {
            console.error("Lỗi đọc cache dịch:", e);
        }
    }

    try {
        const response = await fetch('/api/translations');
        const newData = await response.json();
        localStorage.setItem('translations_cache', JSON.stringify(newData));
        translations = newData;
        window.setLanguage(savedLang);
    } catch (error) {
        console.error("Lỗi khi tải bộ từ điển dịch thuật từ server:", error);
    }
};

window.startTranslationObserver = function() {
    const observer = new MutationObserver((mutations) => {
        let hasNewTranslateElement = false;
        mutations.forEach(mutation => {
            mutation.addedNodes.forEach(node => {
                if (node.nodeType === Node.ELEMENT_NODE) {
                    if (node.hasAttribute('data-translate') || node.querySelector('[data-translate]')) {
                        hasNewTranslateElement = true;
                    }
                }
            });
        });
        if (hasNewTranslateElement) {
            const savedLang = localStorage.getItem('lang') || 'vi';
            window.setLanguage(savedLang);
        }
    });
    observer.observe(document.body, { childList: true, subtree: true });
};

// Close dropdown when clicking outside
document.addEventListener('click', (event) => {
  const menu = document.getElementById('lang-dropdown-menu');
  const wrapper = document.getElementById('lang-dropdown-wrapper');
  if (menu && menu.classList.contains('show')) {
    if (wrapper && !wrapper.contains(event.target)) {
      menu.classList.remove('show');
    }
  }
});

document.addEventListener("DOMContentLoaded", function() {
    window.loadTranslations();
    window.startTranslationObserver();

    // Auto-suggest search
    const searchInput = document.getElementById("search-input");
    if (searchInput) {
        const searchForm = searchInput.closest("form");
        if (searchForm) {
            searchForm.style.position = "relative";
            const resultsBox = document.createElement("div");
            resultsBox.className = "search-results-box";
            searchForm.appendChild(resultsBox);
            let searchTimeout;
            searchInput.addEventListener("input", function() {
                const q = this.value.trim();
                clearTimeout(searchTimeout);
                if (q.length < 2) {
                    resultsBox.classList.remove("show");
                    return;
                }
                searchTimeout = setTimeout(() => {
                    fetch("/api/products/search?q=" + encodeURIComponent(q))
                        .then(res => res.json())
                        .then(data => {
                            resultsBox.innerHTML = "";
                            if (data.length > 0) {
                                data.forEach(item => {
                                    const a = document.createElement("a");
                                    a.href = item.productUrl;
                                    a.className = "search-item";
                                    a.innerHTML = `
                                        <img src="${item.image}" alt="">
                                        <div class="search-item-info">
                                            <div class="search-item-title">${item.name}</div>
                                            <div class="search-item-price">${item.price}</div>
                                        </div>
                                    `;
                                    resultsBox.appendChild(a);
                                });
                                resultsBox.classList.add("show");
                            } else {
                                resultsBox.innerHTML = `<div style="padding: 10px; color: #888; text-align: center;">Kh�ng t�m th?y s?n ph?m</div>`;
                                resultsBox.classList.add("show");
                            }
                        })
                        .catch(err => console.error(err));
                }, 300);
            });
            document.addEventListener("click", function(e) {
                if (!searchForm.contains(e.target)) {
                    resultsBox.classList.remove("show");
                }
            });
            searchInput.addEventListener("focus", function() {
                if (this.value.trim().length >= 2) {
                    resultsBox.classList.add("show");
                }
            });
        }
    }
});







