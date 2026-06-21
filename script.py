import sys
html = open('src/main/resources/templates/layout/footer.html', encoding='utf-8').read()
chatbot_code = open('temp_chat.txt', encoding='utf-8').read()

cart_popup_code = """
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const forms = document.querySelectorAll('form[action="/cart/add"]');
      if(forms.length > 0) {
        forms.forEach(form => {
          form.addEventListener('submit', function(e) {
            if (e.submitter && e.submitter.getAttribute('formaction') === '/cart/buy-now') {
              return;
            }
            e.preventDefault();
            const formData = new FormData(this);
            fetch(this.action, {
              method: 'POST',
              body: formData,
              redirect: 'follow'
            }).then(res => {
               document.getElementById('cart-popup').style.display = 'block';
               let currentCount = parseInt(document.getElementById('cart-count')?.textContent || '0');
               let addedQty = parseInt(this.querySelector('input[name="qty"]')?.value || '1');
               if(document.getElementById('cart-count')) {
                   document.getElementById('cart-count').textContent = currentCount + addedQty;
               }
            });
          });
        });
      }
    });
  </script>

  <div id="cart-popup" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%); background:var(--deep); padding:2rem; border:1px solid var(--gold); z-index:9000; color:var(--white); text-align:center; border-radius:8px; min-width:300px; box-shadow:0 10px 30px rgba(0,0,0,0.5);">
    <div style="font-size:3rem; color:var(--gold); margin-bottom:1rem;">✓</div>
    <h3 style="font-family:var(--sans); font-weight: 400; margin-bottom:1rem; color:var(--white);">Thêm vào giỏ hàng thành công!</h3>
    <div style="margin-top:2rem; display:flex; gap:1rem; justify-content:center;">
      <button onclick="document.getElementById('cart-popup').style.display='none'" style="padding:0.8rem 1.5rem; background:transparent; border:1px solid var(--gold); color:var(--gold); cursor:pointer; font-weight:bold; border-radius:4px;">Tiếp tục mua sắm</button>
      <button onclick="location.href='/cart'" style="padding:0.8rem 1.5rem; background:var(--gold); border:none; color:var(--black); cursor:pointer; font-weight:bold; border-radius:4px;">Xem giỏ hàng</button>
    </div>
  </div>
"""

new_html = html.replace('</div>\n</body>', chatbot_code + '\n' + cart_popup_code + '\n</div>\n</body>')
open('src/main/resources/templates/layout/footer.html', 'w', encoding='utf-8').write(new_html)
