function initPaymentStatusPolling() {
    const page = document.querySelector('[data-payment-status-url]');
    if (!page) {
        return;
    }

    const pollingIntervalMs = 4000;
    const TOTAL_TIMER_SECONDS = 5 * 60; // 5 phút (300 giây)
    const statusUrl = page.dataset.paymentStatusUrl;
    const cancelUrl = page.dataset.cancelUrl || '/api/payments/vietqr/cancel';
    const orderCode = page.dataset.orderCode;
    const paymentToken = page.dataset.paymentToken;
    const statusElement = document.getElementById('payment-status');
    const successMessage = document.getElementById('payment-success-message');
    const timerClock = document.getElementById('payment-timer-clock');
    const timerWrapper = document.getElementById('payment-timer-wrapper');
    const timerIcon = document.getElementById('payment-timer-icon');

    let intervalId = null;
    let timerIntervalId = null;
    let stopped = false;

    // Persist start timestamp per orderCode in localStorage
    const storageKey = 'vietqr_timer_start_' + orderCode;
    let startTimeStr = localStorage.getItem(storageKey);
    const now = Date.now();
    let startTime = now;

    if (!startTimeStr) {
        localStorage.setItem(storageKey, now.toString());
    } else {
        const parsed = parseInt(startTimeStr, 10);
        // Nếu mốc cũ đã quá 5 phút, khởi tạo lại từ hiện tại
        if (isNaN(parsed) || (now - parsed) >= (TOTAL_TIMER_SECONDS * 1000)) {
            localStorage.setItem(storageKey, now.toString());
            startTime = now;
        } else {
            startTime = parsed;
        }
    }

    const stopPolling = () => {
        if (stopped) return;
        stopped = true;
        if (intervalId) window.clearInterval(intervalId);
        if (timerIntervalId) window.clearInterval(timerIntervalId);
    };

    const showPollingMessage = (message, isError = true) => {
        let messageElement = document.getElementById('payment-polling-message');
        if (!messageElement) {
            messageElement = document.createElement('p');
            messageElement.id = 'payment-polling-message';
            messageElement.style.marginTop = '16px';
            messageElement.style.fontWeight = '600';
            if (successMessage) {
                successMessage.insertAdjacentElement('afterend', messageElement);
            } else if (timerWrapper) {
                timerWrapper.insertAdjacentElement('afterend', messageElement);
            }
        }
        messageElement.style.color = isError ? '#dc2626' : '#b45309';
        messageElement.textContent = message;
        messageElement.hidden = false;
    };

    const handleTimeoutCancel = async () => {
        // Kiểm tra lần cuối xem đơn hàng đã được thanh toán chưa trước khi thực hiện hủy
        try {
            const finalCheck = await fetch(statusUrl + '?orderCode=' + encodeURIComponent(orderCode), {
                headers: { 'X-Payment-Token': paymentToken },
                cache: 'no-store'
            });
            if (finalCheck.ok) {
                const finalResult = await finalCheck.json();
                if (finalResult.paid) {
                    stopPolling();
                    localStorage.removeItem(storageKey);
                    if (statusElement) {
                        statusElement.textContent = finalResult.paymentStatus || 'Đã thanh toán';
                        statusElement.style.color = '#22c55e';
                    }
                    if (successMessage) successMessage.hidden = false;
                    if (timerWrapper) timerWrapper.style.display = 'none';
                    return;
                }
            }
        } catch (e) {
            console.error('Lỗi kiểm tra trạng thái cuối cùng:', e);
        }

        stopPolling();
        localStorage.removeItem(storageKey);

        if (timerClock) {
            timerClock.textContent = '00:00';
            timerClock.style.color = '#dc2626';
        }
        if (timerWrapper) {
            timerWrapper.style.border = '1.5px solid #fca5a5';
            timerWrapper.style.background = '#fef2f2';
        }

        if (statusElement) {
            statusElement.textContent = 'Đã hết thời gian thanh toán (Đã hủy)';
            statusElement.style.color = '#dc2626';
        }

        showPollingMessage('❌ Đã quá thời gian thanh toán 5 phút. Đơn hàng ' + orderCode + ' đã bị tự động hủy.', true);

        // Làm mờ mã QR Code
        const qrBox = document.querySelector('.qr-image-box');
        if (qrBox) {
            qrBox.style.opacity = '0.3';
            qrBox.style.pointerEvents = 'none';
        }

        // Gọi Backend cập nhật trạng thái đơn hàng thành DA_HUY
        try {
            await fetch(cancelUrl + '?orderCode=' + encodeURIComponent(orderCode), {
                method: 'POST',
                headers: { 'X-Payment-Token': paymentToken },
                cache: 'no-store'
            });
        } catch (err) {
            console.error('Lỗi khi gửi yêu cầu hủy đơn:', err);
        }
    };

    // Hàm cập nhật đồng hồ đếm ngược từng giây
    const updateCountdown = () => {
        if (stopped) return;
        const currentNow = Date.now();
        const elapsedSeconds = Math.floor((currentNow - startTime) / 1000);
        const remainingSeconds = TOTAL_TIMER_SECONDS - elapsedSeconds;

        if (remainingSeconds <= 0) {
            handleTimeoutCancel();
            return;
        }

        const minutes = Math.floor(remainingSeconds / 60);
        const seconds = remainingSeconds % 60;
        const formatted = String(minutes).padStart(2, '0') + ' : ' + String(seconds).padStart(2, '0');

        if (timerClock) {
            timerClock.textContent = formatted;
            if (remainingSeconds <= 60) {
                timerClock.style.color = '#dc2626';
                if (timerIcon) timerIcon.style.color = '#dc2626';
            } else {
                timerClock.style.color = '#dc2626';
                if (timerIcon) timerIcon.style.color = '#f59e0b';
            }
        }
    };

    const poll = async () => {
        if (stopped) return;
        try {
            const response = await fetch(statusUrl + '?orderCode=' + encodeURIComponent(orderCode), {
                headers: { 'X-Payment-Token': paymentToken },
                cache: 'no-store'
            });

            if (response.status === 401 || response.status === 403 || response.status === 404) {
                stopPolling();
                showPollingMessage('Không thể kiểm tra trạng thái thanh toán. Vui lòng mở lại đơn hàng từ trang cá nhân.');
                return;
            }
            if (!response.ok) return;

            const result = await response.json();
            if (statusElement) statusElement.textContent = result.paymentStatus;

            if (result.paid) {
                stopPolling();
                localStorage.removeItem(storageKey);
                if (statusElement) statusElement.style.color = '#22c55e';
                if (successMessage) successMessage.hidden = false;
                if (timerWrapper) timerWrapper.style.display = 'none';
            }
        } catch (error) {
            console.error(error);
        }
    };

    // Chạy đếm ngược ngay và tạo interval 1s
    updateCountdown();
    timerIntervalId = window.setInterval(updateCountdown, 1000);

    // Chạy polling kiểm tra thanh toán
    intervalId = window.setInterval(poll, pollingIntervalMs);
    poll();
}

// Đảm bảo chạy ngay dù DOM đã ready hay chưa
if (document.readyState === 'complete' || document.readyState === 'interactive') {
    initPaymentStatusPolling();
} else {
    document.addEventListener('DOMContentLoaded', initPaymentStatusPolling, { once: true });
}
