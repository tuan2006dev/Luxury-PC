import re

input_file = r"D:\nguyen\fixed.sql"
output_file = r"D:\nguyen\import_data_only.sql"

with open(input_file, 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Extract schemas
tables = {}
for m in re.finditer(r'CREATE TABLE\s+"([^"]+)"\s*\((.*?)\)\s*(?:;|\nGO)', content, re.IGNORECASE | re.DOTALL):
    table_name = m.group(1)
    columns_block = m.group(2)
    columns = []
    for line in columns_block.split('\n'):
        m_col = re.search(r'^\s*"([^"]+)"', line)
        if m_col:
            columns.append(m_col.group(1))
    tables[table_name] = columns

# Replace INSERTs
for table_name, columns in tables.items():
    if not columns: continue
    col_str = ", ".join([f'"{c}"' for c in columns])
    pattern = r'INSERT INTO\s+"' + re.escape(table_name) + r'"\s+VALUES'
    replacement = f'INSERT INTO "{table_name}" ({col_str}) VALUES'
    content = re.sub(pattern, replacement, content, flags=re.IGNORECASE)

lines = content.split('\n')
out_lines = []

# Disable all foreign key constraints
out_lines.append("EXEC sp_msforeachtable \"ALTER TABLE ? NOCHECK CONSTRAINT ALL\";")
out_lines.append("GO")

current_table = None

for line in lines:
    # Skip CREATE, ALTER, DROP, GO, etc. We only want INSERTs
    if line.strip() == "" or line.upper().startswith("CREATE ") or line.upper().startswith("ALTER ") or line.upper().startswith("DROP ") or line.upper() == "GO":
        continue
    
    m = re.match(r'^INSERT INTO\s+"([^"]+)"', line, re.IGNORECASE)
    if m:
        table = m.group(1)
        if table != current_table:
            if current_table is not None:
                out_lines.append(f"IF OBJECTPROPERTY(OBJECT_ID('{current_table}'), 'TableHasIdentity') = 1 SET IDENTITY_INSERT \"{current_table}\" OFF;")
                out_lines.append("GO")
            out_lines.append(f"IF OBJECTPROPERTY(OBJECT_ID('{table}'), 'TableHasIdentity') = 1 SET IDENTITY_INSERT \"{table}\" ON;")
            out_lines.append("GO")
            current_table = table
        out_lines.append(line)
    elif line.startswith("INSERT INTO") or line.startswith("("):
        # Multi-line inserts or other inserts
        out_lines.append(line)
    else:
        # It could be data for the insert inside a string, keep it
        if current_table is not None:
             out_lines.append(line)

if current_table is not None:
    out_lines.append(f"IF OBJECTPROPERTY(OBJECT_ID('{current_table}'), 'TableHasIdentity') = 1 SET IDENTITY_INSERT \"{current_table}\" OFF;")
    out_lines.append("GO")

# Re-enable all foreign key constraints
out_lines.append("EXEC sp_msforeachtable \"ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL\";")
out_lines.append("GO")

with open(output_file, 'w', encoding='utf-8') as f:
    f.write('\n'.join(out_lines))

print(f"Generated {output_file} successfully!")
