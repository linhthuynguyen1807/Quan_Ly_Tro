<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="dashboard"/>
<c:set var="pageTitle" value="Trang chủ"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Student Dashboard — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/student-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Welcome Banner -->
            <div class="card-custom p-0 overflow-hidden mb-4" data-aos="fade-up">
                <div style="background:var(--gradient-main); padding:32px; position:relative; overflow:hidden;">
                    <div style="position:absolute; top:-40px; right:-40px; width:200px; height:200px; border-radius:50%; background:rgba(255,255,255,0.05);"></div>
                    <div style="position:absolute; bottom:-60px; right:80px; width:160px; height:160px; border-radius:50%; background:rgba(255,255,255,0.03);"></div>
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h4 style="color:white; font-weight:800; margin:0 0 8px;">
                                Xin chào, ${student != null ? student.full_name : (sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Sinh viên')}! 👋
                            </h4>
                            <p style="color:rgba(255,255,255,0.7); font-size:0.9rem; margin:0;">
                                Chào mừng bạn đến KTX Manager. Kiểm tra phòng, hóa đơn và dịch vụ của bạn tại đây.
                            </p>
                        </div>
                        <div class="col-lg-4 text-end d-none d-lg-block">
                            <i class="fas fa-graduation-cap" style="font-size:5rem; color:rgba(255,255,255,0.1);"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stats-card" style="border-left:4px solid var(--primary-500);">
                        <div class="stats-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Phòng</div>
                            <div class="stats-value">
                                <c:choose>
                                    <c:when test="${room != null}">${room.room_number}</c:when>
                                    <c:otherwise>Chưa có</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stats-card" style="border-left:4px solid var(--success);">
                        <div class="stats-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Ký túc xá</div>
                            <div class="stats-value" style="font-size:1.2rem;">
                                <c:choose>
                                    <c:when test="${room != null}">${room.hostelName}</c:when>
                                    <c:otherwise>Chưa có</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stats-card" style="border-left:4px solid #F59E0B;">
                        <div class="stats-icon" style="background:rgba(245,158,11,0.1); color:#F59E0B;">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Hóa đơn chưa TT</div>
                            <div class="stats-value" style="color:#F59E0B;">${unpaidInvoices != null ? unpaidInvoices : 0}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="400">
                    <div class="stats-card" style="border-left:4px solid var(--info);">
                        <div class="stats-icon" style="background:rgba(6,182,212,0.1); color:var(--info);">
                            <i class="fas fa-tools"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Yêu cầu bảo trì</div>
                            <div class="stats-value">${requests != null ? requests.size() : 0}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- Pending Bills -->
                <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                    <div class="card-custom p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 style="font-weight:700; margin:0;">
                                <i class="fas fa-file-invoice-dollar me-2" style="color:var(--primary-500);"></i>Hóa đơn cần thanh toán
                            </h6>
                            <a href="${pageContext.request.contextPath}/student/billing" style="font-size:0.82rem; font-weight:600; color:var(--primary-500); text-decoration:none;">
                                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr>
                                        <th>Tháng</th>
                                        <th>Tiền phòng</th>
                                        <th>Tổng tiền</th>
                                        <th>Hạn TT</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty invoices}">
                                            <c:forEach var="inv" items="${invoices}" varStatus="loop">
                                                <c:if test="${(inv.status == 'unpaid' || inv.status == 'overdue') && loop.index < 5}">
                                                    <tr>
                                                        <td style="font-weight:600;">${inv.invoiceMonth}</td>
                                                        <td><fmt:formatNumber value="${inv.roomFee}" pattern="#,###"/>đ</td>
                                                        <td style="font-weight:700; color:${inv.status == 'overdue' ? 'var(--danger)' : 'var(--text-primary)'};">
                                                            <fmt:formatNumber value="${inv.totalAmount}" pattern="#,###"/>đ
                                                        </td>
                                                        <td>
                                                            <c:if test="${inv.dueDate != null}">
                                                                <fmt:formatDate value="${inv.dueDate}" pattern="dd/MM/yyyy"/>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${inv.status == 'overdue'}">
                                                                    <span class="badge-status badge-danger">Quá hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-status badge-warning">Chờ TT</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-4" style="color:var(--text-secondary);">
                                                    <i class="fas fa-check-circle me-2" style="color:var(--success);"></i>Không có hóa đơn cần thanh toán
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions & Room Info -->
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
                    <!-- Room Summary -->
                    <div class="card-custom p-4 mb-4">
                        <h6 style="font-weight:700; margin:0 0 16px;">
                            <i class="fas fa-door-open me-2" style="color:var(--primary-500);"></i>Phòng của tôi
                        </h6>
                        <c:choose>
                            <c:when test="${room != null}">
                                <div style="background:var(--gradient-main); border-radius:16px; padding:20px; color:white; margin-bottom:16px;">
                                    <div style="font-size:2rem; font-weight:800;">${room.room_number}</div>
                                    <div style="font-size:0.82rem; color:rgba(255,255,255,0.7);">
                                        ${room.hostelName} • Tầng ${room.floorNumber} • Phòng ${room.max_capacity} người
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between mb-2" style="font-size:0.82rem;">
                                    <span style="color:var(--text-secondary);">Số người ở:</span>
                                    <span style="font-weight:600;">${room.currentOccupants}/${room.max_capacity}</span>
                                </div>
                                <c:set var="occupancyPercent" value="${room.max_capacity > 0 ? (room.currentOccupants * 100 / room.max_capacity) : 0}"/>
                                <div class="progress" style="height:6px; border-radius:3px;">
                                    <div class="progress-bar" style="width:${occupancyPercent}%; background:var(--gradient-main);"></div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-3" style="color:var(--text-secondary);">
                                    <i class="fas fa-door-closed fa-2x mb-2"></i>
                                    <p class="mb-0">Bạn chưa được phân phòng</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card-custom p-4">
                        <h6 style="font-weight:700; margin:0 0 16px;">
                            <i class="fas fa-bolt me-2" style="color:#F59E0B;"></i>Thao tác nhanh
                        </h6>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/student/maintenance" class="btn btn-outline-primary rounded-3 text-start d-flex align-items-center gap-2 p-3">
                                <i class="fas fa-tools" style="width:20px;"></i>Gửi yêu cầu bảo trì
                            </a>
                            <a href="${pageContext.request.contextPath}/student/billing" class="btn btn-outline-primary rounded-3 text-start d-flex align-items-center gap-2 p-3">
                                <i class="fas fa-receipt" style="width:20px;"></i>Xem hóa đơn
                            </a>
                            <a href="${pageContext.request.contextPath}/student/notifications" class="btn btn-outline-primary rounded-3 text-start d-flex align-items-center gap-2 p-3">
                                <i class="fas fa-bell" style="width:20px;"></i>Thông báo mới
                                <c:if test="${unreadNotifications != null && unreadNotifications > 0}">
                                    <span class="badge bg-danger rounded-pill ms-auto">${unreadNotifications}</span>
                                </c:if>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Notifications -->
                <div class="col-12" data-aos="fade-up" data-aos-delay="300">
                    <div class="card-custom p-4">
                        <h6 style="font-weight:700; margin:0 0 16px;">
                            <i class="fas fa-bell me-2" style="color:var(--primary-500);"></i>Thông báo gần đây
                        </h6>
                        <div class="d-flex flex-column gap-3">
                            <c:choose>
                                <c:when test="${not empty notifications}">
                                    <c:forEach var="noti" items="${notifications}" varStatus="loop">
                                        <c:if test="${loop.index < 5}">
                                            <c:set var="notiColor" value="${noti.type == 'warning' ? '#F59E0B' : (noti.type == 'success' ? 'var(--success)' : 'var(--primary-500)')}"/>
                                            <c:set var="notiIcon" value="${noti.type == 'warning' ? 'exclamation-circle' : (noti.type == 'success' ? 'check-circle' : 'info-circle')}"/>
                                            <c:set var="notiColorRgb" value="${noti.type == 'warning' ? '245,158,11' : (noti.type == 'success' ? '16,185,129' : '59,130,246')}"/>
                                            <div class="d-flex gap-3 p-3 rounded-3" style="background:rgba(${notiColorRgb},0.05); border:1px solid rgba(${notiColorRgb},0.1);${!noti.read ? ' border-left:3px solid '+=notiColor : ''}">
                                                <div style="width:40px; height:40px; border-radius:10px; background:rgba(${notiColorRgb},0.1); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                                                    <i class="fas fa-${notiIcon}" style="color:${notiColor};"></i>
                                                </div>
                                                <div>
                                                    <div style="font-weight:${!noti.read ? '700' : '600'}; font-size:0.88rem;">${noti.title}</div>
                                                    <div style="font-size:0.8rem; color:var(--text-secondary);">${noti.message}</div>
                                                    <div style="font-size:0.72rem; color:var(--text-secondary); margin-top:4px;">
                                                        <fmt:formatDate value="${noti.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4" style="color:var(--text-secondary);">
                                        <i class="fas fa-bell-slash fa-2x mb-2"></i>
                                        <p class="mb-0">Chưa có thông báo nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
