document.addEventListener('DOMContentLoaded', () => {
    // Tab switching
    const tabs = document.querySelectorAll('.pd-tab');
    const tabContents = document.querySelectorAll('.pd-tab-content');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove('active'));
            // Hide all tab contents
            tabContents.forEach(content => content.style.display = 'none');

            // Add active class to clicked tab
            tab.classList.add('active');
            // Show corresponding content
            const targetId = tab.getAttribute('data-tab');
            document.getElementById(targetId).style.display = 'block';
        });
    });

    // Image thumbnail switching
    const mainImg = document.querySelector('.pd-main-img img');
    const thumbnails = document.querySelectorAll('.pd-thumbnails img');

    thumbnails.forEach(thumb => {
        thumb.addEventListener('click', () => {
            // Remove active from all thumbs
            thumbnails.forEach(t => t.classList.remove('active'));
            
            // Add active to clicked thumb
            thumb.classList.add('active');
            
            // Update main image source
            mainImg.src = thumb.src;
        });
    });
});
