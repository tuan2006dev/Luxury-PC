document.addEventListener('DOMContentLoaded', () => {
    const faqItems = document.querySelectorAll('.faq-item');

    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');
        question.addEventListener('click', () => {
            // Check if this item is already active
            const isActive = item.classList.contains('active');
            
            // Close all items
            faqItems.forEach(faq => {
                faq.classList.remove('active');
                const icon = faq.querySelector('.faq-question i');
                if (icon) {
                    icon.classList.remove('fa-chevron-up');
                    icon.classList.add('fa-chevron-down');
                }
            });

            // If it wasn't active, open it
            if (!isActive) {
                item.classList.add('active');
                const icon = item.querySelector('.faq-question i');
                if (icon) {
                    icon.classList.remove('fa-chevron-down');
                    icon.classList.add('fa-chevron-up');
                }
            }
        });
    });

    // Handle form submit
    const supportForm = document.getElementById('support-form');
    if (supportForm) {
        supportForm.addEventListener('submit', (e) => {
            e.preventDefault();
            if(typeof showToast === 'function') {
                showToast('Yêu cầu hỗ trợ của bạn đã được gửi thành công. Chúng tôi sẽ liên hệ lại trong thời gian sớm nhất!');
            } else {
                alert('Yêu cầu hỗ trợ của bạn đã được gửi thành công. Chúng tôi sẽ liên hệ lại trong thời gian sớm nhất!');
            }
            supportForm.reset();
        });
    }
});
