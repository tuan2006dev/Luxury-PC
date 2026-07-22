/* ======================================================
   LUXURY PC - Profile Master Script Loader (profile.js)
   Tự động nạp toàn bộ các tệp JS xử lý theo từng tab
   ====================================================== */
(function () {
    const tabScripts = [
        '/js/account/tabprofile/core.js',
        '/js/account/tabprofile/info.js',
        '/js/account/tabprofile/orders.js',
        '/js/account/tabprofile/vouchers.js',
        '/js/account/tabprofile/wishlist.js',
        '/js/account/tabprofile/security.js',
        '/js/account/tabprofile/notifications.js',
        '/js/account/tabprofile/address.js'
    ];

    tabScripts.forEach(src => {
        const script = document.createElement('script');
        script.src = src;
        script.async = false; // Đảm bảo thứ tự thực thi đồng bộ
        document.head.appendChild(script);
    });
})();