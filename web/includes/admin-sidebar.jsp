<%@page pageEncoding="UTF-8"%>
<%-- 
    Admin Sidebar Component
    Usage: <%@include file="/includes/admin-sidebar.jsp"%>
    Requires: currentPage variable set before include
--%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Mobile Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- Sidebar -->
<aside class="admin-sidebar" id="adminSidebar">
    <!-- Logo -->
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">
            <i class="fas fa-building"></i>
        </div>
        <div>
            <div class="sidebar-logo-title">KTX Manager</div>
            <div class="sidebar-logo-subtitle">Quản lý nhà trọ</div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="sidebar-nav">
        <div class="sidebar-section-title">TỔNG QUAN</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" 
           class="sidebar-link ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-chart-pie"></i>
            <span>Dashboard</span>
        </a>

        <div class="sidebar-section-title">QUẢN LÝ</div>
        <a href="${pageContext.request.contextPath}/admin/hostels" 
           class="sidebar-link ${currentPage == 'hostels' ? 'active' : ''}">
            <i class="fas fa-hotel"></i>
            <span>Khu trọ</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/rooms" 
           class="sidebar-link ${currentPage == 'rooms' ? 'active' : ''}">
            <i class="fas fa-door-open"></i>
            <span>Phòng</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/students" 
           class="sidebar-link ${currentPage == 'students' ? 'active' : ''}">
            <i class="fas fa-user-graduate"></i>
            <span>Sinh viên</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/contracts" 
           class="sidebar-link ${currentPage == 'contracts' ? 'active' : ''}">
            <i class="fas fa-file-contract"></i>
            <span>Hợp đồng</span>
        </a>

        <div class="sidebar-section-title">TÀI CHÍNH</div>
        <a href="${pageContext.request.contextPath}/admin/invoices" 
           class="sidebar-link ${currentPage == 'invoices' ? 'active' : ''}">
            <i class="fas fa-file-invoice-dollar"></i>
            <span>Hóa đơn</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/utilities" 
           class="sidebar-link ${currentPage == 'utilities' ? 'active' : ''}">
            <i class="fas fa-bolt"></i>
            <span>Điện nước</span>
        </a>

        <div class="sidebar-section-title">HỖ TRỢ</div>
        <a href="${pageContext.request.contextPath}/admin/requests" 
           class="sidebar-link ${currentPage == 'requests' ? 'active' : ''}">
            <i class="fas fa-wrench"></i>
            <span>Yêu cầu sửa chữa</span>
            <c:if test="${pendingRequestCount > 0}">
                <span class="sidebar-badge">${pendingRequestCount}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" 
           class="sidebar-link ${currentPage == 'reports' ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i>
            <span>Báo cáo</span>
        </a>
    </nav>

    <!-- User & Logout -->
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="sidebar-avatar">
                <i class="fas fa-user"></i>
            </div>
            <div>
                <div class="sidebar-username">${sessionScope.user.username}</div>
                <div class="sidebar-role">Chủ trọ</div>
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
