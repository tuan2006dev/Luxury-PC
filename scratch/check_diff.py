import sys, re
sys.stdout.reconfigure(encoding='utf-8')

with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    full_sql = f.read()

with open('d:/Luxury-PC-main/fixed_koko.sql', 'r', encoding='utf-8') as f:
    koko_sql = f.read()

# Check categories in both
print("Categories in fixed_koko.sql:")
for m in re.finditer(r"INSERT INTO categories \((.*?)\) VALUES \((\d+), N?'([^']+)'", koko_sql):
    print(f"  {m.group(2)}: {m.group(3)}")

print("\nCategories in init_luxurypc_full.sql:")
m_cat = re.search(r"INSERT INTO categories \([^)]+\) VALUES\n([\s\S]*?);", full_sql)
if m_cat:
    for line in m_cat.group(1).strip().split("\n"):
        print(f"  {line}")

# Check duplicate product IDs in fixed_koko vs init_luxurypc_full
koko_prods = re.findall(r"INSERT INTO products \([^)]+\) VALUES \((\d+), N?'([^']+)'", koko_sql)
print(f"\nTotal products in fixed_koko: {len(koko_prods)}")
koko_ids = [int(p[0]) for p in koko_prods]
print(f"Unique product IDs in fixed_koko: {len(set(koko_ids))}")

# In init_luxurypc_full
m_prods = re.search(r"INSERT INTO products \([^)]+\) VALUES\n([\s\S]*?);", full_sql)
full_prods = []
if m_prods:
    # Match each tuple
    for row in re.finditer(r"\((\d+),\s*N?'([^']*)'", m_prods.group(1)):
        full_prods.append((int(row.group(1)), row.group(2)))
print(f"Total products in init_luxurypc_full.sql: {len(full_prods)}")
print(f"Unique product IDs in init_luxurypc_full.sql: {len(set([p[0] for p in full_prods]))}")
