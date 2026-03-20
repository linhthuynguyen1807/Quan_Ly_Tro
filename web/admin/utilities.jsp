<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="utilities"/>
<c:set var="pageTitle" value="Điện & Nước"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Điện & Nước — KTX Manager</title>
    <style>
        .reading-highlight {
            background: linear-gradient(135deg, rgba(59,130,246,0.08), rgba(139,92,246,0.08));
            border-radius: 12px;
            padding: 6px 12px;
            font-weight: 700;
            font-size: 0.85rem;
        }
        .reading-highlight.electric { color: #F59E0B; }
        .reading-highlight.water { color: #3B82F6; }
        .meter-arrow { font-size: 0.7rem; color: var(--text-secondary); margin: 0 4px; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-3" data-aos="fade-up">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:var(--warning);">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalRecords != null ? totalRecords : 0}</div>
                            <div class="stat-label">Tổng bản ghi</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-tint"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <c:set var="totalWater" value="0"/>
                                <c:forEach items="${readings}" var="r">
                                    <c:set var="totalWater" value="${totalWater + r.waterUsage}"/>
                                </c:forEach>
                                ${totalWater}
                            </div>
                            <div class="stat-label">Tổng nước (m³) trang này</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:#F59E0B;">
                            <i class="fas fa-plug"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <c:set var="totalElectric" value="0"/>
                                <c:forEach items="${readings}" var="r">
                                    <c:set var="totalElectric" value="${totalElectric + r.electricUsage}"/>
                                </c:forEach>
                                ${totalElectric}
                            </div>
                            <div class="stat-label">Tổng điện (kWh) trang này</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div>
                            <div class="stat-value">${filterMonth != null ? filterMonth : 'Tất cả'}</div>
                            <div class="stat-label">Tháng đang lọc</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <form method="GET" action="${pageContext.request.contextPath}/admin/utilities">
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0" style="border-radius:12px 0 0 12px;">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" name="search" class="form-control border-start-0" placeholder="Số phòng..."
                                   style="border-radius:0 12px 12px 0;" value="${search}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Khu trọ</label>
                        <select name="hostelId" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <c:forEach items="${hostels}" var="h">
                                <option value="${h.hostel_id}" ${selectedHostelId == h.hostel_id ? 'selected' : ''}>${h.hostel_name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tháng ghi</label>
                        <input type="month" name="month" class="form-control" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                               value="${filterMonth}">
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn-gradient flex-fill"><i class="fas fa-filter me-1"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/utilities" class="btn btn-light rounded-3" title="Reset"><i class="fas fa-undo"></i></a>
                    </div>
                </div>
            </div>
            </form>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-end gap-2 mb-3" data-aos="fade-up">
                <button type="button" class="btn-gradient" data-bs-toggle="modal" data-bs-target="#addReadingModal">
                    <i class="fas fa-plus-circle me-2"></i> Thêm chỉ số
                </button>
            </div>

            <!-- Readings Table -->
            <div class="card-custom" data-aos="fade-up" data-aos-delay="100">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Phòng</th>
                                <th>Tháng</th>
                                <th>Điện cũ</th>
                                <th>Điện mới</th>
                                <th>Tiêu thụ điện</th>
                                <th>Nước cũ</th>
                                <th>Nước mới</th>
                                <th>Tiêu thụ nước</th>
                                <th>Ngày ghi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty readings}">
                                    <c:forEach items="${readings}" var="r" varStatus="loop">
                                        <tr>
                                            <td style="font-weight:600; color:var(--text-secondary);">
                                                ${(currentPage - 1) * 10 + loop.count}
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:32px; height:32px; background:var(--gradient-main); border-radius:8px; display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:0.75rem;">
                                                        <i class="fas fa-door-open"></i>
                                                    </div>
                                                    <span style="font-weight:600;">${r.roomNumber}</span>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-light text-dark" style="font-size:0.8rem;">${r.readingMonth}</span></td>
                                            <td>${r.electricOld}</td>
                                            <td>${r.electricNew}</td>
                                            <td>
                                                <span class="reading-highlight electric">
                                                    <i class="fas fa-bolt me-1"></i>${r.electricUsage} kWh
                                                </span>
                                            </td>
                                            <td>${r.waterOld}</td>
                                            <td>${r.waterNew}</td>
                                            <td>
                                                <span class="reading-highlight water">
                                                    <i class="fas fa-tint me-1"></i>${r.waterUsage} m³
                                                </span>
                                            </td>
                                            <td style="font-size:0.82rem; color:var(--text-secondary);">
                                                <fmt:formatDate value="${r.readingDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="text-center py-5">
                                            <div style="color:var(--text-secondary);">
                                                <i class="fas fa-inbox fa-3x mb-3 d-block" style="opacity:0.3;"></i>
                                                <p class="mb-0" style="font-weight:600;">Chưa có dữ liệu chỉ số điện nước</p>
                                                <p class="mb-0" style="font-size:0.82rem;">Hãy thêm chỉ số mới bằng nút "Thêm chỉ số" ở trên</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination -->
            <tags:pagination currentPage="${currentPage}" totalPages="${totalPages}"
                             baseUrl="${pageContext.request.contextPath}/admin/utilities?hostelId=${selectedHostelId}&search=${search}&month=${filterMonth}"/>

            <!-- Info Footer -->
            <div class="text-center mt-3 mb-4" style="font-size:0.8rem; color:var(--text-secondary);" data-aos="fade-up">
                Hiển thị <strong>${not empty readings ? readings.size() : 0}</strong> / <strong>${totalRecords}</strong> bản ghi
            </div>

        </main>
    </div>

    <!-- Add Reading Modal -->
    <div class="modal fade" id="addReadingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="border-radius:20px; border:none;">
                <div class="modal-header" style="background:var(--gradient-main); color:white; border-radius:20px 20px 0 0;">
                    <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>Thêm chỉ số điện nước</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/utilities">
                    <input type="hidden" name="hostelId" value="${selectedHostelId}">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label class="form-label fw-bold">Phòng <span class="text-danger">*</span></label>
                                <select name="roomId" class="form-select" required style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                                    <option value="">-- Chọn phòng --</option>
                                    <c:forEach items="${rooms}" var="room">
                                        <option value="${room.room_id}">${room.room_number}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tháng <span class="text-danger">*</span></label>
                                <select name="month" class="form-select" required style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                                    <c:forEach var="m" begin="1" end="12">
                                        <option value="${m < 10 ? '0' : ''}${m}">Tháng ${m}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Năm <span class="text-danger">*</span></label>
                                <select name="year" class="form-select" required style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                                    <option value="2024">2024</option>
                                    <option value="2025" selected>2025</option>
                                    <option value="2026">2026</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <hr style="border-color:#E2E8F0;">
                                <h6 class="fw-bold mb-3"><i class="fas fa-bolt text-warning me-2"></i>Chỉ số điện</h6>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Chỉ số cũ (kWh)</label>
                                <input type="number" name="prevElectric" class="form-control" min="0" value="0"
                                       style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Chỉ số mới (kWh) <span class="text-danger">*</span></label>
                                <input type="number" name="currElectric" class="form-control" min="0" required
                                       style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-12">
                                <hr style="border-color:#E2E8F0;">
                                <h6 class="fw-bold mb-3"><i class="fas fa-tint text-primary me-2"></i>Chỉ số nước</h6>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Chỉ số cũ (m³)</label>
                                <input type="number" name="prevWater" class="form-control" min="0" value="0"
                                       style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Chỉ số mới (m³) <span class="text-danger">*</span></label>
                                <input type="number" name="currWater" class="form-control" min="0" required
                                       style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top:1px solid #E2E8F0;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient px-4">
                            <i class="fas fa-save me-2"></i>Lưu chỉ số
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/footer-scripts.jsp"%>
</body>
</html>
