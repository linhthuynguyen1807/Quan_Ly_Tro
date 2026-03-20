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
                                <th>Trường</th>
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
                                            <td style="font-size:0.85rem;">${s.school}</td>
                                            <td style="font-size:0.85rem;">${s.address}</td>
                                            <td><span class="badge-status badge-info">${s.roomNumber}</span></td>
                                            <td>
                                                <tags:statusBadge status="${s.contractStatus != null ? s.contractStatus : 'active'}"/>
                                            </td>
                                            <td class="text-center">
                                                <button class="btn btn-sm btn-outline-info rounded-2 me-1" title="Xem chi tiết"
                                                        onclick="viewStudent('${s.full_name}', '${s.cccd}', '${s.phone}', '${s.school}', '${s.gender}', '${s.address}', '${s.roomNumber}')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-primary rounded-2 me-1" title="Sửa"
                                                        onclick="editStudent(${s.student_id}, '${s.full_name}', '${s.cccd}', '${s.phone}', '${s.school}', '${s.gender}', '${s.address}')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
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
                                        <td colspan="9" class="text-center py-5">
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

    <!-- ==================== ADD STUDENT MODAL ==================== -->
    <div class="modal fade" id="addStudentModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-user-plus me-2" style="color:var(--primary-500);"></i> Thêm sinh viên mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/students" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="action" value="add"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">User ID <span class="text-danger">*</span></label>
                                <input type="number" name="userId" class="form-control" placeholder="ID tài khoản" required min="1"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                <small class="text-muted">ID của tài khoản đã đăng ký trong hệ thống</small>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">CCCD <span class="text-danger">*</span></label>
                                <input type="text" name="cccd" class="form-control" placeholder="001234567890" required maxlength="12"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số điện thoại</label>
                                <input type="tel" name="phone" class="form-control" placeholder="0901234567"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giới tính</label>
                                <select name="gender" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="Nam">Nam</option>
                                    <option value="Nữ">Nữ</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Trường học</label>
                                <input type="text" name="school" class="form-control" placeholder="Đại học FPT"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-12">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Quê quán</label>
                                <input type="text" name="address" class="form-control" placeholder="Hà Nội, Việt Nam"
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

    <!-- ==================== EDIT STUDENT MODAL ==================== -->
    <div class="modal fade" id="editStudentModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-user-edit me-2" style="color:var(--primary-500);"></i> Chỉnh sửa sinh viên
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/students" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="studentId" id="editStudentId"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" id="editFullName" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">CCCD <span class="text-danger">*</span></label>
                                <input type="text" name="cccd" id="editCccd" class="form-control" required maxlength="12"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số điện thoại</label>
                                <input type="tel" name="phone" id="editPhone" class="form-control"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giới tính</label>
                                <select name="gender" id="editGender" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="Nam">Nam</option>
                                    <option value="Nữ">Nữ</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Trường học</label>
                                <input type="text" name="school" id="editSchool" class="form-control"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-12">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Quê quán</label>
                                <input type="text" name="address" id="editAddress" class="form-control"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
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

    <!-- ==================== VIEW STUDENT MODAL ==================== -->
    <div class="modal fade" id="viewStudentModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-user me-2" style="color:var(--primary-500);"></i> Thông tin sinh viên
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" style="padding:24px 28px;">
                    <div class="text-center mb-4">
                        <div id="viewAvatar" style="width:64px; height:64px; background:var(--gradient-main); border-radius:16px; display:inline-flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:1.5rem;"></div>
                        <h5 id="viewName" class="mt-2 mb-0" style="font-weight:700;"></h5>
                        <span id="viewGenderBadge" class="badge-status badge-info mt-1"></span>
                    </div>
                    <div class="list-group list-group-flush">
                        <div class="list-group-item d-flex justify-content-between px-0 border-0" style="font-size:0.9rem;">
                            <span style="color:var(--text-secondary);"><i class="fas fa-id-card me-2"></i>CCCD</span>
                            <strong id="viewCccd"></strong>
                        </div>
                        <div class="list-group-item d-flex justify-content-between px-0 border-0" style="font-size:0.9rem;">
                            <span style="color:var(--text-secondary);"><i class="fas fa-phone me-2"></i>Điện thoại</span>
                            <strong id="viewPhone"></strong>
                        </div>
                        <div class="list-group-item d-flex justify-content-between px-0 border-0" style="font-size:0.9rem;">
                            <span style="color:var(--text-secondary);"><i class="fas fa-school me-2"></i>Trường</span>
                            <strong id="viewSchool"></strong>
                        </div>
                        <div class="list-group-item d-flex justify-content-between px-0 border-0" style="font-size:0.9rem;">
                            <span style="color:var(--text-secondary);"><i class="fas fa-map-marker-alt me-2"></i>Quê quán</span>
                            <strong id="viewAddress"></strong>
                        </div>
                        <div class="list-group-item d-flex justify-content-between px-0 border-0" style="font-size:0.9rem;">
                            <span style="color:var(--text-secondary);"><i class="fas fa-door-open me-2"></i>Phòng</span>
                            <strong id="viewRoom"></strong>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0" style="padding:0 28px 28px;">
                    <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Delete Form (POST) -->
    <form id="deleteStudentForm" action="${pageContext.request.contextPath}/admin/students" method="POST" style="display:none;">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" name="studentId" id="deleteStudentId"/>
    </form>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // View Student Detail
        function viewStudent(name, cccd, phone, school, gender, address, room) {
            document.getElementById('viewAvatar').textContent = name.charAt(0);
            document.getElementById('viewName').textContent = name;
            document.getElementById('viewGenderBadge').textContent = gender;
            document.getElementById('viewCccd').textContent = cccd || '—';
            document.getElementById('viewPhone').textContent = phone || '—';
            document.getElementById('viewSchool').textContent = school || '—';
            document.getElementById('viewAddress').textContent = address || '—';
            document.getElementById('viewRoom').textContent = room || '—';
            new bootstrap.Modal(document.getElementById('viewStudentModal')).show();
        }

        // Edit Student
        function editStudent(id, name, cccd, phone, school, gender, address) {
            document.getElementById('editStudentId').value = id;
            document.getElementById('editFullName').value = name;
            document.getElementById('editCccd').value = cccd;
            document.getElementById('editPhone').value = phone;
            document.getElementById('editSchool').value = school;
            document.getElementById('editGender').value = gender;
            document.getElementById('editAddress').value = address;
            new bootstrap.Modal(document.getElementById('editStudentModal')).show();
        }

        // Delete Student (via POST)
        function deleteStudent(id, name) {
            Swal.fire({
                title: 'Xóa sinh viên?',
                html: 'Bạn chắc chắn muốn xóa <strong>' + name + '</strong>?',
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#EF4444', cancelButtonColor: '#64748B',
                confirmButtonText: 'Xóa', cancelButtonText: 'Hủy'
            }).then(r => {
                if (r.isConfirmed) {
                    document.getElementById('deleteStudentId').value = id;
                    document.getElementById('deleteStudentForm').submit();
                }
            });
        }
    </script>
</body>
</html>
