function openModal() { document.getElementById('flashSaleModal').classList.add('show'); }
function closeModal() { document.getElementById('flashSaleModal').classList.remove('show'); }
document.getElementById('flashSaleModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
