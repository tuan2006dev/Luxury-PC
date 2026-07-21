/* ============================================
   APEX PC — JavaScript
   Features: Loader, cursor, navbar scroll,
   cart, stats counter, testimonial slider,
   newsletter toast, product wishlist
============================================ */

// Global handler to hide broken images
window.addEventListener('error', function (e) {
    if (e.target.tagName && e.target.tagName.toLowerCase() === 'img') {
        e.target.style.display = 'none';
    }
}, true);

// Hide images that already failed to load before the script executed
// document.addEventListener('DOMContentLoaded', () => {
//     document.querySelectorAll('img').forEach(img => {
//         if (img.complete && img.naturalHeight === 0) {
//             img.style.display = 'none';
//         }
//     });
// });

window.addEventListener('load', () => {
    const loader = document.getElementById('loader');
    if (loader) {
        loader.classList.add('hidden');
        setTimeout(() => {
            loader.style.display = 'none';
        }, 500);
    }
});

// Hero Carousel Logic
document.addEventListener('DOMContentLoaded', () => {
    let currentHeroSlide = 0;
    const heroSlides = document.querySelectorAll('.hero-slide');
    const heroDots = document.querySelectorAll('.hero-dot');

    function updateHeroCarousel() {
        if (heroSlides.length === 0) return;

        // Clear track transform if it was set by previous buggy code
        const track = document.querySelector('.hero-carousel-track');
        if (track) {
            track.style.transform = '';
        }

        const total = heroSlides.length;

        heroSlides.forEach((slide, index) => {
            slide.classList.remove('active', 'prev', 'next', 'hidden');

            if (index === currentHeroSlide) {
                slide.classList.add('active');
            } else if (index === (currentHeroSlide - 1 + total) % total) {
                slide.classList.add('prev');
            } else if (index === (currentHeroSlide + 1) % total) {
                slide.classList.add('next');
            } else {
                slide.classList.add('hidden');
            }
        });

        heroDots.forEach((dot, index) => {
            if (index === currentHeroSlide) {
                dot.classList.add('active');
            } else {
                dot.classList.remove('active');
            }
        });
    }

    window.heroCarouselNav = function (direction) {
        if (heroSlides.length === 0) return;
        currentHeroSlide += direction;
        if (currentHeroSlide < 0) {
            currentHeroSlide = heroSlides.length - 1;
        } else if (currentHeroSlide >= heroSlides.length) {
            currentHeroSlide = 0;
        }
        updateHeroCarousel();
    };

    window.heroCarouselGo = function (index) {
        if (heroSlides.length === 0) return;
        if (index >= 0 && index < heroSlides.length) {
            currentHeroSlide = index;
            updateHeroCarousel();
        }
    };

    // Initialize on load
    if (heroSlides.length > 0) {
        updateHeroCarousel();
    }

    // Auto rotate hero carousel
    setInterval(() => {
        if (document.querySelector('.hero-carousel')) {
            window.heroCarouselNav(1);
        }
    }, 5000);
});



// Prevent negative numbers and scientific notation globally on number inputs
document.addEventListener('keydown', function (e) {
    if (e.target && e.target.type === 'number') {
        if (e.key === '-' || e.key === 'e' || e.key === 'E' || e.key === '+') {
            e.preventDefault();
        }
    }
});

document.addEventListener('input', function (e) {
    if (e.target && e.target.type === 'number') {
        if (e.target.value < 0) {
            e.target.value = '';
        }
    }
});

// Global Toast function
let toastTimeout;
window.showToast = function (msg, type = 'success') {
    const el = document.getElementById('toast');
    if (el) {
        // Clear any active timeout to prevent previous toast call from hiding this one prematurely
        clearTimeout(toastTimeout);
        
        // Remove classes first to reset the entry animation
        el.classList.remove('active', 'warning');
        
        // Force reflow so the browser registers the class removal before adding them back
        void el.offsetWidth;
        
        // Set new message text
        el.textContent = msg;
        
        // Apply variant class
        if (type === 'warning') {
            el.classList.add('warning');
        }
        
        el.classList.add('active');
        
        // Hide after 3.5 seconds
        toastTimeout = setTimeout(() => {
            el.classList.remove('active', 'warning');
        }, 3500);
    } else {
        alert(msg);
    }
};
window.toast = window.showToast;

