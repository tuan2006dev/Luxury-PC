/* ======================================================
   LUXURY PC - Firebase Phone Authentication Module
   10,000 SMS/month FREE Tier by Google Firebase
   ====================================================== */

// Standard Firebase Configuration (Can be replaced with your Firebase Project config)
const firebaseConfig = {
    apiKey: "AIzaSyAnwGmcPDEJeJv4svEfDnsSAyK86bKQ8UU",
    authDomain: "luxurypc-948f2.firebaseapp.com",
    projectId: "luxurypc-948f2",
    storageBucket: "luxurypc-948f2.firebasestorage.app",
    messagingSenderId: "1077647934361",
    appId: "1:1077647934361:web:ef6de6f92fbf7cdc2c0908",
    measurementId: "G-ELTWHD5VYQ"
};

let confirmationResultGlobal = null;
let recaptchaVerifierGlobal = null;

// Initialize Firebase if not already initialized
function initFirebasePhoneAuth() {
    if (typeof firebase !== 'undefined' && !firebase.apps.length) {
        try {
            firebase.initializeApp(firebaseConfig);
        } catch (e) {
            console.warn("Firebase Init warning:", e);
        }
    }
}

document.addEventListener('DOMContentLoaded', function () {
    initFirebasePhoneAuth();
});

function setupRecaptchaVerifier() {
    if (recaptchaVerifierGlobal) return recaptchaVerifierGlobal;
    if (typeof firebase === 'undefined' || !firebase.auth) return null;

    const recaptchaContainer = document.getElementById('recaptcha-container');
    if (!recaptchaContainer) return null;

    try {
        recaptchaVerifierGlobal = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
            'size': 'invisible',
            'callback': function (response) {
                // reCAPTCHA solved - allow signInWithPhoneNumber
            },
            'expired-callback': function () {
                // Response expired - ask user to solve reCAPTCHA again.
                if (typeof Swal !== 'undefined') {
                    Swal.fire('Chú ý', 'Mã reCAPTCHA đã hết hạn, vui lòng thử lại.', 'warning');
                }
            }
        });
        return recaptchaVerifierGlobal;
    } catch (e) {
        console.error("Error setting up RecaptchaVerifier:", e);
        return null;
    }
}

function formatPhoneToE164(phone) {
    if (!phone) return '';
    let clean = phone.trim().replace(/\s+/g, '');
    if (clean.startsWith('0')) {
        return '+84' + clean.substring(1);
    }
    if (!clean.startsWith('+')) {
        return '+84' + clean;
    }
    return clean;
}

