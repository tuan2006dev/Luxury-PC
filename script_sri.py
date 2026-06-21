
import sys
content = open('src/main/resources/static/css/style.css', encoding='utf-8').read()

content = content.replace('''.sri-icon {
  font-size: 2rem;
  flex-shrink: 0;
}''', '''.sri-icon {
  font-size: 2rem;
  flex-shrink: 0;
  width: 60px;
  height: 60px;
}''')

open('src/main/resources/static/css/style.css', 'w', encoding='utf-8').write(content)

