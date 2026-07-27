/* Promotions Page JavaScript */

// Toast notification helper
function toast(msg) {
    const el = document.getElementById('toast');
    if (!el) return;
    el.textContent = msg;
    el.style.display = 'block';
    setTimeout(() => {
        el.style.display = 'none';
    }, 5000);
}
window.toast = toast;

// Rules Modal controls
function openRulesModal() {
    const modal = document.getElementById('rules-modal');
    if (modal) modal.classList.add('active');
}
window.openRulesModal = openRulesModal;

function closeRulesModal() {
    const modal = document.getElementById('rules-modal');
    if (modal) modal.classList.remove('active');
}
window.closeRulesModal = closeRulesModal;

// Toggle upcoming sales list expansion in sidebar
let upcomingExpanded = false;
function toggleUpcomingSales() {
    upcomingExpanded = !upcomingExpanded;
    document.querySelectorAll('.upcoming-slot-hidden').forEach(el => {
        el.style.display = upcomingExpanded ? 'block' : 'none';
    });
    const btn = document.getElementById('btnToggleUpcoming');
    if (btn) {
        if (upcomingExpanded) {
            btn.innerHTML = 'Thu gọn <i class="fa-solid fa-arrow-up"></i>';
        } else {
            btn.innerHTML = 'Xem tất cả lịch Flash Sale';
        }
    }
}
window.toggleUpcomingSales = toggleUpcomingSales;

// Save Voucher API Call
function saveVoucher(btn, code) {
    if (!btn) return;
    btn.disabled = true;
    btn.innerHTML = 'Đang lưu...';

    fetch('/api/user-voucher/save', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'code=' + encodeURIComponent(code)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            btn.innerHTML = 'Đã lưu';
            btn.style.background = '#10b981';
            toast('Đã lưu mã giảm giá thành công!');
        } else {
            btn.innerHTML = 'Lưu mã';
            btn.disabled = false;
            toast(data.message || 'Lỗi khi lưu mã');
            if (data.redirect) {
                window.location.href = data.redirect;
            }
        }
    })
    .catch(err => {
        btn.innerHTML = 'Lưu mã';
        btn.disabled = false;
        toast('Lỗi kết nối. Vui lòng thử lại sau.');
    });
}
window.saveVoucher = saveVoucher;

// Central Countdown Timer Logic for Banner Slider & Active Flash Sales
function initPromoCountdown() {
    const bannerCountdowns = document.querySelectorAll('.banner-countdown');
    const mainEndTimers = document.querySelectorAll('.main-end-timer');
    if (bannerCountdowns.length === 0 && mainEndTimers.length === 0) return;

    function updatePromoCountdown() {
        const now = new Date().getTime();

        bannerCountdowns.forEach(function (box) {
            const endTimeAttr = box.getAttribute('data-endtime');
            if (!endTimeAttr) return;
            const endTime = parseInt(endTimeAttr, 10);
            const distance = endTime - now;

            if (distance < 0) {
                box.style.display = 'none';
                return;
            }

            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            let seconds = Math.floor((distance % (1000 * 60)) / 1000);

            hours = hours < 10 ? '0' + hours : hours;
            minutes = minutes < 10 ? '0' + minutes : minutes;
            seconds = seconds < 10 ? '0' + seconds : seconds;

            const dEl = box.querySelector('.promo-days-item');
            const hEl = box.querySelector('.promo-hours-item');
            const mEl = box.querySelector('.promo-minutes-item');
            const sEl = box.querySelector('.promo-seconds-item');
            const dBlock = box.querySelector('.days-block-item');

            if (dEl) dEl.innerText = days;
            if (hEl) hEl.innerText = hours;
            if (mEl) mEl.innerText = minutes;
            if (sEl) sEl.innerText = seconds;

            if (dBlock) {
                dBlock.style.display = days > 0 ? 'flex' : 'none';
            }
        });

        // Update main-end-timer elements
        document.querySelectorAll('.main-end-timer').forEach(function (timerEl) {
            const endtimeAttr = timerEl.getAttribute('data-endtime');
            if (endtimeAttr && parseInt(endtimeAttr, 10) > 0) {
                const distance = parseInt(endtimeAttr, 10) - now;
                if (distance > 0) {
                    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                    let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    let seconds = Math.floor((distance % (1000 * 60)) / 1000);

                    if (days > 0) {
                        timerEl.innerText = 'Còn ' + days + ' ngày';
                    } else {
                        hours = hours < 10 ? '0' + hours : hours;
                        minutes = minutes < 10 ? '0' + minutes : minutes;
                        seconds = seconds < 10 ? '0' + seconds : seconds;
                        const prefixText = (parseInt(hours, 10) === 0 && parseInt(minutes, 10) < 10) ? 'Sắp kết thúc ' : '';
                        timerEl.innerText = prefixText + hours + ':' + minutes + ':' + seconds;
                    }
                } else {
                    timerEl.innerText = 'Đã kết thúc';
                }
            }
        });
    }

    updatePromoCountdown();
    setInterval(updatePromoCountdown, 1000);
}