// Global Wishlist function
window.addToWishlist = function (btn, productId) {
    const csrfTokenMeta = document.querySelector('meta[name="_csrf"]')?.content;
    const csrfTokenInput = document.querySelector('input[name="_csrf"]')?.value;
    const csrfToken = csrfTokenMeta || csrfTokenInput;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';

    const headers = { 'Accept': 'application/json' };
    if (csrfToken) {
        headers[csrfHeader] = csrfToken;
    }

    fetch('/api/wishlist/toggle/' + productId, {
        method: 'POST',
        headers: headers
    })
        .then(res => {
            if (res.status === 401) {
                const redirect = window.location.pathname + window.location.search;
                window.location.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
                return null;
            }
            return res.json();
        })
        .then(data => {
            if (!data) return;
            if (data.success) {
                // Update all wishlist buttons for this product across the page
                const elements = document.querySelectorAll(`[data-product-id="${productId}"]`);
                elements.forEach(el => {
                    const icon = el.querySelector('i');
                    if (icon) {
                        if (data.wished) {
                            icon.className = 'fa-solid fa-heart';
                            icon.style.color = '#ef4444'; // Red color
                            el.classList.add('active');
                        } else {
                            icon.className = 'fa-regular fa-heart';
                            icon.style.color = ''; // Reset color
                            el.classList.remove('active');
                        }
                    }
                });
                window.showToast(data.message);
            } else {
                window.showToast(data.message);
            }
        })
        .catch(err => {
            console.error('Error toggling wishlist:', err);
            window.showToast('⚠️ Lỗi kết nối máy chủ.');
        });
};

// Yellow warning toast (sản phẩm đã có trong giỏ)
window.showToastWarning = function (msg) {
    window.showToast(msg, 'warning');
};

// Set of product IDs currently in cart (populated on page load)
window.cartProductIds = new Set();

document.addEventListener('DOMContentLoaded', () => {
    fetch('/api/cart')
        .then(res => res.ok ? res.json() : null)
        .then(data => {
            if (data && typeof data === 'object') {
                const keys = Object.keys(data);
                window.cartProductIds = new Set();
                keys.forEach(id => window.cartProductIds.add(String(id)));
                const cartCountEl = document.getElementById('cart-count');
                if (cartCountEl) {
                    cartCountEl.innerText = keys.length;
                }
            }
        })
        .catch(() => {}); // silent fail — cart IDs are optional optimization
});

// Global addToCart function (AJAX → /api/cart/add returns JSON, shows toast, syncs header count)
window.addToCart = function (productId, quantity) {
    const pid = String(productId);

    // Nếu sản phẩm đã có trong giỏ → chỉ hiện cảnh báo màu vàng, không gọi API
    if (window.cartProductIds.has(pid)) {
        window.showToastWarning('⚠️ Sản phẩm này đã có trong giỏ hàng của bạn!');
        return;
    }

    const formData = new FormData();
    formData.append('id', productId);
    formData.append('quantity', quantity || 1);

    fetch('/api/cart/add', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401 || res.status === 403) {
                const redirect = window.location.pathname + window.location.search;
                window.location.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
                return null;
            }
            return res.json();
        })
        .then(data => {
            if (!data) return;
            if (data.requireLogin) {
                const redirect = window.location.pathname + window.location.search;
                window.location.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
                return;
            }
            if (data.success) {
                window.cartProductIds.add(pid); // đánh dấu đã thêm
                window.showToast('✅ ' + data.message);
                const cartCountEl = document.getElementById('cart-count');
                if (cartCountEl && data.cartCount !== undefined) {
                    cartCountEl.innerText = data.cartCount;
                }
            } else {
                window.showToast('⚠️ ' + data.message);
            }
        })
        .catch(err => {
            console.error('Lỗi thêm vào giỏ hàng:', err);
            window.showToast('⚠️ Lỗi kết nối, vui lòng thử lại.');
        });
};

// Global buyNow function (creates form dynamically to submit POST request to /cart/add which redirects to /cart)
window.buyNow = function (productId) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/cart/add';
    
    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = productId;
    form.appendChild(idInput);
    
    const qtyInput = document.createElement('input');
    qtyInput.type = 'hidden';
    qtyInput.name = 'quantity';
    qtyInput.value = 1;
    form.appendChild(qtyInput);
    
    document.body.appendChild(form);
    form.submit();
};

