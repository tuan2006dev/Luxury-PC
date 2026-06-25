/**
 * Theme management logic for Dark/Light mode.
 */
document.addEventListener('DOMContentLoaded', () => {
    const toggleBtn = document.getElementById('theme-toggle');
    const rootElement = document.documentElement;
    
    // Check local storage for theme, default to dark
    const currentTheme = localStorage.getItem('theme') || 'dark';
    
    // Apply current theme
    if (currentTheme === 'light') {
        rootElement.setAttribute('data-theme', 'light');
    } else {
        rootElement.setAttribute('data-theme', 'dark');
    }

    // Toggle button click handler
    if (toggleBtn) {
        toggleBtn.addEventListener('click', (e) => {
            // Prevent event from bubbling up if it's inside a link
            e.preventDefault();
            e.stopPropagation();
            
            const isLight = rootElement.getAttribute('data-theme') === 'light';
            const newTheme = isLight ? 'dark' : 'light';
            
            // Set new theme
            rootElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            
            console.log(`Theme switched to: ${newTheme}`);
        });
    }
});

// Also immediately apply theme before DOMContentLoaded to prevent Flash of Unstyled Content (FOUC)
(function() {
    try {
        const theme = localStorage.getItem('theme') || 'dark';
        document.documentElement.setAttribute('data-theme', theme);
    } catch (e) {
        console.warn("localStorage not available for theme check");
    }
})();
