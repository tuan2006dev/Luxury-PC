import re

with open(r'd:\Luxury-PC-main\init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Extract clean schema up to Section 6
cutoff_news = text.find("-- --------------------------------------------------\n-- 6. BASE NEWS CATEGORIES SEED DATA")
if cutoff_news != -1:
    end_news = text.find("DBCC CHECKIDENT ('news_categories', RESEED, 5);\nGO", cutoff_news)
    schema_base = text[:end_news + len("DBCC CHECKIDENT ('news_categories', RESEED, 5);\nGO")].strip()
else:
    print("Could not find section 6")
    schema_base = text[:text.find("-- 6.1 BASE BRANDS SEED DATA")].strip()

# 2. Extract base data from fixed_koko
with open(r'd:\Luxury-PC-main\fixed_koko.sql', 'r', encoding='utf-8') as f:
    koko = f.read()

def extract_exact(content, start_str, end_str):
    p1 = content.find(start_str)
    if p1 == -1:
        return ""
    p2 = content.find(end_str, p1)
    if p2 == -1:
        return ""
    return content[p1:p2 + len(end_str)].strip()

brands_block = extract_exact(koko, "SET IDENTITY_INSERT brands ON;", "DBCC CHECKIDENT ('brands', RESEED, 20);\nGO")
if not brands_block:
    brands_block = extract_exact(koko, "SET IDENTITY_INSERT brands ON;", "DBCC CHECKIDENT ('brands', RESEED") + " ('brands', RESEED, 20);\nGO"

prods_block = extract_exact(koko, "SET IDENTITY_INSERT products ON;", "DBCC CHECKIDENT ('products', RESEED, 548);\nGO")
if not prods_block:
    p_end = koko.find("SET IDENTITY_INSERT products OFF;\nDBCC CHECKIDENT", koko.find("SET IDENTITY_INSERT products ON;"))
    p_go = koko.find("GO", p_end)
    prods_block = koko[koko.find("SET IDENTITY_INSERT products ON;"):p_go+2].strip()

vouchers_block = extract_exact(koko, "SET IDENTITY_INSERT vouchers ON;", "DBCC CHECKIDENT ('vouchers', RESEED, 5);\nGO")
if not vouchers_block:
    v_end = koko.find("SET IDENTITY_INSERT vouchers OFF;\nDBCC CHECKIDENT", koko.find("SET IDENTITY_INSERT vouchers ON;"))
    v_go = koko.find("GO", v_end)
    vouchers_block = koko[koko.find("SET IDENTITY_INSERT vouchers ON;"):v_go+2].strip()

fs_block = extract_exact(koko, "SET IDENTITY_INSERT flash_sales ON;", "DBCC CHECKIDENT ('flash_sales', RESEED, 2);\nGO")
fsi_block = extract_exact(koko, "SET IDENTITY_INSERT flash_sale_items ON;", "DBCC CHECKIDENT ('flash_sale_items', RESEED, 14);\nGO")
pcc_block = extract_exact(koko, "SET IDENTITY_INSERT pc_combos ON;", "DBCC CHECKIDENT ('pc_combos', RESEED, 7);\nGO")
pccd_block = extract_exact(koko, "SET IDENTITY_INSERT pc_combo_details ON;", "DBCC CHECKIDENT ('pc_combo_details', RESEED, 64);\nGO")

with open(r'd:\Luxury-PC-main\scratch\seed_full_data_formatted.sql', 'r', encoding='utf-8') as f:
    users_and_orders_block = f.read()

final_clean_sql = f"""{schema_base}

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
{pcc_block}

{pccd_block}

{users_and_orders_block}
"""

with open(r'd:\Luxury-PC-main\init_luxurypc_full.sql', 'w', encoding='utf-8') as f:
    f.write(final_clean_sql)

print("Final clean SQL generated successfully!")
