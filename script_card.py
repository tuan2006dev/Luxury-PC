
import sys
content = open('src/main/resources/static/css/style.css', encoding='utf-8').read()

content = content.replace('''.products-grid .product-card {
  flex: 0 0 calc(33.333% - 2px);
  min-width: calc(33.333% - 2px);
  scroll-snap-align: start;
}''', '''.products-grid .product-card {
  flex: 0 0 calc(33.333% - 1rem);
  min-width: calc(33.333% - 1rem);
  scroll-snap-align: start;
}''')

open('src/main/resources/static/css/style.css', 'w', encoding='utf-8').write(content)

