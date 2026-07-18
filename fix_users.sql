USE luxpcc;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

-- 1. Ensure ADMIN role exists
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ADMIN')
BEGIN
    INSERT INTO roles (name) VALUES ('ADMIN');
END

-- 2. Update passwords to BCrypt hash of '123456' ($2a$10$o5758o7JwCDtS8hzgdr3M.KQPP1swe5qGUmcop7tyx1PYhLevtyr2)
UPDATE users 
SET password = '$2a$10$o5758o7JwCDtS8hzgdr3M.KQPP1swe5qGUmcop7tyx1PYhLevtyr2'
WHERE email IN ('demo@luxurypc.vn', 'nguyentruongq169@gmail.com', 'tuan9bledinhchinh@gmail.com');

-- 3. Assign ADMIN role to demo@luxurypc.vn
DECLARE @AdminRoleId INT = (SELECT id FROM roles WHERE name = 'ADMIN');
DECLARE @DemoUserId INT = (SELECT id FROM users WHERE email = 'demo@luxurypc.vn');
DECLARE @NguyenUserId INT = (SELECT id FROM users WHERE email = 'nguyentruongq169@gmail.com');

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @DemoUserId AND role_id = @AdminRoleId)
BEGIN
    INSERT INTO user_roles (user_id, role_id) VALUES (@DemoUserId, @AdminRoleId);
END

IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @NguyenUserId AND role_id = @AdminRoleId)
BEGIN
    INSERT INTO user_roles (user_id, role_id) VALUES (@NguyenUserId, @AdminRoleId);
END
