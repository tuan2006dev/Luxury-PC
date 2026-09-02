import sys, re
sys.stdout.reconfigure(encoding='utf-8')

from process_updates import updates

lines = [
    "USE LUXURYPC;",
    "GO",
    ""
]

for pid in sorted(updates.keys()):
    brand, desc = updates[pid]
    escaped_desc = desc.replace("'", "''")
    if brand is None or brand == 'NULL':
        brand_val = "NULL"
    else:
        escaped_brand = brand.replace("'", "''")
        brand_val = f"N'{escaped_brand}'"
    lines.append(f"UPDATE products SET brand = {brand_val}, description = N'{escaped_desc}' WHERE id = {pid};")

lines.append("GO")
lines.append("SELECT COUNT(*) AS total_products, COUNT(brand) AS products_with_brand FROM products;")
lines.append("GO")

content = "\n".join(lines) + "\n"

with open("d:/Luxury-PC-main/scratch/update_products_exec.sql", "w", encoding="utf-8") as f:
    f.write(content)

print(f"Generated SQL with {len(updates)} UPDATE statements in scratch/update_products_exec.sql")
