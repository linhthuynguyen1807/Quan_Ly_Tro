<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu — KTX Manager</title>

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

        .bg-orb {
            position: absolute; border-radius: 50%; filter: blur(80px); opacity: 0.3;
            animation: float 8s ease-in-out infinite;
        }
        .bg-orb-1 { width: 350px; height: 350px; background: #3B82F6; top: -80px; left: -80px; }
        .bg-orb-2 { width: 280px; height: 280px; background: #60A5FA; bottom: -80px; right: -80px; animation-delay: 3s; }
        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-25px) scale(1.05); }
        }

        .forgot-container {
            position: relative; z-index: 10;
            width: 100%; max-width: 440px; padding: 16px;
        }
        .forgot-card {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 48px 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
        }

        .forgot-logo { text-align: center; margin-bottom: 32px; }
        .forgot-logo-icon {
            width: 64px; height: 64px;
            background: linear-gradient(135deg, #F59E0B, #FBBF24);
            border-radius: 20px;
            display: inline-flex; align-items: center; justify-content: center;
            color: white; font-size: 1.6rem; margin-bottom: 16px;
            box-shadow: 0 8px 24px rgba(245,158,11,0.3);
        }
        .forgot-logo h2 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700; font-size: 1.4rem; color: #1E293B; margin-bottom: 8px;
        }
        .forgot-logo p {
            color: #64748B; font-size: 0.85rem; line-height: 1.5;
        }

        .form-group { margin-bottom: 20px; }
        .form-label-custom {
            display: block; font-size: 0.82rem; font-weight: 600;
            color: #374151; margin-bottom: 6px;
        }
        .input-wrapper { position: relative; }
        .input-wrapper i {
            position: absolute; left: 16px; top: 50%;
            transform: translateY(-50%); color: #94A3B8; font-size: 0.9rem;
        }
        .form-input {
            width: 100%; padding: 13px 16px 13px 44px;
            border: 2px solid #E2E8F0; border-radius: 14px;
            font-size: 0.92rem; font-family: 'Inter', sans-serif;
            background: #F8FAFC; transition: all 0.3s ease; outline: none;
        }
        .form-input:focus {
            border-color: #3B82F6; background: white;
            box-shadow: 0 0 0 4px rgba(59,130,246,0.1);
        }

        .btn-submit {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, #2563EB, #3B82F6);
            color: white; border: none; border-radius: 14px;
            font-size: 1rem; font-weight: 600;
            cursor: pointer; transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37,99,235,0.4);
        }

        .alert-info-custom {
            background: #EFF6FF; border: 1px solid #BFDBFE;
            color: #1E40AF; padding: 14px 16px; border-radius: 12px;
            font-size: 0.82rem; margin-bottom: 20px;
            display: flex; align-items: flex-start; gap: 10px;
            line-height: 1.5;
        }
        .alert-info-custom i { color: #3B82F6; margin-top: 2px; }

        .back-link {
            text-align: center; margin-top: 24px; font-size: 0.85rem;
        }
        .back-link a {
            color: #2563EB; text-decoration: none; font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .back-link a:hover { color: #1D4ED8; }

        .login-footer {
            text-align: center; margin-top: 24px;
            color: rgba(255,255,255,0.6); font-size: 0.78rem;
        }

        /* Success state */
        .success-state { text-align: center; }
        .success-icon {
            width: 80px; height: 80px;
            background: linear-gradient(135deg, #10B981, #34D399);
            border-radius: 50%; display: inline-flex;
            align-items: center; justify-content: center;
            color: white; font-size: 2rem; margin-bottom: 20px;
            box-shadow: 0 8px 24px rgba(16,185,129,0.3);
        }
    </style>
</head>
<body>
    <div class="bg-orb bg-orb-1"></div>
    <div class="bg-orb bg-orb-2"></div>

    <div class="forgot-container" data-aos="fade-up" data-aos-duration="800">
        <div class="forgot-card">
            <!-- Default State -->
            <div id="formState">
                <div class="forgot-logo">
                    <div class="forgot-logo-icon"><i class="fas fa-key"></i></div>
                    <h2>Quên mật khẩu?</h2>
                    <p>Nhập tên đăng nhập hoặc email của bạn, chúng tôi sẽ hỗ trợ khôi phục mật khẩu.</p>
                </div>

                <div class="alert-info-custom">
                    <i class="fas fa-info-circle"></i>
                    <span>Tính năng đang phát triển. Vui lòng liên hệ quản trị viên để được hỗ trợ đặt lại mật khẩu.</span>
                </div>

                <form id="forgotForm" onsubmit="handleSubmit(event)">
                    <div class="form-group">
                        <label class="form-label-custom">Tên đăng nhập hoặc Email</label>
                        <div class="input-wrapper">
                            <input type="text" class="form-input" 
                                   placeholder="Nhập tên đăng nhập hoặc email" required>
                            <i class="fas fa-envelope"></i>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fas fa-paper-plane me-2"></i> Gửi Yêu Cầu
                    </button>
                </form>
            </div>

            <!-- Success State (hidden by default) -->
            <div id="successState" class="success-state" style="display:none;">
                <div class="success-icon"><i class="fas fa-check"></i></div>
                <h3 style="font-size:1.3rem; font-weight:700; color:#1E293B; margin-bottom:8px;">
                    Yêu cầu đã được gửi!
                </h3>
                <p style="color:#64748B; font-size:0.88rem; margin-bottom:24px; line-height:1.5;">
                    Vui lòng liên hệ quản trị viên hoặc kiểm tra email để nhận hướng dẫn đặt lại mật khẩu.
                </p>
                <a href="${pageContext.request.contextPath}/login" class="btn-submit" style="text-decoration:none; display:inline-block; width:auto; padding:12px 32px;">
                    <i class="fas fa-arrow-left me-2"></i> Về Đăng Nhập
                </a>
            </div>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/login">
                    <i class="fas fa-arrow-left"></i> Quay lại Đăng nhập
                </a>
            </div>
        </div>
        <p class="login-footer">© 2026 KTX Manager</p>
    </div>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 600, once: true });

        function handleSubmit(e) {
            e.preventDefault();
            // Show success state (placeholder — backend not implemented yet)
            document.getElementById('formState').style.display = 'none';
            document.getElementById('successState').style.display = 'block';
        }
    </script>
</body>
</html>
