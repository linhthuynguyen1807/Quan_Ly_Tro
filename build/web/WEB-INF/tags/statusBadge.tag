<%@tag description="Reusable status badge component" pageEncoding="UTF-8"%>
<%@attribute name="status" required="true"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<c:choose>
    <c:when test="${status == 'active' || status == 'paid' || status == 'resolved' || status == 'Đang ở'}">
        <span class="badge-status badge-success">${status}</span>
    </c:when>
    <c:when test="${status == 'pending' || status == 'unpaid' || status == 'Trống'}">
        <span class="badge-status badge-warning">${status}</span>
    </c:when>
    <c:when test="${status == 'processing' || status == 'in_progress'}">
        <span class="badge-status badge-info">${status}</span>
    </c:when>
    <c:when test="${status == 'terminated' || status == 'expired' || status == 'rejected' || status == 'overdue' || status == 'Bảo trì'}">
        <span class="badge-status badge-danger">${status}</span>
    </c:when>
    <c:otherwise>
        <span class="badge-status" style="background:#E2E8F0; color:#475569;">${status}</span>
    </c:otherwise>
</c:choose>
