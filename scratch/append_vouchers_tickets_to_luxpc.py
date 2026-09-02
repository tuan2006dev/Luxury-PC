with open('luxpc.sql', 'r', encoding='utf-8') as f:
    luxpc_content = f.read()

with open('scratch/seed_vouchers_and_tickets.sql', 'r', encoding='utf-8') as f:
    vt_content = f.read()

# Strip any header settings from vt_content
vt_insert = vt_content.split("USE LUXURYPC;\nGO\n")[1]

# Remove previous sections if already present
if "-- 11. 20 MÃ GIẢM GIÁ VOUCHER" in luxpc_content:
    luxpc_content = luxpc_content.split("-- 11. 20 MÃ GIẢM GIÁ VOUCHER")[0].strip()

luxpc_content = luxpc_content.strip() + "\n\n" + vt_insert

with open('luxpc.sql', 'w', encoding='utf-8') as f:
    f.write(luxpc_content)

print("Updated luxpc.sql with 20 vouchers and 10 tickets successfully!")
