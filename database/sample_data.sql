-- =====================================================
-- KTX Manager - Sample Data Script for SQL Server
-- Database: quanlitro
-- Run this script in SSMS or Azure Data Studio
-- =====================================================

USE quanlitro;
GO

-- =====================================================
-- 1. DROP EXISTING TABLES (reverse dependency order)
-- =====================================================
IF OBJECT_ID('NOTIFICATION', 'U') IS NOT NULL DROP TABLE NOTIFICATION;
IF OBJECT_ID('PAYMENT', 'U') IS NOT NULL DROP TABLE PAYMENT;
IF OBJECT_ID('INVOICE', 'U') IS NOT NULL DROP TABLE INVOICE;
IF OBJECT_ID('ELECTRICITY_WATER_READING', 'U') IS NOT NULL DROP TABLE ELECTRICITY_WATER_READING;
IF OBJECT_ID('REQUEST', 'U') IS NOT NULL DROP TABLE REQUEST;
IF OBJECT_ID('CONTRACT', 'U') IS NOT NULL DROP TABLE CONTRACT;
IF OBJECT_ID('STUDENT', 'U') IS NOT NULL DROP TABLE STUDENT;
IF OBJECT_ID('ROOM', 'U') IS NOT NULL DROP TABLE ROOM;
IF OBJECT_ID('HOSTEL', 'U') IS NOT NULL DROP TABLE HOSTEL;
IF OBJECT_ID('USERS', 'U') IS NOT NULL DROP TABLE USERS;
GO

-- =====================================================
-- 2. CREATE TABLES
-- =====================================================

CREATE TABLE USERS (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL CHECK (role IN ('landlord', 'student')),
    full_name NVARCHAR(100),
    email NVARCHAR(100),
    phone NVARCHAR(20),
    avatar NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE HOSTEL (
    hostel_id INT IDENTITY(1,1) PRIMARY KEY,
    landlord_id INT NOT NULL,
    hostel_name NVARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (landlord_id) REFERENCES USERS(user_id)
);

CREATE TABLE ROOM (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    hostel_id INT NOT NULL,
    room_number NVARCHAR(20) NOT NULL,
    area FLOAT DEFAULT 0,
    price FLOAT NOT NULL,
    max_capacity INT DEFAULT 1,
    status NVARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'maintenance')),
    room_type NVARCHAR(20) DEFAULT N'Đơn',
    floor_number INT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (hostel_id) REFERENCES HOSTEL(hostel_id)
);

CREATE TABLE STUDENT (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    full_name NVARCHAR(100),
    cccd NVARCHAR(20),
    school NVARCHAR(100),
    phone NVARCHAR(20),
    email NVARCHAR(100),
    date_of_birth DATE,
    gender NVARCHAR(10),
    address NVARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

CREATE TABLE CONTRACT (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    deposit FLOAT DEFAULT 0,
    status NVARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'terminated')),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (room_id) REFERENCES ROOM(room_id)
);

CREATE TABLE INVOICE (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_id INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    room_fee FLOAT DEFAULT 0,
    electric_fee FLOAT DEFAULT 0,
    water_fee FLOAT DEFAULT 0,
    service_fee FLOAT DEFAULT 0,
    total_amount FLOAT DEFAULT 0,
    payment_status NVARCHAR(20) DEFAULT 'unpaid' CHECK (payment_status IN ('paid', 'unpaid', 'overdue')),
    due_date DATE,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (contract_id) REFERENCES CONTRACT(contract_id)
);

CREATE TABLE PAYMENT (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    amount FLOAT NOT NULL,
    payment_method NVARCHAR(50) DEFAULT 'cash',
    payment_date DATETIME DEFAULT GETDATE(),
    transaction_code NVARCHAR(50),
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(invoice_id)
);

CREATE TABLE ELECTRICITY_WATER_READING (
    reading_id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    old_electric_number INT DEFAULT 0,
    new_electric_number INT DEFAULT 0,
    old_water_number INT DEFAULT 0,
    new_water_number INT DEFAULT 0,
    electric_price FLOAT DEFAULT 3500,
    water_price FLOAT DEFAULT 25000,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (room_id) REFERENCES ROOM(room_id)
);

