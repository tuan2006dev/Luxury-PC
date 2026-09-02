import sys, re
sys.stdout.reconfigure(encoding='utf-8')

# Let's inspect categories in init_luxurypc_full.sql vs user's snippet
with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

m_cat = re.search(r'INSERT INTO categories \((.*?)\) VALUES\n([\s\S]*?);', sql)
if m_cat:
    print('Current categories in init_luxurypc_full.sql:')
    print(m_cat.group(0))

# Let's check fixed_koko.sql categories and products count
with open('d:/Luxury-PC-main/fixed_koko.sql', 'r', encoding='utf-8') as f:
    koko = f.read()

m_koko_cat = re.search(r'INSERT INTO categories \((.*?)\) VALUES\s*([\s\S]*?);(?:\n\n|\nSET)', koko)
if m_koko_cat:
    print('\nCategories in fixed_koko.sql:')
    print(m_koko_cat.group(0)[:500])

m_koko_prods = re.findall(r'INSERT INTO products \((.*?)\) VALUES \((.*?)\);', koko)
print(f'\nTotal products in fixed_koko.sql: {len(m_koko_prods)}')
