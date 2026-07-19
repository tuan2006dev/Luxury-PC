function toggleSidebarMenu(menuId, titleEl) {
            const menu = document.getElementById(menuId);
            const isShowing = menu.classList.contains('show');
            
            if (isShowing) {
                menu.classList.remove('show');
                titleEl.classList.remove('active');
            } else {
                menu.classList.add('show');
                titleEl.classList.add('active');
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            if(window.__spaInitialized) return;
            window.__spaInitialized = true;

            function updateSidebarActiveStatus(path) {
                document.querySelectorAll('.sub-menu a, .nav-link, .menu-title').forEach(el => el.classList.remove('active'));
                
                const linkMap = {
                    '/admin/dashboard': 'nav-dashboard',
                    '/admin/products': 'nav-products',
                    '/admin/categories': 'nav-categories',
                    '/admin/flash-sales': 'nav-flash-sales',
                    '/admin/flash-sale-items': 'nav-flash-sales',
                    '/admin/inventory': 'nav-inventory',
                    '/admin/orders': 'nav-orders',
                    '/admin/account': 'nav-account',
                    '/admin/vouchers': 'nav-vouchers',
                    '/admin/tickets': 'nav-tickets'
                };
                
                let activeId = null;
                for (let key in linkMap) {
                    if (path.startsWith(key)) activeId = linkMap[key];
                }

                if (activeId) {
                    const activeEl = document.getElementById(activeId);
                    if (activeEl) {
                        activeEl.classList.add('active');
                        const parentMenu = activeEl.closest('.sub-menu');
                        if (parentMenu) {
                            parentMenu.classList.add('show');
                            const titleEl = parentMenu.previousElementSibling;
                            if (titleEl && titleEl.classList.contains('menu-title')) {
                                titleEl.classList.add('active');
                            }
                        }
                    }
                }
            }

            // Init on load
            updateSidebarActiveStatus(window.location.pathname);

            // Custom SPA Router (PJAX)
            document.querySelectorAll('.sub-menu a, #nav-dashboard').forEach(link => {
                link.addEventListener('click', async (e) => {
                    const url = link.getAttribute('href');
                    if (!url || url === '#' || url.startsWith('javascript')) return;
                    
                    if (window.location.pathname === url) {
                        e.preventDefault();
                        return;
                    }
                    if (e.ctrlKey || e.metaKey || link.target === '_blank') return;
                    
                    e.preventDefault();

                    const mainContent = document.querySelector('.main-content');
                    if(mainContent) mainContent.style.opacity = '0.5';

                    window.history.pushState({}, '', url);
                    updateSidebarActiveStatus(url);

                    try {
                        const res = await fetch(url);
                        const html = await res.text();
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, 'text/html');
                        
                        const newContent = doc.querySelector('.main-content');
                        if (newContent) {
                            // Sync title
                            if (doc.title) document.title = doc.title;

                            // Sync styles and links from head
                            const newStyles = Array.from(doc.head.querySelectorAll('link[rel="stylesheet"], style'));
                            const oldStyles = Array.from(document.head.querySelectorAll('link[rel="stylesheet"], style'));

                            newStyles.forEach(newStyle => {
                                let exists = false;
                                if (newStyle.tagName === 'LINK') {
                                    exists = oldStyles.some(old => old.tagName === 'LINK' && old.href === newStyle.href);
                                } else if (newStyle.tagName === 'STYLE') {
                                    exists = oldStyles.some(old => old.tagName === 'STYLE' && old.innerHTML.trim() === newStyle.innerHTML.trim());
                                }
                                if (!exists) {
                                    const clone = newStyle.cloneNode(true);
                                    document.head.appendChild(clone);
                                    oldStyles.push(clone);
                                }
                            });

                            if (mainContent) mainContent.replaceWith(newContent);
                            
                            // Execute new scripts
                            const scripts = newContent.querySelectorAll('script');
                            scripts.forEach(oldScript => {
                                const newScript = document.createElement('script');
                                Array.from(oldScript.attributes).forEach(attr => newScript.setAttribute(attr.name, attr.value));
                                newScript.appendChild(document.createTextNode(oldScript.innerHTML));
                                oldScript.parentNode.replaceChild(newScript, oldScript);
                            });

                            // Trigger event for other components
                            document.dispatchEvent(new Event('spa:load'));
                        } else {
                            window.location.href = url; // Fallback
                        }
                    } catch(err) {
                        window.location.href = url; // Fallback
                    }
                });
            });

            window.addEventListener('popstate', () => window.location.reload());
        });



