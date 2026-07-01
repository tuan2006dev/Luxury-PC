/* TOAST */
    let toastT;
    function toast(msg) { const el = document.getElementById('toast'); el.textContent = msg; el.classList.add('show'); clearTimeout(toastT); toastT = setTimeout(() => el.classList.remove('show'), 3500); }

    /* STEP NAVIGATION */
    let currentStep = 1;
    function goStep(n) {
      for (let i = 1; i <= 4; i++) {
        document.getElementById('step' + i)?.classList.toggle('active', i === n);
        const dot = document.getElementById('dot' + i);
        const lbl = document.getElementById('lbl' + i);
        if (dot) { dot.classList.toggle('active', i === n); dot.classList.toggle('done', i < n); }
        if (lbl) { lbl.classList.toggle('active', i === n); }
      }
      currentStep = n;
    }

    /* STEP 1 */
    function sendOTP() {
      const email = document.getElementById('fp-email');
      const err = document.getElementById('err-email');
      if (!email.value || !/\S+@\S+\.\S+/.test(email.value)) {
        email.classList.add('error'); err.classList.add('show'); return;
      }
      email.classList.remove('error'); err.classList.remove('show');

      const btn = document.getElementById('btn-send-otp');
      const originalText = btn.innerHTML;
      btn.disabled = true;
      btn.innerHTML = '<span class="btn-gold-inner">Đang gửi OTP...</span>';
      btn.style.opacity = '0.7';
      btn.style.cursor = 'wait';

      const formData = new URLSearchParams();
      formData.append('email', email.value);

      fetch('/api/forgot-password/send-otp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
      })
        .then(res => res.text())
        .then(data => {
          btn.disabled = false;
          btn.innerHTML = originalText;
          btn.style.opacity = '1';
          btn.style.cursor = 'none';

          if (data === 'success') {
            document.getElementById('sent-email').textContent = email.value;
            toast('✓ Mã OTP đã được gửi đến ' + email.value);
            goStep(2);
            startOTPTimer(300);
          } else if (data === 'error_not_found') {
            toast('❌ Tài khoản không tồn tại trong hệ thống!');
          } else {
            toast('⚠️ Có lỗi xảy ra, vui lòng thử lại.');
          }
        })
        .catch(error => {
          btn.disabled = false;
          btn.innerHTML = originalText;
          btn.style.opacity = '1';
          btn.style.cursor = 'none';

          console.error(error);
          toast('⚠️ Lỗi kết nối!');
        });
    }

    /* OTP HELPERS */
    function otpNext(el, prevId, nextId) {
      el.value = el.value.replace(/[^0-9]/g, '');
      if (el.value && nextId) document.getElementById(nextId)?.focus();
    }
    function otpBack(e, el, prevId) {
      if (e.key === 'Backspace' && !el.value && prevId) document.getElementById(prevId)?.focus();
    }

    /* OTP TIMER */
    let timerInt;
    function startOTPTimer(seconds) {
      clearInterval(timerInt);
      document.getElementById('resend-btn').disabled = true;
      const lbl = document.getElementById('otp-timer');
      let rem = seconds;
      timerInt = setInterval(() => {
        const m = Math.floor(rem / 60).toString().padStart(2, '0');
        const s = (rem % 60).toString().padStart(2, '0');
        lbl.textContent = m + ':' + s;
        if (--rem < 0) { clearInterval(timerInt); lbl.textContent = 'Hết hạn'; document.getElementById('resend-btn').disabled = false; }
      }, 1000);
    }
    function resendOTP() {
      const email = document.getElementById('fp-email').value;
      const formData = new URLSearchParams();
      formData.append('email', email);
      fetch('/api/forgot-password/send-otp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
      }).then(res => res.text()).then(data => {
        if (data === 'success') {
          toast('✓ Đã gửi lại mã OTP mới.');
          startOTPTimer(300);
          ['otp1', 'otp2', 'otp3', 'otp4', 'otp5', 'otp6'].forEach(id => document.getElementById(id).value = '');
          document.getElementById('otp1').focus();
        } else {
          toast('⚠️ Không thể gửi lại mã OTP.');
        }
      });
    }

    /* STEP 2 */
    function verifyOTP() {
      const otp = ['otp1', 'otp2', 'otp3', 'otp4', 'otp5', 'otp6'].map(id => document.getElementById(id).value).join('');
      if (otp.length < 6 || !/^\d{6}$/.test(otp)) { toast('⚠️ Vui lòng nhập đủ 6 chữ số OTP.'); return; }
      clearInterval(timerInt);
      goStep(3);
    }

    /* STEP 3 */
    function checkStrength(pw) {
      const bars = [document.getElementById('b1'), document.getElementById('b2'), document.getElementById('b3'), document.getElementById('b4')];
      const lbl = document.getElementById('pw-lbl');
      bars.forEach(b => b.className = 'pw-bar');
      if (!pw) { lbl.textContent = 'Nhập mật khẩu'; return; }
      let score = 0;
      if (pw.length >= 8) score++; if (/[A-Z]/.test(pw)) score++; if (/[0-9]/.test(pw)) score++; if (/[^A-Za-z0-9]/.test(pw)) score++;
      const cls = score <= 1 ? 'weak' : score === 2 ? 'medium' : 'strong';
      for (let i = 0; i < score; i++)bars[i].classList.add(cls);
      lbl.textContent = ['', 'Yếu', 'Yếu', 'Trung bình', 'Mạnh'][score] || '';
    }
    function togglePw(id, btnId) {
      const inp = document.getElementById(id), btn = document.getElementById(btnId);
      if (inp.type === 'password') { inp.type = 'text'; btn.textContent = '🙈'; } else { inp.type = 'password'; btn.textContent = '👁'; }
    }
    function resetPassword() {
      const pw = document.getElementById('new-pw');
      const pw2 = document.getElementById('new-pw2');
      let ok = true;
      if (!pw.value || pw.value.length < 8) { pw.classList.add('error'); document.getElementById('err-newpw').classList.add('show'); ok = false; } else { pw.classList.remove('error'); document.getElementById('err-newpw').classList.remove('show'); }
      if (pw2.value !== pw.value) { pw2.classList.add('error'); document.getElementById('err-newpw2').classList.add('show'); ok = false; } else { pw2.classList.remove('error'); document.getElementById('err-newpw2').classList.remove('show'); }

      if (ok) {
        const email = document.getElementById('fp-email').value;
        const otp = ['otp1', 'otp2', 'otp3', 'otp4', 'otp5', 'otp6'].map(id => document.getElementById(id).value).join('');

        const formData = new URLSearchParams();
        formData.append('email', email);
        formData.append('otp', otp);
        formData.append('newPassword', pw.value);

        fetch('/api/forgot-password/reset', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData.toString()
        })
          .then(res => res.text())
          .then(data => {
            if (data === 'success') {
              goStep(4);
            } else if (data === 'error_otp') {
              toast('❌ Mã OTP không chính xác hoặc đã hết hạn!');
              ['otp1', 'otp2', 'otp3', 'otp4', 'otp5', 'otp6'].forEach(id => document.getElementById(id).value = '');
              document.getElementById('new-pw').value = '';
              document.getElementById('new-pw2').value = '';
              checkStrength('');
              goStep(2); // Về lại bước nhập OTP để sửa
              setTimeout(() => document.getElementById('otp1').focus(), 100);
            } else {
              toast('⚠️ Đổi mật khẩu thất bại!');
            }
          });
      }
    }