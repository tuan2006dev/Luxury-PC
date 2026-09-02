import sys, re
sys.stdout.reconfigure(encoding='utf-8')

from process_updates import updates
from test_update_products import parse_sql_row

with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

m = re.search(r'(SET IDENTITY_INSERT products ON;\s*INSERT INTO products \((.*?)\) VALUES\n)([\s\S]*?)(;\s*SET IDENTITY_INSERT products OFF;)', sql, re.IGNORECASE)
if not m:
    print('Failed to find products block')
    sys.exit(1)

prefix = m.group(1)
cols_str = m.group(2)
cols = [c.strip() for c in cols_str.split(',')]
rows_text = m.group(3)
suffix = m.group(4)

lines = [l.strip() for l in rows_text.splitlines() if l.strip()]

parsed_rows = []
for idx, line in enumerate(lines):
    inner = line
    if inner.endswith(','):
        inner = inner[:-1].strip()
    if inner.startswith('(') and inner.endswith(')'):
        inner = inner[1:-1].strip()
    tokens = parse_sql_row(inner)
    if len(tokens) != len(cols):
        print(f'Error at line {idx+1}: expected {len(cols)} tokens, got {len(tokens)}')
        sys.exit(1)
    parsed_rows.append(tokens)

# Update each row
for row in parsed_rows:
    pid = int(row[0])
    if pid in updates:
        new_brand, new_desc = updates[pid]
        # column 3 is description, column 8 is brand
        escaped_desc = new_desc.replace("'", "''")
        row[3] = f"N'{escaped_desc}'"
        
        if new_brand is None or new_brand == 'NULL':
            row[8] = 'NULL'
        else:
            escaped_brand = new_brand.replace("'", "''")
            row[8] = f"N'{escaped_brand}'"

# Reconstruct the products block
formatted_rows = []
for idx, row in enumerate(parsed_rows):
    comma = ',' if idx < len(parsed_rows) - 1 else ''
    formatted_rows.append(f"({', '.join(row)}){comma}")

new_rows_text = '\n'.join(formatted_rows)
new_sql = sql[:m.start()] + prefix + new_rows_text + suffix + sql[m.end():]

with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'w', encoding='utf-8') as f:
    f.write(new_sql)

print('Successfully applied products brand and description updates to init_luxurypc_full.sql!')
