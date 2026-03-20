<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="currentPage" value="hostels"/>
<c:set var="pageTitle" value="Chi tiết Khu trọ"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>${hostel.hostel_name} — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Hostel Info Card -->
            <div class="card-custom p-0 overflow-hidden mb-4" data-aos="fade-up">
                <div style="background:var(--gradient-main); padding:32px; position:relative; overflow:hidden;">
                    <!-- Decorative circles -->
                    <div style="position:absolute; top:-40px; right:-40px; width:160px; height:160px; border-radius:50%; background:rgba(255,255,255,0.05);"></div>
                    <div style="position:absolute; bottom:-60px; right:80px; width:200px; height:200px; border-radius:50%; background:rgba(255,255,255,0.03);"></div>
                    
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                        <div class="d-flex gap-3 align-items-center">
                            <div style="width:64px; height:64px; background:rgba(255,255,255,0.15); border-radius:18px; display:flex; align-items:center; justify-content:center; backdrop-filter:blur(10px);">
                                <i class="fas fa-hotel fa-2x" style="color:white;"></i>
                            </div>
                            <div>
                                <h3 style="color:white; font-weight:700; margin:0;">${hostel.hostel_name}</h3>
                                <p style="color:rgba(255,255,255,0.7); margin:4px 0 0; font-size:0.9rem;">
                                    <i class="fas fa-map-marker-alt me-1"></i>${hostel.address}
                                </p>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm" style="background:rgba(255,255,255,0.15); color:white; border:1px solid rgba(255,255,255,0.2); border-radius:10px; padding:8px 16px; font-weight:600;">
                                <i class="fas fa-edit me-1"></i> Sửa
                            </button>
                            <a href="hostels" class="btn btn-sm" style="background:rgba(255,255,255,0.1); color:rgba(255,255,255,0.8); border:1px solid rgba(255,255,255,0.15); border-radius:10px; padding:8px 16px; font-weight:600;">
                                <i class="fas fa-arrow-left me-1"></i> Quay lại
                            </a>
                        </div>
                    </div>

                    <!-- Mini stats -->
                    <div class="row g-3 mt-3">
                        <div class="col-auto">
                            <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px 20px; backdrop-filter:blur(10px);">
                                <div style="color:rgba(255,255,255,0.6); font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px;">Tổng phòng</div>
                                <div style="color:white; font-size:1.3rem; font-weight:700;">${totalRooms != null ? totalRooms : 0}</div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px 20px; backdrop-filter:blur(10px);">
                                <div style="color:rgba(255,255,255,0.6); font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px;">Phòng trống</div>
                                <div style="color:#86EFAC; font-size:1.3rem; font-weight:700;">${availableRooms != null ? availableRooms : 0}</div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px 20px; backdrop-filter:blur(10px);">
                                <div style="color:rgba(255,255,255,0.6); font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px;">Sinh viên</div>
                                <div style="color:#FCD34D; font-size:1.3rem; font-weight:700;">${totalStudents != null ? totalStudents : 0}</div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div style="background:rgba(255,255,255,0.1); border-radius:12px; padding:12px 20px; backdrop-filter:blur(10px);">
                                <div style="color:rgba(255,255,255,0.6); font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px;">Tỷ lệ lấp đầy</div>
                                <div style="color:white; font-size:1.3rem; font-weight:700;">${occupancyRate != null ? occupancyRate : 0}%</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Room list -->
            <div class="d-flex justify-content-between align-items-center mb-3" data-aos="fade-up">
                <h5 style="font-weight:700; margin:0; color:var(--text-primary);">
                    <i class="fas fa-door-open me-2" style="color:var(--primary-500);"></i>Danh sách phòng
                </h5>
                <button class="btn-gradient btn-sm" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                    <i class="fas fa-plus me-1"></i> Thêm phòng
                </button>
            </div>

            <div class="row g-3">
                <c:forEach items="${rooms}" var="r" varStatus="loop">
                    <div class="col-xl-3 col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="${loop.index * 50}">
                        <div class="card-custom p-4 h-100" style="border-left:4px solid ${r.status == 'available' ? 'var(--success)' : r.status == 'full' ? 'var(--danger)' : 'var(--warning)'};">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h6 style="font-weight:700; margin:0; font-size:1rem;">${r.room_number}</h6>
                                    <span style="font-size:0.75rem; color:var(--text-secondary);">${r.room_type}</span>
                                </div>
                                <c:choose>
                                    <c:when test="${r.status == 'available'}">
                                        <span class="badge-status badge-success">Trống</span>
                                    </c:when>
                                    <c:when test="${r.status == 'full'}">
                                        <span class="badge-status badge-danger">Đầy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status badge-warning">Còn chỗ</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.82rem; margin-bottom:12px;">
                                <div>
                                    <div style="color:var(--text-secondary);">Sức chứa</div>
                                    <div style="font-weight:600;">${r.current_occupants}/${r.capacity}</div>
                                </div>
                                <div>
                                    <div style="color:var(--text-secondary);">Diện tích</div>
                                    <div style="font-weight:600;">${r.area} m²</div>
                                </div>
                                <div style="grid-column:span 2;">
                                    <div style="color:var(--text-secondary);">Giá thuê</div>
                                    <div style="font-weight:700; color:var(--primary-600);">${r.price} VNĐ/tháng</div>
                                </div>
                            </div>

                            <!-- Occupancy bar -->
                            <div style="background:#E2E8F0; border-radius:6px; height:6px; overflow:hidden;">
                                <div style="background: ${r.status == 'available' ? 'var(--success)' : r.status == 'full' ? 'var(--danger)' : 'var(--warning)'}; height:100%; width:${r.capacity > 0 ? (r.current_occupants * 100 / r.capacity) : 0}%; border-radius:6px; transition:width 0.5s;"></div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty rooms}">
                    <div class="col-12">
                        <div class="card-custom p-5 text-center">
                            <i class="fas fa-door-closed fa-3x mb-3" style="color:var(--primary-200);"></i>
                            <p style="color:var(--text-secondary);">Khu trọ này chưa có phòng nào.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <!-- Add Room Modal -->
    <div class="modal fade" id="addRoomModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-plus-circle me-2" style="color:var(--primary-500);"></i>Thêm phòng mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="add-room" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="hostel_id" value="${hostel.hostel_id}">
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số phòng</label>
                                <input type="text" name="room_number" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Loại phòng</label>
                                <select name="room_type" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option>Đơn</option>
                                    <option>Đôi</option>
                                    <option>Ghép</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Diện tích (m²)</label>
                                <input type="number" name="area" class="form-control" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Sức chứa</label>
                                <input type="number" name="capacity" class="form-control" required min="1" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giá (VNĐ)</label>
                                <input type="number" name="price" class="form-control" required style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0" style="padding:0 28px 28px;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient"><i class="fas fa-save me-1"></i> Lưu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
