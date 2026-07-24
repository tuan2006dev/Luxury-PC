/* Profile Wishlist Section Logic */

function removeFromWishlist(btn) {
  const wishlistId = btn?.dataset?.wishlistItemId;
  if (!wishlistId) return;
  fetch('/api/wishlist/remove/' + wishlistId, {
    method: 'DELETE',
    headers: { [csrfHeader]: csrfToken }
  })
    .then(res => res.json())
    .then(data => {
      toast(data.message || '✓ Đã xóa khỏi danh sách yêu thích.');
      if (data.success) setTimeout(() => location.reload(), 500);
    })
    .catch(err => {
      console.error('Remove wishlist error:', err);
      toast('Không thể xóa sản phẩm yêu thích.');
    });
}

function removeAllWishlist() {
  showConfirm('Bạn chắc chắn muốn xóa tất cả sản phẩm yêu thích?').then(confirmed => {
    if (!confirmed) return;
    fetch('/api/wishlist/remove-all', {
      method: 'DELETE',
      headers: { [csrfHeader]: csrfToken }
    })
      .then(res => res.json())
      .then(data => {
        toast(data.message || '✓ Đã xóa tất cả khỏi danh sách yêu thích.');
        if (data.success) setTimeout(() => location.reload(), 500);
      })
      .catch(err => {
        console.error('Remove all wishlist error:', err);
        toast('Không thể xóa danh sách yêu thích.');
      });
  });
}
