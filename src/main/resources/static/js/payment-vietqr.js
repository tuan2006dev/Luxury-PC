function initPaymentStatusPolling() {
    const page = document.querySelector('[data-payment-status-url]');
    if (!page) {
        return;
    }

    const pollingIntervalMs = 5000;
    const pollingTimeoutMs = 15 * 60 * 1000;
    const statusUrl = page.dataset.paymentStatusUrl;
    const orderCode = page.dataset.orderCode;
    const paymentToken = page.dataset.paymentToken;
    const statusElement = document.getElementById('payment-status');
    const successMessage = document.getElementById('payment-success-message');
    let intervalId = null;
    let timeoutId = null;
    let stopped = false;

    const stopPolling = () => {
        if (stopped) {
            return;
        }
        stopped = true;
        window.clearInterval(intervalId);
        window.clearTimeout(timeoutId);
    };

    const showPollingMessage = (message) => {
        let messageElement = document.getElementById('payment-polling-message');
        if (!messageElement) {
            messageElement = document.createElement('p');
            messageElement.id = 'payment-polling-message';
            messageElement.style.marginTop = '16px';
            messageElement.style.color = '#b45309';
            successMessage.insertAdjacentElement('afterend', messageElement);
        }
        messageElement.textContent = message;
        messageElement.hidden = false;
    };

    const poll = async () => {
        if (stopped) {
            return;
        }
        try {
            const response = await fetch(statusUrl + '?orderCode=' + encodeURIComponent(orderCode), {
                headers: { 'X-Payment-Token': paymentToken },
                cache: 'no-store'
            });
            if (response.status === 401 || response.status === 403 || response.status === 404) {
                stopPolling();
                showPollingMessage('Kh\u00f4ng th\u1ec3 ki\u1ec3m tra tr\u1ea1ng th\u00e1i thanh to\u00e1n. Vui l\u00f2ng m\u1edf l\u1ea1i \u0111\u01a1n h\u00e0ng t\u1eeb trang c\u00e1 nh\u00e2n.');
                return;
            }
            if (!response.ok) {
                return;
            }

            const result = await response.json();
            statusElement.textContent = result.paymentStatus;
            if (result.paid) {
                statusElement.style.color = '#22c55e';
                successMessage.hidden = false;
                stopPolling();
            }
        } catch (error) {
            console.error(error);
        }
    };

    intervalId = window.setInterval(poll, pollingIntervalMs);
    timeoutId = window.setTimeout(() => {
        stopPolling();
        showPollingMessage('H\u1ebft th\u1eddi gian t\u1ef1 \u0111\u1ed9ng ki\u1ec3m tra. B\u1ea1n c\u00f3 th\u1ec3 xem l\u1ea1i tr\u1ea1ng th\u00e1i trong trang c\u00e1 nh\u00e2n.');
    }, pollingTimeoutMs);
    poll();
}

document.addEventListener('DOMContentLoaded', initPaymentStatusPolling, { once: true });
