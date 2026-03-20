<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="contracts"/>
<c:set var="pageTitle" value="Hợp đồng"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Hợp đồng — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Stats Cards -->
            <div class="row g-3 mb-4">
                <div class="col-lg-4 col-md-6" data-aos="fade-up">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div>
                            <div class="stat-value">${contracts != null ? contracts.size() : 0}</div>
                            <div class="stat-label">Tổng hợp đồng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters & Actions -->
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4" data-aos="fade-up">
                <div class="d-flex gap-2 flex-wrap">
                    <tags:hostelFilter hostels="${hostels}" selectedHostelId="${selectedHostelId}"
                                       baseUrl="${pageContext.request.contextPath}/admin/contracts?"/>
                    <div class="input-group" style="max-width:240px;">
                        <span class="input-group-text bg-white border-end-0" style="border-radius:10px 0 0 10px;">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" class="form-control border-start-0" placeholder="Tìm hợp đồng..."
                               style="border-radius:0 10px 10px 0;" id="searchContract">
                    </div>
                </div>
                <button class="btn-gradient" data-bs-toggle="modal" data-bs-target="#addContractModal">
                    <i class="fas fa-plus me-2"></i> Tạo hợp đồng
                </button>
            </div>

            <!-- Contract Table -->
            <div class="card-custom" data-aos="fade-up" data-aos-delay="100">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Sinh viên</th>
                                <th>Phòng</th>
                                <th>Ngày bắt đầu</th>
                                <th>Ngày kết thúc</th>
                                <th>Tiền thuê/tháng</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty contracts}">
                                    <c:forEach items="${contracts}" var="c" varStatus="loop">
                                        <tr class="contract-row">
                                            <td>
                                                <code style="font-size:0.82rem; font-weight:600;">#${c.contract_id}</code>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:32px; height:32px; background:var(--gradient-main); border-radius:8px; display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:0.75rem;">
                                                        ${c.studentName != null ? c.studentName.substring(0,1) : '?'}
                                                    </div>
                                                    <span style="font-weight:500; font-size:0.88rem;">${c.studentName}</span>
                                                </div>
                                            </td>
                                            <td><span class="badge-status badge-info">${c.roomNumber}</span></td>
                                            <td style="font-size:0.85rem;">
                                                <fmt:formatDate value="${c.start_date}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td style="font-size:0.85rem;">
                                                <fmt:formatDate value="${c.end_date}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td style="font-weight:700; color:var(--primary-700);">
                                                <fmt:formatNumber value="${c.monthly_rent}" type="number" groupingUsed="true"/> VNĐ
                                            </td>
                                            <td>
                                                <tags:statusBadge status="${c.status}"/>
                                            </td>
                                            <td class="text-center">
                                                <button class="btn btn-sm btn-outline-primary rounded-2 me-1" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <c:if test="${c.status == 'active'}">
                                                    <button class="btn btn-sm btn-outline-danger rounded-2" title="Kết thúc"
                                                            onclick="terminateContract(${c.contract_id})">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="fas fa-file-contract fa-3x mb-3" style="color:var(--primary-200);"></i>
                                            <p style="color:var(--text-secondary); margin:0;">Chưa có hợp đồng nào.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Add Contract Modal -->
    <div class="modal fade" id="addContractModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-file-contract me-2" style="color:var(--primary-500);"></i>Tạo hợp đồng mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/contracts" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Sinh viên (Student ID)</label>
                                <input type="number" name="studentId" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Phòng (Room ID)</label>
                                <input type="number" name="roomId" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Ngày bắt đầu</label>
                                <input type="date" name="startDate" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Ngày kết thúc</label>
                                <input type="date" name="endDate" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tiền thuê/tháng (VNĐ)</label>
                                <input type="number" name="monthlyRent" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tiền đặt cọc (VNĐ)</label>
                                <input type="number" name="deposit" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0" style="padding:0 28px 28px;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient"><i class="fas fa-save me-1"></i> Tạo hợp đồng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Search
        document.getElementById('searchContract').addEventListener('input', function() {
            const q = this.value.toLowerCase();
            document.querySelectorAll('.contract-row').forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        });

        function terminateContract(id) {
            Swal.fire({
                title: 'Kết thúc hợp đồng?',
                text: 'Bạn có chắc chắn muốn kết thúc hợp đồng này?',
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#EF4444', cancelButtonColor: '#64748B',
                confirmButtonText: 'Kết thúc', cancelButtonText: 'Hủy'
            }).then(r => {
                if (r.isConfirmed) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/contracts';
                    form.innerHTML = '<input type="hidden" name="action" value="terminate">' +
                                     '<input type="hidden" name="contractId" value="' + id + '">';
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    </script>
</body>
</html>
