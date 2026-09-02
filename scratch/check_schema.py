import os
import re
import subprocess

# Get all tables and columns from SQL Server
cmd = ['sqlcmd', '-S', 'localhost', '-U', 'tuan2006', '-P', '24112004', '-C', '-Q', 'USE LUXURYPC; SELECT t.name AS table_name, c.name AS column_name FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id ORDER BY t.name, c.name;']
res = subprocess.run(cmd, capture_output=True, text=True)

db_cols = {}
for line in res.stdout.splitlines():
    parts = line.split()
    if len(parts) >= 2 and parts[0] != 'table_name' and not parts[0].startswith('---'):
        t = parts[0].lower()
        c = parts[1].lower()
        if t not in db_cols:
            db_cols[t] = set()
        db_cols[t].add(c)

# Scan Java entities
entity_dir = 'src/main/java/poly/edu/entity'
for f in os.listdir(entity_dir):
    if f.endswith('.java'):
        with open(os.path.join(entity_dir, f), 'r', encoding='utf-8') as jf:
            content = jf.read()
        
        tm = re.search(r'@Table\s*\(\s*name\s*=\s*"([^"]+)"\)', content)
        if tm:
            tname = tm.group(1).lower()
        else:
            tname = f[:-5].lower() + 's'
            
        if tname in db_cols:
            cols = re.findall(r'@Column\s*\([^)]*name\s*=\s*"([^"]+)"', content)
            join_cols = re.findall(r'@JoinColumn\s*\([^)]*name\s*=\s*"([^"]+)"', content)
            
            for ec in cols + join_cols:
                if ec.lower() not in db_cols[tname]:
                    print(f'MISSING in DB: Table `{tname}` missing column `{ec}` (from entity {f})')
