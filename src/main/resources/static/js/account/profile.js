function toggleOrder(orderId) {
            const pane = document.getElementById(orderId);
            if (pane.classList.contains('active')) {
              pane.classList.remove('active');
            } else {
              // Close others
              document.querySelectorAll('.order-details-pane').forEach(el => el.classList.remove('active'));
              pane.classList.add('active');
            }
          }