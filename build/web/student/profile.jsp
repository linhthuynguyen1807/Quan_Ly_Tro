<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="profile"/>
<c:set var="pageTitle" value="Hồ sơ cá nhân"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Hồ sơ cá nhân — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/student-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Messages -->
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert" style="border-radius:12px; font-size:0.9rem;">
                    <i class="fas fa-check-circle me-2"></i>${successMsg}
                </div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger d-flex align-items-center mb-4" role="alert" style="border-radius:12px; font-size:0.9rem;">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Profile Card -->
                <div class="col-lg-4" data-aos="fade-up">
                    <div class="card-custom p-4 text-center">
                        <div style="width:100px; height:100px; border-radius:50%; background:linear-gradient(135deg, var(--primary-500), var(--primary-600)); display:flex; align-items:center; justify-content:center; margin:0 auto 16px; font-size:2.5rem; color:white; font-weight:700;">
                            ${profile != null && profile.fullName != null ? profile.fullName.substring(0,1).toUpperCase() : 'U'}
                        </div>
                        <h5 style="font-weight:800; color:var(--text-primary); margin-bottom:4px;">
                            ${profile != null ? profile.fullName : 'N/A'}
                        </h5>
                        <p style="font-size:0.85rem; color:var(--text-secondary); margin-bottom:16px;">
                            <i class="fas fa-user-tag me-1"></i>
                            ${profile != null ? profile.role : 'student'}
                        </p>
                        <div style="border-top:1px solid var(--border-color); padding-top:16px;">
                            <div class="d-flex align-items-center gap-2 mb-3" style="font-size:0.85rem;">
                                <i class="fas fa-user" style="color:var(--primary-500); width:20px;"></i>
                                <span style="color:var(--text-secondary);">Username:</span>
                                <span style="font-weight:600; margin-left:auto;">${profile != null ? profile.username : 'N/A'}</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 mb-3" style="font-size:0.85rem;">
                                <i class="fas fa-envelope" style="color:var(--primary-500); width:20px;"></i>
                                <span style="color:var(--text-secondary);">Email:</span>
                                <span style="font-weight:600; margin-left:auto;">${profile != null ? profile.email : 'N/A'}</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 mb-3" style="font-size:0.85rem;">
                                <i class="fas fa-phone" style="color:var(--primary-500); width:20px;"></i>
                                <span style="color:var(--text-secondary);">SĐT:</span>
                                <span style="font-weight:600; margin-left:auto;">${profile != null ? profile.phone : 'N/A'}</span>
                            </div>
                            <div class="d-flex align-items-center gap-2" style="font-size:0.85rem;">
                                <i class="fas fa-calendar" style="color:var(--primary-500); width:20px;"></i>
                                <span style="color:var(--text-secondary);">Ngày tạo:</span>
                                <span style="font-weight:600; margin-left:auto;">
                                    <c:if test="${profile != null && profile.createdAt != null}">
                                        <fmt:formatDate value="${profile.createdAt}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                    <c:if test="${profile == null || profile.createdAt == null}">N/A</c:if>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Forms -->
                <div class="col-lg-8">
                    <!-- Update Profile -->
                    <div class="card-custom p-4 mb-4" data-aos="fade-up" data-aos-delay="100">
                        <h6 style="font-weight:700; margin-bottom:20px; color:var(--text-primary);">
                            <i class="fas fa-user-edit me-2" style="color:var(--primary-500);"></i>Cập nhật thông tin
                        </h6>
                        <form method="post" action="${pageContext.request.contextPath}/student/profile">
                            <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Họ và tên</label>
                                    <input type="text" name="fullName" class="form-control" value="${profile != null ? profile.fullName : ''}" required
                                           style="border-radius:12px; border:2px solid #E2E8F0; padding:10px 14px; font-size:0.9rem;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Email</label>
                                    <input type="email" name="email" class="form-control" value="${profile != null ? profile.email : ''}" required
                                           style="border-radius:12px; border:2px solid #E2E8F0; padding:10px 14px; font-size:0.9rem;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số điện thoại</label>
                                    <input type="tel" name="phone" class="form-control" value="${profile != null ? profile.phone : ''}"
                                           style="border-radius:12px; border:2px solid #E2E8F0; padding:10px 14px; font-size:0.9rem;">
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn-gradient">
                                        <i class="fas fa-save me-1"></i>Lưu thay đổi
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Change Password -->
                    <div class="card-custom p-4" data-aos="fade-up" data-aos-delay="200">
                        <h6 style="font-weight:700; margin-bottom:20px; color:var(--text-primary);">
                            <i class="fas fa-lock me-2" style="color:#F59E0B;"></i>Đổi mật khẩu
                        </h6>
                        <form method="post" action="${pageContext.request.contextPath}/student/profile">
                            <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                            <input type="hidden" name="action" value="changePassword">
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Mật khẩu hiện tại</label>
                                    <input type="password" name="oldPassword" class="form-control" required
                                           style="border-radius:12px; border:2px solid #E2E8F0; padding:10px 14px; font-size:0.9rem;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Mật khẩu mới</label>
                                    <input type="password" name="newPassword" class="form-control" required minlength="6"
                                           style="border-radius:12px; border:2px solid #E2E8F0; padding:10px 14px; font-size:0.9rem;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword" class="form-control" required minlength="6"
                                           style="border-radius:12px; border:2px solid #E2E8F0; padding:10px 14px; font-size:0.9rem;">
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn-gradient">
                                        <i class="fas fa-key me-1"></i>Đổi mật khẩu
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
