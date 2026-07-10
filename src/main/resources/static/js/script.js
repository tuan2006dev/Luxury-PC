/* ============================================
   APEX PC — JavaScript
   Features: Loader, cursor, navbar scroll,
   cart, stats counter, testimonial slider,
   newsletter toast, product wishlist
============================================ */

// Global handler to hide broken images
window.addEventListener('error', function(e) {
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

    window.heroCarouselNav = function(direction) {
        if (heroSlides.length === 0) return;
        currentHeroSlide += direction;
        if (currentHeroSlide < 0) {
            currentHeroSlide = heroSlides.length - 1;
        } else if (currentHeroSlide >= heroSlides.length) {
            currentHeroSlide = 0;
        }
        updateHeroCarousel();
    };

    window.heroCarouselGo = function(index) {
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

