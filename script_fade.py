
import sys
content = open('src/main/resources/static/js/script.js', encoding='utf-8').read()

content = content.replace('''    filtered.forEach((card, i) => {
      card.classList.remove('hidden-by-filter');
      card.classList.remove('filter-fade-in');
      // Force reflow
      void card.offsetWidth;
      card.classList.add('filter-fade-in');
      card.style.animationDelay = \\ms\;
      productsGrid.appendChild(card);
    });''', '''    filtered.forEach((card, i) => {
      card.classList.remove('hidden-by-filter');
      card.classList.remove('filter-fade-in');
      // Remove scroll observer classes to prevent conflict with animation
      card.classList.remove('fade-in-up-visible');
      card.classList.remove('fade-in-up-hidden');
      card.style.transition = 'none'; // clear transition to prevent stutter
      
      // Force reflow
      void card.offsetWidth;
      
      card.style.transition = ''; // restore original CSS transition behavior after reflow
      card.classList.add('filter-fade-in');
      card.style.animationDelay = \\ms\;
      productsGrid.appendChild(card);
    });''')

open('src/main/resources/static/js/script.js', 'w', encoding='utf-8').write(content)

