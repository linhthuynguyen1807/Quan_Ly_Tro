<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="students"/>
<c:set var="pageTitle" value="Quản lý Sinh viên"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Sinh viên — KTX Manager</title>
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
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-users"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalRecords != null ? totalRecords : 0}</div>
                            <div class="stat-label">Tổng sinh viên</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div>
                            <div class="stat-value">${activeStudents != null ? activeStudents : 0}</div>
                            <div class="stat-label">Đang ở</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:var(--warning);">
                            <i class="fas fa-user-clock"></i>
                        </div>
                        <div>
                            <div class="stat-value">${pendingStudents != null ? pendingStudents : 0}</div>
                            <div class="stat-label">Sắp hết hạn</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(239,68,68,0.1); color:var(--danger);">
                            <i class="fas fa-user-times"></i>
                        </div>
                        <div>
                            <div class="stat-value">${expiredStudents != null ? expiredStudents : 0}</div>
                            <div class="stat-label">Hết hạn</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter & Actions -->
            <form method="GET" action="${pageContext.request.contextPath}/admin/students" id="studentFilterForm">
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0" style="border-radius:12px 0 0 12px;">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" name="search" class="form-control border-start-0" placeholder="Tên, SĐT, CCCD, quê quán..."
                                   style="border-radius:0 12px 12px 0;" value="${search}">
                        </div>
                    </div>
                    <div class="col-md-2">
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
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Giới tính</label>
                        <select name="gender" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tầng</label>
                        <select name="floor" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <c:forEach items="${floors}" var="f">
                                <option value="${f}" ${floor == f ? 'selected' : ''}>Tầng ${f}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Hợp đồng</label>
                        <select name="contractExpiry" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <option value="active" ${contractExpiry == 'active' ? 'selected' : ''}>🟢 Còn hạn</option>
                            <option value="expiring" ${contractExpiry == 'expiring' ? 'selected' : ''}>🟡 Sắp hết</option>
                            <option value="expired" ${contractExpiry == 'expired' ? 'selected' : ''}>🔴 Hết hạn</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn-gradient flex-fill"><i class="fas fa-filter me-1"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-light rounded-3" title="Reset"><i class="fas fa-undo"></i></a>
                    </div>
                </div>
            </div>
            </form>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-end gap-2 mb-3" data-aos="fade-up">
                <button type="button" class="btn btn-outline-primary rounded-3" style="font-weight:600;">
                    <i class="fas fa-file-export me-1"></i> Xuất Excel
                </button>
                <button type="button" class="btn-gradient" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                    <i class="fas fa-user-plus me-2"></i> Thêm sinh viên
                </button>
            </div>

            <!-- Student Table -->
            <div class="card-custom" data-aos="fade-up" data-aos-delay="100">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Sinh viên</th>
                                <th>CCCD</th>
                                <th>SĐT</th>
                                <th>Quê quán</th>
                                <th>Phòng</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty students}">
                                    <c:forEach items="${students}" var="s" varStatus="loop">
                                        <tr class="student-row">
                                            <td style="font-weight:600; color:var(--text-secondary);">${(currentPage - 1) * 10 + loop.count}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div style="width:38px; height:38px; background:var(--gradient-main); border-radius:10px; display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:0.85rem;">
                                                        ${s.full_name.substring(0,1)}
                                                    </div>
                                                    <div>
                                                        <div style="font-weight:600; font-size:0.9rem;">${s.full_name}</div>
                                                        <div style="font-size:0.75rem; color:var(--text-secondary);">${s.gender}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><code style="font-size:0.82rem;">${s.cccd}</code></td>
                                            <td style="font-size:0.85rem;">${s.phone}</td>
                                            <td style="font-size:0.85rem;">${s.address}</td>
                                            <td><span class="badge-status badge-info">${s.roomNumber}</span></td>
                                            <td>
                                                <tags:statusBadge status="${s.contractStatus != null ? s.contractStatus : 'active'}"/>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/admin/view-student?id=${s.student_id}" class="btn btn-sm btn-outline-primary rounded-2 me-1" title="Xem">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <button class="btn btn-sm btn-outline-danger rounded-2" title="Xóa"
                                                        onclick="deleteStudent(${s.student_id}, '${s.full_name}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="fas fa-user-graduate fa-3x mb-3" style="color:var(--primary-200);"></i>
                                            <p style="color:var(--text-secondary); margin:0;">Chưa có sinh viên nào trong hệ thống.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/students?search=${search}&hostelId=${selectedHostelId}&gender=${gender}&floor=${floor}&contractExpiry=${contractExpiry}"/>
                <div class="d-flex justify-content-between align-items-center p-3 border-top" style="font-size:0.85rem;">
                    <span style="color:var(--text-secondary);">Hiển thị ${(currentPage-1)*10+1}-${currentPage*10 > totalRecords ? totalRecords : currentPage*10} / ${totalRecords} sinh viên</span>
                    <tags:pagination currentPage="${currentPage}" totalPages="${totalPages}" baseUrl="${baseUrl}"/>
                </div>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        function deleteStudent(id, name) {
            Swal.fire({
                title: 'Xóa sinh viên?',
                html: 'Bạn chắc chắn muốn xóa <strong>' + name + '</strong>?',
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#EF4444', cancelButtonColor: '#64748B',
                confirmButtonText: 'Xóa', cancelButtonText: 'Hủy'
            }).then(r => { if (r.isConfirmed) window.location.href = '${pageContext.request.contextPath}/admin/students?action=delete&studentId=' + id; });
        }
    </script>
</body>
</html>
