<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập — KTX Manager</title>

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

        /* Animated Background Orbs */
        .bg-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.3;
            animation: float 8s ease-in-out infinite;
        }
        .bg-orb-1 { width: 400px; height: 400px; background: #3B82F6; top: -100px; left: -100px; }
        .bg-orb-2 { width: 300px; height: 300px; background: #60A5FA; bottom: -50px; right: -50px; animation-delay: 2s; }
        .bg-orb-3 { width: 200px; height: 200px; background: #93C5FD; top: 50%; left: 60%; animation-delay: 4s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-30px) scale(1.05); }
        }

        /* Login Container */
        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 440px;
            padding: 16px;
        }

        .login-card {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 48px 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2), 0 0 0 1px rgba(255,255,255,0.1);
        }

        /* Logo */
        .login-logo {
            text-align: center;
            margin-bottom: 32px;
        }
        .login-logo-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #2563EB, #3B82F6);
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.6rem;
            margin-bottom: 16px;
            box-shadow: 0 8px 24px rgba(37,99,235,0.3);
        }
        .login-logo h2 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.5rem;
            color: #1E293B;
            margin-bottom: 4px;
        }
        .login-logo p {
            color: #64748B;
            font-size: 0.88rem;
        }

        /* Form */
        .form-group {
            margin-bottom: 20px;
        }
        .form-label-custom {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        .input-wrapper {
            position: relative;
        }
        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94A3B8;
            font-size: 0.9rem;
            transition: color 0.3s;
        }
        .form-input {
            width: 100%;
            padding: 13px 16px 13px 44px;
            border: 2px solid #E2E8F0;
            border-radius: 14px;
            font-size: 0.92rem;
            font-family: 'Inter', sans-serif;
            background: #F8FAFC;
            transition: all 0.3s ease;
            outline: none;
        }
        .form-input:focus {
            border-color: #3B82F6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59,130,246,0.1);
        }
        .form-input:focus + i,
        .input-wrapper:focus-within i {
            color: #3B82F6;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #94A3B8;
            cursor: pointer;
            font-size: 0.9rem;
            padding: 4px;
        }
        .password-toggle:hover { color: #3B82F6; }

        /* Role Select */
        .form-select-custom {
            width: 100%;
            padding: 13px 16px 13px 44px;
            border: 2px solid #E2E8F0;
            border-radius: 14px;
            font-size: 0.92rem;
            font-family: 'Inter', sans-serif;
            background: #F8FAFC;
            transition: all 0.3s ease;
            outline: none;
            appearance: none;
            -webkit-appearance: none;
            cursor: pointer;
        }
        .form-select-custom:focus {
            border-color: #3B82F6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59,130,246,0.1);
        }
        .select-arrow {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94A3B8;
            pointer-events: none;
        }

        /* Button */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #2563EB, #3B82F6);
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 0.3px;
            font-family: 'Inter', sans-serif;
            position: relative;
            overflow: hidden;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37,99,235,0.4);
        }
        .btn-login:active { transform: translateY(0); }
        .btn-login::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }
        .btn-login:active::after { width: 300px; height: 300px; }

        /* Links */
        .login-links {
            text-align: center;
            margin-top: 24px;
            font-size: 0.85rem;
            color: #64748B;
        }
        .login-links a {
            color: #2563EB;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .login-links a:hover { color: #1D4ED8; }

        /* Error Alert */
        .alert-error {
            background: #FEF2F2;
            border: 1px solid #FECACA;
            color: #991B1B;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .alert-error i { color: #EF4444; }

        /* Footer Text */
        .login-footer {
            text-align: center;
            margin-top: 28px;
            color: rgba(255,255,255,0.6);
            font-size: 0.78rem;
            position: relative;
            z-index: 10;
        }
        .login-footer a { color: rgba(255,255,255,0.8); text-decoration: none; }
    </style>
</head>
<body>
    <!-- Background Orbs -->
    <div class="bg-orb bg-orb-1"></div>
    <div class="bg-orb bg-orb-2"></div>
    <div class="bg-orb bg-orb-3"></div>

    <div class="login-container" data-aos="fade-up" data-aos-duration="800">
        <div class="login-card">
            <!-- Logo -->
            <div class="login-logo">
                <div class="login-logo-icon">
                    <i class="fas fa-building"></i>
                </div>
                <h2>KTX Manager</h2>
                <p>Hệ thống quản lý nhà trọ thông minh</p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Login Form -->
            <form action="login" method="POST" id="loginForm">
                <div class="form-group">
                    <label class="form-label-custom">Tên đăng nhập</label>
                    <div class="input-wrapper">
                        <input type="text" name="username" class="form-input" 
                               placeholder="Nhập tên đăng nhập" required
                               value="${fn:escapeXml(param.username)}" autocomplete="username">
                        <i class="fas fa-user"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label-custom">Mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" id="passwordInput" 
                               class="form-input" placeholder="Nhập mật khẩu" required
                               autocomplete="current-password">
                        <i class="fas fa-lock"></i>
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="eyeIcon"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt me-2"></i> Đăng Nhập
                </button>
            </form>

            <!-- Links -->
            <div class="login-links">
                <a href="${pageContext.request.contextPath}/forgot-password.jsp">Quên mật khẩu?</a>
                <span class="mx-2">|</span>
                <a href="${pageContext.request.contextPath}/register">Đăng ký tài khoản</a>
            </div>
        </div>

        <p class="login-footer">
            © 2026 KTX Manager — Quản lý nhà trọ thông minh
        </p>
    </div>

    <!-- AOS JS -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 600, once: true });

        function togglePassword() {
            const input = document.getElementById('passwordInput');
            const icon = document.getElementById('eyeIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        // Add subtle input animation
        document.querySelectorAll('.form-input, .form-select-custom').forEach(el => {
            el.addEventListener('focus', () => el.parentElement.style.transform = 'scale(1.01)');
            el.addEventListener('blur', () => el.parentElement.style.transform = 'scale(1)');
        });
    </script>
</body>
</html>
