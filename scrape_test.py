import requests
import re

html = requests.get('https://gearvn.com/collections/cpu', headers={'User-Agent': 'Mozilla/5.0'}).text
links = re.findall(r'href=["\'](/products/.*?)["\']', html)
links = list(set(links))
print(f"Found {len(links)} products.")
for link in links[:3]:
    print("Product Link:", link)
    p_html = requests.get('https://gearvn.com' + link, headers={'User-Agent': 'Mozilla/5.0'}).text
    title = re.search(r'<h1.*?>(.*?)</h1>', p_html)
    if title:
        print("Title:", title.group(1).strip())
    price = re.search(r'class="product-price".*?>([\d,]+)₫', p_html)
    if price:
        print("Price:", price.group(1))
    print("-----")
