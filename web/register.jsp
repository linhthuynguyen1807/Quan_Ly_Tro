<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký — KTX Manager</title>

    <!-- Bootstrap 5.3 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <!-- AOS -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0F172A 0%, #1E3A5F 30%, #2563EB 60%, #60A5FA 100%);
            position: relative;
            overflow: hidden;
        }

        /* Animated Background */
        .bg-orb {
            position: absolute; border-radius: 50%; filter: blur(80px); opacity: 0.3;
            animation: float 8s ease-in-out infinite;
        }
        .bg-orb-1 { width: 400px; height: 400px; background: #3B82F6; top: -100px; right: -100px; }
        .bg-orb-2 { width: 300px; height: 300px; background: #60A5FA; bottom: -50px; left: -50px; animation-delay: 2s; }
        .bg-orb-3 { width: 200px; height: 200px; background: #93C5FD; top: 60%; left: 40%; animation-delay: 4s; }
        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-25px) scale(1.05); }
        }

        .register-container {
            position: relative; z-index: 10;
            width: 100%; max-width: 480px; padding: 16px;
        }
        .register-card {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 44px 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2), 0 0 0 1px rgba(255,255,255,0.1);
        }

        /* Logo */
        .register-logo { text-align: center; margin-bottom: 28px; }
        .register-logo-icon {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, #2563EB, #3B82F6);
            border-radius: 16px;
            display: inline-flex; align-items: center; justify-content: center;
            color: white; font-size: 1.3rem; margin-bottom: 12px;
            box-shadow: 0 6px 20px rgba(37,99,235,0.3);
        }
        .register-logo h2 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700; font-size: 1.35rem; color: #1E293B; margin-bottom: 4px;
        }
        .register-logo p { color: #64748B; font-size: 0.85rem; }

        /* Form */
        .form-group { margin-bottom: 18px; }
        .form-label-custom {
            display: block; font-size: 0.82rem; font-weight: 600;
            color: #374151; margin-bottom: 6px;
        }
        .input-wrapper { position: relative; }
        .input-wrapper > i:first-of-type {
            position: absolute; left: 16px; top: 50%;
            transform: translateY(-50%); color: #94A3B8; font-size: 0.9rem;
            transition: color 0.3s;
        }
        .form-input {
            width: 100%;
            padding: 12px 16px 12px 44px;
            border: 2px solid #E2E8F0;
            border-radius: 14px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            background: #F8FAFC;
            transition: all 0.3s ease;
            outline: none;
        }
        .form-input:focus {
            border-color: #3B82F6; background: white;
            box-shadow: 0 0 0 4px rgba(59,130,246,0.1);
        }
        .input-wrapper:focus-within > i:first-of-type { color: #3B82F6; }

        /* Password Strength */
        .password-strength { display: flex; gap: 4px; margin-top: 8px; }
        .strength-bar {
            flex: 1; height: 4px; border-radius: 4px;
            background: #E2E8F0; transition: background 0.3s;
        }
        .strength-bar.active-weak { background: #EF4444; }
        .strength-bar.active-medium { background: #F59E0B; }
        .strength-bar.active-strong { background: #10B981; }
        .strength-text { font-size: 0.72rem; margin-top: 4px; color: #64748B; }

        /* Password Match */
        .match-indicator {
            font-size: 0.78rem; margin-top: 6px;
            display: flex; align-items: center; gap: 4px;
        }
        .match-ok { color: #10B981; }
        .match-fail { color: #EF4444; }

        .password-toggle {
            position: absolute; right: 16px; top: 50%; transform: translateY(-50%);
            background: none; border: none; color: #94A3B8;
            cursor: pointer; font-size: 0.9rem; padding: 4px;
        }
        .password-toggle:hover { color: #3B82F6; }

        /* Button */
        .btn-register {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, #2563EB, #3B82F6);
            color: white; border: none; border-radius: 14px;
            font-size: 1rem; font-weight: 600;
            cursor: pointer; transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37,99,235,0.4);
        }
        .btn-register:disabled {
            opacity: 0.6; cursor: not-allowed; transform: none;
            box-shadow: none;
        }

        /* Alert */
        .alert-error {
            background: #FEF2F2; border: 1px solid #FECACA;
            color: #991B1B; padding: 12px 16px; border-radius: 12px;
            font-size: 0.85rem; margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }
        .alert-error i { color: #EF4444; }
        .alert-success {
            background: #F0FDF4; border: 1px solid #BBF7D0;
            color: #166534; padding: 12px 16px; border-radius: 12px;
            font-size: 0.85rem; margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }
        .alert-success i { color: #10B981; }

        .login-links {
            text-align: center; margin-top: 24px;
            font-size: 0.85rem; color: #64748B;
        }
        .login-links a {
            color: #2563EB; text-decoration: none; font-weight: 600;
        }
        .login-links a:hover { color: #1D4ED8; }

        .login-footer {
            text-align: center; margin-top: 24px;
            color: rgba(255,255,255,0.6); font-size: 0.78rem;
            position: relative; z-index: 10;
        }
    </style>
</head>
<body>
    <div class="bg-orb bg-orb-1"></div>
    <div class="bg-orb bg-orb-2"></div>
    <div class="bg-orb bg-orb-3"></div>

    <div class="register-container" data-aos="fade-up" data-aos-duration="800">
        <div class="register-card">
            <!-- Logo -->
            <div class="register-logo">
                <div class="register-logo-icon"><i class="fas fa-user-plus"></i></div>
                <h2>Tạo tài khoản mới</h2>
                <p>Đăng ký để sử dụng hệ thống KTX Manager</p>
            </div>

            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="alert-error">
                    <i class="fas fa-exclamation-circle"></i> <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert-success">
                    <i class="fas fa-check-circle"></i> <span>${success}</span>
                </div>
            </c:if>

            <!-- Register Form -->
            <form action="register" method="POST" id="registerForm">
                <input type="hidden" name="role" value="student">

                <div class="form-group">
                    <label class="form-label-custom">Tên đăng nhập</label>
                    <div class="input-wrapper">
                        <input type="text" name="username" class="form-input" 
                               placeholder="Ít nhất 4 ký tự" required minlength="4"
                               value="${param.username}" autocomplete="username">
                        <i class="fas fa-user"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label-custom">Mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" id="passwordInput" 
                               class="form-input" placeholder="Ít nhất 6 ký tự" 
                               required minlength="6" autocomplete="new-password">
                        <i class="fas fa-lock"></i>
                        <button type="button" class="password-toggle" onclick="togglePassword('passwordInput', 'eyeIcon1')">
                            <i class="fas fa-eye" id="eyeIcon1"></i>
                        </button>
                    </div>
                    <div class="password-strength" id="strengthBars">
                        <div class="strength-bar"></div>
                        <div class="strength-bar"></div>
                        <div class="strength-bar"></div>
                        <div class="strength-bar"></div>
                    </div>
                    <div class="strength-text" id="strengthText"></div>
                </div>

                <div class="form-group">
                    <label class="form-label-custom">Xác nhận mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" name="confirmPassword" id="confirmInput"
                               class="form-input" placeholder="Nhập lại mật khẩu" 
                               required autocomplete="new-password">
                        <i class="fas fa-lock"></i>
                        <button type="button" class="password-toggle" onclick="togglePassword('confirmInput', 'eyeIcon2')">
                            <i class="fas fa-eye" id="eyeIcon2"></i>
                        </button>
                    </div>
                    <div class="match-indicator" id="matchIndicator"></div>
                </div>

                <button type="submit" class="btn-register" id="submitBtn">
                    <i class="fas fa-user-plus me-2"></i> Đăng Ký
                </button>
            </form>

            <div class="login-links">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </div>
        <p class="login-footer">© 2026 KTX Manager</p>
    </div>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 600, once: true });

        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        // Password strength checker
        const passwordInput = document.getElementById('passwordInput');
        passwordInput.addEventListener('input', function() {
            const val = this.value;
            const bars = document.querySelectorAll('.strength-bar');
            const text = document.getElementById('strengthText');
            let score = 0;

            if (val.length >= 6) score++;
            if (val.length >= 8) score++;
            if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
            if (/[0-9]/.test(val) || /[^A-Za-z0-9]/.test(val)) score++;

            bars.forEach((bar, i) => {
                bar.className = 'strength-bar';
                if (i < score) {
                    if (score <= 1) bar.classList.add('active-weak');
                    else if (score <= 2) bar.classList.add('active-medium');
                    else bar.classList.add('active-strong');
                }
            });

            const labels = ['', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];
            text.textContent = val.length > 0 ? labels[score] : '';
            checkMatch();
        });

        // Password match checker
        const confirmInput = document.getElementById('confirmInput');
        confirmInput.addEventListener('input', checkMatch);

        function checkMatch() {
            const indicator = document.getElementById('matchIndicator');
            const pw = passwordInput.value;
            const cf = confirmInput.value;
            if (cf.length === 0) { indicator.innerHTML = ''; return; }
            if (pw === cf) {
                indicator.innerHTML = '<i class="fas fa-check-circle"></i> <span class="match-ok">Mật khẩu khớp</span>';
                indicator.className = 'match-indicator match-ok';
            } else {
                indicator.innerHTML = '<i class="fas fa-times-circle"></i> <span class="match-fail">Mật khẩu không khớp</span>';
                indicator.className = 'match-indicator match-fail';
            }
        }

        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            if (passwordInput.value !== confirmInput.value) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            }
        });
    </script>
</body>
</html>
