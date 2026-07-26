function initPaymentStatusPolling() {
    const page = document.querySelector('[data-payment-status-url]');
    if (!page || page.dataset.vietqrInitialized === 'true') {
        return;
    }
    page.dataset.vietqrInitialized = 'true';

    const pollingIntervalMs = 5000;
    const countdownIntervalMs = 250;
    const statusUrl = page.dataset.paymentStatusUrl;
    const orderCode = page.dataset.orderCode;
    const paymentToken = page.dataset.paymentToken;
    const statusElement = document.getElementById('payment-status');
    const successMessage = document.getElementById('payment-success-message');
    const validityElement = document.getElementById('qr-validity');
    const countdownElement = document.getElementById('payment-countdown');
    const expiredMessage = document.getElementById('payment-expired-message');
    const renewLink = document.getElementById('payment-renew-link');
    const qrImageBox = document.getElementById('qr-image-box');
    const qrImage = document.getElementById('vietqr-image');

    let pollingIntervalId = null;
    let countdownIntervalId = null;
    let serverOffsetMs = 0;
    let expiresAtMs = Date.parse(page.dataset.expiresAt);
    let expiresAt = page.dataset.expiresAt;
    let stopped = false;
    let requestInFlight = false;
    let expiredEventDispatched = false;

    const stopAll = () => {
        if (stopped) {
            return;
        }
        stopped = true;
        window.clearInterval(pollingIntervalId);
        window.clearInterval(countdownIntervalId);
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

    const formatRemaining = (remainingSeconds) => {
        const minutes = Math.floor(remainingSeconds / 60);
        const seconds = remainingSeconds % 60;
        return String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
    };

    const expireQr = () => {
        stopAll();
        countdownElement.textContent = '00:00';
        validityElement.hidden = true;
        expiredMessage.hidden = false;
        renewLink.hidden = false;
        qrImageBox.style.opacity = '0.35';
        qrImageBox.style.filter = 'grayscale(1)';
        qrImage.style.pointerEvents = 'none';
        qrImage.setAttribute('aria-disabled', 'true');
        statusElement.textContent = 'M\u00e3 QR \u0111\u00e3 h\u1ebft h\u1ea1n';
        statusElement.style.color = '#b91c1c';

        if (!expiredEventDispatched) {
            expiredEventDispatched = true;
            document.dispatchEvent(new CustomEvent('vietqr:expired', {
                detail: {
                    orderCode,
                    expiresAt
                }
            }));
        }
    };

    const renderCountdown = () => {
        if (stopped || !Number.isFinite(expiresAtMs)) {
            return;
        }
        const serverNowMs = Date.now() + serverOffsetMs;
        const remainingSeconds = Math.max(0, Math.ceil((expiresAtMs - serverNowMs) / 1000));
        countdownElement.textContent = formatRemaining(remainingSeconds);
        if (remainingSeconds === 0) {
            expireQr();
        }
    };

    const synchronizeClock = (result) => {
        const parsedServerTime = Date.parse(result.serverTime);
        const parsedExpiresAt = Date.parse(result.expiresAt);
        if (Number.isFinite(parsedServerTime)) {
            serverOffsetMs = parsedServerTime - Date.now();
        }
        if (Number.isFinite(parsedExpiresAt)) {
            expiresAtMs = parsedExpiresAt;
            expiresAt = result.expiresAt;
            page.dataset.expiresAt = result.expiresAt;
        }
    };

    const showPaid = () => {
        statusElement.style.color = '#22c55e';
        successMessage.hidden = false;
        validityElement.hidden = true;
        stopAll();
    };

    const poll = async () => {
        if (stopped || requestInFlight) {
            return;
        }
        requestInFlight = true;
        try {
            const response = await fetch(statusUrl + '?orderCode=' + encodeURIComponent(orderCode), {
                headers: { 'X-Payment-Token': paymentToken },
                cache: 'no-store'
            });
            if (response.status === 401 || response.status === 403 || response.status === 404) {
                stopAll();
                showPollingMessage('Kh\u00f4ng th\u1ec3 ki\u1ec3m tra tr\u1ea1ng th\u00e1i thanh to\u00e1n. Vui l\u00f2ng m\u1edf l\u1ea1i \u0111\u01a1n h\u00e0ng t\u1eeb trang c\u00e1 nh\u00e2n.');
                return;
            }
            if (!response.ok) {
                return;
            }

            const result = await response.json();
            synchronizeClock(result);
            statusElement.textContent = result.paymentStatus;
            if (result.paid) {
                showPaid();
                return;
            }
            if (result.expired) {
                expireQr();
                return;
            }
            renderCountdown();
        } catch (error) {
            console.error(error);
        } finally {
            requestInFlight = false;
        }
    };

    const initialServerTimeMs = Date.parse(page.dataset.serverTime);
    if (Number.isFinite(initialServerTimeMs)) {
        serverOffsetMs = initialServerTimeMs - Date.now();
    }
    renderCountdown();

    if (!stopped) {
        pollingIntervalId = window.setInterval(poll, pollingIntervalMs);
        countdownIntervalId = window.setInterval(renderCountdown, countdownIntervalMs);
        poll();
    }

    document.addEventListener('visibilitychange', () => {
        if (document.visibilityState === 'visible' && !stopped) {
            poll();
        }
    });
}

document.addEventListener('DOMContentLoaded', initPaymentStatusPolling, { once: true });