document.addEventListener("DOMContentLoaded", function() {
            function initFlatpickr() {
                if (typeof flatpickr !== 'undefined') {
                    document.querySelectorAll("input[type='datetime-local']").forEach(input => {
                        if (input.classList.contains('flatpickr-input')) return; // Already initialized
                        
                        let fpInstance = flatpickr(input, {
                            enableTime: true,
                            dateFormat: "Y-m-d\\TH:i",
                            altInput: true,
                            altFormat: "d/m/Y H:i",
                            time_24hr: true,
                            plugins: [new confirmDatePlugin({
                                confirmIcon: "<i class='fa-solid fa-check'></i> ", 
                                confirmText: "Xác nhận",
                                showAlways: true,
                                theme: "light"
                            })]
                        });

                        let altInput = fpInstance.altInput;
                        let existingWrapper = altInput.closest('.datetime-wrapper');
                        if (!existingWrapper) {
                            let wrapper = document.createElement('div');
                            wrapper.className = 'datetime-wrapper';
                            altInput.parentNode.insertBefore(wrapper, altInput);
                            wrapper.appendChild(altInput);
                            
                            let icon = document.createElement('i');
                            icon.className = 'fa-solid fa-calendar-days';
                            icon.onclick = function() { fpInstance.open(); };
                            wrapper.appendChild(icon);
                        } else {
                            // If the user already wrapped the input, find the icon and make it clickable
                            let icon = existingWrapper.querySelector('.fa-calendar-days');
                            if (icon) {
                                icon.style.cursor = 'pointer';
                                icon.onclick = function() { fpInstance.open(); };
                            }
                        }
                    });
                }
            }
            initFlatpickr();
            document.addEventListener('spa:load', initFlatpickr);
        });

// Global Delete Confirmation using Custom Popup
        window.confirmDelete = function(formElement, message) {
            if (typeof window.showConfirm !== 'undefined') {
                window.showConfirm(message || 'Bạn có chắc chắn muốn xóa?').then((confirmed) => {
                    if (confirmed) {
                        formElement.submit();
                    }
                });
            } else {
                if (confirm(message || 'Bạn có chắc chắn muốn xóa?')) {
                    formElement.submit();
                }
            }
            return false;
        };

// Global validation to prevent negative numbers in all number inputs
        function initNumberValidation() {
            document.querySelectorAll('input[type="number"]').forEach(input => {
                // Remove existing to avoid duplicates if called multiple times
                input.removeEventListener('keydown', preventNegativeInput);
                input.removeEventListener('paste', preventNegativePaste);
                input.removeEventListener('input', enforcePositiveValue);
                
                input.addEventListener('keydown', preventNegativeInput);
                input.addEventListener('paste', preventNegativePaste);
                input.addEventListener('input', enforcePositiveValue);
            });
        }

        function preventNegativeInput(e) {
            if (e.key === '-' || e.key === '+' || e.key === 'e' || e.key === 'E') {
                e.preventDefault();
            }
        }

        function preventNegativePaste(e) {
            const pastedData = e.clipboardData.getData('text');
            if (pastedData.includes('-') || pastedData.includes('+') || pastedData.includes('e') || pastedData.includes('E')) {
                e.preventDefault();
            }
        }

        function enforcePositiveValue(e) {
            if (this.value < 0) {
                this.value = Math.abs(this.value);
            }
        }

        document.addEventListener('DOMContentLoaded', initNumberValidation);
        document.addEventListener('spa:load', initNumberValidation);

// Prevent negative numbers and scientific notation globally on number inputs
document.addEventListener('keydown', function(e) {
    if (e.target && e.target.type === 'number') {
        if (e.key === '-' || e.key === 'e' || e.key === 'E' || e.key === '+') {
            e.preventDefault();
        }
    }
});

document.addEventListener('input', function(e) {
    if (e.target && e.target.type === 'number') {
        if (e.target.value < 0) {
            e.target.value = '';
        }
    }
});