// Flash Banner Slider Logic
let currentFlashSlide = 0;
function moveFlashSlider(direction) {
    const flashSlides = document.querySelectorAll('.flash-slide');
    if (flashSlides.length === 0) return;
    currentFlashSlide += direction;
    if (currentFlashSlide >= flashSlides.length) currentFlashSlide = 0;
    if (currentFlashSlide < 0) currentFlashSlide = flashSlides.length - 1;
    const track = document.getElementById('flashSaleSliderTrack');
    if (track) track.style.transform = 'translateX(-' + (currentFlashSlide * 100) + '%)';
}
window.moveFlashSlider = moveFlashSlider;

function initBannerAutoSlide() {
    const flashSlides = document.querySelectorAll('.flash-slide');
    if (flashSlides.length > 1) {
        setInterval(function () {
            moveFlashSlider(1);
        }, 5000);
    }
}

// Upcoming Timers Logic
function initUpcomingTimers() {
    const upcomingTimers = document.querySelectorAll('.upcoming-timer');
    if (upcomingTimers.length === 0) return;

    setInterval(function () {
        upcomingTimers.forEach(function (el) {
            let secs = parseInt(el.getAttribute('data-seconds'), 10);
            if (secs > 0) {
                secs--;
                el.setAttribute('data-seconds', secs);

                const d = Math.floor(secs / 86400);
                const h = Math.floor((secs % 86400) / 3600);
                const m = Math.floor((secs % 3600) / 60);
                const s = secs % 60;

                const dStr = d < 10 ? '0' + d : '' + d;
                const hStr = h < 10 ? '0' + h : '' + h;
                const mStr = m < 10 ? '0' + m : '' + m;
                const sStr = s < 10 ? '0' + s : '' + s;

                const dEl = el.querySelector('.upcoming-days');
                const hEl = el.querySelector('.upcoming-hours');
                const mEl = el.querySelector('.upcoming-minutes');
                const sEl = el.querySelector('.upcoming-seconds');
                const dBlock = el.querySelector('.upcoming-days-block');

                if (dEl && hEl && mEl && sEl) {
                    dEl.innerText = dStr;
                    hEl.innerText = hStr;
                    mEl.innerText = mStr;
                    sEl.innerText = sStr;
                    if (dBlock) {
                        dBlock.style.display = d > 0 ? 'flex' : 'none';
                    }
                } else if (hEl && mEl && sEl) {
                    hEl.innerText = (d > 0 ? (d * 24 + h) : hStr);
                    mEl.innerText = mStr;
                    sEl.innerText = sStr;
                } else {
                    el.innerText = (d > 0 ? d + 'd ' : '') + hStr + ':' + mStr + ':' + sStr;
                }
            } else if (secs === 0) {
                const hEl = el.querySelector('.upcoming-hours');
                if (hEl) {
                    if (el.querySelector('.upcoming-days')) el.querySelector('.upcoming-days').innerText = '00';
                    el.querySelector('.upcoming-hours').innerText = '00';
                    el.querySelector('.upcoming-minutes').innerText = '00';
                    el.querySelector('.upcoming-seconds').innerText = '00';
                } else {
                    el.innerText = 'Đang diễn ra...';
                }
                el.setAttribute('data-seconds', -1);
                setTimeout(function () { window.location.reload(); }, 2000);
            }
        });
    }, 1000);
}

