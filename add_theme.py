import os

files = ['cart.html', 'checkout.html', 'payment.html', 'payment-vietqr.html']
base_dir = r'c:\Users\tuan\Downloads\LuxuryPC404\LuxuryPC\src\main\resources\templates'

button_html = '''
<!-- THEME TOGGLE -->
<button class="theme-toggle-btn floating-theme-btn" id="theme-toggle" aria-label="Chuyển đổi giao diện Sáng/Tối">
    <i class="fa-regular fa-moon"></i>
</button>
<script th:src="@{/js/theme.js}"></script>
'''

for f in files:
    path = os.path.join(base_dir, f)
    with open(path, 'r', encoding='utf-8') as file:
        content = file.read()
        
    if 'theme-toggle-btn' not in content:
        content = content.replace('</body>', button_html + '\n</body>')
        with open(path, 'w', encoding='utf-8', newline='\n') as file:
            file.write(content)
