// Toggle FAQ Accordion
        function toggleFaq(header) {
            const item = header.parentElement;
            const isActive = item.classList.contains('active');
            
            document.querySelectorAll('.faq-item').forEach(el => {
                el.classList.remove('active');
            });
            
            if (!isActive) {
                item.classList.add('active');
            }
        }



        let translations = {};
        
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
                }
            });
            document.querySelectorAll('[data-translate-placeholder]').forEach(el => {
                const key = el.getAttribute('data-translate-placeholder');
                if (translations[lang] && translations[lang][key]) {
                    el.setAttribute('placeholder', translations[lang][key]);
                }
            });
        }

        async function loadTranslations() {
            const savedLang = localStorage.getItem('lang') || 'vi';
            const cachedData = localStorage.getItem('translations_cache');
            if (cachedData) {
                try {
                    translations = JSON.parse(cachedData);
                    setLanguage(savedLang);
                } catch (e) {
                    console.error(e);
                }
            }

            try {
                const response = await fetch('/api/translations');
                translations = await response.json();
                localStorage.setItem('translations_cache', JSON.stringify(translations));
                setLanguage(savedLang);
            } catch (error) {
                console.error(error);
            }
        }

        document.addEventListener('DOMContentLoaded', loadTranslations);