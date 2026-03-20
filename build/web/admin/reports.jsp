<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="reports"/>
<c:set var="pageTitle" value="Báo cáo & Thống kê"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Báo cáo — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- KPI Cards -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-md-6" data-aos="fade-up">
                    <div class="stat-card" style="border-left:4px solid var(--primary-500);">
                        <div>
                            <div class="stat-label">Tổng doanh thu</div>
                            <div class="stat-value" style="color:var(--primary-600);">
                                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/>đ
                            </div>
                            <div style="font-size:0.75rem; color:var(--text-secondary); margin-top:4px;">
                                <i class="fas fa-chart-line me-1"></i>${totalStudents} sinh viên
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card" style="border-left:4px solid var(--success);">
                        <div>
                            <div class="stat-label">Tỷ lệ lấp đầy</div>
                            <div class="stat-value" style="color:var(--success);">${occupancyRate}%</div>
                            <div style="font-size:0.75rem; color:var(--text-secondary); margin-top:4px;">
                                <i class="fas fa-door-open me-1"></i>${occupiedRooms}/${totalRooms} phòng
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card" style="border-left:4px solid var(--warning);">
                        <div>
                            <div class="stat-label">Hóa đơn chưa thanh toán</div>
                            <div class="stat-value" style="color:var(--warning);">${unpaidInvoices}</div>
                            <div style="font-size:0.75rem; color:var(--warning); margin-top:4px;">
                                <i class="fas fa-exclamation-circle me-1"></i>Cần thu hồi
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card" style="border-left:4px solid var(--danger);">
                        <div>
                            <div class="stat-label">Yêu cầu bảo trì</div>
                            <div class="stat-value" style="color:var(--danger);">${pendingRequests}</div>
                            <div style="font-size:0.75rem; color:var(--danger); margin-top:4px;">
                                <i class="fas fa-tools me-1"></i>Đang chờ xử lý
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row g-4 mb-4">
                <div class="col-lg-8" data-aos="fade-up">
                    <div class="card-custom p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 style="font-weight:700; margin:0;">
                                <i class="fas fa-building me-2" style="color:var(--primary-500);"></i>Doanh thu theo khu trọ
                            </h6>
                        </div>
                        <canvas id="hostelRevenueChart" height="140"></canvas>
                    </div>
                </div>
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="card-custom p-4 h-100">
                        <h6 style="font-weight:700; margin:0 0 16px;">
                            <i class="fas fa-chart-pie me-2" style="color:var(--primary-500);"></i>Phân bổ phòng
                        </h6>
                        <canvas id="roomAllocationChart" height="200"></canvas>
                        <div class="mt-3">
                            <div class="d-flex justify-content-between py-2 border-bottom" style="font-size:0.82rem;">
                                <span><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#10B981;margin-right:8px;"></span>Đang ở</span>
                                <span style="font-weight:600;">${occupiedRooms} phòng</span>
                            </div>
                            <div class="d-flex justify-content-between py-2" style="font-size:0.82rem;">
                                <span><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#EF4444;margin-right:8px;"></span>Trống</span>
                                <span style="font-weight:600;">${emptyRooms} phòng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Revenue by Hostel Table -->
            <div class="card-custom p-4" data-aos="fade-up">
                <h6 style="font-weight:700; margin:0 0 16px;">
                    <i class="fas fa-table me-2" style="color:var(--primary-500);"></i>Chi tiết theo khu trọ
                </h6>
                <c:choose>
                    <c:when test="${empty hostels}">
                        <div class="text-center py-5">
                            <i class="fas fa-building fa-3x mb-3 text-muted"></i>
                            <p class="text-muted">Chưa có khu trọ nào</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr>
                                        <th>Khu trọ</th>
                                        <th>Tổng phòng</th>
                                        <th>Đang ở</th>
                                        <th>Tỷ lệ lấp đầy</th>
                                        <th>Sinh viên</th>
                                        <th>Doanh thu</th>
                                        <th>Chưa TT</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${hostels}" var="h">
                                        <c:set var="rate" value="${h.totalRooms > 0 ? (h.occupiedRooms * 100 / h.totalRooms) : 0}"/>
                                        <tr>
                                            <td style="font-weight:600;">${h.hostel_name}</td>
                                            <td>${h.totalRooms}</td>
                                            <td>${h.occupiedRooms}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="flex:1; background:#E2E8F0; border-radius:4px; height:8px; max-width:100px;">
                                                        <div style="width:<fmt:formatNumber value="${rate}" maxFractionDigits="0"/>%; background:${rate >= 80 ? 'var(--success)' : rate >= 50 ? 'var(--warning)' : 'var(--danger)'}; height:100%; border-radius:4px;"></div>
                                                    </div>
                                                    <span style="font-weight:600; font-size:0.82rem;"><fmt:formatNumber value="${rate}" maxFractionDigits="0"/>%</span>
                                                </div>
                                            </td>
                                            <td>${h.totalStudents}</td>
                                            <td style="font-weight:700; color:var(--primary-600);">
                                                <fmt:formatNumber value="${hostelRevenue[h.hostel_id]}" pattern="#,##0"/>đ
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${hostelUnpaid[h.hostel_id] > 0}">
                                                        <span class="badge-status badge-warning">${hostelUnpaid[h.hostel_id]} hóa đơn</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status badge-success">0</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr style="font-weight:700; background:rgba(59,130,246,0.04);">
                                        <td>Tổng cộng</td>
                                        <td>${totalRooms}</td>
                                        <td>${occupiedRooms}</td>
                                        <td>${occupancyRate}%</td>
                                        <td>${totalStudents}</td>
                                        <td style="color:var(--primary-600);"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/>đ</td>
                                        <td><span class="badge-status badge-warning">${unpaidInvoices}</span></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Room allocation doughnut chart
        new Chart(document.getElementById('roomAllocationChart'), {
            type: 'doughnut',
            data: {
                labels: ['Đang ở','Trống'],
                datasets: [{
                    data: [${occupiedRooms}, ${emptyRooms}],
                    backgroundColor: ['#10B981','#EF4444'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                cutout: '70%',
                plugins: { legend: { display:false } }
            }
        });

        // Hostel revenue bar chart
        <c:if test="${not empty hostels}">
        new Chart(document.getElementById('hostelRevenueChart'), {
            type: 'bar',
            data: {
                labels: [<c:forEach items="${hostels}" var="h" varStatus="s">'${h.hostel_name}'<c:if test="${!s.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: [<c:forEach items="${hostels}" var="h" varStatus="s">${hostelRevenue[h.hostel_id]}<c:if test="${!s.last}">,</c:if></c:forEach>],
                    backgroundColor: 'rgba(59,130,246,0.7)',
                    borderRadius: 8,
                    borderSkipped: false
                }, {
                    label: 'Chưa thanh toán',
                    data: [<c:forEach items="${hostels}" var="h" varStatus="s">${hostelUnpaid[h.hostel_id]}<c:if test="${!s.last}">,</c:if></c:forEach>],
                    backgroundColor: 'rgba(239,68,68,0.6)',
                    borderRadius: 8,
                    borderSkipped: false,
                    yAxisID: 'y1'
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position:'top', labels: { usePointStyle:true, padding:20 } } },
                scales: {
                    y: { beginAtZero:true, grid: { color:'rgba(0,0,0,0.04)' }, title: { display:true, text:'VNĐ' } },
                    y1: { beginAtZero:true, position:'right', grid: { display:false }, title: { display:true, text:'Hóa đơn' } },
                    x: { grid: { display:false } }
                }
            }
        });
        </c:if>
    </script>
</body>
</html>
