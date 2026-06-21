import base64
with open(r'c:\Users\tuan\Downloads\en.png', 'rb') as f:
    en_b64 = base64.b64encode(f.read()).decode('utf-8')
with open(r'c:\Users\tuan\Downloads\vn.png', 'rb') as f:
    vn_b64 = base64.b64encode(f.read()).decode('utf-8')

header_path = r'c:\Users\tuan\Downloads\LuxuryPC404\LuxuryPC\src\main\resources\templates\layout\header.html'
with open(header_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('th:src="@{/images/vn.png}"', 'src="data:image/png;base64,' + vn_b64 + '"')
content = content.replace('th:src="@{/images/en.png}"', 'src="data:image/png;base64,' + en_b64 + '"')

with open(header_path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Patched successfully!')
