import os
import sys
import re

img_dir = 'src/main/resources/static/images/products'
files = set(os.listdir(img_dir))

# 1. Build map of exact product ID to image file
id_to_file = {}
for f in files:
    m = re.search(r'_([0-9]+)\.(jpg|png|webp)$', f)
    if m:
        id_to_file[int(m.group(1))] = f

# 2. Specific dedicated clean images
specific_map = {
    1: 'i9_14900k.jpg',
    16: 'xigmatek_quantum_4af.jpg',
    256: 'ultra7_265f.jpg',
    257: 'i5_12400f.png',
    258: 'i7_14700f.jpg',
    259: 'gigabyte_z890_eagle.jpg',
    260: 'gigabyte_h610m.jpg',
    261: 'gigabyte_b760m_gaming.jpg',
    262: 'kingmax_horizon_5600.jpg',
    263: 'kingspec_heatsink_red.jpg',
    264: 'msi_rtx_5070ti_shadow.jpg',
    265: 'gigabyte_rtx_5080_windforce.jpg',
    266: 'msi_rtx_5060_ventus.jpg',
    267: 'zotac_rtx_5060ti_twin.png',
    268: 'kingston_nv3_1tb.jpg',
    269: 'kingspec_nvme_512gb.jpg',
    270: 'corsair_rm850e.jpg',
    271: 'cooler_master_mwe_650.jpg',
    272: 'fsp_hv_pro_650w.png',
    273: 'corsair_cx650.jpg',
    274: 'corsair_3500x_black.png',
    275: 'corsair_frame_4500x.jpg',
    276: 'corsair_nautilus_360.jpg',
    277: 'cooler_master_212_spectrum.jpg',
    278: 'i9_14900k.jpg',
    279: 'ultra9_285k.jpg',
    280: 'asus_rog_z790.jpg',
    281: 'proart_z790.jpg',
    282: 'corsair_dominator_64gb.jpg',
    283: 'gskill_trident_64gb.jpg',
    284: 'asus_rog_rtx_5090.jpg',
    285: 'samsung_990pro.jpg',
    286: 'rog_ryujin_360.jpg',
    307: 'rog_ryujin_360.jpg',
    308: 'corsair_nautilus_360.jpg',
    309: 'rog_ryujin_360.jpg',
    318: 'asus_rog_rtx_4090.jpg',
    319: 'msi_rtx_5060_ventus.jpg',
    320: '67516ee7-cfb7-4b5c-a4c8-e5986142addd_42.jpg',
    321: 'b63e560f-7c2b-4a68-9c94-63a2db14bd97_321.jpg',
    322: '8fc6934e-659b-42d6-8f00-e95ea46ac0e6_34.jpg',
    323: '034fd156-4269-44e8-8990-ac02b7777b37_36.jpg',
    324: '9e0e427f-258d-4526-981b-9dc93b94bcef_49.jpg',
}

