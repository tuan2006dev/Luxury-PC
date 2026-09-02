import os
import re

image_dir = r"c:\Backend\Luxury-PC\src\main\resources\static\images\image"
files = os.listdir(image_dir)

print(f"Total files in image dir: {len(files)}")

# Pattern: 001_Name_main.ext
pattern = re.compile(r"^(\d{3})_(.+?)_(main|sub1|sub2|sub3)\.(jpg|jpeg|png|webp|gif|avif)$", re.IGNORECASE)

product_files = {} # stt (int) -> {'main': filename, 'sub1': filename, 'sub2': filename, 'sub3': filename}

for f in files:
    m = pattern.match(f)
    if m:
        stt = int(m.group(1))
        name = m.group(2)
        img_type = m.group(3).lower()
        if stt not in product_files:
            product_files[stt] = {}
        product_files[stt][img_type] = f

print(f"Total unique product STTs with images: {len(product_files)}")
print(f"Sample STT 1: {product_files.get(1)}")
print(f"Sample STT 2: {product_files.get(2)}")
print(f"Sample STT 540: {product_files.get(540)}")
