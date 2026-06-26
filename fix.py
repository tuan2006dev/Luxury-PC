import os
import re

files = [
    'cart.html','checkout.html','payment.html','payment-vietqr.html',
    'account/auth.html','account/forgot-password.html','account/profile.html', 
    'index.html', 'all-products.html', 'build-pc.html', 'product-detail.html', 
    'products.html', 'promotions.html', 'support.html', 'layout/index.html'
]

base_dir = r'c:\Users\tuan\Downloads\LuxuryPC404\LuxuryPC\src\main\resources\templates'

for f in files:
    path = os.path.join(base_dir, f.replace('/', '\\'))
    
    with open(path, 'r', encoding='utf-8') as file:
        content = file.read()
        
    if 'light-theme.css' not in content and 'th:href="@{/css/style.css' in content:
        content = re.sub(r'(<link rel="stylesheet" th:href="@\{/css/style\.css[^}]*\}"\s*/>)', r'\1\n    <link rel="stylesheet" th:href="@{/css/light-theme.css}" />', content)
        
    content = re.sub(r'<span style="font-family:\'Inter\', sans-serif; font-size:2rem; font-weight:400; letter-spacing:0\.35em; color:var\(--gold\);">LUXURY</span>\s*<div style="width:1px; height:28px; background:var\(--gold\); opacity:0\.6;"></div>\s*<span style="font-family:\'Inter\', sans-serif; font-size:0\.7rem; font-weight:500; letter-spacing:0\.5em; color:#888; text-transform:uppercase;">PC</span>', '<span class="logo-Luxury">LUXURY</span> <span class="logo-pc">PC</span>', content)
    
    with open(path, 'w', encoding='utf-8', newline='\n') as file:
        file.write(content)
