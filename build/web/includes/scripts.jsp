<%@page pageEncoding="UTF-8"%>
<%-- 
    Common JS includes - place before </body>
    Usage: <%@include file="/includes/scripts.jsp"%>
--%>
<!-- Bootstrap 5.3 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- AOS.js -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- Chart.js (only loaded on pages that need it) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>

<script>
    // Init AOS animations
    AOS.init({ duration: 600, once: true, offset: 50 });

    // Bootstrap tooltip init
    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
        new bootstrap.Tooltip(el);
    });

    // Flash message support
    <c:if test="${not empty successMsg}">
        Swal.fire({ icon: 'success', title: 'Thành công!', text: '${successMsg}', timer: 2500, showConfirmButton: false });
    </c:if>
    <c:if test="${not empty errorMsg}">
        Swal.fire({ icon: 'error', title: 'Lỗi!', text: '${errorMsg}' });
    </c:if>
</script>
