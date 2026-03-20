<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 — Lỗi hệ thống | KTX Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Poppins:wght@700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, #0F172A 0%, #1E3A5F 30%, #2563EB 60%, #60A5FA 100%);
            color: white; text-align: center;
        }
        .error-container { max-width: 480px; padding: 24px; }
        .error-code {
            font-family: 'Poppins', sans-serif;
            font-size: 8rem; font-weight: 700; line-height: 1;
            background: linear-gradient(135deg, #EF4444, #F87171);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            background-clip: text; margin-bottom: 16px;
        }
        .error-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 12px; }
        .error-desc { color: rgba(255,255,255,0.7); font-size: 0.95rem; line-height: 1.6; margin-bottom: 32px; }
        .btn-home {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255,255,255,0.15); color: white;
            padding: 14px 28px; border-radius: 14px; font-weight: 600;
            text-decoration: none; transition: all 0.3s ease;
            backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2);
        }
        .btn-home:hover { background: rgba(255,255,255,0.25); transform: translateY(-2px); color: white; }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <h1 class="error-title">Lỗi hệ thống</h1>
        <p class="error-desc">
            Đã xảy ra lỗi không mong muốn. Đội ngũ kỹ thuật đã được thông báo.
            Vui lòng thử lại sau hoặc liên hệ quản trị viên.
        </p>
        <a href="${pageContext.request.contextPath}/login" class="btn-home">
            <i class="fas fa-arrow-left"></i> Về trang chủ
        </a>
    </div>
</body>
</html>