window.sendFirebasePhoneOtp = function (rawPhone, successCallback, errorCallback) {
    initFirebasePhoneAuth();

    if (!rawPhone || !/^0(3|5|7|8|9)[0-9]{8}$/.test(rawPhone.trim().replace(/\s+/g, ''))) {
        const errMsg = 'Số điện thoại không đúng định dạng (VD: 0912345678)!';
        if (typeof Swal !== 'undefined') {
            Swal.fire('Lỗi định dạng', errMsg, 'error');
        } else {
            alert(errMsg);
        }
        if (typeof errorCallback === 'function') errorCallback(errMsg);
        return;
    }

    const formattedPhone = formatPhoneToE164(rawPhone);
    const verifier = setupRecaptchaVerifier();

    if (typeof firebase === 'undefined' || !firebase.auth) {
        const errMsg = 'Thư viện Firebase Auth chưa được nạp!';
        if (typeof errorCallback === 'function') errorCallback(errMsg);
        return;
    }

    firebase.auth().signInWithPhoneNumber(formattedPhone, verifier)
        .then(function (confirmationResult) {
            confirmationResultGlobal = confirmationResult;
            if (typeof successCallback === 'function') {
                successCallback(formattedPhone);
            }
        })
        .catch(function (error) {
            console.warn("Firebase Real SMS Notice:", error);

            if (error.code === 'auth/billing-not-enabled' || error.code === 'auth/operation-not-allowed') {
                // Auto Fallback to Test OTP Mode (Code: 123456)
                confirmationResultGlobal = {
                    confirm: function (code) {
                        return new Promise(function (resolve, reject) {
                            if (code && code.trim() === '123456') {
                                resolve({ user: { phoneNumber: formattedPhone } });
                            } else {
                                reject(new Error('Mã OTP không chính xác!'));
                            }
                        });
                    }
                };

                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'info',
                        title: 'Kích hoạt Mã OTP Thử nghiệm 📩',
                        html: 'Mã OTP thử nghiệm cho số <b>' + formattedPhone + '</b> là: <b style="color:#10b981; font-size:20px;">123456</b><br><small style="color:#64748b;">(Do dự án Firebase chưa thêm số test hoặc chưa bật Billing. Bạn gõ mã 123456 để tiếp tục test mượt mà nhé!)</small>',
                        confirmButtonText: 'Đã hiểu & Nhập OTP',
                        confirmButtonColor: '#0066CC'
                    }).then(() => {
                        if (typeof successCallback === 'function') {
                            successCallback(formattedPhone);
                        }
                    });
                } else {
                    alert('Mã OTP thử nghiệm là: 123456');
                    if (typeof successCallback === 'function') {
                        successCallback(formattedPhone);
                    }
                }
                return;
            }

            let userMsg = 'Không thể gửi SMS OTP lúc này. Vui lòng kiểm tra lại số điện thoại hoặc thử lại sau!';
            if (error.code === 'auth/invalid-phone-number') {
                userMsg = 'Số điện thoại không hợp lệ!';
            } else if (error.code === 'auth/too-many-requests') {
                userMsg = 'Bạn đã yêu cầu quá nhiều mã SMS. Vui lòng thử lại sau ít phút!';
            } else if (error.code === 'auth/app-not-authorized') {
                userMsg = 'Tên miền localhost chưa được thêm vào Authorized Domains trên Firebase Console!';
            }

            if (recaptchaVerifierGlobal && typeof recaptchaVerifierGlobal.render === 'function') {
                recaptchaVerifierGlobal.render().then(function (widgetId) {
                    if (typeof grecaptcha !== 'undefined') grecaptcha.reset(widgetId);
                }).catch(() => {});
            }

            if (typeof Swal !== 'undefined') {
                Swal.fire('Lỗi gửi SMS', userMsg, 'error');
            } else {
                alert(userMsg);
            }

            if (typeof errorCallback === 'function') errorCallback(userMsg);
        });
};

window.confirmFirebasePhoneOtp = function (otpCode, rawPhone, successCallback, errorCallback) {
    if (!confirmationResultGlobal) {
        const errMsg = 'Chưa khởi tạo yêu cầu gửi SMS OTP!';
        if (typeof errorCallback === 'function') errorCallback(errMsg);
        return;
    }

    if (!otpCode || otpCode.trim().length < 6) {
        const errMsg = 'Vui lòng nhập đủ 6 chữ số OTP!';
        if (typeof Swal !== 'undefined') Swal.fire('Lỗi OTP', errMsg, 'warning');
        if (typeof errorCallback === 'function') errorCallback(errMsg);
        return;
    }

    confirmationResultGlobal.confirm(otpCode.trim())
        .then(function (result) {
            // Firebase OTP Verification Successful!
            // Now notify Spring Boot backend to save phone into DB
            const formData = new URLSearchParams();
            formData.append('phone', rawPhone);

            return fetch('/api/profile/verify-phone', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });
        })
        .then(res => res.json())
        .then(data => {
            if (data && data.success) {
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'success',
                        title: 'Xác Thực Thành Công! 🎉',
                        text: data.message || 'Đã xác thực và cập nhật số điện thoại thành công.',
                        confirmButtonColor: '#10b981'
                    }).then(() => {
                        window.location.reload();
                    });
                } else {
                    alert('Xác thực và cập nhật thành công!');
                    window.location.reload();
                }
                if (typeof successCallback === 'function') successCallback(data);
            } else {
                const errMsg = data.message || 'Lỗi cập nhật số điện thoại vào máy chủ!';
                if (typeof Swal !== 'undefined') Swal.fire('Thất bại', errMsg, 'error');
                if (typeof errorCallback === 'function') errorCallback(errMsg);
            }
        })
        .catch(function (error) {
            console.error("Firebase Verify OTP Error:", error);
            let userMsg = 'Mã OTP không đúng hoặc đã hết hạn!';
            if (typeof Swal !== 'undefined') Swal.fire('Lỗi xác thực', userMsg, 'error');
            if (typeof errorCallback === 'function') errorCallback(userMsg);
        });
};
