<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="maintenance"/>
<c:set var="pageTitle" value="Yêu cầu sửa chữa"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Yêu cầu sửa chữa — KTX Manager</title>
    <style>
        .request-card {
            background: var(--bg-card);
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 20px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }
        .request-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            transform: translateY(-2px);
        }
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }
        .request-title {
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--text-primary);
        }
        .request-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.5;
        }
        .request-meta {
            display: flex;
            gap: 16px;
            margin-top: 12px;
            font-size: 0.8rem;
            color: var(--text-tertiary);
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/student-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Summary -->
            <div class="row g-4 mb-4">
                <div class="col-md-4" data-aos="fade-up">
                    <div class="stats-card" style="border-left:4px solid var(--primary-500);">
                        <div class="stats-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-tools"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Tổng yêu cầu</div>
                            <div class="stats-value">${totalRecords != null ? totalRecords : 0}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="stats-card" style="border-left:4px solid #F59E0B;">
                        <div class="stats-icon" style="background:rgba(245,158,11,0.1); color:#F59E0B;">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Phòng hiện tại</div>
                            <div class="stats-value">${room != null ? room.roomNumber : 'N/A'}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="stats-card" style="border-left:4px solid var(--success);">
                        <div class="stats-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                        <div class="stats-info">
                            <div class="stats-label">Gửi yêu cầu mới</div>
                            <div class="stats-value">
                                <button type="button" class="btn-gradient" data-bs-toggle="modal" data-bs-target="#newRequestModal" style="padding:6px 16px; font-size:0.8rem;">
                                    <i class="fas fa-plus me-1"></i>Tạo mới
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter -->
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <form method="get" action="${pageContext.request.contextPath}/student/maintenance" class="d-flex flex-wrap gap-3 align-items-center">
                    <select name="status" class="form-select" style="width:auto; border-radius:12px; border:2px solid #E2E8F0; font-size:0.85rem;" onchange="this.form.submit()">
                        <option value="">Tất cả trạng thái</option>
                        <option value="pending" ${filterStatus == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="processing" ${filterStatus == 'processing' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="done" ${filterStatus == 'done' ? 'selected' : ''}>Đã xong</option>
                    </select>
                    <span class="ms-auto" style="font-size:0.82rem; color:var(--text-secondary);">
                        Hiển thị <strong>${not empty requests ? requests.size() : 0}</strong> / <strong>${totalRecords}</strong> yêu cầu
                    </span>
                </form>
            </div>

            <!-- Request List -->
            <div data-aos="fade-up">
                <c:choose>
                    <c:when test="${not empty requests}">
                        <c:forEach var="req" items="${requests}">
                            <div class="request-card">
                                <div class="request-header">
                                    <div class="request-title">
                                        <i class="fas fa-wrench me-2" style="color:var(--primary-500);"></i>
                                        ${req.title}
                                    </div>
                                    <c:choose>
                                        <c:when test="${req.status == 'done'}">
                                            <span class="badge-status badge-success">Đã xong</span>
                                        </c:when>
                                        <c:when test="${req.status == 'processing'}">
                                            <span class="badge-status badge-info">Đang xử lý</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status badge-warning">Chờ xử lý</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="request-desc">${req.description}</div>
                                <div class="request-meta">
                                    <span><i class="fas fa-door-open me-1"></i>Phòng ${req.room_number}</span>
                                    <span><i class="fas fa-calendar me-1"></i>
                                        <c:if test="${req.created_at != null}">
                                            <fmt:formatDate value="${req.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:if>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card-custom p-5 text-center" style="color:var(--text-secondary);">
                            <i class="fas fa-tools fa-3x mb-3" style="opacity:0.2;"></i>
                            <p class="mb-0">Bạn chưa có yêu cầu sửa chữa nào</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages != null && totalPages > 1}">
                <nav class="mt-3">
                    <ul class="pagination pagination-custom justify-content-center mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/student/maintenance?page=${currentPage - 1}${filterStatus != null ? '&status='.concat(filterStatus) : ''}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/student/maintenance?page=${i}${filterStatus != null ? '&status='.concat(filterStatus) : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/student/maintenance?page=${currentPage + 1}${filterStatus != null ? '&status='.concat(filterStatus) : ''}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </main>
    </div>

    <!-- New Request Modal -->
    <div class="modal fade modal-custom" id="newRequestModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus-circle me-2"></i>Gửi yêu cầu mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/student/maintenance">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề <span style="color:var(--danger);">*</span></label>
                            <input type="text" name="title" class="form-control" required placeholder="VD: Hỏng bóng đèn phòng...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả chi tiết <span style="color:var(--danger);">*</span></label>
                            <textarea name="description" class="form-control" rows="4" required placeholder="Mô tả chi tiết vấn đề bạn gặp phải..." style="resize:vertical;"></textarea>
                        </div>
                        <div class="p-3" style="background:rgba(59,130,246,0.05); border-radius:12px; font-size:0.82rem; color:var(--text-secondary);">
                            <i class="fas fa-info-circle me-1" style="color:var(--primary-500);"></i>
                            Yêu cầu sẽ được gửi cho phòng <strong>${room != null ? room.roomNumber : 'N/A'}</strong>.
                            Ban quản lý sẽ xử lý trong thời gian sớm nhất.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light rounded-3" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient">
                            <i class="fas fa-paper-plane me-1"></i>Gửi yêu cầu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
