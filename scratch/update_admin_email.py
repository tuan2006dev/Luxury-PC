import re

with open('luxpc.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Replace user 1 admin email and valid password hash
sql = sql.replace(
    "(1, 'admin', 'admin@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.w5r4r24eatIAJIRGn2', N'Quản Trị Viên Hệ Thống'",
    "(1, 'admin', 'leecookcu@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Quản Trị Viên Hệ Thống'"
)

# Replace any other broken hashes for staff/users
sql = sql.replace(
    '$2a$10$79vW12jU9Gk2rOQ45jF78.w5r4r24eatIAJIRGn2',
    '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2'
)
sql = sql.replace(
    '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.',
    '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2'
)

with open('luxpc.sql', 'w', encoding='utf-8') as f:
    f.write(sql)

print('Updated luxpc.sql successfully!')
