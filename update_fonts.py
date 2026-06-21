import os
import re

css_dir = r"c:\Users\tuan\Downloads\LuxuryPC404\LuxuryPC\src\main\resources\static\css"

font_vars = {
    "--font-main": "var(--font-sans)",
    "--font-serif": "var(--font-serif)",
    "--sans": "var(--font-sans)",
    "--serif": "var(--font-serif)",
}

for root, _, files in os.walk(css_dir):
    for f in files:
        if f.endswith('.css'):
            path = os.path.join(root, f)
            with open(path, 'r', encoding='utf-8') as file:
                content = file.read()
            
            new_content = content
            
            # Use regex to find and replace the values of these variables
            for var, new_val in font_vars.items():
                # Matches: --var-name: some-value;
                pattern = re.compile(rf"({var}\s*:\s*)[^;]+(;)")
                new_content = pattern.sub(rf"\1{new_val}\2", new_content)
                
            if content != new_content:
                with open(path, 'w', encoding='utf-8') as file:
                    file.write(new_content)
                print(f"Updated {path}")
