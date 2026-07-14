function initPaymentStatusPolling() {
    const page = document.querySelector('[data-payment-status-url]');
    if (!page) {
        return;
    }

    const statusUrl = page.dataset.paymentStatusUrl;
    const orderCode = page.dataset.orderCode;
    const paymentToken = page.dataset.paymentToken;
    const statusElement = document.getElementById('payment-status');
    const successMessage = document.getElementById('payment-success-message');
    let paymentStatusTimer = null;

    const poll = async () => {
        try {
            const response = await fetch(statusUrl + '?orderCode=' + encodeURIComponent(orderCode), {
                headers: { 'X-Payment-Token': paymentToken },
                cache: 'no-store'
            });
            if (!response.ok) {
                return;
            }

            const result = await response.json();
            if (result.paid) {
                statusElement.textContent = result.paymentStatus;
                statusElement.style.color = '#22c55e';
                successMessage.hidden = false;
                if (paymentStatusTimer !== null) {
                    window.clearInterval(paymentStatusTimer);
                    paymentStatusTimer = null;
                }
            }
        } catch (error) {
            console.error(error);
        }
    };

    poll();
    paymentStatusTimer = window.setInterval(poll, 5000);
}

document.addEventListener('DOMContentLoaded', initPaymentStatusPolling, { once: true });
