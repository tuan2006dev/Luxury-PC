import sys, re
sys.stdout.reconfigure(encoding='utf-8')

with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    full_sql = f.read()

m_prods = re.search(r"INSERT INTO products \([^)]+\) VALUES\n([\s\S]*?);", full_sql)
cat_ids = set()
prods = []
for m in re.finditer(r"\((\d+),\s*N?'([^']*)',\s*([0-9.]+),\s*(?:N'([^']*)'|NULL),\s*(?:'([^']*)'|NULL),\s*(\d+)", m_prods.group(1)):
    p_id = int(m.group(1))
    name = m.group(2)
    price = m.group(3)
    desc = m.group(4)
    img = m.group(5)
    c_id = int(m.group(6))
    cat_ids.add(c_id)
    prods.append((p_id, name, c_id))

print(f"Distinct category_ids in products: {sorted(list(cat_ids))}")
print("\nSample products per category_id:")
for cid in sorted(list(cat_ids)):
    samples = [p[1] for p in prods if p[2] == cid][:3]
    print(f"Category {cid}: {samples}")
