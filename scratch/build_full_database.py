import re

with open(r'd:\Luxury-PC-main\init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    current_sql = f.read()

# Take schema up to section 6 (news_categories seed)
cutoff = current_sql.find("-- 7. INSERT USERS & ROLES SEED DATA")
if cutoff != -1:
    schema_part = current_sql[:cutoff].strip()
else:
    schema_part = current_sql.strip()

with open(r'd:\Luxury-PC-main\fixed_koko.sql', 'r', encoding='utf-8') as f:
    koko_content = f.read()

# Helper to extract a block between start pattern and end pattern or next section
def extract_block(text, start_pattern, end_pattern=None):
    m_start = re.search(start_pattern, text)
    if not m_start:
        return ""
    start_pos = m_start.start()
    if end_pattern:
        m_end = re.search(end_pattern, text[start_pos:])
        if m_end:
            return text[start_pos:start_pos + m_end.start()].strip()
    return text[start_pos:].strip()

# Extract Brands
brands_block = extract_block(koko_content, r"SET IDENTITY_INSERT brands ON;", r"SET IDENTITY_INSERT brands OFF;\s*DBCC CHECKIDENT")
if brands_block:
    brands_block += "\nSET IDENTITY_INSERT brands OFF;\nDBCC CHECKIDENT ('brands', RESEED, 20);\nGO\n"

# Extract Products
prods_block = extract_block(koko_content, r"SET IDENTITY_INSERT products ON;", r"SET IDENTITY_INSERT products OFF;\s*DBCC CHECKIDENT")
if prods_block:
    prods_block += "\nSET IDENTITY_INSERT products OFF;\nDBCC CHECKIDENT ('products', RESEED, 548);\nGO\n"

# Extract Vouchers
vouchers_block = extract_block(koko_content, r"SET IDENTITY_INSERT vouchers ON;", r"SET IDENTITY_INSERT vouchers OFF;\s*DBCC CHECKIDENT")
if vouchers_block:
    vouchers_block += "\nSET IDENTITY_INSERT vouchers OFF;\nDBCC CHECKIDENT ('vouchers', RESEED, 10);\nGO\n"

# Extract Flash Sales & Items
fs_block = extract_block(koko_content, r"SET IDENTITY_INSERT flash_sales ON;", r"SET IDENTITY_INSERT flash_sales OFF;\s*DBCC CHECKIDENT")
if fs_block:
    fs_block += "\nSET IDENTITY_INSERT flash_sales OFF;\nDBCC CHECKIDENT ('flash_sales', RESEED, 5);\nGO\n"

fsi_block = extract_block(koko_content, r"SET IDENTITY_INSERT flash_sale_items ON;", r"SET IDENTITY_INSERT flash_sale_items OFF;\s*DBCC CHECKIDENT")
if fsi_block:
    fsi_block += "\nSET IDENTITY_INSERT flash_sale_items OFF;\nDBCC CHECKIDENT ('flash_sale_items', RESEED, 20);\nGO\n"

# Extract PC Combos & Details
combo_block = extract_block(koko_content, r"SET IDENTITY_INSERT pc_combos ON;", r"SET IDENTITY_INSERT pc_combos OFF;\s*DBCC CHECKIDENT")
if combo_block:
    combo_block += "\nSET IDENTITY_INSERT pc_combos OFF;\nDBCC CHECKIDENT ('pc_combos', RESEED, 10);\nGO\n"

combo_det_block = extract_block(koko_content, r"SET IDENTITY_INSERT pc_combo_details ON;", r"SET IDENTITY_INSERT pc_combo_details OFF;\s*DBCC CHECKIDENT")
if combo_det_block:
    combo_det_block += "\nSET IDENTITY_INSERT pc_combo_details OFF;\nDBCC CHECKIDENT ('pc_combo_details', RESEED, 100);\nGO\n"

with open(r'd:\Luxury-PC-main\scratch\seed_full_data.sql', 'r', encoding='utf-8') as f:
    user_order_seed = f.read()

# Assemble
full_sql = f"""{schema_part}

-- --------------------------------------------------
-- 6.1 BASE BRANDS SEED DATA
-- --------------------------------------------------
{brands_block}

-- --------------------------------------------------
-- 6.2 BASE PRODUCTS SEED DATA
-- --------------------------------------------------
{prods_block}

-- --------------------------------------------------
-- 6.3 BASE VOUCHERS SEED DATA
-- --------------------------------------------------
{vouchers_block}

-- --------------------------------------------------
-- 6.4 BASE FLASH SALES & ITEMS
-- --------------------------------------------------
{fs_block}

{fsi_block}

-- --------------------------------------------------
-- 6.5 BASE PC COMBOS & DETAILS
-- --------------------------------------------------
{combo_block}

{combo_det_block}

{user_order_seed}
"""

with open(r'd:\Luxury-PC-main\init_luxurypc_full.sql', 'w', encoding='utf-8') as f:
    f.write(full_sql)

print(f"Full SQL assembled: {len(full_sql)} characters.")
