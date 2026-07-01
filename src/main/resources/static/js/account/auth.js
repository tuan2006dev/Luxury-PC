    function switchTab(tab) {
      document.getElementById('tab-login').classList.toggle('active', tab === 'login');
      document.getElementById('tab-register').classList.toggle('active', tab === 'register');
      document.getElementById('form-login').classList.toggle('active', tab === 'login');
      document.getElementById('form-register').classList.toggle('active', tab === 'register');
    }

    /* ===== TOGGLE PASSWORD ===== */
    function togglePw(id, btn) {
      const inp = document.getElementById(id);
      if (inp.type === 'password') { inp.type = 'text'; btn.textContent = '🙈'; }
      else { inp.type = 'password'; btn.textContent = '👁'; }
    }

    /* ===== PASSWORD STRENGTH ===== */
    function checkStrength(pw) {
      const bars = [document.getElementById('bar1'), document.getElementById('bar2'), document.getElementById('bar3'), document.getElementById('bar4')];
      const label = document.getElementById('pw-label');
      bars.forEach(b => { b.className = 'pw-bar'; });
      if (!pw) { label.textContent = 'Nhập mật khẩu'; return 0; }
      let score = 0;
      if (pw.length >= 8) score++;
      if (/[A-Z]/.test(pw)) score++;
      if (/[0-9]/.test(pw)) score++;
      if (/[^A-Za-z0-9]/.test(pw)) score++;
      const cls = score <= 1 ? 'weak' : score === 2 ? 'medium' : 'strong';
      const labels = ['', 'Yếu', 'Yếu', 'Trung bình', 'Mạnh'];
      for (let i = 0; i < score; i++) bars[i].classList.add(cls);
      label.textContent = labels[score] || '';
      return score;
    }

    /* ===== TOAST ===== */
    let toastT;
    function toast(msg) {
      const el = document.getElementById('toast');
      el.textContent = msg; el.classList.add('show');
      clearTimeout(toastT); toastT = setTimeout(() => el.classList.remove('show'), 3500);
    }

    /* ===== VALIDATION ===== */
    function setErr(id, show) {
      const el = document.getElementById(id);
      if (el) el.classList.toggle('show', show);
    }
    function setInputState(inp, state) {
      inp.classList.remove('error', 'success');
      if (state) inp.classList.add(state);
    }


    /* ===== SOCIAL ===== */
    function socialLogin(provider) {
      toast(`🔗 Đang kết nối với ${provider}... (Tính năng UI demo)`);
    }

    /* ===== URL PARAMS NOTIFICATION ===== */
    window.addEventListener('DOMContentLoaded', () => {
      const urlParams = new URLSearchParams(window.location.search);
      if (urlParams.has('error')) {
        toast('Đăng nhập không thành công. Vui lòng kiểm tra lại email hoặc mật khẩu!');
      } else if (urlParams.has('exist')) {
        switchTab('register');
        toast('Email này đã được sử dụng. Vui lòng dùng email khác!');
      } else if (urlParams.has('phoneExist')) {
        switchTab('register');
        toast('Số điện thoại này đã được sử dụng. Vui lòng dùng số điện thoại khác!');
      } else if (urlParams.has('invalidEmail')) {
        switchTab('register');
        toast('Vui lòng sử dụng địa chỉ email hợp lệ!');
      } else if (urlParams.has('invalidOtp')) {
        switchTab('register');
        toast('Mã OTP không chính xác hoặc đã hết hạn!');
      } else if (urlParams.has('success')) {
        switchTab('login');
        toast('Tạo tài khoản thành công! Bây giờ bạn có thể đăng nhập.');
      }
    });

    /* ===== FRONTEND VALIDATION ===== */
    document.getElementById('form-register').addEventListener('submit', function (e) {
      const email = document.getElementById('reg-email').value;
      const phone = document.getElementById('reg-phone').value;
      const pw1 = document.getElementById('reg-pw').value;
      const pw2 = document.getElementById('reg-pw2').value;
      const inviteCode = document.getElementById('reg-invite').value;

      // Kiểm tra độ mạnh mật khẩu (yêu cầu score >= 3, tức là Trung bình trở lên)
      const strengthScore = checkStrength(pw1);
      if (strengthScore < 3) {
        e.preventDefault();
        setErr('err-reg-pw', true);
        toast('Mật khẩu của bạn chưa đủ mạnh! Vui lòng đảm bảo mật khẩu có ít nhất 8 ký tự, bao gồm cả chữ in hoa, chữ số hoặc ký tự đặc biệt.');
        return;
      } else {
        setErr('err-reg-pw', false);
      }

      if (pw1 !== pw2) {
        e.preventDefault();
        setErr('err-reg-pw2', true);
        toast('Mật khẩu xác nhận không khớp! Vui lòng kiểm tra lại.');
        return;
      } else {
        setErr('err-reg-pw2', false);
      }

      setErr('err-reg-email', false);

      const phoneRegex = /^(\+84|84|0)(3|5|7|8|9)[0-9]{8}$/;
      if (phone && !phoneRegex.test(phone.replace(/\s+/g, ''))) {
        e.preventDefault();
        toast('Vui lòng nhập số điện thoại Việt Nam hợp lệ (VD: 09xx, +849xx)!');
        return;
      }

      const otp = document.getElementById('reg-otp').value;
      if (!otp || otp.trim().length !== 6) {
        e.preventDefault();
        toast('Vui lòng nhập đúng 6 số của mã OTP!');
        return;
      }
      
      // Since it's a standard form submission, we don't need to manually add inviteCode 
      // if we ensure the input has name="inviteCode" and it's inside the form.
      // But we should double check the form mapping.
    });

    /* ===== SEND OTP API ===== */
    function sendOtpCode() {
      const emailInput = document.getElementById('reg-email');
      const email = emailInput.value;
      if (!email || !email.includes('@')) {
        toast('Vui lòng nhập Email hợp lệ trước khi lấy mã OTP!');
        emailInput.focus();
        return;
      }

      const btn = document.getElementById('btn-send-otp');
      btn.disabled = true;
      btn.innerHTML = '<span class="btn-gold-inner">Đang gửi...</span>';

      fetch('/api/send-otp?email=' + encodeURIComponent(email), { method: 'POST' })
        .then(res => res.text())
        .then(text => {
          if (text === 'success') {
            toast('Đã gửi mã OTP đến email của bạn!');
            let countdown = 60;
            const interval = setInterval(() => {
              countdown--;
              btn.innerHTML = `<span class="btn-gold-inner">Thử lại (${countdown}s)</span>`;
              if (countdown <= 0) {
                clearInterval(interval);
                btn.innerHTML = '<span class="btn-gold-inner">Gửi Mã</span>';
                btn.disabled = false;
              }
            }, 1000);
          } else if (text === 'error_exist') {
            toast('Email này đã được sử dụng!');
            btn.disabled = false;
            btn.innerHTML = '<span class="btn-gold-inner">Gửi Mã</span>';
          } else if (text === 'error_format') {
            toast('Vui lòng sử dụng tài khoản email hợp lệ!');
            btn.disabled = false;
            btn.innerHTML = '<span class="btn-gold-inner">Gửi Mã</span>';
          } else {
            toast('Lỗi hệ thống khi gửi email, vui lòng thử lại sau!');
            btn.disabled = false;
            btn.innerHTML = '<span class="btn-gold-inner">Gửi Mã</span>';
          }
        })
        .catch(err => {
          toast('Lỗi kết nối khi lấy mã OTP!');
          btn.disabled = false;
          btn.innerHTML = '<span class="btn-gold-inner">Gửi Mã</span>';
        });
    }

