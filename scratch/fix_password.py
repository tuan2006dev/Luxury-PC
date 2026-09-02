import subprocess

# Exact BCrypt hash for '123456'
pw_hash = '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2'

with open('scratch/update_pass.sql', 'w', encoding='utf-8') as f:
    f.write(f"""USE LUXURYPC;
UPDATE users SET password = '{pw_hash}', status = 1 WHERE username = 'admin' OR username LIKE 'staff.%' OR email = 'nguyentruongq169@gmail.com';
SELECT id, username, email, password, status FROM users WHERE username = 'admin';
""")

cmd = ['sqlcmd', '-S', 'localhost', '-U', 'tuan2006', '-P', '24112004', '-C', '-f', '65001', '-i', 'scratch/update_pass.sql']
res = subprocess.run(cmd, capture_output=True, text=True)
print(res.stdout)
