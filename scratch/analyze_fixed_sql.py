import sys
import re

with open('fixed.sql', 'r', encoding='utf-8', errors='ignore') as f:
    sql = f.read()

# Match all INSERT INTO products
pattern = r'INSERT INTO products \([^)]+\)\s*VALUES\s*\((.*?)\);'
matches = re.findall(pattern, sql, re.DOTALL)

print(f'Total matched statements: {len(matches)}')
product_images = {}
for m in matches:
    # parse fields by splitting on comma, respecting quotes
    # sql csv parser
    tokens = []
    curr = []
    in_quote = False
    for char in m:
        if char == "'":
            in_quote = not in_quote
            curr.append(char)
        elif char == ',' and not in_quote:
            tokens.append(''.join(curr).strip())
            curr = []
        else:
            curr.append(char)
    if curr:
        tokens.append(''.join(curr).strip())
        
    if len(tokens) >= 5:
        try:
            pid = int(tokens[0])
            name = tokens[1]
            price = tokens[2]
            desc = tokens[3]
            img = tokens[4].strip("'")
            cat = tokens[5]
            stock = tokens[6]
            created = tokens[7]
            brand = tokens[8] if len(tokens) > 8 else 'NULL'
            
            if pid not in product_images or img.startswith('http'):
                product_images[pid] = {
                    'name': name,
                    'price': price,
                    'desc': desc,
                    'img': img,
                    'cat': cat,
                    'stock': stock,
                    'created': created,
                    'brand': brand
                }
        except Exception as e:
            pass

print(f'Distinct product IDs in fixed.sql: {len(product_images)}')
http_count = sum(1 for p in product_images.values() if p['img'].startswith('http'))
print(f'Products with http URLs: {http_count}')
distinct_imgs = len(set(p['img'] for p in product_images.values()))
print(f'Distinct image values: {distinct_imgs}')

# Check samples
for pid in list(product_images.keys())[:15]:
    p = product_images[pid]
    print(f"ID {pid}: {p['name'][:30]} -> {p['img'][:60]}")
