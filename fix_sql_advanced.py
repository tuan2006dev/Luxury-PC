import re

# Load actual columns
actual_cols_set = set()
with open('actual_columns.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('-'): continue
        parts = line.split('.')
        if len(parts) == 2:
            table = parts[0].lower()
            col = parts[1].lower()
            actual_cols_set.add(f"{table}.{col}")

print(f"Loaded {len(actual_cols_set)} actual columns from SQL Server.")

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

def parse_values(val_str):
    values = []
    current_val = []
    in_string = False
    escape = False
    for char in val_str:
        if in_string:
            if char == "'" and not escape:
                in_string = False
            elif char == "\\":
                escape = True # Might not be true for SQL server, but standard PG dumps use it or ''
            else:
                escape = False
            current_val.append(char)
        else:
            if char == "'":
                in_string = True
                current_val.append(char)
            elif char == ",":
                values.append("".join(current_val).strip())
                current_val = []
            elif char in "()":
                pass
            else:
                current_val.append(char)
    if current_val:
        values.append("".join(current_val).strip())
    return values

lines = content.split('\n')
out_lines = []

out_lines.append("SET QUOTED_IDENTIFIER ON;")
out_lines.append("GO")
out_lines.append("EXEC sp_msforeachtable \"ALTER TABLE ? NOCHECK CONSTRAINT ALL\";")
out_lines.append("GO")

current_table = None

# We need to process INSERT lines properly
import sys

for line in lines:
    if line.strip() == "" or line.upper().startswith("CREATE ") or line.upper().startswith("ALTER ") or line.upper().startswith("DROP ") or line.upper() == "GO":
        continue
    
    m = re.match(r'^INSERT INTO\s+"([^"]+)"\s+VALUES\s+\((.*)\);$', line, re.IGNORECASE)
    if m:
        table = m.group(1)
        val_str = m.group(2)
        
        # Check table
        if table != current_table:
            if current_table is not None:
                out_lines.append(f"IF OBJECTPROPERTY(OBJECT_ID('{current_table}'), 'TableHasIdentity') = 1 SET IDENTITY_INSERT \"{current_table}\" OFF;")
                out_lines.append("GO")
            out_lines.append(f"IF OBJECTPROPERTY(OBJECT_ID('{table}'), 'TableHasIdentity') = 1 SET IDENTITY_INSERT \"{table}\" ON;")
            out_lines.append("GO")
            current_table = table
            
        if table in tables:
            orig_cols = tables[table]
            vals = parse_values(val_str)
            
            # Map valid columns
            valid_cols = []
            valid_vals = []
            
            # Some dumps might have values spread across lines? No, if it matches our regex, it's a single line.
            # If length mismatch, just fallback to full line (could be error)
            if len(vals) == len(orig_cols):
                for i in range(len(orig_cols)):
                    col_name = orig_cols[i]
                    if f"{table.lower()}.{col_name.lower()}" in actual_cols_set:
                        valid_cols.append(col_name)
                        valid_vals.append(vals[i])
                
                col_str = ", ".join([f'"{c}"' for c in valid_cols])
                val_str_joined = ", ".join(valid_vals)
                out_lines.append(f"INSERT INTO \"{table}\" ({col_str}) VALUES ({val_str_joined});")
            else:
                # Mismatch, maybe commas inside strings were not parsed perfectly
                out_lines.append(line)
        else:
            out_lines.append(line)
    elif line.startswith("INSERT INTO") or line.startswith("("):
        # Unhandled format
        out_lines.append(line)
    else:
        if current_table is not None:
             out_lines.append(line)

if current_table is not None:
    out_lines.append(f"IF OBJECTPROPERTY(OBJECT_ID('{current_table}'), 'TableHasIdentity') = 1 SET IDENTITY_INSERT \"{current_table}\" OFF;")
    out_lines.append("GO")

out_lines.append("EXEC sp_msforeachtable \"ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL\";")
out_lines.append("GO")

with open(output_file, 'w', encoding='utf-8') as f:
    f.write('\n'.join(out_lines))

print(f"Generated {output_file} successfully!")
