<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="rooms"/>
<c:set var="pageTitle" value="Quản lý Phòng"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Quản lý Phòng — KTX Manager</title>
    <style>
        .room-card {
            background: white;
            border-radius: 16px;
            border: 2px solid #E2E8F0;
            padding: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .room-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.08);
            border-color: var(--primary-300);
        }
        .room-card.status-available { border-top: 4px solid #10B981; }
        .room-card.status-full { border-top: 4px solid #EF4444; }
        .room-card.status-partial { border-top: 4px solid #F59E0B; }
        .room-card.status-maintenance { border-top: 4px solid #6B7280; }

        .room-number {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }
        .room-detail {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #F1F5F9;
            font-size: 0.85rem;
        }
        .room-detail:last-child { border-bottom: none; }
        .room-detail .label { color: var(--text-secondary); }
        .room-detail .value { font-weight: 600; }
        .room-status-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 6px;
        }
        .room-status-dot.available { background: #10B981; }
        .room-status-dot.full { background: #EF4444; }
        .room-status-dot.partial { background: #F59E0B; }
        .room-status-dot.maintenance { background: #6B7280; }

        .room-actions {
            display: flex;
            gap: 6px;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid #F1F5F9;
        }
        .room-actions .btn { flex: 1; font-size: 0.78rem; padding: 6px 0; border-radius: 10px; }

        .occupancy-bar {
            height: 6px;
            background: #E2E8F0;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 6px;
        }
        .occupancy-bar .fill {
            height: 100%;
            border-radius: 3px;
            transition: width 0.6s ease;
        }
        .occupancy-bar .fill.low { background: #10B981; }
        .occupancy-bar .fill.medium { background: #F59E0B; }
        .occupancy-bar .fill.high { background: #EF4444; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Select Hostel -->
            <c:if test="${empty selectedHostelId}">
                <div class="card-custom p-5 text-center" data-aos="fade-up">
                    <i class="fas fa-building fa-3x mb-3" style="color:var(--primary-300);"></i>
                    <h4 style="font-weight:700;">Chọn khu trọ để quản lý phòng</h4>
                    <p class="mb-4" style="color:var(--text-secondary);">Vui lòng chọn một khu trọ từ danh sách bên dưới để xem và quản lý các phòng.</p>
                    <div class="row g-3 justify-content-center">
                        <c:forEach items="${hostels}" var="h">
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/admin/rooms?hostelId=${h.hostel_id}" class="card-custom p-4 d-block text-decoration-none text-center" style="transition:all 0.3s;">
                                    <div style="width:56px; height:56px; background:var(--gradient-main); border-radius:16px; display:inline-flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:1.2rem; margin-bottom:12px;">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <h6 style="font-weight:700; color:var(--text-primary);">${h.hostel_name}</h6>
                                    <small style="color:var(--text-secondary);">${h.address}</small>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty selectedHostelId}">
            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-3" data-aos="fade-up">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalRecords != null ? totalRecords : 0}</div>
                            <div class="stat-label">Tổng phòng</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div>
                            <div class="stat-value">${availableRooms != null ? availableRooms : 0}</div>
                            <div class="stat-label">Phòng trống</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:var(--warning);">
                            <i class="fas fa-user-friends"></i>
                        </div>
                        <div>
                            <div class="stat-value">${partialRooms != null ? partialRooms : 0}</div>
                            <div class="stat-label">Còn chỗ</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(239,68,68,0.1); color:var(--danger);">
                            <i class="fas fa-ban"></i>
                        </div>
                        <div>
                            <div class="stat-value">${fullRooms != null ? fullRooms : 0}</div>
                            <div class="stat-label">Phòng đầy</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hostel Selector & Filter -->
            <form method="GET" action="${pageContext.request.contextPath}/admin/rooms" id="roomFilterForm">
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Khu trọ</label>
                        <select name="hostelId" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <c:forEach items="${hostels}" var="h">
                                <option value="${h.hostel_id}" ${selectedHostelId == h.hostel_id ? 'selected' : ''}>${h.hostel_name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0" style="border-radius:12px 0 0 12px;"><i class="fas fa-search text-muted"></i></span>
                            <input type="text" name="search" class="form-control border-start-0" placeholder="Số phòng..." style="border-radius:0 12px 12px 0;" value="${search}">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Trạng thái</label>
                        <select name="status" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <option value="Trống" ${selectedStatus == 'Trống' ? 'selected' : ''}>🟢 Trống</option>
                            <option value="Đã thuê" ${selectedStatus == 'Đã thuê' ? 'selected' : ''}>🔴 Đã thuê</option>
                            <option value="Còn chỗ" ${selectedStatus == 'Còn chỗ' ? 'selected' : ''}>🟡 Còn chỗ</option>
                            <option value="Bảo trì" ${selectedStatus == 'Bảo trì' ? 'selected' : ''}>⚙️ Bảo trì</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tầng</label>
                        <select name="floor" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <c:forEach items="${floors}" var="f">
                                <option value="${f}" ${selectedFloor == f ? 'selected' : ''}>Tầng ${f}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn-gradient flex-fill"><i class="fas fa-filter me-1"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/rooms?hostelId=${selectedHostelId}" class="btn btn-light rounded-3" title="Reset"><i class="fas fa-undo"></i></a>
                        <button type="button" class="btn-gradient" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                            <i class="fas fa-plus me-1"></i> Thêm
                        </button>
                    </div>
                </div>
            </div>
            </form>

            <!-- Room Grid -->
            <div class="row g-3" data-aos="fade-up" data-aos-delay="100">
                <c:choose>
                    <c:when test="${not empty rooms}">
                        <c:forEach items="${rooms}" var="r">
                            <c:set var="statusClass" value="${r.status == 'Trống' ? 'available' : (r.status == 'Đã thuê' ? 'full' : (r.status == 'Còn chỗ' ? 'partial' : 'maintenance'))}"/>
                            <c:set var="occupancyPercent" value="${r.max_capacity > 0 ? (r.currentOccupants * 100 / r.max_capacity) : 0}"/>
                            <c:set var="occupancyLevel" value="${occupancyPercent < 50 ? 'low' : (occupancyPercent < 100 ? 'medium' : 'high')}"/>
                            <div class="col-lg-3 col-md-4 col-sm-6">
                                <div class="room-card status-${statusClass}">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <span class="room-number">${r.room_number}</span>
                                            <div style="font-size:0.78rem; color:var(--text-secondary);">Tầng ${r.floorNumber}</div>
                                        </div>
                                        <span class="badge-status badge-${statusClass == 'available' ? 'success' : (statusClass == 'full' ? 'danger' : (statusClass == 'partial' ? 'warning' : 'secondary'))}">
                                            <span class="room-status-dot ${statusClass}"></span>${r.status}
                                        </span>
                                    </div>

                                    <div class="room-detail">
                                        <span class="label"><i class="fas fa-ruler-combined me-1"></i> Diện tích</span>
                                        <span class="value"><fmt:formatNumber value="${r.area}" maxFractionDigits="1"/>m²</span>
                                    </div>
                                    <div class="room-detail">
                                        <span class="label"><i class="fas fa-tag me-1"></i> Loại phòng</span>
                                        <span class="value">${r.roomType}</span>
                                    </div>
                                    <div class="room-detail">
                                        <span class="label"><i class="fas fa-money-bill me-1"></i> Giá phòng</span>
                                        <span class="value" style="color:var(--primary-500);"><fmt:formatNumber value="${r.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                    </div>
                                    <div class="room-detail">
                                        <span class="label"><i class="fas fa-users me-1"></i> Người ở</span>
                                        <span class="value">${r.currentOccupants}/${r.max_capacity}</span>
                                    </div>
                                    <div class="occupancy-bar">
                                        <div class="fill ${occupancyLevel}" style="width:${occupancyPercent > 100 ? 100 : occupancyPercent}%;"></div>
                                    </div>

                                    <div class="room-actions">
                                        <button class="btn btn-sm btn-outline-primary" title="Sửa phòng"
                                                onclick="editRoom(${r.room_id}, '${r.room_number}', ${r.area}, ${r.price}, ${r.max_capacity}, '${r.roomType}', ${r.floorNumber}, '${r.status}')">
                                            <i class="fas fa-edit"></i> Sửa
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" title="Xóa phòng"
                                                onclick="deleteRoom(${r.room_id}, '${r.room_number}')">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12">
                            <div class="card-custom p-5 text-center">
                                <i class="fas fa-door-open fa-3x mb-3" style="color:var(--primary-200);"></i>
                                <p style="color:var(--text-secondary); margin:0;">Chưa có phòng nào. Hãy thêm phòng mới!</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/rooms?hostelId=${selectedHostelId}&search=${search}&status=${selectedStatus}&floor=${selectedFloor}"/>
                <div class="d-flex justify-content-between align-items-center mt-4" style="font-size:0.85rem;">
                    <span style="color:var(--text-secondary);">Hiển thị ${(currentPage-1)*12+1}-${currentPage*12 > totalRecords ? totalRecords : currentPage*12} / ${totalRecords} phòng</span>
                    <tags:pagination currentPage="${currentPage}" totalPages="${totalPages}" baseUrl="${baseUrl}"/>
                </div>
            </c:if>
            </c:if>
        </main>
    </div>

    <!-- ==================== ADD ROOM MODAL ==================== -->
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
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="hostelId" value="${selectedHostelId}"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số phòng <span class="text-danger">*</span></label>
                                <input type="text" name="roomNumber" class="form-control" required placeholder="P101"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tầng</label>
                                <input type="number" name="floorNumber" class="form-control" value="1" min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Diện tích (m²)</label>
                                <input type="number" name="area" class="form-control" step="0.1" min="1" placeholder="20"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Sức chứa <span class="text-danger">*</span></label>
                                <input type="number" name="capacity" class="form-control" required min="1" placeholder="4"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giá phòng (VNĐ) <span class="text-danger">*</span></label>
                                <input type="number" name="price" class="form-control" required min="0" step="1000" placeholder="2000000"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Loại phòng</label>
                                <select name="roomType" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="Thường">Thường</option>
                                    <option value="VIP">VIP</option>
                                    <option value="Máy lạnh">Máy lạnh</option>
                                    <option value="Quạt">Quạt</option>
                                </select>
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

    <!-- ==================== EDIT ROOM MODAL ==================== -->
    <div class="modal fade" id="editRoomModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-edit me-2" style="color:var(--primary-500);"></i> Chỉnh sửa phòng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/rooms" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="hostelId" value="${selectedHostelId}"/>
                    <input type="hidden" name="roomId" id="editRoomId"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số phòng <span class="text-danger">*</span></label>
                                <input type="text" name="roomNumber" id="editRoomNumber" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tầng</label>
                                <input type="number" name="floorNumber" id="editFloorNumber" class="form-control" min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Diện tích (m²)</label>
                                <input type="number" name="area" id="editArea" class="form-control" step="0.1" min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Sức chứa <span class="text-danger">*</span></label>
                                <input type="number" name="capacity" id="editCapacity" class="form-control" required min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giá phòng (VNĐ) <span class="text-danger">*</span></label>
                                <input type="number" name="price" id="editPrice" class="form-control" required min="0" step="1000"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Loại phòng</label>
                                <select name="roomType" id="editRoomType" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="Thường">Thường</option>
                                    <option value="VIP">VIP</option>
                                    <option value="Máy lạnh">Máy lạnh</option>
                                    <option value="Quạt">Quạt</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Trạng thái</label>
                                <select name="status" id="editStatus" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="Trống">🟢 Trống</option>
                                    <option value="Đã thuê">🔴 Đã thuê</option>
                                    <option value="Còn chỗ">🟡 Còn chỗ</option>
                                    <option value="Bảo trì">⚙️ Bảo trì</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0" style="padding:0 28px 28px;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient"><i class="fas fa-save me-1"></i> Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Hidden Delete Form (POST) -->
    <form id="deleteRoomForm" action="${pageContext.request.contextPath}/admin/rooms" method="POST" style="display:none;">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" name="hostelId" value="${selectedHostelId}"/>
        <input type="hidden" name="roomId" id="deleteRoomId"/>
    </form>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Edit Room
        function editRoom(id, roomNumber, area, price, capacity, roomType, floor, status) {
            document.getElementById('editRoomId').value = id;
            document.getElementById('editRoomNumber').value = roomNumber;
            document.getElementById('editArea').value = area;
            document.getElementById('editPrice').value = price;
            document.getElementById('editCapacity').value = capacity;
            document.getElementById('editRoomType').value = roomType;
            document.getElementById('editFloorNumber').value = floor;
            document.getElementById('editStatus').value = status;
            new bootstrap.Modal(document.getElementById('editRoomModal')).show();
        }

        // Delete Room (via POST)
        function deleteRoom(id, roomNumber) {
            Swal.fire({
                title: 'Xóa phòng?',
                html: 'Bạn chắc chắn muốn xóa phòng <strong>' + roomNumber + '</strong>?<br><small class="text-muted">Hành động này không thể hoàn tác.</small>',
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#EF4444', cancelButtonColor: '#64748B',
                confirmButtonText: 'Xóa', cancelButtonText: 'Hủy'
            }).then(r => {
                if (r.isConfirmed) {
                    document.getElementById('deleteRoomId').value = id;
                    document.getElementById('deleteRoomForm').submit();
                }
            });
        }
    </script>
</body>
</html>
