
import sys
content = open('src/main/resources/static/css/style.css', encoding='utf-8').read()

# Make the grid have standard gaps and no weird background block
content = content.replace('''.products-grid {
  display: flex;
  flex-direction: row;
  overflow-x: auto;
  overflow-y: hidden;
  gap: 2px;
  background: rgba(201, 168, 76, 0.08);''', '''.products-grid {
  display: flex;
  flex-direction: row;
  overflow-x: auto;
  overflow-y: hidden;
  gap: 1.5rem;
  background: transparent;
  padding: 1rem 0;''')

content = content.replace('''  scrollbar-color: rgba(201, 168, 76, 0.5) rgba(201, 168, 76, 0.08);
}''', '''  scrollbar-color: rgba(201, 168, 76, 0.5) transparent;
}''')

open('src/main/resources/static/css/style.css', 'w', encoding='utf-8').write(content)

