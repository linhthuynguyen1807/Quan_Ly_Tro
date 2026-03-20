<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="billing"/>
<c:set var="pageTitle" value="Hóa đơn & Thanh toán"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Hóa đơn — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Revenue Summary -->
            <div class="row g-3 mb-4">
                <div class="col-lg-3 col-md-6" data-aos="fade-up">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalInvoices != null ? totalInvoices : 0}</div>
                            <div class="stat-label">Tổng hóa đơn</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div>
                            <div class="stat-value" style="color:var(--success);">${paidInvoices != null ? paidInvoices : 0}</div>
                            <div class="stat-label">Đã thanh toán</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:var(--warning);">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <div class="stat-value" style="color:var(--warning);">${pendingInvoices != null ? pendingInvoices : 0}</div>
                            <div class="stat-label">Chờ thanh toán</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(239,68,68,0.1); color:var(--danger);">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div>
                            <div class="stat-value" style="color:var(--danger);">${overdueInvoices != null ? overdueInvoices : 0}</div>
                            <div class="stat-label">Quá hạn</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Revenue Card -->
            <div class="card-custom p-4 mb-4" data-aos="fade-up">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 style="font-weight:700; margin:0;">
                        <i class="fas fa-chart-line me-2" style="color:var(--primary-500);"></i>Thống kê doanh thu
                    </h6>
                    <select class="form-select" style="max-width:160px; border-radius:10px; font-size:0.85rem; border:2px solid #E2E8F0;">
                        <option>Năm 2024</option>
                        <option>Năm 2023</option>
                    </select>
                </div>
                <canvas id="revenueChart" height="100"></canvas>
            </div>

            <!-- Filters & Actions -->
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4" data-aos="fade-up">
                <div class="d-flex gap-2 flex-wrap">
                    <select class="form-select" style="border-radius:10px; max-width:160px; font-size:0.85rem; border:2px solid #E2E8F0;">
                        <option value="">Tất cả trạng thái</option>
                        <option value="paid">✅ Đã thanh toán</option>
                        <option value="pending">⏳ Chờ thanh toán</option>
                        <option value="overdue">❌ Quá hạn</option>
                    </select>
                    <select class="form-select" style="border-radius:10px; max-width:150px; font-size:0.85rem; border:2px solid #E2E8F0;">
                        <option>Tháng này</option>
                        <option>Tháng trước</option>
                        <option>3 tháng</option>
                        <option>6 tháng</option>
                    </select>
                    <div class="input-group" style="max-width:240px;">
                        <span class="input-group-text bg-white border-end-0" style="border-radius:10px 0 0 10px;">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" class="form-control border-start-0" placeholder="Tìm hóa đơn..." 
                               style="border-radius:0 10px 10px 0;" id="searchInvoice">
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-primary rounded-3" style="font-weight:600;">
                        <i class="fas fa-file-export me-1"></i> Xuất báo cáo
                    </button>
                    <button class="btn-gradient" data-bs-toggle="modal" data-bs-target="#createInvoiceModal">
                        <i class="fas fa-plus me-2"></i> Tạo hóa đơn
                    </button>
                </div>
            </div>

            <!-- Invoice Table -->
            <div class="card-custom" data-aos="fade-up" data-aos-delay="100">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Sinh viên</th>
                                <th>Phòng</th>
                                <th>Loại</th>
                                <th>Số tiền</th>
                                <th>Hạn thanh toán</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty invoices}">
                                    <c:forEach items="${invoices}" var="inv" varStatus="loop">
                                        <tr class="invoice-row">
                                            <td>
                                                <code style="font-size:0.82rem; font-weight:600;">#${inv.invoice_id}</code>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:32px; height:32px; background:var(--gradient-main); border-radius:8px; display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:0.75rem;">
                                                        ${inv.student_name.substring(0,1)}
                                                    </div>
                                                    <span style="font-weight:500; font-size:0.88rem;">${inv.student_name}</span>
                                                </div>
                                            </td>
                                            <td><span class="badge-status badge-info">${inv.room_number}</span></td>
                                            <td style="font-size:0.85rem;">${inv.type}</td>
                                            <td style="font-weight:700; color:var(--primary-700);">${inv.amount} VNĐ</td>
                                            <td style="font-size:0.85rem;">${inv.due_date}</td>
                                            <td>
                                                <tags:statusBadge status="${inv.status}"/>
                                            </td>
                                            <td class="text-center">
                                                <button class="btn btn-sm btn-outline-primary rounded-2 me-1" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <c:if test="${inv.status != 'paid'}">
                                                    <button class="btn btn-sm btn-outline-success rounded-2" title="Xác nhận TT" 
                                                            onclick="confirmPayment(${inv.invoice_id})">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="fas fa-file-invoice fa-3x mb-3" style="color:var(--primary-200);"></i>
                                            <p style="color:var(--text-secondary); margin:0;">Chưa có hóa đơn nào.</p>
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

    <!-- Create Invoice Modal -->
    <div class="modal fade" id="createInvoiceModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-file-invoice me-2" style="color:var(--primary-500);"></i>Tạo hóa đơn mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="create-invoice" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Sinh viên</label>
                                <select name="student_id" class="form-select" required style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="">Chọn sinh viên...</option>
                                    <c:forEach items="${students}" var="s">
                                        <option value="${s.user_id}">${s.fullname} — ${s.room_number}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Loại hóa đơn</label>
                                <select name="type" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option>Tiền phòng</option>
                                    <option>Tiền điện</option>
                                    <option>Tiền nước</option>
                                    <option>Phí dịch vụ</option>
                                    <option>Khác</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số tiền (VNĐ)</label>
                                <input type="number" name="amount" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Hạn thanh toán</label>
                                <input type="date" name="due_date" class="form-control" required
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Ghi chú</label>
                                <input type="text" name="note" class="form-control" 
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0" style="padding:0 28px 28px;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient"><i class="fas fa-save me-1"></i> Tạo hóa đơn</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Revenue chart
        const ctx = document.getElementById('revenueChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'],
                    datasets: [{
                        label: 'Doanh thu (triệu VNĐ)',
                        data: [12,15,18,14,20,22,19,25,23,28,26,30],
                        backgroundColor: 'rgba(59,130,246,0.15)',
                        borderColor: '#3B82F6',
                        borderWidth: 2,
                        borderRadius: 8,
                        borderSkipped: false,
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color:'rgba(0,0,0,0.04)' } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Search
        document.getElementById('searchInvoice').addEventListener('input', function() {
            const q = this.value.toLowerCase();
            document.querySelectorAll('.invoice-row').forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        });

        function confirmPayment(id) {
            Swal.fire({
                title: 'Xác nhận thanh toán?',
                text: 'Đánh dấu hóa đơn này đã được thanh toán.',
                icon: 'question', showCancelButton: true,
                confirmButtonColor: '#10B981', cancelButtonColor: '#64748B',
                confirmButtonText: 'Xác nhận', cancelButtonText: 'Hủy'
            }).then(r => { if (r.isConfirmed) window.location.href = 'confirm-payment?invoice_id=' + id; });
        }
    </script>
</body>
</html>
