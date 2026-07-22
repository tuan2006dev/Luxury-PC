/* ======================================================
   LUXURY PC - Profile Wishlist Tab Script (wishlist.js)
   ====================================================== */

function removeFromWishlist(btn, itemId) {
    let wishlistId = itemId;
    if (!wishlistId && btn) {
        wishlistId = (btn.getAttribute ? btn.getAttribute('data-wishlist-item-id') : null) || btn.dataset?.wishlistItemId;
    }
    if (!wishlistId && window.event && window.event.target) {
        const targetBtn = window.event.target.closest('[data-wishlist-item-id]');
        if (targetBtn) wishlistId = targetBtn.getAttribute('data-wishlist-item-id');
    }

    if (!wishlistId) {
        console.error("removeFromWishlist error: Missing wishlist item ID");
        return;
    }

    const doDelete = function () {
        const headers = { 'Content-Type': 'application/json' };
        const token = document.querySelector('meta[name="_csrf"]')?.content || document.querySelector('input[name="_csrf"]')?.value;
        const headerName = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
        if (token) headers[headerName] = token;

        fetch('/api/wishlist/remove/' + wishlistId, {
            method: 'POST',
            headers: headers
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (typeof toast === 'function') toast(data.message || '✓ Đã xóa khỏi danh sách yêu thích.');
                const card = btn?.closest ? btn.closest('.wl-card') : document.querySelector(`[data-wishlist-item-id="${wishlistId}"]`)?.closest('.wl-card');
                if (card) {
                    card.remove();
                    const remainingCards = document.querySelectorAll('.wl-card');
                    if (remainingCards.length === 0) {
                        setTimeout(() => reloadProfileTab('wishlist'), 300);
                    }
                } else {
                    setTimeout(() => reloadProfileTab('wishlist'), 300);
                }
            } else {
                if (typeof toast === 'function') toast('⚠️ ' + (data.message || 'Không thể xóa sản phẩm yêu thích.'));
            }
        })
        .catch(err => {
            console.error('Remove wishlist error:', err);
            if (typeof toast === 'function') toast('⚠️ Không thể xóa sản phẩm yêu thích.');
        });
    };

    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Xác Nhận',
            text: 'Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then(result => {
            if (result.isConfirmed) doDelete();
        });
    } else if (typeof window.showConfirm === 'function') {
        window.showConfirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?').then(confirmed => {
            if (confirmed) doDelete();
        });
    } else {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?')) {
            doDelete();
        }
    }
}

function removeAllWishlist() {
    const doClear = function () {
        const headers = { 'Content-Type': 'application/json' };
        const token = document.querySelector('meta[name="_csrf"]')?.content || document.querySelector('input[name="_csrf"]')?.value;
        const headerName = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
        if (token) headers[headerName] = token;

        fetch('/api/wishlist/remove-all', {
            method: 'POST',
            headers: headers
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (typeof toast === 'function') toast(data.message || '✓ Đã xóa tất cả khỏi danh sách yêu thích.');
                setTimeout(() => reloadProfileTab('wishlist'), 400);
            } else {
                if (typeof toast === 'function') toast('⚠️ ' + (data.message || 'Không thể xóa danh sách yêu thích.'));
            }
        })
        .catch(err => {
            console.error('Remove all wishlist error:', err);
            if (typeof toast === 'function') toast('⚠️ Không thể xóa danh sách yêu thích.');
        });
    };

    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Xác Nhận',
            text: 'Bạn chắc chắn muốn xóa tất cả sản phẩm yêu thích?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then(result => {
            if (result.isConfirmed) doClear();
        });
    } else if (typeof window.showConfirm === 'function') {
        window.showConfirm('Bạn chắc chắn muốn xóa tất cả sản phẩm yêu thích?').then(confirmed => {
            if (confirmed) doClear();
        });
    } else {
        if (confirm('Bạn chắc chắn muốn xóa tất cả sản phẩm yêu thích?')) {
            doClear();
        }
    }
}
