
import sys
content = open('src/main/resources/static/css/style.css', encoding='utf-8').read()

content = content.replace('''.products-grid.vertical-slider {
  display: flex;
  flex-wrap: wrap;
  align-content: flex-start;
  overflow-y: auto;
  overflow-x: hidden;
  height: 35rem; /* Fits approx 1 row */
  scroll-snap-type: y mandatory;
  padding-bottom: 0;
}''', '''.products-grid.vertical-slider {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  overflow-y: auto;
  overflow-x: hidden;
  max-height: 500px;
  scroll-snap-type: y mandatory;
  padding-bottom: 2rem;
}
.products-grid.vertical-slider .product-card {
  width: 100%;
  min-width: 0;
  max-width: none;
  flex: none;
}
''')

open('src/main/resources/static/css/style.css', 'w', encoding='utf-8').write(content)