CREATE TABLE REQUEST (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    title NVARCHAR(200),
    description NVARCHAR(MAX),
    category NVARCHAR(50) DEFAULT 'other',
    priority NVARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    status NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'done', 'rejected')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (room_id) REFERENCES ROOM(room_id)
);

CREATE TABLE NOTIFICATION (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    title NVARCHAR(200),
    message NVARCHAR(MAX),
    type NVARCHAR(30) DEFAULT 'system' CHECK (type IN ('system', 'invoice', 'maintenance', 'contract', 'general')),
    is_read BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);
GO

-- =====================================================
-- 3. INSERT SAMPLE DATA
-- =====================================================

-- === USERS (2 landlords + 8 students) ===
SET IDENTITY_INSERT USERS ON;
INSERT INTO USERS (user_id, username, password, role, full_name, email, phone) VALUES
(1, 'admin1',    '123456', 'landlord', N'Nguyễn Văn Admin',   'admin1@ktx.vn',     '0901234567'),
(2, 'admin2',    '123456', 'landlord', N'Trần Thị Quản Lý',   'admin2@ktx.vn',     '0901234568'),
(3, 'student1',  '123456', 'student',  N'Lê Minh Tuấn',       'tuan.le@sv.vn',     '0912345671'),
(4, 'student2',  '123456', 'student',  N'Phạm Thị Hương',     'huong.pham@sv.vn',  '0912345672'),
(5, 'student3',  '123456', 'student',  N'Hoàng Đức Anh',      'anh.hoang@sv.vn',   '0912345673'),
(6, 'student4',  '123456', 'student',  N'Ngô Thị Mai',        'mai.ngo@sv.vn',     '0912345674'),
(7, 'student5',  '123456', 'student',  N'Vũ Quốc Bảo',       'bao.vu@sv.vn',      '0912345675'),
(8, 'student6',  '123456', 'student',  N'Đặng Thanh Hà',      'ha.dang@sv.vn',     '0912345676'),
(9, 'student7',  '123456', 'student',  N'Bùi Văn Khoa',       'khoa.bui@sv.vn',    '0912345677'),
(10,'student8',  '123456', 'student',  N'Trịnh Ngọc Lan',     'lan.trinh@sv.vn',   '0912345678');
SET IDENTITY_INSERT USERS OFF;

-- === HOSTELS (3 hostels) ===
SET IDENTITY_INSERT HOSTEL ON;
INSERT INTO HOSTEL (hostel_id, landlord_id, hostel_name, address, description) VALUES
(1, 1, N'KTX Khu A - Đại học FPT', N'Khu Công nghệ cao, Q.9, TP.HCM', N'Ký túc xá hiện đại dành cho sinh viên năm nhất, đầy đủ tiện nghi.'),
(2, 1, N'KTX Khu B - Đại học FPT', N'Khu Công nghệ cao, Q.9, TP.HCM', N'Ký túc xá cao cấp, có phòng gym và canteen.'),
(3, 2, N'Nhà trọ Bình An',          N'12 Nguyễn Xiển, Q.9, TP.HCM',    N'Nhà trọ giá rẻ, gần trường đại học, tiện ích đầy đủ.');
SET IDENTITY_INSERT HOSTEL OFF;

