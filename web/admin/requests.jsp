<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="currentPage" value="requests"/>
<c:set var="pageTitle" value="Yêu cầu sửa chữa"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Yêu cầu sửa chữa — KTX Manager</title>
    <style>
        .status-select {
            border: 2px solid #E2E8F0;
            border-radius: 10px;
            padding: 6px 12px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .status-select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59,130,246,0.15);
        }
        .request-title {
            font-weight: 700;
            font-size: 0.9rem;
            color: var(--text-primary);
        }
        .request-desc {
            font-size: 0.8rem;
            color: var(--text-secondary);
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
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
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalRecords != null ? totalRecords : 0}</div>
                            <div class="stat-label">Tổng yêu cầu</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:var(--warning);">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <c:set var="pendingCount" value="0"/>
                                <c:forEach items="${requests}" var="r">
                                    <c:if test="${r.status == 'pending'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
                                </c:forEach>
                                ${pendingCount}
                            </div>
                            <div class="stat-label">Đang chờ (trang này)</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:#3B82F6;">
                            <i class="fas fa-wrench"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <c:set var="progressCount" value="0"/>
                                <c:forEach items="${requests}" var="r">
                                    <c:if test="${r.status == 'in_progress'}"><c:set var="progressCount" value="${progressCount + 1}"/></c:if>
                                </c:forEach>
                                ${progressCount}
                            </div>
                            <div class="stat-label">Đang xử lý (trang này)</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <c:set var="resolvedCount" value="0"/>
                                <c:forEach items="${requests}" var="r">
                                    <c:if test="${r.status == 'resolved'}"><c:set var="resolvedCount" value="${resolvedCount + 1}"/></c:if>
                                </c:forEach>
                                ${resolvedCount}
                            </div>
                            <div class="stat-label">Hoàn thành (trang này)</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <form method="GET" action="${pageContext.request.contextPath}/admin/requests">
            <div class="card-custom p-3 mb-4" data-aos="fade-up">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0" style="border-radius:12px 0 0 12px;">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" name="search" class="form-control border-start-0" placeholder="Tiêu đề, mô tả..."
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
                        <label class="form-label" style="font-weight:600; font-size:0.82rem;">Trạng thái</label>
                        <select name="status" class="form-select" style="border-radius:12px; padding:10px 14px; border:2px solid #E2E8F0;"
                                onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <option value="pending" ${filterStatus == 'pending' ? 'selected' : ''}>🟡 Đang chờ</option>
                            <option value="in_progress" ${filterStatus == 'in_progress' ? 'selected' : ''}>🔵 Đang xử lý</option>
                            <option value="resolved" ${filterStatus == 'resolved' ? 'selected' : ''}>🟢 Hoàn thành</option>
                            <option value="rejected" ${filterStatus == 'rejected' ? 'selected' : ''}>🔴 Từ chối</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn-gradient flex-fill"><i class="fas fa-filter me-1"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/requests" class="btn btn-light rounded-3" title="Reset"><i class="fas fa-undo"></i></a>
                    </div>
                </div>
            </div>
            </form>

            <!-- Requests Table -->
            <div class="card-custom" data-aos="fade-up" data-aos-delay="100">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tiêu đề</th>
                                <th>Phòng</th>
                                <th>Mô tả</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach items="${requests}" var="r" varStatus="loop">
                                        <tr>
                                            <td style="font-weight:600; color:var(--text-secondary);">
                                                ${(currentPage - 1) * 10 + loop.count}
                                            </td>
                                            <td>
                                                <div class="request-title">${r.title}</div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:28px; height:28px; background:var(--gradient-main); border-radius:8px; display:flex; align-items:center; justify-content:center; color:white; font-size:0.7rem;">
                                                        <i class="fas fa-door-open"></i>
                                                    </div>
                                                    <span style="font-weight:600; font-size:0.85rem;">${r.room_number}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="request-desc" title="${r.description}">${r.description}</div>
                                            </td>
                                            <td style="font-size:0.82rem; color:var(--text-secondary);">
                                                <fmt:formatDate value="${r.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.status == 'pending'}">
                                                        <span class="badge" style="background:rgba(245,158,11,0.15); color:#D97706; font-weight:600; padding:6px 12px; border-radius:8px;">
                                                            <i class="fas fa-clock me-1"></i>Đang chờ
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${r.status == 'in_progress'}">
                                                        <span class="badge" style="background:rgba(59,130,246,0.15); color:#2563EB; font-weight:600; padding:6px 12px; border-radius:8px;">
                                                            <i class="fas fa-wrench me-1"></i>Đang xử lý
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${r.status == 'resolved'}">
                                                        <span class="badge" style="background:rgba(16,185,129,0.15); color:#059669; font-weight:600; padding:6px 12px; border-radius:8px;">
                                                            <i class="fas fa-check-circle me-1"></i>Hoàn thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${r.status == 'rejected'}">
                                                        <span class="badge" style="background:rgba(239,68,68,0.15); color:#DC2626; font-weight:600; padding:6px 12px; border-radius:8px;">
                                                            <i class="fas fa-times-circle me-1"></i>Từ chối
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary" style="padding:6px 12px; border-radius:8px;">${r.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/requests" style="display:inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="requestId" value="${r.request_id}">
                                                    <select name="status" class="status-select" onchange="this.form.submit()">
                                                        <option value="pending" ${r.status == 'pending' ? 'selected' : ''}>🟡 Đang chờ</option>
                                                        <option value="in_progress" ${r.status == 'in_progress' ? 'selected' : ''}>🔵 Đang xử lý</option>
                                                        <option value="resolved" ${r.status == 'resolved' ? 'selected' : ''}>🟢 Hoàn thành</option>
                                                        <option value="rejected" ${r.status == 'rejected' ? 'selected' : ''}>🔴 Từ chối</option>
                                                    </select>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5">
                                            <div style="color:var(--text-secondary);">
                                                <i class="fas fa-inbox fa-3x mb-3 d-block" style="opacity:0.3;"></i>
                                                <p class="mb-0" style="font-weight:600;">Chưa có yêu cầu sửa chữa nào</p>
                                                <p class="mb-0" style="font-size:0.82rem;">Các yêu cầu từ sinh viên sẽ hiển thị tại đây</p>
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
                             baseUrl="${pageContext.request.contextPath}/admin/requests?hostelId=${selectedHostelId}&status=${filterStatus}&search=${search}"/>

            <!-- Info Footer -->
            <div class="text-center mt-3 mb-4" style="font-size:0.8rem; color:var(--text-secondary);" data-aos="fade-up">
                Hiển thị <strong>${not empty requests ? requests.size() : 0}</strong> / <strong>${totalRecords}</strong> yêu cầu
            </div>

        </main>
    </div>

    <%@include file="/includes/footer-scripts.jsp"%>
</body>
</html>
