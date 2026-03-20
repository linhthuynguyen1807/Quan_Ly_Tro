<%@tag description="Reusable hostel filter dropdown" pageEncoding="UTF-8"%>
<%@attribute name="hostels" required="true" type="java.util.List"%>
<%@attribute name="selectedHostelId" required="false" type="java.lang.Integer"%>
<%@attribute name="baseUrl" required="true"%>
<%@attribute name="paramName" required="false"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<c:if test="${empty paramName}">
    <c:set var="paramName" value="hostelId"/>
</c:if>

<select name="${paramName}" class="form-select"
        style="border-radius:12px; max-width:180px; border:2px solid #E2E8F0; font-size:0.85rem;"
        onchange="window.location.href='${baseUrl}' + (this.value ? '&${paramName}=' + this.value : '')">
    <option value="">Tất cả khu trọ</option>
    <c:forEach items="${hostels}" var="h">
        <option value="${h.hostel_id}" ${selectedHostelId == h.hostel_id ? 'selected' : ''}>${h.hostel_name}</option>
    </c:forEach>
</select>
