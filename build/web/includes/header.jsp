<%@page pageEncoding="UTF-8"%>
<%-- 
    Header/Navbar Component
    Usage: <%@include file="/includes/header.jsp"%>
    Set pageTitle before include
--%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<header class="admin-header">
    <!-- Mobile Toggle -->
    <button class="header-toggle d-md-none" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Page Title -->
    <div class="header-title">
        <h1 class="header-h1">${pageTitle}</h1>
        <p class="header-breadcrumb">
            <i class="fas fa-home"></i>
            <span>Trang chủ</span>
            <c:if test="${not empty pageTitle}">
                <i class="fas fa-chevron-right"></i>
                <span>${pageTitle}</span>
            </c:if>
        </p>
    </div>

    <!-- Right Section -->
    <div class="header-actions">
        <!-- Search (Optional) -->
        <div class="header-search d-none d-lg-flex">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Tìm kiếm..." class="header-search-input">
        </div>

        <!-- Notifications -->
        <div class="header-icon-btn" title="Thông báo">
            <i class="fas fa-bell"></i>
            <c:if test="${pendingRequestCount > 0}">
                <span class="header-notification-dot"></span>
            </c:if>
        </div>

        <!-- User dropdown -->
        <div class="dropdown">
            <button class="header-user-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="header-user-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">${sessionScope.user.username.substring(0,1).toUpperCase()}</c:when>
                        <c:otherwise>?</c:otherwise>
                    </c:choose>
                </div>
                <span class="d-none d-md-inline header-user-name">${not empty sessionScope.user ? sessionScope.user.username : 'Guest'}</span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3">
                <li><h6 class="dropdown-header">Xin chào, ${not empty sessionScope.user ? sessionScope.user.username : 'Guest'}!</h6></li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'landlord'}">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                                <i class="fas fa-user me-2 text-muted"></i> Tài khoản
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/student/profile">
                                <i class="fas fa-user me-2 text-muted"></i> Tài khoản
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
                <li>
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'landlord'}">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/settings">
                                <i class="fas fa-cog me-2 text-muted"></i> Cài đặt
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/student/settings">
                                <i class="fas fa-cog me-2 text-muted"></i> Cài đặt
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item text-danger" href="#" onclick="event.preventDefault(); confirmLogout();">
                        <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

<style>
    .admin-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 0 24px 0;
        gap: 16px;
    }
    .header-toggle {
        background: var(--bg-card);
        border: none;
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: var(--shadow-card);
        cursor: pointer;
        color: var(--text-primary);
        font-size: 1.1rem;
    }
    .header-h1 {
        font-size: 1.6rem;
        font-weight: 700;
        color: var(--text-primary);
        margin: 0;
        line-height: 1.3;
    }
    .header-breadcrumb {
        font-size: 0.78rem;
        color: var(--text-secondary);
        margin: 2px 0 0;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .header-breadcrumb .fa-chevron-right { font-size: 0.55rem; }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    /* Search */
    .header-search {
        display: flex;
        align-items: center;
        gap: 8px;
        background: var(--bg-card);
        border: 1px solid #E2E8F0;
        border-radius: 12px;
        padding: 8px 16px;
        transition: all 0.3s ease;
    }
    .header-search:focus-within {
        border-color: var(--primary-400);
        box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
    }
    .header-search i { color: var(--text-secondary); font-size: 0.85rem; }
    .header-search-input {
        border: none;
        outline: none;
        background: transparent;
        font-size: 0.85rem;
        width: 180px;
        color: var(--text-primary);
    }

    /* Icon Buttons */
    .header-icon-btn {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: var(--bg-card);
        border: 1px solid #E2E8F0;
        cursor: pointer;
        color: var(--text-secondary);
        position: relative;
        transition: all 0.2s ease;
    }
    .header-icon-btn:hover {
        color: var(--primary-600);
        border-color: var(--primary-200);
        background: var(--primary-50);
    }
    .header-notification-dot {
        position: absolute;
        top: 8px;
        right: 8px;
        width: 8px;
        height: 8px;
        background: var(--danger);
        border-radius: 50%;
        border: 2px solid var(--bg-card);
    }

    /* User Button */
    .header-user-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        background: var(--bg-card);
        border: 1px solid #E2E8F0;
        border-radius: 12px;
        padding: 6px 12px 6px 6px;
        cursor: pointer;
        transition: all 0.2s;
    }
    .header-user-btn::after { display: none; } /* Remove default dropdown arrow */
    .header-user-btn:hover {
        border-color: var(--primary-200);
        background: var(--primary-50);
    }
    .header-user-avatar {
        width: 32px;
        height: 32px;
        background: var(--gradient-btn);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 0.85rem;
    }
    .header-user-name {
        font-weight: 600;
        font-size: 0.85rem;
        color: var(--text-primary);
    }
</style>