-- === ROOMS (15 rooms across 3 hostels) ===
SET IDENTITY_INSERT ROOM ON;
INSERT INTO ROOM (room_id, hostel_id, room_number, area, price, max_capacity, status, room_type, floor_number) VALUES
-- KTX Khu A (6 rooms)
(1,  1, 'A101', 25, 1500000, 2, 'occupied',    N'Đôi',  1),
(2,  1, 'A102', 25, 1500000, 2, 'occupied',    N'Đôi',  1),
(3,  1, 'A201', 18, 2000000, 1, 'occupied',    N'Đơn',  2),
(4,  1, 'A202', 18, 2000000, 1, 'available',   N'Đơn',  2),
(5,  1, 'A301', 30, 1200000, 4, 'occupied',    N'Ghép', 3),
(6,  1, 'A302', 30, 1200000, 4, 'maintenance', N'Ghép', 3),
-- KTX Khu B (5 rooms)
(7,  2, 'B101', 20, 1800000, 2, 'occupied',    N'Đôi',  1),
(8,  2, 'B102', 20, 1800000, 2, 'available',   N'Đôi',  1),
(9,  2, 'B201', 15, 2500000, 1, 'occupied',    N'Đơn',  2),
(10, 2, 'B202', 15, 2500000, 1, 'available',   N'Đơn',  2),
(11, 2, 'B301', 35, 1000000, 4, 'occupied',    N'Ghép', 3),
-- Nhà trọ Bình An (4 rooms)
(12, 3, 'BA01', 20, 1600000, 2, 'occupied',    N'Đôi',  1),
(13, 3, 'BA02', 20, 1600000, 2, 'available',   N'Đôi',  1),
(14, 3, 'BA03', 16, 2200000, 1, 'occupied',    N'Đơn',  1),
(15, 3, 'BA04', 16, 2200000, 1, 'available',   N'Đơn',  1);
SET IDENTITY_INSERT ROOM OFF;

-- === STUDENTS (8 students) ===
SET IDENTITY_INSERT STUDENT ON;
INSERT INTO STUDENT (student_id, user_id, full_name, cccd, school, phone, email, date_of_birth, gender, address) VALUES
(1, 3,  N'Lê Minh Tuấn',     '079201001234', N'ĐH FPT',           '0912345671', 'tuan.le@sv.vn',    '2003-05-15', N'Nam',  N'Đà Nẵng'),
(2, 4,  N'Phạm Thị Hương',   '079201005678', N'ĐH FPT',           '0912345672', 'huong.pham@sv.vn', '2003-08-22', N'Nữ',   N'Hà Nội'),
(3, 5,  N'Hoàng Đức Anh',    '079201009012', N'ĐH FPT',           '0912345673', 'anh.hoang@sv.vn',  '2002-12-01', N'Nam',  N'TP.HCM'),
(4, 6,  N'Ngô Thị Mai',      '079201003456', N'ĐH Bách Khoa',     '0912345674', 'mai.ngo@sv.vn',    '2003-03-10', N'Nữ',   N'Huế'),
(5, 7,  N'Vũ Quốc Bảo',     '079201007890', N'ĐH FPT',           '0912345675', 'bao.vu@sv.vn',     '2002-07-25', N'Nam',  N'Hải Phòng'),
(6, 8,  N'Đặng Thanh Hà',    '079201002345', N'ĐH Kinh Tế',       '0912345676', 'ha.dang@sv.vn',    '2003-11-08', N'Nữ',   N'Cần Thơ'),
(7, 9,  N'Bùi Văn Khoa',     '079201006789', N'ĐH FPT',           '0912345677', 'khoa.bui@sv.vn',   '2003-01-30', N'Nam',  N'Nghệ An'),
(8, 10, N'Trịnh Ngọc Lan',   '079201000123', N'ĐH Sư Phạm',       '0912345678', 'lan.trinh@sv.vn',  '2003-09-18', N'Nữ',   N'Quảng Ninh');
SET IDENTITY_INSERT STUDENT OFF;

-- === CONTRACTS (8 active contracts) ===
SET IDENTITY_INSERT CONTRACT ON;
INSERT INTO CONTRACT (contract_id, student_id, room_id, start_date, end_date, deposit, status) VALUES
(1, 1, 1,  '2025-09-01', '2026-08-31', 1500000, 'active'),
(2, 2, 1,  '2025-09-01', '2026-08-31', 1500000, 'active'),
(3, 3, 3,  '2025-09-01', '2026-08-31', 2000000, 'active'),
(4, 4, 5,  '2025-09-01', '2026-08-31', 1200000, 'active'),
(5, 5, 5,  '2025-09-01', '2026-08-31', 1200000, 'active'),
(6, 6, 7,  '2025-09-01', '2026-08-31', 1800000, 'active'),
(7, 7, 9,  '2025-09-01', '2026-08-31', 2500000, 'active'),
(8, 8, 12, '2025-09-01', '2026-08-31', 1600000, 'active');
SET IDENTITY_INSERT CONTRACT OFF;

