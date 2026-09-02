import sys, re
sys.stdout.reconfigure(encoding='utf-8')

from process_updates import updates

with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Find the products block
m = re.search(r'SET IDENTITY_INSERT products ON;\s*INSERT INTO products \((.*?)\) VALUES\n([\s\S]*?);\s*SET IDENTITY_INSERT products OFF;', sql, re.IGNORECASE)
if not m:
    print('Failed to find products block')
    sys.exit(1)

cols = m.group(1)
rows_text = m.group(2)
lines = [l.strip() for l in rows_text.splitlines() if l.strip()]

print(f'Total product lines found: {len(lines)}')

# Let's inspect the first 5 and last 5 lines
print('First 3 lines:')
for l in lines[:3]:
    print(' ', l)

print('Last 3 lines:')
for l in lines[-3:]:
    print(' ', l)
