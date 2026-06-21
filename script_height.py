
import sys
content = open('src/main/resources/static/css/style.css', encoding='utf-8').read()

content = content.replace('''.products-grid.vertical-slider {
  display: flex;
  flex-wrap: wrap;
  align-content: flex-start;
  overflow-y: auto;
  overflow-x: hidden;
  max-height: 850px;
  scroll-snap-type: y mandatory;
  padding-bottom: 0;
}''', '''.products-grid.vertical-slider {
  display: flex;
  flex-wrap: wrap;
  align-content: flex-start;
  overflow-y: auto;
  overflow-x: hidden;
  height: 35rem; /* Fits approx 1 row */
  scroll-snap-type: y mandatory;
  padding-bottom: 0;
}''')

open('src/main/resources/static/css/style.css', 'w', encoding='utf-8').write(content)

