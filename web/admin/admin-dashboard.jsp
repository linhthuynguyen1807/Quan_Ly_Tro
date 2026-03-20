<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="currentPage" value="dashboard"/>
<c:set var="pageTitle" value="Dashboard"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Dashboard — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>

        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <!-- Stat Cards -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="0">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #2563EB, #3B82F6);">
                            <i class="fas fa-hotel"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalHostels != null ? totalHostels : 0}</div>
                            <div class="stat-label">Khu trọ</div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #059669, #10B981);">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalRooms != null ? totalRooms : 0}</div>
                            <div class="stat-label">Phòng</div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #D97706, #F59E0B);">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <div>
                            <div class="stat-value">${totalStudents != null ? totalStudents : 0}</div>
                            <div class="stat-label">Sinh viên</div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #DC2626, #EF4444);">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div>
                            <div class="stat-value">${monthlyRevenue != null ? monthlyRevenue : '0'}
                                <span style="font-size:0.65em; font-weight:400;">đ</span>
                            </div>
                            <div class="stat-label">Doanh thu tháng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row g-4 mb-4">
                <!-- Revenue Chart -->
                <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                    <div class="card-custom p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 style="font-weight:700; font-size:1.05rem; margin:0;">
                                <i class="fas fa-chart-line me-2" style="color:var(--primary-500);"></i>
                                Doanh thu 6 tháng gần nhất
                            </h5>
                            <select class="form-select form-select-sm" style="width:auto; border-radius:10px; font-size:0.82rem;">
                                <option>2026</option>
                                <option>2025</option>
                            </select>
                        </div>
                        <canvas id="revenueChart" height="260"></canvas>
                    </div>
                </div>

                <!-- Room Status Doughnut -->
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="card-custom p-4" style="height:100%;">
                        <h5 style="font-weight:700; font-size:1.05rem; margin:0 0 20px;">
                            <i class="fas fa-chart-pie me-2" style="color:var(--primary-500);"></i>
                            Trạng thái phòng
                        </h5>
                        <div style="max-width:220px; margin:0 auto;">
                            <canvas id="roomChart"></canvas>
                        </div>
                        <div class="d-flex justify-content-center gap-3 mt-3" style="font-size:0.78rem;">
                            <span><span style="display:inline-block;width:10px;height:10px;border-radius:3px;background:#10B981;"></span> Trống</span>
                            <span><span style="display:inline-block;width:10px;height:10px;border-radius:3px;background:#EF4444;"></span> Đầy</span>
                            <span><span style="display:inline-block;width:10px;height:10px;border-radius:3px;background:#F59E0B;"></span> Còn chỗ</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions + Recent Activity -->
            <div class="row g-4">
                <!-- Quick Actions -->
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="0">
                    <div class="card-custom p-4">
                        <h5 style="font-weight:700; font-size:1.05rem; margin:0 0 20px;">
                            <i class="fas fa-bolt me-2" style="color:var(--warning);"></i>
                            Thao tác nhanh
                        </h5>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-outline-primary rounded-3 text-start">
                                <i class="fas fa-plus me-2"></i> Thêm phòng mới
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-success rounded-3 text-start">
                                <i class="fas fa-user-plus me-2"></i> Thêm sinh viên
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/invoices" class="btn btn-outline-warning rounded-3 text-start">
                                <i class="fas fa-file-invoice me-2"></i> Tạo hóa đơn
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/utilities" class="btn btn-outline-info rounded-3 text-start">
                                <i class="fas fa-bolt me-2"></i> Ghi điện nước
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                    <div class="card-custom p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 style="font-weight:700; font-size:1.05rem; margin:0;">
                                <i class="fas fa-clock me-2" style="color:var(--info);"></i>
                                Hoạt động gần đây
                            </h5>
                            <a href="#" style="font-size:0.82rem; color:var(--primary-600); font-weight:600; text-decoration:none;">
                                Xem tất cả →
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-custom mb-0" style="font-size:0.88rem;">
                                <thead>
                                    <tr>
                                        <th>Thời gian</th>
                                        <th>Nội dung</th>
                                        <th>Loại</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentActivities}">
                                            <c:forEach items="${recentActivities}" var="act">
                                                <tr>
                                                    <td style="color:var(--text-secondary); white-space:nowrap;">
                                                        <fmt:formatDate value="${act.createdAt}" pattern="dd/MM HH:mm"/>
                                                    </td>
                                                    <td>
                                                        <strong>${act.title}</strong>
                                                        <div style="font-size:0.8rem; color:var(--text-secondary);">${act.message}</div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${act.type == 'payment'}">
                                                                <span class="badge-status badge-success">Thanh toán</span>
                                                            </c:when>
                                                            <c:when test="${act.type == 'maintenance'}">
                                                                <span class="badge-status badge-warning">Bảo trì</span>
                                                            </c:when>
                                                            <c:when test="${act.type == 'contract'}">
                                                                <span class="badge-status badge-info">Hợp đồng</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-status badge-info">${act.type}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center py-4" style="color:var(--text-secondary);">
                                                    <i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:0.3;"></i>
                                                    Chưa có hoạt động nào
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const gradient = revenueCtx.createLinearGradient(0, 0, 0, 260);
        gradient.addColorStop(0, 'rgba(59,130,246,0.3)');
        gradient.addColorStop(1, 'rgba(59,130,246,0.01)');

        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ${revenueChartLabels != null ? revenueChartLabels : "['T1','T2','T3','T4','T5','T6']"},
                datasets: [{
                    label: 'Doanh thu (triệu đ)',
                    data: ${revenueChartData != null ? revenueChartData : '[0,0,0,0,0,0]'},
                    fill: true,
                    backgroundColor: gradient,
                    borderColor: '#3B82F6',
                    borderWidth: 3,
                    tension: 0.4,
                    pointBackgroundColor: '#3B82F6',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1E293B',
                        padding: 12,
                        cornerRadius: 10,
                        titleFont: { size: 13, weight: '600' },
                        bodyFont: { size: 13 },
                        callbacks: {
                            label: ctx => ctx.parsed.y + ' triệu đ'
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { font: { size: 12 }, color: '#94A3B8' },
                        grid: { color: 'rgba(0,0,0,0.04)' }
                    },
                    x: {
                        ticks: { font: { size: 12 }, color: '#94A3B8' },
                        grid: { display: false }
                    }
                }
            }
        });

        // Room Status Doughnut
        new Chart(document.getElementById('roomChart'), {
            type: 'doughnut',
            data: {
                labels: ['Trống', 'Đầy', 'Còn chỗ'],
                datasets: [{
                    data: [${roomAvailable != null ? roomAvailable : 0}, ${roomFull != null ? roomFull : 0}, ${roomPartial != null ? roomPartial : 0}],
                    backgroundColor: ['#10B981', '#EF4444', '#F59E0B'],
                    borderWidth: 0,
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                cutout: '65%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1E293B',
                        padding: 10,
                        cornerRadius: 8,
                        titleFont: { size: 12 },
                        bodyFont: { size: 12 }
                    }
                }
            }
        });
    </script>
</body>
</html>