def get_best_image(pid, name, cat, brand, curr_img):
    if pid in specific_map and specific_map[pid] in files:
        return specific_map[pid]
    if pid in id_to_file and id_to_file[pid] in files:
        return id_to_file[pid]
    
    n = name.lower()
    
    # 1. Cooling / Tản nhiệt (check before VGA/GPU to avoid name collision)
    if 'tản nhiệt nước' in n or 'tản nhiệt aio' in n or 'tản nhiệt khí' in n or 'tản nhiệt' in n or 'liquid cooler' in n or 'air cooler' in n or cat in [8, 13]:
        if 'nautilus' in n: return 'corsair_nautilus_360.jpg'
        if 'ryujin' in n or 'kraken' in n or 'liquid' in n or 'aio' in n or 'water' in n or '360' in n or '240' in n or 'coreliquid' in n:
            return 'rog_ryujin_360.jpg'
        if 'peerless' in n or 'assassin' in n or 'phantom' in n:
            return 'ca3120a1-03f7-4697-8733-cef6260be95b_489.jpg'
        if 'dark rock' in n:
            return '65a155e1-3950-409c-ab14-97a2f740e4f6_364.jpg'
        if 'pccooler' in n or 'k6' in n:
            return '1bb8555e-bf25-4aec-9c65-8863dd6f1e44_365.jpg'
        return 'cooler_master_212_spectrum.jpg'
        
    # 2. Case Fan (Quạt tản nhiệt)
    if 'fan' in n or 'quạt' in n or cat == 14:
        if 'qx120' in n or 'corsair' in n: return '636479cd-497a-41e9-9f8c-1d72c6e776c4_368.jpg'
        if 'tl-k12' in n or 'thermalright' in n: return '56e94511-8bf1-4d32-8669-cde51fa1dda6_506.jpg'
        return '949dc241-73a6-48c2-9dc2-e64df3fa679f_251.jpg'

    # 3. Keyboard
    if 'bàn phím' in n or 'keyboard' in n or cat == 15:
        return 'keyboard_default.png'
        
    # 4. Headset / Earphones
    if 'tai nghe' in n or 'headset' in n or 'headphones' in n or 'buds' in n or cat == 17:
        return 'headset_default.png'
        
    # 5. Mouse
    if 'chuột' in n or 'mouse' in n or cat == 16:
        return 'mouse_default.png'
        
    # 6. Monitor
    if 'màn hình' in n or 'monitor' in n or 'oled' in n or cat == 6:
        if 'zowie' in n or 'xl25' in n: return 'faa03135-3ffe-42d9-aff8-5ca5fa1dd171_179.jpg'
        return '5764811a-6769-4c36-8880-9c17e7d9db3f_152.jpg'

    # 7. CPU (Category 1)
    if cat == 1 or 'cpu' in n or 'intel' in n or 'ryzen' in n:
        if 'ultra 9' in n or '285k' in n: return 'ultra9_285k.jpg'
        if 'ultra 7' in n or '265' in n: return 'ultra7_265f.jpg'
        if '14700' in n: return 'i7_14700f.jpg'
        if '12400' in n: return 'i5_12400f.png'
        if 'amd' in n or 'ryzen' in n:
            if 'ryzen 9' in n or '7950' in n or '7900' in n: return '336c6c69-55e0-40b7-957d-03f227ab747c_2.jpg'
            if 'ryzen 7' in n or '7800' in n or '5800' in n: return 'c6283793-5cca-4a8b-bf49-e538d3c7288d_4.jpg'
            return '4b24c512-013f-46b8-86f9-6cd07717c494_6.jpg'
        return 'i9_14900k.jpg'
    
    # 8. GPU / VGA (Category 2 & 9)
    if cat in [2, 9] or 'card màn hình' in n or 'vga' in n or 'rtx' in n or 'geforce' in n or 'radeon' in n or 'rx ' in n:
        if '5090' in n: return 'asus_rog_rtx_5090.jpg'
        if '5080' in n: return 'gigabyte_rtx_5080_windforce.jpg'
        if '5070' in n: return 'msi_rtx_5070ti_shadow.jpg'
        if '5060 ti' in n: return 'zotac_rtx_5060ti_twin.png'
        if '5060' in n: return 'msi_rtx_5060_ventus.jpg'
        if '4090' in n: return 'asus_rog_rtx_4090.jpg'
        if '4080' in n: return 'b408c37a-725e-496c-98d5-743e157f6b05_32.jpg'
        if '4070 ti' in n or '4070 super' in n or '4070' in n:
            if 'super' in n: return '67516ee7-cfb7-4b5c-a4c8-e5986142addd_42.jpg'
            if 'ti' in n: return '602b1568-2345-4906-8273-a42484e458f7_33.jpg'
            return 'dae8035e-e1d1-4676-b32e-8ca167cec287_40.jpg'
        if '4060 ti' in n: return 'dac12a7a-15d9-4b2f-8318-8da0892e69a5_35.jpg'
        if '4060' in n: return '1003ecf1-22e2-4186-a8e0-daf466610d7f_41.jpg'
        if '3080' in n: return 'evga_rtx_3080.jpg'
        if '3070' in n: return '42318da8-7209-40b2-9995-2cd3dbdb740d_47.jpg'
        if '3060' in n: return '393be85d-a8d6-4055-b672-216903a19a16_37.jpg'
        if '3050' in n: return '4387e950-6c6b-48c5-95ae-11e48d1a0a42_44.jpg'
        if '7900' in n: return '8fc6934e-659b-42d6-8f00-e95ea46ac0e6_34.jpg'
        if '7800' in n: return '034fd156-4269-44e8-8990-ac02b7777b37_36.jpg'
        if '7600' in n: return '08f9fcb7-b5d5-414d-9ad5-3f8f4d5f298a_43.jpg'
        if '6700' in n: return 'a0a1c554-e01a-43fa-88a7-858f8008f6e5_52.jpg'
        if '6600' in n: return 'dfe44600-f5ce-488b-8d14-7db8db6eadf0_38.jpg'
        if 'pro w' in n: return 'radeon_pro_w7800.jpg'
        if 'arc a' in n: return 'b509dc96-cc52-4039-9632-a0ec4d2f7270_56.jpg'
        return 'asus_rog_rtx_4090.jpg'
        
    # 9. Mainboard (Category 4)
    if cat == 4 or 'bo mạch chủ' in n or 'mainboard' in n or 'z890' in n or 'z790' in n or 'b760' in n or 'h610' in n or 'b650' in n or 'x670' in n or 'b550' in n or 'b450' in n or 'a520' in n or 'a620' in n:
        if 'z890' in n: return 'gigabyte_z890_eagle.jpg'
        if 'hero' in n or 'dark hero' in n: return 'asus_rog_z790.jpg'
        if 'proart' in n or 'creator' in n: return 'proart_z790.jpg'
        if 'taichi' in n: return 'z790_taichi.jpg'
        if 'valkyrie' in n: return 'valkyrie_z790.jpg'
        if 'b760' in n or 'gaming plus' in n: return 'gigabyte_b760m_gaming.jpg'
        if 'h610' in n: return 'gigabyte_h610m.jpg'
        return 'z790_dark_kingpin.jpg'
        
    # 10. RAM (Category 3)
    if cat == 3 or 'ram' in n or 'ddr4' in n or 'ddr5' in n:
        if 'dominator' in n: return 'corsair_dominator_64gb.jpg'
        if 'trident' in n: return 'gskill_trident_64gb.jpg'
        if 'kingmax' in n or 'horizon' in n: return 'kingmax_horizon_5600.jpg'
        if 'kingspec' in n or 'heatsink' in n: return 'kingspec_heatsink_red.jpg'
        if 'vengeance' in n: return '0991b674-f512-443d-9e12-650dbc663474_82.jpg'
        if 'fury' in n: return '0485387e-4c55-41fa-8b8f-5550ba015c9f_63.jpg'
        if 't-force' in n or 'delta' in n: return 'b7b1af8c-b84c-48bb-a3a7-4a0ed1e2f85e_64.jpg'
        if 'hof' in n: return 'galax_hof_32gb.jpg'
        return 'galax_hof_32gb.jpg'
        
    # 11. Storage / SSD / HDD (Category 5, 7, 10)
    if cat in [5, 7, 10] or 'ssd' in n or 'nvme' in n or 'hdd' in n or 'thẻ nhớ' in n or 'ổ cứng' in n:
        if 't705' in n or 'gen5' in n: return 'crucial_t705_2tb.jpg'
        if '990 pro' in n or '980' in n: return 'samsung_990pro.jpg'
        if 'nv3' in n: return 'kingston_nv3_1tb.jpg'
        if 'kingspec' in n: return 'kingspec_nvme_512gb.jpg'
        if 'barracuda' in n or 'hdd pc' in n: return 'd5978f46-d314-4119-80aa-59168f5669bd_327.jpg'
        if 'ironwolf' in n or 'nas' in n or 'server' in n: return 'fdce89f4-a596-44f8-87c8-c05a3756a7d7_330.jpg'
        if 'thẻ nhớ' in n or 'sdxc' in n or 'microsd' in n: return '091dab4d-d95d-440a-9d93-bb48eda8e469_292.jpg'
        if 'storejet' in n or 'di động' in n: return '18400482-db50-4a78-a3b4-d4246331dea0_304.jpg'
        return 'sabrent_rocket_4tb.jpg'
        
    # 12. PSU / Nguồn (Category 11)
    if cat == 11 or 'nguồn' in n or 'psu' in n:
        if 'rm850' in n or 'rm1000' in n or 'shift' in n: return 'corsair_rm850e.jpg'
        if 'cx650' in n: return 'corsair_cx650.jpg'
        if 'mwe' in n: return 'cooler_master_mwe_650.jpg'
        if 'hv pro' in n: return 'fsp_hv_pro_650w.png'
        if 'hydro' in n: return '436cee84-93cf-4c92-9386-26d80c0b6a46_345.jpg'
        if 'thermaltake' in n or 'toughpower' in n: return '2bd05062-2191-4dcf-9d30-82f1c07fff56_346.jpg'
        return 'corsair_rm850e.jpg'
        
    # 13. Case / Vỏ máy tính (Category 12)
    if cat == 12 or 'vỏ' in n or 'case' in n or 'thùng' in n:
        if '4500x' in n: return 'corsair_frame_4500x.jpg'
        if 'quantum' in n: return 'xigmatek_quantum_4af.jpg'
        if 'king 95' in n: return 'ff30aaa5-6b0e-4acc-a79c-457eaeaf706e_350.jpg'
        if 'y60' in n: return '592529bf-2828-4ebe-8787-d05e8aa36459_351.jpg'
        if 'h9' in n: return 'd57fd8ba-973e-44ba-9156-82e55f66cd4b_479.jpg'
        if 'aios' in n: return 'c4fcfb0c-56ec-4bb5-a4c2-8233474210a2_487.jpg'
        return 'corsair_3500x_black.png'

    # Fallback
    if curr_img in files:
        return curr_img
    return 'corsair_3500x_black.png'

# Process file
with open('init_luxurypc_full.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

def replacer(match):
    pid_str = match.group(1)
    name_str = match.group(2)
    price_str = match.group(3)
    desc_str = match.group(4)
    old_img = match.group(5)
    cat_str = match.group(6)
    stock_str = match.group(7)
    rest_str = match.group(8)
    
    clean_name = name_str.strip('N\'')
    cat = int(cat_str)
    pid = int(pid_str)
    
    new_img = get_best_image(pid, clean_name, cat, rest_str, old_img)
    return f"({pid_str}, {name_str}, {price_str}, {desc_str}, '{new_img}', {cat_str}, {stock_str}, {rest_str})"

row_pattern = re.compile(r'\((\d+),\s*(N?\'(?:[^\']|\'\')*\'),\s*([^,]+),\s*(N?\'(?:[^\']|\'\')*\'|NULL),\s*\'([^\']+)\',\s*(\d+),\s*(\d+),\s*([^\)]+)\)')

updated_sql = row_pattern.sub(replacer, sql)

with open('init_luxurypc_full.sql', 'w', encoding='utf-8') as f:
    f.write(updated_sql)

print('Updated init_luxurypc_full.sql successfully!')
