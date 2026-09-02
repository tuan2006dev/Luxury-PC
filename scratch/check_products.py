import re, sys

# 1. Read existing products in init_luxurypc_full.sql
with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Let's find products block
m = re.search(r'SET IDENTITY_INSERT products ON;\s*INSERT INTO products \((.*?)\) VALUES\s*([\s\S]*?);?\s*SET IDENTITY_INSERT products OFF;', sql, re.IGNORECASE)
if not m:
    print('Could not find products block')
    sys.exit(1)

cols = m.group(1).strip()
values_text = m.group(2).strip()
print('Columns:', cols)

# Let's see what products exist (IDs)
rows = re.findall(r'\((\d+),\s*([\s\S]*?)\)(?:,|\s*;)', values_text)
print('Found product rows in init_luxurypc_full.sql:', len(rows))
if rows:
    ids = [int(r[0]) for r in rows]
    print('IDs range:', min(ids), 'to', max(ids))
