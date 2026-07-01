/**
 * Theme management logic for Dark/Light mode.
 */
document.addEventListener('DOMContentLoaded', () => {
    const toggleBtn = document.getElementById('theme-toggle');
    const bodyElement = document.body;
    
    // Check local storage for theme, default to dark
    const currentTheme = localStorage.getItem('theme') || 'dark';
    
    // Apply current theme
    if (currentTheme === 'light') {
        bodyElement.classList.add('light-mode');
    } else {
        bodyElement.classList.remove('light-mode');
    }

    // Toggle button click handler
    if (toggleBtn) {
        toggleBtn.addEventListener('click', (e) => {
            // Prevent event from bubbling up if it's inside a link
            e.preventDefault();
            e.stopPropagation();
            
            bodyElement.classList.toggle('light-mode');
            const isLight = bodyElement.classList.contains('light-mode');
            const newTheme = isLight ? 'light' : 'dark';
            
            localStorage.setItem('theme', newTheme);
            
            console.log(`Theme switched to: ${newTheme}`);
        });
    }
});

// Also immediately apply theme before DOMContentLoaded to prevent Flash of Unstyled Content (FOUC)
(function() {
    try {
        const theme = localStorage.getItem('theme') || 'dark';
        if (theme === 'light') {
            document.body.classList.add('light-mode');
        }
    } catch (e) {
        console.warn("localStorage not available for theme check");
    }
})();
