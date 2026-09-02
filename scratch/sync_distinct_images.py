import sys
import re

# 1. Parse fixed.sql to get product image URLs
with open('fixed.sql', 'r', encoding='utf-8', errors='ignore') as f:
    fixed_sql = f.read()

pattern = r'INSERT INTO products \([^)]+\)\s*VALUES\s*\((.*?)\);'
matches = re.findall(pattern, fixed_sql, re.DOTALL)

product_data = {}
for m in matches:
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
            
            # Prefer real http URL
            if pid not in product_data or img.startswith('http'):
                product_data[pid] = {
                    'name': name,
                    'price': price,
                    'desc': desc,
                    'img': img,
                    'cat': cat,
                    'stock': stock,
                    'created': created,
                    'brand': brand
                }
        except Exception:
            pass

print(f"Extracted {len(product_data)} products from fixed.sql")

# 2. Read init_luxurypc_full.sql
with open('init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    init_sql = f.read()

# Replace rows in init_luxurypc_full.sql
def replace_product_row(match):
    pid_str = match.group(1)
    name_str = match.group(2)
    price_str = match.group(3)
    desc_str = match.group(4)
    old_img = match.group(5)
    cat_str = match.group(6)
    stock_str = match.group(7)
    rest_str = match.group(8)
    
    pid = int(pid_str)
    
    if pid in product_data:
        new_img = product_data[pid]['img']
        # Escape single quotes in image url if any
        new_img_escaped = new_img.replace("'", "''")
        return f"({pid_str}, {name_str}, {price_str}, {desc_str}, '{new_img_escaped}', {cat_str}, {stock_str}, {rest_str})"
    else:
        return match.group(0)

row_pattern = re.compile(r'\((\d+),\s*(N?\'(?:[^\']|\'\')*\'),\s*([^,]+),\s*(N?\'(?:[^\']|\'\')*\'|NULL),\s*\'([^\']+)\',\s*(\d+),\s*(\d+),\s*([^\)]+)\)')

updated_init_sql = row_pattern.sub(replace_product_row, init_sql)

with open('init_luxurypc_full.sql', 'w', encoding='utf-8') as f:
    f.write(updated_init_sql)

print("Successfully updated init_luxurypc_full.sql with individual product images!")
