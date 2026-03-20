<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="currentPage" value="settings"/>
<c:set var="pageTitle" value="Cài đặt hệ thống"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Cài đặt — KTX Manager</title>
</head>
<body>
    <div class="admin-layout">
        <%@include file="/includes/admin-sidebar.jsp"%>
        <main class="admin-main">
            <%@include file="/includes/header.jsp"%>

            <div class="row g-4">
                <!-- Settings Navigation -->
                <div class="col-lg-3" data-aos="fade-up">
                    <div class="card-custom p-0 overflow-hidden">
                        <div style="background:var(--gradient-main); padding:20px;">
                            <h6 style="color:white; font-weight:700; margin:0;">
                                <i class="fas fa-cog me-2"></i>Cài đặt
                            </h6>
                        </div>
                        <div class="p-2">
                            <a href="#general" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none setting-tab active" data-tab="general">
                                <i class="fas fa-sliders-h" style="width:20px; color:var(--primary-500);"></i>
                                <span style="font-weight:600; font-size:0.88rem; color:var(--text-primary);">Chung</span>
                            </a>
                            <a href="#notifications" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none setting-tab" data-tab="notifications">
                                <i class="fas fa-bell" style="width:20px; color:var(--text-secondary);"></i>
                                <span style="font-weight:600; font-size:0.88rem; color:var(--text-primary);">Thông báo</span>
                            </a>
                            <a href="#security" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none setting-tab" data-tab="security">
                                <i class="fas fa-shield-alt" style="width:20px; color:var(--text-secondary);"></i>
                                <span style="font-weight:600; font-size:0.88rem; color:var(--text-primary);">Bảo mật</span>
                            </a>
                            <a href="#email" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none setting-tab" data-tab="email">
                                <i class="fas fa-envelope" style="width:20px; color:var(--text-secondary);"></i>
                                <span style="font-weight:600; font-size:0.88rem; color:var(--text-primary);">Email</span>
                            </a>
                            <a href="#backup" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none setting-tab" data-tab="backup">
                                <i class="fas fa-database" style="width:20px; color:var(--text-secondary);"></i>
                                <span style="font-weight:600; font-size:0.88rem; color:var(--text-primary);">Sao lưu</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Settings Content -->
                <div class="col-lg-9" data-aos="fade-up" data-aos-delay="100">
                    <!-- General -->
                    <div class="setting-panel" id="panel-general">
                        <div class="card-custom p-4 mb-4">
                            <h6 style="font-weight:700; margin:0 0 20px;">
                                <i class="fas fa-sliders-h me-2" style="color:var(--primary-500);"></i>Cài đặt chung
                            </h6>
                            <form>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label" style="font-weight:600; font-size:0.85rem;">Tên hệ thống</label>
                                        <input type="text" class="form-control" value="KTX Manager"
                                               style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" style="font-weight:600; font-size:0.85rem;">Email liên hệ</label>
                                        <input type="email" class="form-control" value="admin@ktxmanager.vn"
                                               style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số điện thoại</label>
                                        <input type="text" class="form-control" value="0123 456 789"
                                               style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" style="font-weight:600; font-size:0.85rem;">Múi giờ</label>
                                        <select class="form-select" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                            <option>Asia/Ho_Chi_Minh (GMT+7)</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label" style="font-weight:600; font-size:0.85rem;">Địa chỉ</label>
                                        <input type="text" class="form-control" value="123 Nguyễn Văn Cừ, Q.5, TP.HCM"
                                               style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                    </div>
                                </div>
                                <div class="mt-4 d-flex justify-content-end">
                                    <button type="button" class="btn-gradient" onclick="saveSetting('Cài đặt chung')">
                                        <i class="fas fa-save me-1"></i> Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Pricing -->
                        <div class="card-custom p-4">
                            <h6 style="font-weight:700; margin:0 0 20px;">
                                <i class="fas fa-tag me-2" style="color:var(--primary-500);"></i>Cài đặt giá
                            </h6>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giá điện (/kWh)</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" value="3500" style="border-radius:12px 0 0 12px; border:2px solid #E2E8F0;">
                                        <span class="input-group-text" style="border-radius:0 12px 12px 0;">VNĐ</span>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Giá nước (/m³)</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" value="15000" style="border-radius:12px 0 0 12px; border:2px solid #E2E8F0;">
                                        <span class="input-group-text" style="border-radius:0 12px 12px 0;">VNĐ</span>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Phí dịch vụ</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" value="100000" style="border-radius:12px 0 0 12px; border:2px solid #E2E8F0;">
                                        <span class="input-group-text" style="border-radius:0 12px 12px 0;">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 d-flex justify-content-end">
                                <button type="button" class="btn-gradient" onclick="saveSetting('Cài đặt giá')">
                                    <i class="fas fa-save me-1"></i> Lưu thay đổi
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Notifications (hidden) -->
                    <div class="setting-panel" id="panel-notifications" style="display:none;">
                        <div class="card-custom p-4">
                            <h6 style="font-weight:700; margin:0 0 20px;">
                                <i class="fas fa-bell me-2" style="color:var(--primary-500);"></i>Cài đặt thông báo
                            </h6>
                            <div class="d-flex justify-content-between align-items-center p-3 rounded-3 border mb-3">
                                <div>
                                    <div style="font-weight:600; font-size:0.9rem;">Thông báo email</div>
                                    <div style="font-size:0.78rem; color:var(--text-secondary);">Gửi email khi có hóa đơn mới, yêu cầu bảo trì</div>
                                </div>
                                <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked style="width:48px; height:24px;"></div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center p-3 rounded-3 border mb-3">
                                <div>
                                    <div style="font-weight:600; font-size:0.9rem;">Nhắc nhở thanh toán</div>
                                    <div style="font-size:0.78rem; color:var(--text-secondary);">Tự động nhắc sinh viên khi đến hạn thanh toán</div>
                                </div>
                                <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked style="width:48px; height:24px;"></div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center p-3 rounded-3 border mb-3">
                                <div>
                                    <div style="font-weight:600; font-size:0.9rem;">Cảnh báo quá hạn</div>
                                    <div style="font-size:0.78rem; color:var(--text-secondary);">Thông báo khi có hóa đơn quá hạn thanh toán</div>
                                </div>
                                <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked style="width:48px; height:24px;"></div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center p-3 rounded-3 border">
                                <div>
                                    <div style="font-weight:600; font-size:0.9rem;">Báo cáo tự động</div>
                                    <div style="font-size:0.78rem; color:var(--text-secondary);">Gửi báo cáo tổng hợp hàng tháng qua email</div>
                                </div>
                                <div class="form-check form-switch"><input class="form-check-input" type="checkbox" style="width:48px; height:24px;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Security (hidden) -->
                    <div class="setting-panel" id="panel-security" style="display:none;">
                        <div class="card-custom p-4">
                            <h6 style="font-weight:700; margin:0 0 20px;">
                                <i class="fas fa-shield-alt me-2" style="color:var(--primary-500);"></i>Cài đặt bảo mật
                            </h6>
                            <div class="mb-4 p-4 rounded-3" style="background:#FEF3C7; border:1px solid #F59E0B;">
                                <div class="d-flex gap-2 align-items-center mb-2">
                                    <i class="fas fa-exclamation-triangle" style="color:#F59E0B;"></i>
                                    <span style="font-weight:700; color:#92400E;">Cảnh báo bảo mật</span>
                                </div>
                                <p style="font-size:0.85rem; color:#92400E; margin:0;">Hệ thống đang lưu mật khẩu dạng plaintext. Nên chuyển sang bcrypt/argon2.</p>
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Thời gian hết phiên (phút)</label>
                                    <input type="number" class="form-control" value="30" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Số lần đăng nhập thất bại tối đa</label>
                                    <input type="number" class="form-control" value="5" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Email (hidden) -->
                    <div class="setting-panel" id="panel-email" style="display:none;">
                        <div class="card-custom p-4">
                            <h6 style="font-weight:700; margin:0 0 20px;">
                                <i class="fas fa-envelope me-2" style="color:var(--primary-500);"></i>Cấu hình Email SMTP
                            </h6>
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">SMTP Host</label>
                                    <input type="text" class="form-control" value="smtp.gmail.com" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Port</label>
                                    <input type="number" class="form-control" value="587" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">Email</label>
                                    <input type="email" class="form-control" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" style="font-weight:600; font-size:0.85rem;">App Password</label>
                                    <input type="password" class="form-control" style="border-radius:12px; padding:10px; border:2px solid #E2E8F0;">
                                </div>
                            </div>
                            <div class="mt-4 d-flex justify-content-end gap-2">
                                <button class="btn btn-outline-primary rounded-3">Test kết nối</button>
                                <button class="btn-gradient" onclick="saveSetting('Cấu hình Email')"><i class="fas fa-save me-1"></i> Lưu</button>
                            </div>
                        </div>
                    </div>

                    <!-- Backup (hidden) -->
                    <div class="setting-panel" id="panel-backup" style="display:none;">
                        <div class="card-custom p-4">
                            <h6 style="font-weight:700; margin:0 0 20px;">
                                <i class="fas fa-database me-2" style="color:var(--primary-500);"></i>Sao lưu dữ liệu
                            </h6>
                            <div class="d-flex gap-3 mb-4">
                                <button class="btn-gradient"><i class="fas fa-download me-2"></i>Sao lưu ngay</button>
                                <button class="btn btn-outline-primary rounded-3"><i class="fas fa-upload me-2"></i>Khôi phục</button>
                            </div>
                            <h6 style="font-weight:600; font-size:0.88rem; margin-bottom:12px;">Lịch sử sao lưu</h6>
                            <div class="table-responsive">
                                <table class="table table-custom mb-0">
                                    <thead><tr><th>Thời gian</th><th>Kích thước</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                                    <tbody>
                                        <tr>
                                            <td>19/03/2024 08:00</td>
                                            <td>2.5 MB</td>
                                            <td><span class="badge-status badge-success">Thành công</span></td>
                                            <td><button class="btn btn-sm btn-outline-primary rounded-2"><i class="fas fa-download"></i></button></td>
                                        </tr>
                                        <tr>
                                            <td>18/03/2024 08:00</td>
                                            <td>2.4 MB</td>
                                            <td><span class="badge-status badge-success">Thành công</span></td>
                                            <td><button class="btn btn-sm btn-outline-primary rounded-2"><i class="fas fa-download"></i></button></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%@include file="/includes/scripts.jsp"%>
    <script>
        // Tab switching
        document.querySelectorAll('.setting-tab').forEach(tab => {
            tab.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.setting-tab').forEach(t => {
                    t.classList.remove('active');
                    t.style.background = '';
                });
                this.classList.add('active');
                this.style.background = 'rgba(59,130,246,0.08)';
                
                const panelId = 'panel-' + this.dataset.tab;
                document.querySelectorAll('.setting-panel').forEach(p => p.style.display = 'none');
                document.getElementById(panelId).style.display = 'block';
            });
        });
        // Set first tab active
        document.querySelector('.setting-tab.active').style.background = 'rgba(59,130,246,0.08)';

        function saveSetting(name) {
            Swal.fire({ icon:'success', title:'Đã lưu!', text: name + ' đã được cập nhật.', timer:1500, showConfirmButton:false });
        }
    </script>
</body>
</html>