-- === ELECTRICITY & WATER READINGS ===
INSERT INTO ELECTRICITY_WATER_READING (room_id, month, year, old_electric_number, new_electric_number, old_water_number, new_water_number, electric_price, water_price) VALUES
(1,  1, 2026, 100, 145, 10, 18, 3500, 25000),
(1,  2, 2026, 145, 198, 18, 27, 3500, 25000),
(1,  3, 2026, 198, 240, 27, 34, 3500, 25000),
(3,  1, 2026, 50,  85,  5,  12, 3500, 25000),
(3,  2, 2026, 85,  130, 12, 20, 3500, 25000),
(3,  3, 2026, 130, 168, 20, 26, 3500, 25000),
(5,  1, 2026, 200, 280, 20, 35, 3500, 25000),
(5,  2, 2026, 280, 350, 35, 48, 3500, 25000),
(5,  3, 2026, 350, 420, 48, 60, 3500, 25000),
(7,  1, 2026, 80,  120, 8,  15, 3500, 25000),
(7,  2, 2026, 120, 165, 15, 23, 3500, 25000),
(7,  3, 2026, 165, 205, 23, 30, 3500, 25000),
(9,  1, 2026, 30,  65,  3,  10, 3500, 25000),
(9,  2, 2026, 65,  100, 10, 16, 3500, 25000),
(12, 1, 2026, 90,  130, 9,  16, 3500, 25000);

-- === INVOICES (20 invoices) ===
SET IDENTITY_INSERT INVOICE ON;
INSERT INTO INVOICE (invoice_id, contract_id, month, year, room_fee, electric_fee, water_fee, service_fee, total_amount, payment_status, due_date) VALUES
-- Student 1+2 (Room A101, contract 1)
(1,  1, 1, 2026, 1500000, 157500, 200000, 100000, 1957500, 'paid',   '2026-01-15'),
(2,  1, 2, 2026, 1500000, 185500, 225000, 100000, 2010500, 'paid',   '2026-02-15'),
(3,  1, 3, 2026, 1500000, 147000, 175000, 100000, 1922000, 'unpaid', '2026-03-15'),
-- Student 3 (Room A201, contract 3)
(4,  3, 1, 2026, 2000000, 122500, 175000, 100000, 2397500, 'paid',   '2026-01-15'),
(5,  3, 2, 2026, 2000000, 157500, 200000, 100000, 2457500, 'paid',   '2026-02-15'),
(6,  3, 3, 2026, 2000000, 133000, 150000, 100000, 2383000, 'unpaid', '2026-03-15'),
-- Student 4+5 (Room A301, contract 4)
(7,  4, 1, 2026, 1200000, 280000, 375000, 100000, 1955000, 'paid',   '2026-01-15'),
(8,  4, 2, 2026, 1200000, 245000, 325000, 100000, 1870000, 'overdue','2026-02-15'),
(9,  4, 3, 2026, 1200000, 245000, 300000, 100000, 1845000, 'unpaid', '2026-03-15'),
-- Student 6 (Room B101, contract 6)
(10, 6, 1, 2026, 1800000, 140000, 175000, 100000, 2215000, 'paid',   '2026-01-15'),
(11, 6, 2, 2026, 1800000, 157500, 200000, 100000, 2257500, 'paid',   '2026-02-15'),
(12, 6, 3, 2026, 1800000, 140000, 175000, 100000, 2215000, 'unpaid', '2026-03-15'),
-- Student 7 (Room B201, contract 7)
(13, 7, 1, 2026, 2500000, 122500, 175000, 100000, 2897500, 'paid',   '2026-01-15'),
(14, 7, 2, 2026, 2500000, 122500, 150000, 100000, 2872500, 'overdue','2026-02-15'),
(15, 7, 3, 2026, 2500000, 105000, 125000, 100000, 2830000, 'unpaid', '2026-03-15'),
-- Student 8 (Room BA01, contract 8)
(16, 8, 1, 2026, 1600000, 140000, 175000, 100000, 2015000, 'paid',   '2026-01-15'),
(17, 8, 2, 2026, 1600000, 140000, 175000, 100000, 2015000, 'paid',   '2026-02-15'),
(18, 8, 3, 2026, 1600000, 122500, 150000, 100000, 1972500, 'unpaid', '2026-03-15'),
-- Student 2 (contract 2 — same room A101)
(19, 2, 1, 2026, 1500000, 157500, 200000, 100000, 1957500, 'paid',   '2026-01-15'),
(20, 2, 2, 2026, 1500000, 185500, 225000, 100000, 2010500, 'overdue','2026-02-15');
SET IDENTITY_INSERT INVOICE OFF;

