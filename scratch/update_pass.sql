USE LUXURYPC;
UPDATE users SET password = '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', status = 1 WHERE username = 'admin' OR username LIKE 'staff.%' OR email = 'nguyentruongq169@gmail.com';
SELECT id, username, email, password, status FROM users WHERE username = 'admin';
