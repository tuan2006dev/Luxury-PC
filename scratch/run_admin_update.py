import subprocess

sql = """SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
USE LUXURYPC;
GO

-- 1. Ensure ADMIN role exists
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ADMIN')
    INSERT INTO roles (name) VALUES ('ADMIN');
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'STAFF')
    INSERT INTO roles (name) VALUES ('STAFF');
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'USER')
    INSERT INTO roles (name) VALUES ('USER');
GO

-- 2. Update user 1 to leecookcu@gmail.com with password '123456'
UPDATE users 
SET email = 'leecookcu@gmail.com',
    password = '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2',
    status = 1
WHERE id = 1 OR username = 'admin' OR email = 'admin@luxurypc.vn';
GO

-- 3. Ensure role ADMIN is assigned to user 1
DECLARE @AdminRoleId INT, @AdminUserId INT;
SELECT @AdminRoleId = id FROM roles WHERE name = 'ADMIN';
SELECT @AdminUserId = id FROM users WHERE email = 'leecookcu@gmail.com' OR username = 'admin';

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @AdminUserId AND role_id = @AdminRoleId)
BEGIN
    INSERT INTO user_roles (user_id, role_id) VALUES (@AdminUserId, @AdminRoleId);
END
GO

SELECT u.id, u.username, u.email, u.status, r.name AS role_name 
FROM users u 
JOIN user_roles ur ON u.id = ur.user_id 
JOIN roles r ON ur.role_id = r.id 
WHERE u.email = 'leecookcu@gmail.com' OR u.username = 'admin';
GO
"""

with open('scratch/update_admin_db.sql', 'w', encoding='utf-8') as f:
    f.write(sql)

cmd = ['sqlcmd', '-S', 'localhost', '-U', 'tuan2006', '-P', '24112004', '-C', '-f', '65001', '-i', 'scratch/update_admin_db.sql']
res = subprocess.run(cmd, capture_output=True, text=True)
print(res.stdout)
