<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="rooms"/>
<c:set var="pageTitle" value="Quản lý Phòng"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Phòng — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Filter Bar -->
            <form method="GET" action="${pageContext.request.contextPath}/admin/rooms" id="roomFilterForm">
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Khu trọ</label>
                        <select name="hostelId" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả khu trọ</option>
                            <c:forEach items="${hostels}" var="h">
                                <option value="${h.hostel_id}" ${selectedHostelId == h.hostel_id ? 'selected' : ''}>${h.hostel_name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Trạng thái</label>
                        <select name="status" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <option value="available" ${selectedStatus == 'available' ? 'selected' : ''}>🟢 Trống</option>
                            <option value="partial" ${selectedStatus == 'partial' ? 'selected' : ''}>🟡 Còn chỗ</option>
                            <option value="full" ${selectedStatus == 'full' ? 'selected' : ''}>🔴 Đầy</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tầng</label>
                        <select name="floor" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả tầng</option>
                            <c:forEach items="${floors}" var="f">
                                <option value="${f}" ${selectedFloor == f ? 'selected' : ''}>Tầng ${f}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0" style="border-radius:12px 0 0 12px;">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" name="search" class="form-control border-start-0" placeholder="Tìm số phòng..."
                                   style="border-radius:0 12px 12px 0;" value="${search}">
                        </div>
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn-gradient flex-fill"><i class="fas fa-filter me-1"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-light rounded-3" title="Reset"><i class="fas fa-undo"></i></a>
                    </div>
                </div>
            </div>
            </form>

            <!-- Stats Mini -->
            <div class="row g-3 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="col-auto">
                    <div class="d-flex align-items-center gap-2 px-3 py-2 rounded-3" style="background:#D1FAE5;">
                        <span style="width:10px;height:10px;border-radius:50%;background:#10B981;"></span>
                        <span style="font-size:0.82rem; font-weight:600; color:#065F46;">Trống: <strong>${availableRooms != null ? availableRooms : '--'}</strong></span>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="d-flex align-items-center gap-2 px-3 py-2 rounded-3" style="background:#FEF3C7;">
                        <span style="width:10px;height:10px;border-radius:50%;background:#F59E0B;"></span>
                        <span style="font-size:0.82rem; font-weight:600; color:#92400E;">Còn chỗ: <strong>${partialRooms != null ? partialRooms : '--'}</strong></span>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="d-flex align-items-center gap-2 px-3 py-2 rounded-3" style="background:#FEE2E2;">
                        <span style="width:10px;height:10px;border-radius:50%;background:#EF4444;"></span>
                        <span style="font-size:0.82rem; font-weight:600; color:#991B1B;">Đầy: <strong>${fullRooms != null ? fullRooms : '--'}</strong></span>
                    </div>
                </div>
                <div class="col-auto ms-auto">
                    <button class="btn-gradient" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                        <i class="fas fa-plus me-2"></i> Thêm phòng mới
                    </button>
                </div>
            </div>

            <!-- Room Table -->
            <div class="card-custom" data-aos="fade-up" data-aos-delay="200">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Số phòng</th>
                                <th>Khu trọ</th>
                                <th>Tầng</th>
                                <th>Loại</th>
                                <th>Diện tích</th>
                                <th>Giá (VNĐ)</th>
                                <th>Sức chứa</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty rooms}">
                                    <c:forEach items="${rooms}" var="r" varStatus="loop">
                                        <tr>
                                            <td style="font-weight:600; color:var(--text-secondary);">${(currentPage - 1) * 10 + loop.count}</td>
                                            <td>
                                                <span style="font-weight:600;">${r.room_number}</span>
                                            </td>
                                            <td>${r.hostel_name}</td>
                                            <td><span class="badge-status badge-info">Tầng ${r.floorNumber}</span></td>
                                            <td>
                                                <span class="badge-status badge-info">${r.room_type}</span>
                                            </td>
                                            <td>${r.area} m²</td>
                                            <td style="font-weight:600; color:var(--primary-700);">
                                                ${r.price}
                                            </td>
                                            <td>${r.current_occupants}/${r.capacity}</td>
                                            <td>
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
                                            </td>
                                            <td class="text-center">
                                                <button class="btn btn-sm btn-outline-primary rounded-2 me-1" title="Sửa"
                                                        onclick="editRoom(${r.room_id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger rounded-2" title="Xóa"
                                                        onclick="deleteRoom(${r.room_id}, '${r.room_number}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="text-center py-5">
                                            <i class="fas fa-door-open fa-3x mb-3" style="color:var(--primary-200);"></i>
                                            <p style="color:var(--text-secondary); margin:0;">Chưa có phòng nào. Hãy thêm phòng mới!</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/rooms?search=${search}&hostelId=${selectedHostelId}&status=${selectedStatus}&floor=${selectedFloor}"/>
                <div class="d-flex justify-content-between align-items-center p-3 border-top" style="font-size:0.85rem;">
                    <span style="color:var(--text-secondary);">Hiển thị ${(currentPage-1)*10+1}-${currentPage*10 > totalRecords ? totalRecords : currentPage*10} / ${totalRecords} phòng</span>
                    <tags:pagination currentPage="${currentPage}" totalPages="${totalPages}" baseUrl="${baseUrl}"/>
                </div>
            </div>
        </main>
    </div>

    <!-- Add Room Modal -->
    <div class="modal fade" id="addRoomModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-plus-circle me-2" style="color:var(--primary-500);"></i> Thêm phòng mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/rooms" method="POST">
                    <input type="hidden" name="action" value="add"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Khu trọ</label>
                                <select name="hostelId" class="form-select" required style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <c:forEach items="${hostels}" var="h">
                                        <option value="${h.hostel_id}">${h.hostel_name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số phòng</label>
                                <input type="text" name="roomNumber" class="form-control" placeholder="VD: P.101" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Loại phòng</label>
                                <select name="roomType" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option>Đơn</option>
                                    <option>Đôi</option>
                                    <option>Ghép</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tầng</label>
                                <input type="number" name="floorNumber" class="form-control" placeholder="1" min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Diện tích (m²)</label>
                                <input type="number" name="area" class="form-control" placeholder="20"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giá thuê (VNĐ/tháng)</label>
                                <input type="number" name="price" class="form-control" placeholder="2500000" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Sức chứa (người)</label>
                                <input type="number" name="capacity" class="form-control" placeholder="4" required min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
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
    <script>
        function deleteRoom(id, name) {
            Swal.fire({
                title: 'Xóa phòng?',
                html: 'Bạn chắc chắn muốn xóa phòng <strong>' + name + '</strong>?',
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#EF4444', cancelButtonColor: '#64748B',
                confirmButtonText: 'Xóa', cancelButtonText: 'Hủy'
            }).then(r => { if (r.isConfirmed) window.location.href = '${pageContext.request.contextPath}/admin/rooms?action=delete&roomId=' + id; });
        }
    </script>
</body>
</html>
