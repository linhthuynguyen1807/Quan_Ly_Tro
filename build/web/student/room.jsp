<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="room"/>
<c:set var="pageTitle" value="Phòng của tôi"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Phòng của tôi — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/student-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <c:choose>
                <c:when test="${room != null}">
                    <!-- Room Header -->
                    <div class="card-custom p-0 overflow-hidden mb-4" data-aos="fade-up">
                        <div style="background:var(--gradient-main); padding:32px; position:relative; overflow:hidden;">
                            <div style="position:absolute; top:-40px; right:-40px; width:200px; height:200px; border-radius:50%; background:rgba(255,255,255,0.05);"></div>
                            <div class="row align-items-center">
                                <div class="col">
                                    <div class="d-flex align-items-center gap-3 mb-2">
                                        <div style="width:60px; height:60px; border-radius:16px; background:rgba(255,255,255,0.15); display:flex; align-items:center; justify-content:center;">
                                            <i class="fas fa-door-open" style="color:white; font-size:1.5rem;"></i>
                                        </div>
                                        <div>
                                            <h4 style="color:white; font-weight:800; margin:0;">Phòng ${room.room_number}</h4>
                                            <p style="color:rgba(255,255,255,0.7); font-size:0.88rem; margin:0;">
                                                ${room.hostelName} • Tầng ${room.floorNumber} • Phòng ${room.max_capacity} người
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <c:choose>
                                        <c:when test="${contract != null && contract.status == 'active'}">
                                            <span class="badge" style="background:rgba(16,185,129,0.2); color:#34D399; padding:8px 16px; border-radius:20px; font-weight:600;">
                                                <i class="fas fa-circle me-1" style="font-size:0.5rem;"></i>Đang ở
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge" style="background:rgba(245,158,11,0.2); color:#F59E0B; padding:8px 16px; border-radius:20px; font-weight:600;">
                                                <i class="fas fa-circle me-1" style="font-size:0.5rem;"></i>Chờ xác nhận
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <!-- Mini stats -->
                            <div class="row g-3 mt-2">
                                <div class="col-6 col-md-3">
                                    <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px; text-align:center;">
                                        <div style="color:rgba(255,255,255,0.7); font-size:0.72rem;">Diện tích</div>
                                        <div style="color:white; font-weight:700;"><fmt:formatNumber value="${room.area}" pattern="#,###"/> m²</div>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px; text-align:center;">
                                        <div style="color:rgba(255,255,255,0.7); font-size:0.72rem;">Giá phòng</div>
                                        <div style="color:white; font-weight:700;"><fmt:formatNumber value="${room.price}" pattern="#,###"/>đ</div>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px; text-align:center;">
                                        <div style="color:rgba(255,255,255,0.7); font-size:0.72rem;">Số người ở</div>
                                        <div style="color:white; font-weight:700;">${room.currentOccupants}/${room.max_capacity}</div>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px; text-align:center;">
                                        <div style="color:rgba(255,255,255,0.7); font-size:0.72rem;">Ngày vào</div>
                                        <div style="color:white; font-weight:700;">
                                            <c:if test="${contract != null}"><fmt:formatDate value="${contract.start_date}" pattern="dd/MM/yyyy"/></c:if>
                                            <c:if test="${contract == null}">—</c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                            <!-- Contract Info -->
                            <c:if test="${contract != null}">
                                <div class="card-custom p-4 mb-4">
                                    <h6 style="font-weight:700; margin:0 0 20px;">
                                        <i class="fas fa-file-contract me-2" style="color:var(--primary-500);"></i>Thông tin hợp đồng
                                    </h6>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between mb-2" style="font-size:0.85rem;">
                                                <span style="color:var(--text-secondary);">Mã hợp đồng:</span>
                                                <span style="font-weight:600;">#HD-${contract.contract_id}</span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2" style="font-size:0.85rem;">
                                                <span style="color:var(--text-secondary);">Ngày bắt đầu:</span>
                                                <span style="font-weight:600;"><fmt:formatDate value="${contract.start_date}" pattern="dd/MM/yyyy"/></span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2" style="font-size:0.85rem;">
                                                <span style="color:var(--text-secondary);">Ngày kết thúc:</span>
                                                <span style="font-weight:600;"><fmt:formatDate value="${contract.end_date}" pattern="dd/MM/yyyy"/></span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between mb-2" style="font-size:0.85rem;">
                                                <span style="color:var(--text-secondary);">Tiền phòng/tháng:</span>
                                                <span style="font-weight:600;"><fmt:formatNumber value="${contract.monthly_rent}" pattern="#,###"/>đ</span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2" style="font-size:0.85rem;">
                                                <span style="color:var(--text-secondary);">Tiền cọc:</span>
                                                <span style="font-weight:600;"><fmt:formatNumber value="${contract.deposit}" pattern="#,###"/>đ</span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2" style="font-size:0.85rem;">
                                                <span style="color:var(--text-secondary);">Trạng thái:</span>
                                                <c:choose>
                                                    <c:when test="${contract.status == 'active'}">
                                                        <span class="badge-status badge-success">Đang hiệu lực</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'expired'}">
                                                        <span class="badge-status badge-danger">Đã hết hạn</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status badge-warning">${contract.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Room Amenities -->
                            <div class="card-custom p-4">
                                <h6 style="font-weight:700; margin:0 0 20px;">
                                    <i class="fas fa-couch me-2" style="color:var(--primary-500);"></i>Tiện nghi phòng
                                </h6>
                                <div class="row g-3">
                                    <div class="col-6 col-md-4">
                                        <div class="d-flex align-items-center gap-2 p-2">
                                            <i class="fas fa-check-circle" style="color:var(--success);"></i>
                                            <span style="font-size:0.85rem;">Máy lạnh</span>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-4">
                                        <div class="d-flex align-items-center gap-2 p-2">
                                            <i class="fas fa-check-circle" style="color:var(--success);"></i>
                                            <span style="font-size:0.85rem;">Nóng lạnh</span>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-4">
                                        <div class="d-flex align-items-center gap-2 p-2">
                                            <i class="fas fa-check-circle" style="color:var(--success);"></i>
                                            <span style="font-size:0.85rem;">WiFi</span>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-4">
                                        <div class="d-flex align-items-center gap-2 p-2">
                                            <i class="fas fa-check-circle" style="color:var(--success);"></i>
                                            <span style="font-size:0.85rem;">Tủ cá nhân</span>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-4">
                                        <div class="d-flex align-items-center gap-2 p-2">
                                            <i class="fas fa-check-circle" style="color:var(--success);"></i>
                                            <span style="font-size:0.85rem;">Bàn học</span>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-4">
                                        <div class="d-flex align-items-center gap-2 p-2">
                                            <i class="fas fa-check-circle" style="color:var(--success);"></i>
                                            <span style="font-size:0.85rem;">WC riêng</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sidebar -->
                        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
                            <!-- Emergency Contact -->
                            <div class="card-custom p-4 mb-4">
                                <h6 style="font-weight:700; margin:0 0 16px;">
                                    <i class="fas fa-phone-alt me-2" style="color:var(--danger);"></i>Liên hệ khẩn cấp
                                </h6>
                                <div class="d-flex flex-column gap-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div style="width:40px; height:40px; border-radius:10px; background:rgba(239,68,68,0.1); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                                            <i class="fas fa-shield-alt" style="color:var(--danger);"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight:600; font-size:0.85rem;">Bảo vệ KTX</div>
                                            <div style="font-size:0.78rem; color:var(--primary-500);">0901 111 222</div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <div style="width:40px; height:40px; border-radius:10px; background:rgba(59,130,246,0.1); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                                            <i class="fas fa-user-tie" style="color:var(--primary-500);"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight:600; font-size:0.85rem;">Quản lý KTX</div>
                                            <div style="font-size:0.78rem; color:var(--primary-500);">0902 333 444</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Rules -->
                            <div class="card-custom p-4">
                                <h6 style="font-weight:700; margin:0 0 16px;">
                                    <i class="fas fa-clipboard-list me-2" style="color:var(--primary-500);"></i>Nội quy phòng
                                </h6>
                                <ul style="padding-left:16px; font-size:0.82rem; color:var(--text-secondary); margin:0;">
                                    <li class="mb-2">Giữ vệ sinh chung</li>
                                    <li class="mb-2">Không gây ồn sau 22:00</li>
                                    <li class="mb-2">Tiết kiệm điện nước</li>
                                    <li class="mb-2">Báo cáo hư hỏng ngay</li>
                                    <li>Không nấu ăn trong phòng</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- No Room Assigned -->
                    <div class="card-custom p-5 text-center" data-aos="fade-up">
                        <i class="fas fa-door-closed fa-4x mb-3" style="color:var(--text-secondary); opacity:0.3;"></i>
                        <h5 style="font-weight:700; margin-bottom:8px;">Bạn chưa được phân phòng</h5>
                        <p style="color:var(--text-secondary); font-size:0.9rem;">Liên hệ quản trị viên để được hỗ trợ.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
