import os
import shutil

base_dir = r"c:\Users\tuan\Downloads\LuxuryPC404\LuxuryPC\src\main\java\poly\edu\controller"

categories = {
    "admin": [],
    "api": [],
    "auth": [],
    "web": []
}

for f in os.listdir(base_dir):
    if not f.endswith(".java"):
        continue
    
    # Categorize
    if f.startswith("Admin"):
        categories["admin"].append(f)
    elif "Api" in f or "Rest" in f:
        categories["api"].append(f)
    elif "Auth" in f:
        categories["auth"].append(f)
    else:
        categories["web"].append(f)

# Create directories and move files
for category, files in categories.items():
    cat_dir = os.path.join(base_dir, category)
    os.makedirs(cat_dir, exist_ok=True)
    
    for f in files:
        src = os.path.join(base_dir, f)
        dst = os.path.join(cat_dir, f)
        
        # Read content and update package
        with open(src, "r", encoding="utf-8") as file:
            content = file.read()
            
        content = content.replace("package poly.edu.controller;", f"package poly.edu.controller.{category};")
        
        # Write to new location
        with open(dst, "w", encoding="utf-8") as file:
            file.write(content)
            
        # Delete original file
        os.remove(src)
        print(f"Moved {f} to {category}")

print("Done reorganizing controllers.")
