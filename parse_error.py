import re

with open('error_response.html', 'r', encoding='utf-8', errors='ignore') as f:
    html = f.read()

m1 = re.search(r'Exception: (.*?)<br>', html)
m2 = re.search(r'<h1>.*?</h1><p>(.*?)</p>', html)
m3 = re.search(r'\"message\":\"(.*?)\"', html)
m4 = re.search(r'root cause.*?([A-Za-z0-9_\.]+Exception:.*?)<', html, re.DOTALL)

if m1: print(m1.group(1))
elif m2: print(m2.group(1))
elif m3: print(m3.group(1))
elif m4: print(m4.group(1))
else: print(html[:500])
