
import sys
lines = open('src/main/resources/templates/index.html', encoding='utf-8').readlines()
new_lines = lines[:405] + lines[736:]
open('src/main/resources/templates/index.html', 'w', encoding='utf-8').writelines(new_lines)

