import os
import re

directory = 'src/main/resources'

for root, _, files in os.walk(directory):
    for file in files:
        if file.endswith('.html') or file.endswith('.css'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            new_content = content
            # Font family URL
            new_content = re.sub(r'family=Cormorant\+Garamond[^&]*&family=Montserrat[^&]*&', r'family=Outfit:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&', new_content)
            
            # CSS variables
            new_content = re.sub(r"--serif:\s*['\"]Cormorant Garamond['\"][^;]*;", r"--serif: 'Outfit', sans-serif;", new_content)
            new_content = re.sub(r"--sans:\s*['\"]Montserrat['\"][^;]*;", r"--sans: 'Inter', sans-serif;", new_content)
            
            # For style.css
            new_content = re.sub(r"--font-serif:\s*['\"]Inter['\"][^;]*;", r"--font-serif: 'Outfit', sans-serif;", new_content)

            if content != new_content:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated fonts in {path}")
