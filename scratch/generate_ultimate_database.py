import re

with open(r'd:\Luxury-PC-main\fixed_koko.sql', 'r', encoding='utf-8') as f:
    koko = f.read()

# 1. Base schema up to news_categories
with open(r'd:\Luxury-PC-main\init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    init_txt = f.read()

cutoff_news = init_txt.find("DBCC CHECKIDENT ('news_categories', RESEED, 5);\nGO")
schema_part = init_txt[:cutoff_news + len("DBCC CHECKIDENT ('news_categories', RESEED, 5);\nGO")].strip()

# 2. Extract Brands
brand_matches = re.findall(r'INSERT INTO brands\s*\([^)]+\)\s*VALUES\s*\([^;]+;', koko)
brands_sql = "SET IDENTITY_INSERT brands ON;\n" + "\n".join(brand_matches) + "\nSET IDENTITY_INSERT brands OFF;\nDBCC CHECKIDENT ('brands', RESEED, 20);\nGO\n"

# 3. Extract Products (Deduplicate by product ID)
prod_matches = re.findall(r'INSERT INTO products\s*\([^)]+\)\s*VALUES\s*\((\d+),\s*(.*?)\);', koko, re.DOTALL)
seen_pids = set()
unique_prod_lines = []
max_pid = 0
for pid_str, rest in prod_matches:
    pid = int(pid_str)
    if pid not in seen_pids:
        seen_pids.add(pid)
        if pid > max_pid:
            max_pid = pid
        # Clean newlines inside values
        rest_clean = rest.replace('\n', ' ').replace('\r', '')
        unique_prod_lines.append(f"INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES ({pid}, {rest_clean});")

# Sort by product ID
unique_prod_lines.sort(key=lambda x: int(re.search(r'VALUES \((\d+),', x).group(1)))

prods_sql = "SET IDENTITY_INSERT products ON;\n" + "\n".join(unique_prod_lines) + f"\nSET IDENTITY_INSERT products OFF;\nDBCC CHECKIDENT ('products', RESEED, {max_pid});\nGO\n"

# 4. Extract Vouchers
vouch_matches = re.findall(r'INSERT INTO vouchers\s*\([^)]+\)\s*VALUES\s*\([^;]+;', koko)
# Dedup vouchers
seen_v = set()
v_lines = []
for vm in vouch_matches:
    if vm not in seen_v:
        seen_v.add(vm)
        v_lines.append(vm)
vouchers_sql = "SET IDENTITY_INSERT vouchers ON;\n" + "\n".join(v_lines) + "\nSET IDENTITY_INSERT vouchers OFF;\nDBCC CHECKIDENT ('vouchers', RESEED, 10);\nGO\n"

# 5. Extract Flash Sales & Items
fs_matches = re.findall(r'INSERT INTO flash_sales\s*\([^)]+\)\s*VALUES\s*\([^;]+;', koko)
fs_sql = "SET IDENTITY_INSERT flash_sales ON;\n" + "\n".join(fs_matches) + "\nSET IDENTITY_INSERT flash_sales OFF;\nDBCC CHECKIDENT ('flash_sales', RESEED, 5);\nGO\n"

fsi_matches = re.findall(r'INSERT INTO flash_sale_items\s*\([^)]+\)\s*VALUES\s*\([^;]+;', koko)
fsi_sql = "SET IDENTITY_INSERT flash_sale_items ON;\n" + "\n".join(fsi_matches) + "\nSET IDENTITY_INSERT flash_sale_items OFF;\nDBCC CHECKIDENT ('flash_sale_items', RESEED, 20);\nGO\n"

# 6. Extract PC Combos & Details
pcc_matches = re.findall(r'INSERT INTO pc_combos\s*\([^)]+\)\s*VALUES\s*\([^;]+;', koko)
pcc_sql = "SET IDENTITY_INSERT pc_combos ON;\n" + "\n".join(pcc_matches) + "\nSET IDENTITY_INSERT pc_combos OFF;\nDBCC CHECKIDENT ('pc_combos', RESEED, 10);\nGO\n"

pccd_matches = re.findall(r'INSERT INTO pc_combo_details\s*\([^)]+\)\s*VALUES\s*\([^;]+;', koko)
pccd_sql = "SET IDENTITY_INSERT pc_combo_details ON;\n" + "\n".join(pccd_matches) + "\nSET IDENTITY_INSERT pc_combo_details OFF;\nDBCC CHECKIDENT ('pc_combo_details', RESEED, 100);\nGO\n"

# 7. Formatted Users & Orders
with open(r'd:\Luxury-PC-main\scratch\seed_full_data_formatted.sql', 'r', encoding='utf-8') as f:
    users_orders_sql = f.read()

final_sql = f"""{schema_part}

-- ----------------------------------------------------------------------------
-- 6.1 BASE BRANDS SEED DATA
-- ----------------------------------------------------------------------------
{brands_sql}

-- ----------------------------------------------------------------------------
-- 6.2 BASE PRODUCTS SEED DATA ({len(unique_prod_lines)} LINH KIỆN & PHẦN CỨNG CHUẨN)
-- ----------------------------------------------------------------------------
{prods_sql}

-- ----------------------------------------------------------------------------
-- 6.3 BASE VOUCHERS SEED DATA
-- ----------------------------------------------------------------------------
{vouchers_sql}

-- ----------------------------------------------------------------------------
-- 6.4 BASE FLASH SALES & ITEMS
-- ----------------------------------------------------------------------------
{fs_sql}
{fsi_sql}

-- ----------------------------------------------------------------------------
-- 6.5 BASE PC COMBOS & DETAILS
-- ----------------------------------------------------------------------------
{pcc_sql}
{pccd_sql}

{users_orders_sql}
"""

with open(r'd:\Luxury-PC-main\init_luxurypc_full.sql', 'w', encoding='utf-8') as f:
    f.write(final_sql)

print(f"Success! Products extracted: {len(unique_prod_lines)}, Max PID: {max_pid}")
