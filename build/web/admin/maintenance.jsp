<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="currentPage" value="maintenance"/>
<c:set var="pageTitle" value="Bảo trì & Sửa chữa"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Bảo trì — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Stats -->
            <div class="row g-3 mb-4">
                <div class="col-md-3" data-aos="fade-up">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,0.1); color:var(--warning);">
                            <i class="fas fa-tools"></i>
                        </div>
                        <div>
                            <div class="stat-value">${pendingRequests != null ? pendingRequests : 0}</div>
                            <div class="stat-label">Đang chờ xử lý</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(59,130,246,0.1); color:var(--primary-500);">
                            <i class="fas fa-wrench"></i>
                        </div>
                        <div>
                            <div class="stat-value">${inProgressRequests != null ? inProgressRequests : 0}</div>
                            <div class="stat-label">Đang sửa</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,0.1); color:var(--success);">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div>
                            <div class="stat-value">${completedRequests != null ? completedRequests : 0}</div>
                            <div class="stat-label">Hoàn thành</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(239,68,68,0.1); color:var(--danger);">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <div>
                            <div class="stat-value">${urgentRequests != null ? urgentRequests : 0}</div>
                            <div class="stat-label">Khẩn cấp</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4" data-aos="fade-up">
                <div class="d-flex gap-2 flex-wrap">
                    <select class="form-select" style="border-radius:10px; max-width:150px; font-size:0.85rem; border:2px solid #E2E8F0;">
                        <option value="">Tất cả TT</option>
                        <option>⏳ Chờ xử lý</option>
                        <option>🔧 Đang sửa</option>
                        <option>✅ Hoàn thành</option>
                    </select>
                    <select class="form-select" style="border-radius:10px; max-width:150px; font-size:0.85rem; border:2px solid #E2E8F0;">
                        <option value="">Độ ưu tiên</option>
                        <option>🔴 Khẩn cấp</option>
                        <option>🟡 Cao</option>
                        <option>🟢 Bình thường</option>
                    </select>
                    <div class="input-group" style="max-width:240px;">
                        <span class="input-group-text bg-white border-end-0" style="border-radius:10px 0 0 10px;">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" class="form-control border-start-0" placeholder="Tìm kiếm..."
                               style="border-radius:0 10px 10px 0;" id="searchMaint">
                    </div>
                </div>
                <button class="btn-gradient" data-bs-toggle="modal" data-bs-target="#createRequestModal">
                    <i class="fas fa-plus me-2"></i> Tạo yêu cầu
                </button>
            </div>

            <!-- Kanban Board -->
            <div class="row g-3" data-aos="fade-up" data-aos-delay="100">
                <!-- Pending -->
                <div class="col-lg-4">
                    <div style="background:#FEF3C7; border-radius:16px 16px 0 0; padding:12px 20px;">
                        <h6 style="font-weight:700; color:#92400E; margin:0; font-size:0.88rem;">
                            <i class="fas fa-clock me-2"></i>Chờ xử lý
                            <span class="badge-status badge-warning ms-2">${pendingRequests != null ? pendingRequests : 0}</span>
                        </h6>
                    </div>
                    <div class="card-custom" style="border-radius:0 0 16px 16px; border-top:none; min-height:300px;">
                        <div class="p-3">
                            <c:forEach items="${pendingList}" var="req">
                                <div class="p-3 mb-2 rounded-3" style="background:#FAFAFA; border:1px solid #F1F5F9;">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span style="font-weight:600; font-size:0.88rem;">${req.title}</span>
                                        <c:if test="${req.priority == 'urgent'}">
                                            <span class="badge bg-danger rounded-pill" style="font-size:0.65rem;">Khẩn</span>
                                        </c:if>
                                    </div>
                                    <p style="font-size:0.78rem; color:var(--text-secondary); margin:0 0 8px;">${req.description}</p>
                                    <div class="d-flex justify-content-between" style="font-size:0.72rem; color:var(--text-secondary);">
                                        <span><i class="fas fa-door-open me-1"></i>${req.room_number}</span>
                                        <span><i class="fas fa-calendar me-1"></i>${req.created_date}</span>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty pendingList}">
                                <p class="text-center py-4" style="color:var(--text-secondary); font-size:0.85rem;">Không có yêu cầu</p>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- In Progress -->
                <div class="col-lg-4">
                    <div style="background:rgba(59,130,246,0.1); border-radius:16px 16px 0 0; padding:12px 20px;">
                        <h6 style="font-weight:700; color:var(--primary-700); margin:0; font-size:0.88rem;">
                            <i class="fas fa-wrench me-2"></i>Đang sửa
                            <span class="badge-status badge-info ms-2">${inProgressRequests != null ? inProgressRequests : 0}</span>
                        </h6>
                    </div>
                    <div class="card-custom" style="border-radius:0 0 16px 16px; border-top:none; min-height:300px;">
                        <div class="p-3">
                            <c:forEach items="${inProgressList}" var="req">
                                <div class="p-3 mb-2 rounded-3" style="background:#FAFAFA; border:1px solid #F1F5F9;">
                                    <div style="font-weight:600; font-size:0.88rem; margin-bottom:4px;">${req.title}</div>
                                    <p style="font-size:0.78rem; color:var(--text-secondary); margin:0 0 8px;">${req.description}</p>
                                    <div class="d-flex justify-content-between" style="font-size:0.72rem; color:var(--text-secondary);">
                                        <span><i class="fas fa-user me-1"></i>${req.assigned_to}</span>
                                        <span><i class="fas fa-calendar me-1"></i>${req.updated_date}</span>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty inProgressList}">
                                <p class="text-center py-4" style="color:var(--text-secondary); font-size:0.85rem;">Không có yêu cầu</p>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Completed -->
                <div class="col-lg-4">
                    <div style="background:#D1FAE5; border-radius:16px 16px 0 0; padding:12px 20px;">
                        <h6 style="font-weight:700; color:#065F46; margin:0; font-size:0.88rem;">
                            <i class="fas fa-check-circle me-2"></i>Hoàn thành
                            <span class="badge-status badge-success ms-2">${completedRequests != null ? completedRequests : 0}</span>
                        </h6>
                    </div>
                    <div class="card-custom" style="border-radius:0 0 16px 16px; border-top:none; min-height:300px;">
                        <div class="p-3">
                            <c:forEach items="${completedList}" var="req">
                                <div class="p-3 mb-2 rounded-3" style="background:#FAFAFA; border:1px solid #F1F5F9;">
                                    <div style="font-weight:600; font-size:0.88rem; margin-bottom:4px; text-decoration:line-through; opacity:0.7;">${req.title}</div>
                                    <div class="d-flex justify-content-between" style="font-size:0.72rem; color:var(--text-secondary);">
                                        <span><i class="fas fa-door-open me-1"></i>${req.room_number}</span>
                                        <span><i class="fas fa-check me-1" style="color:var(--success);"></i>${req.completed_date}</span>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty completedList}">
                                <p class="text-center py-4" style="color:var(--text-secondary); font-size:0.85rem;">Không có yêu cầu</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Create Request Modal -->
    <div class="modal fade" id="createRequestModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius:20px;">
                <div class="modal-header border-0 pb-0" style="padding:28px 28px 0;">
                    <h5 class="modal-title" style="font-weight:700;">
                        <i class="fas fa-tools me-2" style="color:var(--primary-500);"></i>Tạo yêu cầu bảo trì
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="create-maintenance" method="POST">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
                    <div class="modal-body" style="padding:24px 28px;">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tiêu đề</label>
                                <input type="text" name="title" class="form-control" required
                                       placeholder="VD: Hỏng vòi nước phòng 101"
                                       style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Phòng</label>
                                <select name="room_id" class="form-select" required style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="">Chọn phòng...</option>
                                    <c:forEach items="${rooms}" var="r">
                                        <option value="${r.room_id}">${r.room_number}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Độ ưu tiên</label>
                                <select name="priority" class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    <option value="normal">🟢 Bình thường</option>
                                    <option value="high">🟡 Cao</option>
                                    <option value="urgent">🔴 Khẩn cấp</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label" style="font-weight:600; font-size:0.85rem;">Mô tả chi tiết</label>
                                <textarea name="description" class="form-control" rows="3" 
                                          style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0" style="padding:0 28px 28px;">
                        <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-gradient"><i class="fas fa-save me-1"></i> Tạo yêu cầu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/includes/scripts.jsp"%>
</body>
</html>
