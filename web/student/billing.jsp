<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="billing"/>
<c:set var="pageTitle" value="Hóa đơn"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Hóa đơn — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/student-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Summary Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-xl-3" data-aos="fade-up">
                    <div class="stats-card" style="border-left:4px solid var(--primary-500);">
                        <div class="stats-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-file-invoice"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Tổng hóa đơn</div>
                            <div class="stats-value">${totalRecords != null ? totalRecords : 0}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stats-card" style="border-left:4px solid #F59E0B;">
                        <div class="stats-icon" style="background:rgba(245,158,11,0.1); color:#F59E0B;">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Tổng chưa thanh toán</div>
                            <div class="stats-value" style="color:#F59E0B;">
                                <fmt:formatNumber value="${totalUnpaid != null ? totalUnpaid : 0}" pattern="#,###"/>đ
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stats-card" style="border-left:4px solid var(--success);">
                        <div class="stats-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-check-double"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Đã thanh toán</div>
                            <div class="stats-value" style="color:var(--success);">
                                <fmt:formatNumber value="${totalPaid != null ? totalPaid : 0}" pattern="#,###"/>đ
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stats-card" style="border-left:4px solid var(--primary-500);">
                        <div class="stats-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-pager"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Trang</div>
                            <div class="stats-value">${currentPage != null ? currentPage : 1} / ${totalPages != null && totalPages > 0 ? totalPages : 1}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter -->
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <form method="get" action="${pageContext.request.contextPath}/student/billing" class="d-flex flex-wrap gap-3 align-items-center">
                    <select name="status" class="form-select" style="width:auto; border-radius:12px; border:2px solid #E2E8F0; font-size:0.85rem;" onchange="this.form.submit()">
                        <option value="">Tất cả trạng thái</option>
                        <option value="unpaid" ${filterStatus == 'unpaid' ? 'selected' : ''}>Chờ thanh toán</option>
                        <option value="paid" ${filterStatus == 'paid' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="overdue" ${filterStatus == 'overdue' ? 'selected' : ''}>Quá hạn</option>
                    </select>
                    <div class="ms-auto" style="font-size:0.82rem; color:var(--text-secondary);">
                        Tổng nợ: <strong style="color:var(--danger); font-size:1rem;">
                            <fmt:formatNumber value="${totalUnpaid != null ? totalUnpaid : 0}" pattern="#,###"/>đ
                        </strong>
                    </div>
                </form>
            </div>

            <!-- Invoices -->
            <div class="card-custom p-4" data-aos="fade-up">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>Tháng</th>
                                <th>Tiền phòng</th>
                                <th>Điện</th>
                                <th>Nước</th>
                                <th>Dịch vụ</th>
                                <th>Tổng</th>
                                <th>Hạn TT</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty invoices}">
                                    <c:forEach var="inv" items="${invoices}">
                                        <tr style="${inv.status == 'overdue' ? 'background:rgba(239,68,68,0.03);' : (inv.status == 'unpaid' ? 'background:rgba(245,158,11,0.03);' : '')}">
                                            <td style="font-weight:600;">${inv.invoiceMonth}</td>
                                            <td><fmt:formatNumber value="${inv.roomFee}" pattern="#,###"/>đ</td>
                                            <td><fmt:formatNumber value="${inv.electricFee}" pattern="#,###"/>đ</td>
                                            <td><fmt:formatNumber value="${inv.waterFee}" pattern="#,###"/>đ</td>
                                            <td><fmt:formatNumber value="${inv.serviceFee}" pattern="#,###"/>đ</td>
                                            <td style="font-weight:700;">
                                                <fmt:formatNumber value="${inv.totalAmount}" pattern="#,###"/>đ
                                            </td>
                                            <td>
                                                <c:if test="${inv.dueDate != null}">
                                                    <c:choose>
                                                        <c:when test="${inv.status == 'overdue'}">
                                                            <span style="color:var(--danger); font-weight:600;">
                                                                <fmt:formatDate value="${inv.dueDate}" pattern="dd/MM/yyyy"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatDate value="${inv.dueDate}" pattern="dd/MM/yyyy"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${inv.status == 'paid'}">
                                                        <span class="badge-status badge-success">Đã TT</span>
                                                    </c:when>
                                                    <c:when test="${inv.status == 'overdue'}">
                                                        <span class="badge-status badge-danger">Quá hạn</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status badge-warning">Chờ TT</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-4" style="color:var(--text-secondary);">
                                            <i class="fas fa-file-invoice fa-2x mb-2 d-block" style="opacity:0.3;"></i>
                                            Không có hóa đơn nào
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages != null && totalPages > 1}">
                    <nav class="mt-3">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/student/billing?page=${currentPage - 1}${filterStatus != null ? '&status='.concat(filterStatus) : ''}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/student/billing?page=${i}${filterStatus != null ? '&status='.concat(filterStatus) : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/student/billing?page=${currentPage + 1}${filterStatus != null ? '&status='.concat(filterStatus) : ''}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
