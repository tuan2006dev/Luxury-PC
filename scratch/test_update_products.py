import sys, re
sys.stdout.reconfigure(encoding='utf-8')

from process_updates import updates

def parse_sql_row(row_str):
    # row_str is like: 1, 'Intel Core i9-14900K', 15500000, '24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06 13:46:29.076393', NULL
    # Let's tokenize by comma while respecting quotes
    tokens = []
    current = []
    in_quotes = False
    quote_char = None
    i = 0
    while i < len(row_str):
        c = row_str[i]
        if in_quotes:
            current.append(c)
            if c == quote_char:
                # Check for escaped quote ''
                if i + 1 < len(row_str) and row_str[i+1] == quote_char:
                    current.append(row_str[i+1])
                    i += 1
                else:
                    in_quotes = False
        else:
            if c in ("'", '"'):
                in_quotes = True
                quote_char = c
                current.append(c)
            elif c == ',':
                tokens.append(''.join(current).strip())
                current = []
            else:
                current.append(c)
        i += 1
    if current:
        tokens.append(''.join(current).strip())
    return tokens

# Let's test on all 542 lines in init_luxurypc_full.sql
with open('d:/Luxury-PC-main/init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

m = re.search(r'SET IDENTITY_INSERT products ON;\s*INSERT INTO products \((.*?)\) VALUES\n([\s\S]*?);\s*SET IDENTITY_INSERT products OFF;', sql, re.IGNORECASE)
if not m:
    print('Failed to find products block')
    sys.exit(1)

cols = [c.strip() for c in m.group(1).split(',')]
rows_text = m.group(2)
lines = [l.strip() for l in rows_text.splitlines() if l.strip()]

print(f'Found {len(lines)} product lines')
parsed_rows = []
for idx, line in enumerate(lines):
    # strip trailing comma if any
    inner = line
    if inner.endswith(','):
        inner = inner[:-1].strip()
    if inner.startswith('(') and inner.endswith(')'):
        inner = inner[1:-1].strip()
    tokens = parse_sql_row(inner)
    if len(tokens) != len(cols):
        print(f'Error at line {idx+1}: expected {len(cols)} tokens, got {len(tokens)}')
        print('Line:', line)
        print('Tokens:', tokens)
        sys.exit(1)
    parsed_rows.append(tokens)

print('Successfully parsed all', len(parsed_rows), 'rows!')

# Now let's test updating brand and description
updated_count = 0
for row in parsed_rows:
    pid = int(row[0])
    if pid in updates:
        new_brand, new_desc = updates[pid]
        # column 3 is description, column 8 is brand
        # Format description
        # if new_desc is string, wrap with N'...'
        # Escape single quotes in new_desc
        escaped_desc = new_desc.replace("'", "''")
        row[3] = f"N'{escaped_desc}'"
        
        # Format brand
        if new_brand is None or new_brand == 'NULL':
            row[8] = 'NULL'
        else:
            escaped_brand = new_brand.replace("'", "''")
            row[8] = f"N'{escaped_brand}'"
        updated_count += 1

print(f'Updated {updated_count} products out of {len(parsed_rows)}')

# Let's inspect first 5 updated rows
for r in parsed_rows[:5]:
    print('(', ', '.join(r), '),')
