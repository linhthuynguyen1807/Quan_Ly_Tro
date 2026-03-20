<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="currentPage" value="hostels"/>
<c:set var="pageTitle" value="Quản lý Khu trọ"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Khu trọ — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Actions Bar -->
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4" data-aos="fade-up">
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <div class="input-group" style="max-width:300px;">
                        <span class="input-group-text bg-white border-end-0" style="border-radius:12px 0 0 12px;">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" class="form-control border-start-0" placeholder="Tìm khu trọ..." 
                               style="border-radius:0 12px 12px 0;" id="searchInput">
                    </div>
                </div>
                <button class="btn-gradient" data-bs-toggle="modal" data-bs-target="#addHostelModal">
                    <i class="fas fa-plus me-2"></i> Thêm khu trọ
                </button>
            </div>

            <!-- Hostel Grid -->
            <div class="row g-4">
                <c:forEach items="${hostels}" var="h" varStatus="loop">
                    <div class="col-xl-4 col-md-6 hostel-item" data-aos="fade-up" data-aos-delay="${loop.index * 100}">
                        <div class="card-custom p-0 overflow-hidden h-100">
                            <!-- Card Header with gradient -->
                            <div style="background: var(--gradient-main); padding:20px 24px; position:relative;">
                                <div style="position:absolute; top:12px; right:16px;">
                                    <div class="dropdown">
                                        <button class="btn btn-sm" style="color:rgba(255,255,255,0.8); background:rgba(255,255,255,0.1); border:none; border-radius:8px; padding:4px 10px;" data-bs-toggle="dropdown">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3">
                                            <li><a class="dropdown-item" href="view-hostel-detail?hostel_id=${h.hostel_id}"><i class="fas fa-eye me-2 text-muted"></i>Xem chi tiết</a></li>
                                            <li><a class="dropdown-item" href="#" onclick="editHostel(${h.hostel_id}, '${h.hostel_name}', '${h.address}')"><i class="fas fa-edit me-2 text-muted"></i>Sửa</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item text-danger" href="#" onclick="deleteHostel(${h.hostel_id}, '${h.hostel_name}')"><i class="fas fa-trash me-2"></i>Xóa</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div style="display:flex; align-items:center; gap:14px;">
                                    <div style="width:48px; height:48px; background:rgba(255,255,255,0.15); border-radius:14px; display:flex; align-items:center; justify-content:center; backdrop-filter:blur(10px);">
                                        <i class="fas fa-hotel" style="color:white; font-size:1.2rem;"></i>
                                    </div>
                                    <div>
                                        <h5 style="color:white; font-weight:700; margin:0; font-size:1.05rem;">${h.hostel_name}</h5>
                                        <p style="color:rgba(255,255,255,0.7); font-size:0.82rem; margin:4px 0 0;">
                                            <i class="fas fa-map-marker-alt me-1"></i>${h.address}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- Card Body -->
                            <div style="padding:20px 24px;">
                                <div class="d-flex justify-content-between mb-3" style="font-size:0.85rem;">
                                    <div class="text-center">
                                        <div style="font-weight:700; font-size:1.2rem; color:var(--primary-600);">--</div>
                                        <div style="color:var(--text-secondary); font-size:0.75rem;">Phòng</div>
                                    </div>
                                    <div class="text-center">
                                        <div style="font-weight:700; font-size:1.2rem; color:var(--success);">--</div>
                                        <div style="color:var(--text-secondary); font-size:0.75rem;">Trống</div>
                                    </div>
                                    <div class="text-center">
                                        <div style="font-weight:700; font-size:1.2rem; color:var(--warning);">--</div>
                                        <div style="color:var(--text-secondary); font-size:0.75rem;">Sinh viên</div>
                                    </div>
                                </div>
                                <a href="view-hostel-detail?hostel_id=${h.hostel_id}" class="btn btn-outline-primary w-100" style="border-radius:12px; font-weight:600; font-size:0.88rem;">
                                    Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Empty State -->
                <c:if test="${empty hostels}">
                    <div class="col-12" data-aos="fade-up">
                        <div class="card-custom p-5 text-center">
                            <i class="fas fa-building fa-3x mb-3" style="color:var(--primary-200);"></i>
                            <h5 style="color:var(--text-secondary); font-weight:600;">Chưa có khu trọ nào</h5>
                            <p style="color:var(--text-secondary); font-size:0.88rem;">Hãy thêm khu trọ đầu tiên để bắt đầu quản lý.</p>
                            <button class="btn-gradient mt-2" data-bs-toggle="modal" data-bs-target="#addHostelModal">
                                <i class="fas fa-plus me-2"></i> Thêm khu trọ mới
                            </button>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <!-- Add Hostel Modal -->
    <div class="modal fade" id="addHostelModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700; font-size:1.15rem;">
                        <i class="fas fa-plus-circle me-2" style="color:var(--primary-500);"></i>Thêm khu trọ mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="add-hostel" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="mb-3">
                            <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tên khu trọ</label>
                            <input type="text" name="hostel_name" class="form-control" 
                                   placeholder="VD: KTX Khu A" required
                                   style="border-radius:12px; padding:12px 16px; border:2px solid #E2E8F0;">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" style="font-weight:600; font-size:0.85rem;">Địa chỉ</label>
                            <input type="text" name="address" class="form-control" 
                                   placeholder="VD: 123 Nguyễn Văn Cừ, Q.5" required
                                   style="border-radius:12px; padding:12px 16px; border:2px solid #E2E8F0;">
                        </div>
                    </div>
                    <div class="modal-footer border-0" style="padding:0 28px 28px;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient">
                            <i class="fas fa-save me-1"></i> Lưu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Search filter
        document.getElementById('searchInput').addEventListener('input', function() {
            const q = this.value.toLowerCase();
            document.querySelectorAll('.hostel-item').forEach(el => {
                el.style.display = el.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        });

        function deleteHostel(id, name) {
            Swal.fire({
                title: 'Xóa khu trọ?',
                html: 'Bạn chắc chắn muốn xóa <strong>' + name + '</strong>?<br><small class="text-muted">Tất cả phòng & dữ liệu liên quan sẽ bị xóa.</small>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#EF4444',
                cancelButtonColor: '#64748B',
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy'
            }).then(result => {
                if (result.isConfirmed) {
                    window.location.href = 'delete-hostel?hostel_id=' + id;
                }
            });
        }
    </script>
</body>
</html>