// Category Filter Logic
function initCategoryFilter() {
    const catItems = document.querySelectorAll('.promo-cat-item');
    const flashCards = document.querySelectorAll('.flash-card');
    const noSaleMsg = document.getElementById('no-sale-message');

    function checkEmptyState() {
        let visibleCount = 0;
        flashCards.forEach(function (card) {
            if (card.style.display !== 'none') {
                visibleCount++;
            }
        });
        if (noSaleMsg) {
            noSaleMsg.style.display = (visibleCount === 0) ? 'flex' : 'none';
        }
    }

    catItems.forEach(function (item) {
        item.addEventListener('click', function () {
            catItems.forEach(i => {
                i.classList.remove('active');
                i.style.background = '#fff';
                i.style.borderColor = '#e5e7eb';
                const h4 = i.querySelector('h4');
                if (h4) h4.style.color = '#1f2937';
            });

            this.classList.add('active');
            this.style.background = '#eff6ff';
            this.style.borderColor = '#3b82f6';
            const h4 = this.querySelector('h4');
            if (h4) h4.style.color = '#1e3a8a';

            const catName = this.querySelector('h4').innerText.trim().toUpperCase();

            flashCards.forEach(function (card) {
                const cardCat = (card.getAttribute('data-category') || '').trim().toUpperCase();
                const cardTitle = (card.querySelector('h4') ? card.querySelector('h4').innerText : '').trim().toUpperCase();

                if (catName === 'TẤT CẢ' || catName === 'FLASH SALE') {
                    card.style.display = 'flex';
                } else {
                    const isMatch = cardCat.includes(catName) ||
                        (catName === 'PC & COMBO' && (cardCat.includes('PC') || cardCat.includes('COMBO') || cardTitle.includes('PC') || cardTitle.includes('COMBO'))) ||
                        (catName === 'VỎ CASE' && (cardCat.includes('CASE') || cardCat.includes('VỎ') || cardTitle.includes('CASE') || cardTitle.includes('VỎ'))) ||
                        cardTitle.includes(catName);

                    if (isMatch) {
                        card.style.display = 'flex';
                    } else {
                        card.style.display = 'none';
                    }
                }
            });

            checkEmptyState();
        });
    });

    checkEmptyState();

    catItems.forEach(function (item) {
        const catName = item.querySelector('h4').innerText.trim().toUpperCase();
        const countSpan = item.querySelector('span');
        if (countSpan) {
            if (catName === 'TẤT CẢ' || catName === 'FLASH SALE') {
                countSpan.innerText = flashCards.length + ' Khuyến mãi';
            } else {
                let count = 0;
                flashCards.forEach(function (card) {
                    const cardCat = (card.getAttribute('data-category') || '').trim().toUpperCase();
                    const cardTitle = (card.querySelector('h4') ? card.querySelector('h4').innerText : '').trim().toUpperCase();
                    const isMatch = cardCat.includes(catName) ||
                        (catName === 'PC & COMBO' && (cardCat.includes('PC') || cardCat.includes('COMBO') || cardTitle.includes('PC') || cardTitle.includes('COMBO'))) ||
                        (catName === 'VỎ CASE' && (cardCat.includes('CASE') || cardCat.includes('VỎ') || cardTitle.includes('CASE') || cardTitle.includes('VỎ'))) ||
                        cardTitle.includes(catName);
                    if (isMatch) count++;
                });
                countSpan.innerText = count + ' Khuyến mãi';
            }
        }
    });
}

// Voucher Tabs Filtering and Counts
function initVoucherTabs() {
    const tabs = document.querySelectorAll('.voucher-tab');
    const voucherCards = document.querySelectorAll('.voucher-card');

    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            tabs.forEach(t => {
                t.classList.remove('active');
                t.style.background = 'transparent';
                t.style.color = '#4b5563';
            });

            this.classList.add('active');
            this.style.background = '#eff6ff';
            this.style.color = '#2563eb';

            const tabText = this.innerText.trim().toUpperCase();

            voucherCards.forEach(function (card) {
                const cardType = card.getAttribute('data-type') || 'GENERAL';
                if (tabText.includes('TẤT CẢ')) {
                    card.style.display = 'flex';
                } else if (tabText.includes('MÃ GIẢM GIÁ')) {
                    if (cardType === 'GENERAL') {
                        card.style.display = 'flex';
                    } else {
                        card.style.display = 'none';
                    }
                } else if (tabText.includes('DANH MỤC')) {
                    if (cardType === 'CATEGORY') {
                        card.style.display = 'flex';
                    } else {
                        card.style.display = 'none';
                    }
                }
            });
        });
    });

    let generalCount = 0;
    let categoryCount = 0;
    voucherCards.forEach(function (card) {
        const cardType = card.getAttribute('data-type') || 'GENERAL';
        if (cardType === 'GENERAL') generalCount++;
        else if (cardType === 'CATEGORY') categoryCount++;
    });

    if (tabs[0]) tabs[0].innerText = 'Tất cả (' + voucherCards.length + ')';
    if (tabs[1]) tabs[1].innerText = 'Mã giảm giá (' + generalCount + ')';
    if (tabs[2]) tabs[2].innerText = 'Ưu đãi theo danh mục (' + categoryCount + ')';
}

// Initialize on DOM Ready
function initPromotionsPage() {
    initPromoCountdown();
    initBannerAutoSlide();
    initUpcomingTimers();
    initCategoryFilter();
    initVoucherTabs();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initPromotionsPage);
} else {
    initPromotionsPage();
}
