USE luxpcc;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @Email NVARCHAR(255) = 'tuan9bledinhchinh@gmail.com';
DECLARE @Password NVARCHAR(255) = '$2a$10$wOaA32oQOf10iU3r.jGgL.0wZqE64U1rW0h.V46u0g/zZ.q72b9tK'; -- 123456
DECLARE @AdminRoleId INT = (SELECT id FROM roles WHERE name = 'ADMIN');
DECLARE @TargetUserId INT;

-- Insert user if not exists
IF NOT EXISTS (SELECT 1 FROM users WHERE email = @Email)
BEGIN
    INSERT INTO users (email, password, full_name, status, auth_provider, created_at, notify_order_updates, notify_flash_sale, notify_new_products, notify_weekly_newsletter, two_factor_enabled)
    VALUES (@Email, @Password, 'Admin', 1, 'LOCAL', GETDATE(), 1, 1, 0, 1, 0);
END

SET @TargetUserId = (SELECT id FROM users WHERE email = @Email);

-- Assign ADMIN role
IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @TargetUserId AND role_id = @AdminRoleId)
BEGIN
    INSERT INTO user_roles (user_id, role_id) VALUES (@TargetUserId, @AdminRoleId);
END
