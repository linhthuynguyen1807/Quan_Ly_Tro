<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="notifications"/>
<c:set var="pageTitle" value="Thông báo"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Thông báo — KTX Manager</title>
    <style>
        .noti-item {
            display: flex;
            gap: 16px;
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            transition: all 0.2s ease;
            cursor: default;
        }
        .noti-item:last-child { border-bottom: none; }
        .noti-item:hover { background: rgba(59,130,246,0.02); }
        .noti-item.unread {
            background: rgba(59,130,246,0.04);
            border-left: 3px solid var(--primary-500);
        }
        .noti-icon {
            width: 42px; height: 42px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            font-size: 1rem;
        }
        .noti-content { flex: 1; min-width: 0; }
        .noti-title {
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-primary);
            margin-bottom: 4px;
        }
        .noti-msg {
            font-size: 0.82rem;
            color: var(--text-secondary);
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .noti-time {
            font-size: 0.75rem;
            color: var(--text-tertiary);
            margin-top: 6px;
        }
        .noti-actions {
            display: flex;
            align-items: center;
            flex-shrink: 0;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/student-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
                <div>
                    <h4 style="font-weight:800; color:var(--text-primary); margin-bottom:4px;">
                        <i class="fas fa-bell me-2" style="color:var(--primary-500);"></i>Thông báo
                    </h4>
                    <p style="font-size:0.85rem; color:var(--text-secondary); margin:0;">
                        Bạn có <strong style="color:var(--primary-500);">${unreadCount != null ? unreadCount : 0}</strong> thông báo chưa đọc
                    </p>
                </div>
                <c:if test="${unreadCount != null && unreadCount > 0}">
                    <form method="post" action="${pageContext.request.contextPath}/student/notifications">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                        <input type="hidden" name="action" value="markAllRead">
                        <button type="submit" class="btn btn-outline-primary btn-sm" style="border-radius:10px; font-size:0.82rem;">
                            <i class="fas fa-check-double me-1"></i>Đánh dấu tất cả đã đọc
                        </button>
                    </form>
                </c:if>
            </div>

            <!-- Notifications -->
            <div class="card-custom" data-aos="fade-up" style="overflow:hidden;">
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <c:forEach var="noti" items="${notifications}">
                            <div class="noti-item ${!noti.read ? 'unread' : ''}">
                                <div class="noti-icon"
                                     style="background:${noti.type == 'billing' ? 'rgba(245,158,11,0.1); color:#F59E0B;' :
                                                         (noti.type == 'maintenance' ? 'rgba(59,130,246,0.1); color:var(--primary-500);' :
                                                         (noti.type == 'warning' ? 'rgba(239,68,68,0.1); color:var(--danger);' :
                                                         'rgba(16,185,129,0.1); color:var(--success);'))}">
                                    <i class="fas ${noti.type == 'billing' ? 'fa-file-invoice-dollar' :
                                                    (noti.type == 'maintenance' ? 'fa-tools' :
                                                    (noti.type == 'warning' ? 'fa-exclamation-triangle' : 'fa-bell'))}"></i>
                                </div>
                                <div class="noti-content">
                                    <div class="noti-title">${noti.title}</div>
                                    <div class="noti-msg">${noti.message}</div>
                                    <div class="noti-time">
                                        <i class="fas fa-clock me-1"></i>
                                        <c:if test="${noti.createdAt != null}">
                                            <fmt:formatDate value="${noti.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="noti-actions">
                                    <c:if test="${!noti.read}">
                                        <form method="post" action="${pageContext.request.contextPath}/student/notifications">
                                            <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                                            <input type="hidden" name="action" value="markRead">
                                            <input type="hidden" name="notificationId" value="${noti.notification_id}">
                                            <button type="submit" class="btn btn-sm" style="border:none; background:none; color:var(--primary-500); font-size:0.8rem;" title="Đánh dấu đã đọc">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="p-5 text-center" style="color:var(--text-secondary);">
                            <i class="fas fa-bell-slash fa-3x mb-3" style="opacity:0.2;"></i>
                            <p class="mb-0">Không có thông báo nào</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
