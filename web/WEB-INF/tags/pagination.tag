<%@tag description="Reusable pagination component" pageEncoding="UTF-8"%>
<%@attribute name="currentPage" required="true" type="java.lang.Integer"%>
<%@attribute name="totalPages" required="true" type="java.lang.Integer"%>
<%@attribute name="baseUrl" required="true"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<c:if test="${totalPages > 1}">
<nav aria-label="Pagination" class="d-flex justify-content-center mt-4">
    <ul class="pagination pagination-sm mb-0">
        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
            <a class="page-link" href="${baseUrl}&page=${currentPage - 1}" aria-label="Previous">
                <i class="fas fa-chevron-left"></i>
            </a>
        </li>

        <c:choose>
            <c:when test="${totalPages <= 7}">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="${baseUrl}&page=${i}">${i}</a>
                    </li>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:if test="${currentPage > 3}">
                    <li class="page-item"><a class="page-link" href="${baseUrl}&page=1">1</a></li>
                    <c:if test="${currentPage > 4}">
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                    </c:if>
                </c:if>

                <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}"/>
                <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"/>
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="${baseUrl}&page=${i}">${i}</a>
                    </li>
                </c:forEach>

                <c:if test="${currentPage < totalPages - 2}">
                    <c:if test="${currentPage < totalPages - 3}">
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                    </c:if>
                    <li class="page-item"><a class="page-link" href="${baseUrl}&page=${totalPages}">${totalPages}</a></li>
                </c:if>
            </c:otherwise>
        </c:choose>

        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
            <a class="page-link" href="${baseUrl}&page=${currentPage + 1}" aria-label="Next">
                <i class="fas fa-chevron-right"></i>
            </a>
        </li>
    </ul>
</nav>
</c:if>
