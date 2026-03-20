<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="currentPage" value="profile"/>
<c:set var="pageTitle" value="Hồ sơ cá nhân"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Hồ sơ — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <div class="row g-4">
                <!-- Profile Card -->
                <div class="col-lg-4" data-aos="fade-up">
                    <div class="card-custom p-0 overflow-hidden text-center">
                        <div style="background:var(--gradient-main); padding:40px 24px 60px; position:relative;">
                            <div style="position:absolute; top:-20px; left:-20px; width:100px; height:100px; border-radius:50%; background:rgba(255,255,255,0.05);"></div>
                            <div style="position:absolute; bottom:-30px; right:-30px; width:120px; height:120px; border-radius:50%; background:rgba(255,255,255,0.03);"></div>
                        </div>
                        <div style="margin-top:-50px; position:relative; z-index:1; padding:0 24px 24px;">
                            <div style="width:100px; height:100px; background:white; border-radius:24px; margin:0 auto 16px; box-shadow:0 8px 24px rgba(0,0,0,0.1); display:flex; align-items:center; justify-content:center; overflow:hidden;">
                                <div style="width:100%; height:100%; background:var(--gradient-main); display:flex; align-items:center; justify-content:center; color:white; font-size:2.5rem; font-weight:700;">
                                    ${sessionScope.username != null ? sessionScope.username.substring(0,1).toUpperCase() : 'A'}
                                </div>
                            </div>
                            <h5 style="font-weight:700; margin:0;">${sessionScope.fullname != null ? sessionScope.fullname : 'Admin'}</h5>
                            <p style="color:var(--text-secondary); font-size:0.85rem; margin:4px 0 12px;">
                                <i class="fas fa-user-shield me-1"></i>Quản trị viên
                            </p>
                            <span class="badge-status badge-success">
                                <i class="fas fa-circle me-1" style="font-size:0.5rem;"></i>Đang hoạt động
                            </span>

                            <hr style="margin:20px 0;">

                            <div class="text-start" style="font-size:0.85rem;">
                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <i class="fas fa-envelope" style="width:16px; color:var(--primary-500);"></i>
                                    <span style="color:var(--text-secondary);">${sessionScope.email != null ? sessionScope.email : 'admin@ktx.vn'}</span>
                                </div>
                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <i class="fas fa-phone" style="width:16px; color:var(--primary-500);"></i>
                                    <span style="color:var(--text-secondary);">${sessionScope.phone != null ? sessionScope.phone : '0123 456 789'}</span>
                                </div>
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fas fa-calendar" style="width:16px; color:var(--primary-500);"></i>
                                    <span style="color:var(--text-secondary);">Tham gia: 01/2024</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Profile -->
                <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                    <!-- Personal Info -->
                    <div class="card-custom p-4 mb-4">
                        <h6 style="font-weight:700; margin:0 0 20px;">
                            <i class="fas fa-user-edit me-2" style="color:var(--primary-500);"></i>Thông tin cá nhân
                        </h6>
                        <form action="update-profile" method="POST">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Họ tên</label>
                                    <input type="text" name="fullname" class="form-control" 
                                           value="${sessionScope.fullname}" 
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Username</label>
                                    <input type="text" class="form-control" value="${sessionScope.username}" disabled
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0; background:#F8FAFC;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Email</label>
                                    <input type="email" name="email" class="form-control" 
                                           value="${sessionScope.email}"
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số điện thoại</label>
                                    <input type="text" name="phone" class="form-control" 
                                           value="${sessionScope.phone}"
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                            </div>
                            <div class="mt-4 d-flex justify-content-end">
                                <button type="submit" class="btn-gradient">
                                    <i class="fas fa-save me-1"></i> Cập nhật
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Change Password -->
                    <div class="card-custom p-4">
                        <h6 style="font-weight:700; margin:0 0 20px;">
                            <i class="fas fa-lock me-2" style="color:var(--primary-500);"></i>Đổi mật khẩu
                        </h6>
                        <form action="change-password" method="POST">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Mật khẩu hiện tại</label>
                                    <input type="password" name="currentPassword" class="form-control" required
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Mật khẩu mới</label>
                                    <input type="password" name="newPassword" class="form-control" required id="newPwd"
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword" class="form-control" required id="confirmPwd"
                                           style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <div id="pwdMatch" style="font-size:0.75rem; margin-top:4px;"></div>
                                </div>
                            </div>
                            <div class="mt-4 d-flex justify-content-end">
                                <button type="submit" class="btn-gradient" id="changePwdBtn">
                                    <i class="fas fa-key me-1"></i> Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        const newPwd = document.getElementById('newPwd');
        const confirmPwd = document.getElementById('confirmPwd');
        const pwdMatch = document.getElementById('pwdMatch');

        confirmPwd.addEventListener('input', function() {
            if (this.value === newPwd.value) {
                pwdMatch.innerHTML = '<span style="color:var(--success);"><i class="fas fa-check me-1"></i>Mật khẩu khớp</span>';
            } else {
                pwdMatch.innerHTML = '<span style="color:var(--danger);"><i class="fas fa-times me-1"></i>Mật khẩu không khớp</span>';
            }
        });
    </script>
</body>
</html>
