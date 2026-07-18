USE luxpcc;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

-- Update password to BCrypt hash of '123456' ($2a$10$wOaA32oQOf10iU3r.jGgL.0wZqE64U1rW0h.V46u0g/zZ.q72b9tK)
UPDATE users 
SET password = '$2a$10$wOaA32oQOf10iU3r.jGgL.0wZqE64U1rW0h.V46u0g/zZ.q72b9tK'
WHERE email = 'tuan9bledinhchinh@gmail.com';

-- Assign ADMIN role to tuan9bledinhchinh@gmail.com
DECLARE @AdminRoleId INT = (SELECT id FROM roles WHERE name = 'ADMIN');
DECLARE @TargetUserId INT = (SELECT id FROM users WHERE email = 'tuan9bledinhchinh@gmail.com');

IF @TargetUserId IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @TargetUserId AND role_id = @AdminRoleId)
    BEGIN
        INSERT INTO user_roles (user_id, role_id) VALUES (@TargetUserId, @AdminRoleId);
    END
END
ELSE
BEGIN
    PRINT 'User not found!';
END
