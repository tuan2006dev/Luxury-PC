import os, glob

for root, dirs, files in os.walk('d:/Luxury-PC-main'):
    if '.git' in root or 'node_modules' in root or 'target' in root or '.system_generated' in root:
        continue
    for f in files:
        path = os.path.join(root, f)
        try:
            with open(path, 'r', encoding='utf-8', errors='ignore') as file:
                content = file.read()
                if '558' in content or '543' in content:
                    lines = [l.strip() for l in content.splitlines() if '558' in l or '543' in l]
                    print(path, f'matches: {len(lines)}')
                    for l in lines[:3]:
                        print('  ', l[:100])
        except Exception:
            pass
