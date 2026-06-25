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

                            // Re-apply language translations if present
                            const savedLang = localStorage.getItem('lang') || 'vi';
                            if (typeof setLanguage === 'function') setLanguage(savedLang);

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

let translations = {};
        const reportedKeys = new Set();

        window.t = function(key, defaultValue) {
            const lang = localStorage.getItem('lang') || 'vi';
            return (translations[lang] && translations[lang][key]) || defaultValue;
        };

        function setLanguage(lang) {
            localStorage.setItem('lang', lang);
            
            document.querySelectorAll('[data-translate]').forEach(el => {
                const key = el.getAttribute('data-translate');
                if (translations[lang] && translations[lang][key]) {
                    const val = translations[lang][key];
                    if (el.children.length === 0) {
                        el.textContent = val;
                    } else {
                        let textNode = Array.from(el.childNodes).find(node => node.nodeType === Node.TEXT_NODE);
                        if (textNode) {
                            textNode.nodeValue = val;
                        }
                    }
                } else {
                    reportMissingKey(key, el.textContent.trim());
                }
            });

            document.querySelectorAll('[data-translate-placeholder]').forEach(el => {
                const key = el.getAttribute('data-translate-placeholder');
                if (translations[lang] && translations[lang][key]) {
                    el.setAttribute('placeholder', translations[lang][key]);
                }
            });
        }

        function reportMissingKey(key, defaultValue) {
            if (!key || !defaultValue || reportedKeys.has(key)) return;
            reportedKeys.add(key);

            fetch('/api/translations/missing', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ key: key, defaultValue: defaultValue })
            }).catch(err => console.warn("Lỗi gửi báo cáo dịch tự động (admin):", err));
        }

        async function loadTranslations() {
            const savedLang = localStorage.getItem('lang') || 'vi';

            const cachedData = localStorage.getItem('translations_cache');
            if (cachedData) {
                try {
                    translations = JSON.parse(cachedData);
                    setLanguage(savedLang);
                    return; // Ngăn chặn tải lại để tránh flickering
                } catch (e) {
                    console.error("Lỗi đọc cache dịch admin:", e);
                }
            }

            try {
                const response = await fetch('/api/translations');
                const newData = await response.json();
                
                localStorage.setItem('translations_cache', JSON.stringify(newData));
                translations = newData;
                setLanguage(savedLang);
            } catch (error) {
                console.error("Lỗi khi tải bộ từ điển dịch thuật admin:", error);
            }
        }

        function startTranslationObserver() {
            const observer = new MutationObserver((mutations) => {
                let hasNewTranslateElement = false;
                mutations.forEach(mutation => {
                    mutation.addedNodes.forEach(node => {
                        if (node.nodeType === Node.ELEMENT_NODE) {
                            if (node.hasAttribute('data-translate') || node.querySelector('[data-translate]')) {
                                hasNewTranslateElement = true;
                            }
                        }
                    });
                });
                if (hasNewTranslateElement) {
                    const savedLang = localStorage.getItem('lang') || 'vi';
                    setLanguage(savedLang);
                }
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }

        function initTranslations() {
            loadTranslations();
            startTranslationObserver();
        }

        document.addEventListener('DOMContentLoaded', initTranslations);

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
                            time_24hr: true
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

// Global Delete Confirmation using SweetAlert2
        window.confirmDelete = function(formElement, message) {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    title: message || 'Bạn có chắc chắn muốn xóa?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'OK',
                    cancelButtonText: 'Cancel',
                    background: '#1a1a1a',
                    color: '#f5f0e8',
                    confirmButtonColor: '#ef4444',
                    cancelButtonColor: '#c9a84c'
                }).then((result) => {
                    if (result.isConfirmed) {
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