with open('luxpc.sql', 'r', encoding='utf-8') as f:
    luxpc_content = f.read()

with open('scratch/seed_25_news.sql', 'r', encoding='utf-8') as f:
    news_seed_sql = f.read()

# Extract just the insert block from seed_25_news.sql
insert_block = """
-- ----------------------------------------------------------------------------
-- 10. 25 BÀI VIẾT TIN TỨC CHUẨN XÁC THEO 5 DANH MỤC (5 BÀI / DANH MỤC)
-- ----------------------------------------------------------------------------
""" + news_seed_sql.split("SET IDENTITY_INSERT news ON;")[1]

# Ensure we don't have duplicates in luxpc.sql
if "-- 10. 25 BÀI VIẾT TIN TỨC" in luxpc_content:
    luxpc_content = luxpc_content.split("-- 10. 25 BÀI VIẾT TIN TỨC")[0].strip()

luxpc_content = luxpc_content.strip() + "\n\n" + """-- ----------------------------------------------------------------------------
-- 10. 25 BÀI VIẾT TIN TỨC CHUẨN XÁC THEO 5 DANH MỤC (5 BÀI / DANH MỤC)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT news ON;""" + insert_block

with open('luxpc.sql', 'w', encoding='utf-8') as f:
    f.write(luxpc_content)

print("Updated luxpc.sql with 25 realistic news articles successfully!")
