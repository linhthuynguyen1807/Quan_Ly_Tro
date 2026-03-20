<%@page pageEncoding="UTF-8"%>
<%-- 
    Student Sidebar Component
    Usage: <%@include file="/includes/student-sidebar.jsp"%>
    Requires: currentPage variable set before include
--%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Mobile Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- Sidebar -->
<aside class="admin-sidebar" id="adminSidebar">
    <!-- Logo -->
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon" style="background:linear-gradient(135deg, #10B981, #06B6D4);">
            <i class="fas fa-graduation-cap"></i>
        </div>
        <div>
            <div class="sidebar-logo-title">KTX Manager</div>
            <div class="sidebar-logo-subtitle">STUDENT PORTAL</div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="sidebar-nav">
        <div class="sidebar-section-title">CHÍNH</div>
        <a href="${pageContext.request.contextPath}/student/home" 
           class="sidebar-link ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-home"></i>
            <span>Trang chủ</span>
        </a>
        <a href="${pageContext.request.contextPath}/student/room" 
           class="sidebar-link ${currentPage == 'room' ? 'active' : ''}">
            <i class="fas fa-door-open"></i>
            <span>Phòng của tôi</span>
        </a>

        <div class="sidebar-section-title">TÀI CHÍNH</div>
        <a href="${pageContext.request.contextPath}/student/billing" 
           class="sidebar-link ${currentPage == 'billing' ? 'active' : ''}">
            <i class="fas fa-file-invoice-dollar"></i>
            <span>Hóa đơn</span>
            <c:if test="${pendingBills != null && pendingBills > 0}">
                <span class="sidebar-badge">${pendingBills}</span>
            </c:if>
        </a>

        <div class="sidebar-section-title">DỊCH VỤ</div>
        <a href="${pageContext.request.contextPath}/student/maintenance" 
           class="sidebar-link ${currentPage == 'maintenance' ? 'active' : ''}">
            <i class="fas fa-tools"></i>
            <span>Bảo trì</span>
        </a>
        <a href="${pageContext.request.contextPath}/student/notifications" 
           class="sidebar-link ${currentPage == 'notifications' ? 'active' : ''}">
            <i class="fas fa-bell"></i>
            <span>Thông báo</span>
            <c:if test="${unreadNotifications != null && unreadNotifications > 0}">
                <span class="sidebar-badge" style="background:#F59E0B;">${unreadNotifications}</span>
            </c:if>
        </a>

        <div class="sidebar-section-title">TÀI KHOẢN</div>
        <a href="${pageContext.request.contextPath}/student/profile" 
           class="sidebar-link ${currentPage == 'profile' ? 'active' : ''}">
            <i class="fas fa-user-circle"></i>
            <span>Hồ sơ</span>
        </a>
    </nav>

    <!-- User & Logout -->
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="sidebar-avatar">
                ${sessionScope.username != null ? sessionScope.username.substring(0,1).toUpperCase() : 'S'}
            </div>
            <div>
                <div class="sidebar-username">${sessionScope.fullName != null ? sessionScope.fullName : 'Sinh viên'}</div>
                <div class="sidebar-role">Sinh viên</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout" 
           onclick="event.preventDefault(); confirmLogout();">
            <i class="fas fa-sign-out-alt"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>

<script>
function toggleSidebar() {
    document.getElementById('adminSidebar').classList.toggle('active');
    document.getElementById('sidebarOverlay').classList.toggle('active');
}

function confirmLogout() {
    Swal.fire({
        title: 'Đăng xuất?',
        text: 'Bạn có chắc muốn đăng xuất khỏi hệ thống?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#EF4444',
        cancelButtonColor: '#64748B',
        confirmButtonText: 'Đăng xuất',
        cancelButtonText: 'Hủy',
        customClass: { popup: 'rounded-3' }
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    });
}
</script>