-- === PAYMENTS ===
INSERT INTO PAYMENT (invoice_id, amount, payment_method, payment_date, transaction_code) VALUES
(1,  1957500, N'Chuyển khoản', '2026-01-10', 'TXN20260110001'),
(2,  2010500, N'Tiền mặt',     '2026-02-12', 'TXN20260212002'),
(4,  2397500, N'Chuyển khoản', '2026-01-08', 'TXN20260108003'),
(5,  2457500, N'MoMo',         '2026-02-10', 'TXN20260210004'),
(7,  1955000, N'Chuyển khoản', '2026-01-14', 'TXN20260114005'),
(10, 2215000, N'Tiền mặt',     '2026-01-12', 'TXN20260112006'),
(11, 2257500, N'ZaloPay',      '2026-02-14', 'TXN20260214007'),
(13, 2897500, N'Chuyển khoản', '2026-01-11', 'TXN20260111008'),
(16, 2015000, N'MoMo',         '2026-01-09', 'TXN20260109009'),
(17, 2015000, N'Chuyển khoản', '2026-02-13', 'TXN20260213010'),
(19, 1957500, N'Tiền mặt',     '2026-01-13', 'TXN20260113011');

-- === MAINTENANCE REQUESTS ===
INSERT INTO REQUEST (student_id, room_id, title, description, category, priority, status, created_at, updated_at) VALUES
(1, 1,  N'Hỏng bóng đèn phòng ngủ',       N'Bóng đèn LED phòng ngủ bị hỏng, cần thay mới',            'electrical', 'normal',  'done',       '2026-01-15', '2026-01-17'),
(1, 1,  N'Rò rỉ nước vòi rửa',             N'Vòi rửa tay trong WC bị rò rỉ nước liên tục',              'plumbing',   'high',    'processing', '2026-02-20', '2026-02-22'),
(3, 3,  N'WiFi yếu',                         N'Tín hiệu WiFi trong phòng rất yếu, không thể học online',  'network',    'high',    'processing', '2026-03-01', '2026-03-02'),
(4, 5,  N'Điều hòa không mát',              N'Điều hòa chạy nhưng không mát, nghi bị hết gas',           'electrical', 'urgent',  'pending',    '2026-03-10', '2026-03-10'),
(5, 5,  N'Cửa sổ bị kẹt',                  N'Cửa sổ phòng không đóng mở được',                          'furniture',  'normal',  'done',       '2026-01-25', '2026-01-28'),
(6, 7,  N'Bồn cầu bị tắc',                 N'Bồn cầu bị tắc không xả được nước',                        'plumbing',   'urgent',  'processing', '2026-03-12', '2026-03-12'),
(7, 9,  N'Ổ cắm điện bị lỏng',             N'Ổ cắm điện gần bàn học bị lỏng, có tia lửa khi cắm',      'electrical', 'urgent',  'pending',    '2026-03-15', '2026-03-15'),
(2, 1,  N'Nấm mốc trên tường',             N'Góc tường gần cửa sổ bị nấm mốc do ẩm',                   'other',      'normal',  'pending',    '2026-03-18', '2026-03-18'),
(8, 12, N'Khóa cửa bị hỏng',               N'Khóa cửa chính bị kẹt, khó mở',                             'furniture',  'high',    'done',       '2026-02-05', '2026-02-07'),
(3, 3,  N'Máy nước nóng hỏng',             N'Máy nước nóng không hoạt động',                              'electrical', 'high',    'pending',    '2026-03-19', '2026-03-19');

