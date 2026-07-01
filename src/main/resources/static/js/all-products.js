function formatPriceInput(displayEl, hiddenId) {
                            let rawValue = displayEl.value.replace(/\D/g, '');
                            document.getElementById(hiddenId).value = rawValue;
                            if (rawValue !== '') {
                                displayEl.value = Number(rawValue).toLocaleString('vi-VN').replace(/,/g, '.');
                            } else {
                                displayEl.value = '';
                            }
                        }