-- === NOTIFICATIONS ===
INSERT INTO NOTIFICATION (user_id, title, message, type, is_read, created_at) VALUES
-- For student1 (user_id=3)
(3, N'Hóa đơn tháng 3/2026',           N'Hóa đơn tháng 3 đã được tạo. Vui lòng thanh toán trước ngày 15/03.',        'invoice',      0, '2026-03-01'),
(3, N'Yêu cầu sửa chữa đang xử lý',    N'Yêu cầu "Rò rỉ nước vòi rửa" đã được tiếp nhận và đang xử lý.',            'maintenance',  0, '2026-02-22'),
(3, N'Thông báo bảo trì hệ thống',      N'Hệ thống sẽ bảo trì vào ngày 20/03 từ 00:00-06:00.',                         'system',       1, '2026-03-15'),
-- For student3 (user_id=5)
(5, N'Hóa đơn tháng 3/2026',           N'Hóa đơn tháng 3 đã được tạo. Tổng: 2,383,000 VNĐ.',                         'invoice',      0, '2026-03-01'),
(5, N'WiFi đang được khắc phục',         N'Đội kỹ thuật đang kiểm tra lại router tầng 2.',                               'maintenance',  0, '2026-03-02'),
-- For student4 (user_id=6)
(6, N'Hóa đơn quá hạn tháng 2',        N'Hóa đơn tháng 2 đã quá hạn thanh toán. Vui lòng thanh toán ngay.',           'invoice',      0, '2026-03-01'),
(6, N'Điều hòa đã tiếp nhận',           N'Yêu cầu sửa điều hòa đã được ghi nhận. Kỹ thuật sẽ đến kiểm tra.',          'maintenance',  0, '2026-03-10'),
-- For student7 (user_id=9)
(9, N'Cảnh báo an toàn điện',            N'Ổ cắm bị lỏng rất nguy hiểm. Vui lòng không sử dụng cho đến khi được sửa.', 'maintenance',  0, '2026-03-15'),
(9, N'Hóa đơn quá hạn',                 N'Hóa đơn tháng 2 chưa thanh toán, đã quá hạn.',                               'invoice',      0, '2026-03-01'),
-- For admin1 (user_id=1)
(1, N'Yêu cầu sửa chữa mới',           N'Có 4 yêu cầu sửa chữa mới chờ xử lý.',                                      'maintenance',  0, '2026-03-15'),
(1, N'Hóa đơn quá hạn cần xử lý',      N'Có 3 hóa đơn đã quá hạn thanh toán cần nhắc nhở sinh viên.',                 'invoice',      0, '2026-03-01'),
(1, N'Báo cáo tháng 2 sẵn sàng',       N'Báo cáo doanh thu và chi phí tháng 2/2026 đã sẵn sàng xem.',                  'system',       1, '2026-02-28'),
-- General
(3, N'Chào mừng đến KTX!',              N'Chào mừng bạn đến với hệ thống quản lý KTX. Chúc bạn có trải nghiệm tốt!',  'general',      1, '2025-09-01'),
(5, N'Gia hạn hợp đồng',                N'Hợp đồng cư trú sắp hết hạn. Vui lòng liên hệ quản lý để gia hạn.',         'contract',     0, '2026-03-10'),
(7, N'Lịch vệ sinh khu trọ',            N'Lịch vệ sinh chung khu B: Thứ 7 hàng tuần, 8:00-10:00.',                      'general',      1, '2026-01-05');

GO
PRINT N'✅ Sample data inserted successfully!';
GO
