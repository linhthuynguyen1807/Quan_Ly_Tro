<%@page pageEncoding="UTF-8"%>
<%-- 
    Common <head> includes for all pages
    Usage: <%@include file="/includes/head.jsp"%>
--%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Bootstrap 5.3 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome 6 -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
<!-- AOS Animations -->
<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
<!-- SweetAlert2 -->
<link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">

<style>
    /* === GLOBAL DESIGN TOKENS === */
    :root {
        --primary-50: #EFF6FF;    --primary-100: #DBEAFE;
        --primary-200: #BFDBFE;   --primary-300: #93C5FD;
        --primary-400: #60A5FA;   --primary-500: #3B82F6;
        --primary-600: #2563EB;   --primary-700: #1D4ED8;
        --primary-800: #1E40AF;   --primary-900: #1E3A5F;

        --gradient-main: linear-gradient(135deg, #1E3A5F 0%, #2563EB 50%, #60A5FA 100%);
        --gradient-card: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 100%);
        --gradient-btn:  linear-gradient(135deg, #2563EB, #3B82F6);
        --gradient-sidebar: linear-gradient(180deg, #0F172A 0%, #1E3A5F 100%);

        --success: #10B981;  --warning: #F59E0B;
        --danger: #EF4444;   --info: #06B6D4;
        --bg-light: #F8FAFC; --bg-card: #FFFFFF;
        --text-primary: #1E293B; --text-secondary: #64748B;
        --text-tertiary: #94A3B8;
        --border-color: #E2E8F0;
        --shadow-card: 0 4px 24px rgba(30,58,95,0.08);
        --shadow-card-hover: 0 8px 32px rgba(30,58,95,0.15);
        --radius: 16px;
        --sidebar-width: 260px;
    }

    * { box-sizing: border-box; }

    body {
        font-family: 'Inter', 'Poppins', sans-serif;
        background: var(--bg-light);
        color: var(--text-primary);
        margin: 0;
        min-height: 100vh;
    }

    /* === UTILITY CLASSES === */
    .gradient-text {
        background: var(--gradient-main);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .card-custom {
        background: var(--bg-card);
        border-radius: var(--radius);
        box-shadow: var(--shadow-card);
        border: none;
        transition: all 0.3s ease;
    }
    .card-custom:hover {
        box-shadow: var(--shadow-card-hover);
        transform: translateY(-2px);
    }

    .btn-gradient {
        background: var(--gradient-btn);
        color: white;
        border: none;
        border-radius: 12px;
        padding: 10px 24px;
        font-weight: 600;
        transition: all 0.3s ease;
        cursor: pointer;
    }
    .btn-gradient:hover {
        transform: scale(1.03);
        box-shadow: 0 4px 16px rgba(37,99,235,0.35);
        color: white;
    }

    .badge-status {
        padding: 5px 14px;
        border-radius: 999px;
        font-size: 0.78rem;
        font-weight: 600;
        letter-spacing: 0.3px;
    }
    .badge-success { background: #D1FAE5; color: #065F46; }
    .badge-warning { background: #FEF3C7; color: #92400E; }
    .badge-danger  { background: #FEE2E2; color: #991B1B; }
    .badge-info    { background: #CFFAFE; color: #155E75; }

    .stat-card {
        background: var(--bg-card);
        border-radius: var(--radius);
        box-shadow: var(--shadow-card);
        padding: 24px;
        display: flex;
        align-items: center;
        gap: 20px;
        transition: all 0.3s ease;
    }
    .stat-card:hover {
        box-shadow: var(--shadow-card-hover);
        transform: translateY(-3px);
    }
    .stat-icon {
        width: 56px;
        height: 56px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.3rem;
        color: white;
        flex-shrink: 0;
    }
    .stat-value {
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--text-primary);
        line-height: 1.2;
    }
    .stat-label {
        font-size: 0.85rem;
        color: var(--text-secondary);
        margin-top: 2px;
    }

    /* === STATS CARD (Student Pages) === */
    .stats-card {
        background: var(--bg-card);
        border-radius: var(--radius);
        box-shadow: var(--shadow-card);
        padding: 24px;
        display: flex;
        align-items: center;
        gap: 20px;
        transition: all 0.3s ease;
    }
    .stats-card:hover {
        box-shadow: var(--shadow-card-hover);
        transform: translateY(-3px);
    }
    .stats-icon {
        width: 52px;
        height: 52px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        flex-shrink: 0;
    }
    .stats-info { flex: 1; min-width: 0; }
    .stats-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-primary);
        line-height: 1.2;
    }
    .stats-label {
        font-size: 0.82rem;
        color: var(--text-secondary);
        margin-top: 2px;
    }

    /* === TABLE STYLE === */
    .table-custom {
        border-radius: var(--radius);
        overflow: hidden;
        box-shadow: var(--shadow-card);
    }
    .table-custom thead th {
        background: var(--primary-900);
        color: white;
        font-weight: 600;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 14px 16px;
        border: none;
    }
    .table-custom tbody tr {
        transition: background 0.2s;
    }
    .table-custom tbody tr:hover {
        background: var(--primary-50);
    }
    .table-custom tbody td {
        padding: 12px 16px;
        vertical-align: middle;
        border-color: #F1F5F9;
    }

    /* === ADMIN LAYOUT === */
    .admin-layout {
        display: flex;
        min-height: 100vh;
    }
    .admin-main {
        margin-left: var(--sidebar-width);
        flex: 1;
        padding: 32px;
        min-height: 100vh;
    }

    /* === ANIMATIONS === */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    .animate-in {
        animation: fadeInUp 0.5s ease forwards;
    }

    /* === PAGE HEADER === */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 28px;
        flex-wrap: wrap;
        gap: 16px;
    }
    .page-header-left h2 {
        font-family: 'Poppins', sans-serif;
        font-weight: 700;
        font-size: 1.5rem;
        color: var(--text-primary);
        margin: 0 0 4px;
    }
    .page-header-left .breadcrumb {
        font-size: 0.8rem;
        color: var(--text-secondary);
        margin: 0;
        display: flex;
        gap: 6px;
        list-style: none;
        padding: 0;
    }
    .page-header-left .breadcrumb a {
        color: var(--primary-500);
        text-decoration: none;
    }
    .page-header-left .breadcrumb a:hover { text-decoration: underline; }
    .page-header-actions {
        display: flex;
        gap: 10px;
        align-items: center;
    }

    /* === FILTER CARD === */
    .filter-card {
        background: var(--bg-card);
        border-radius: var(--radius);
        box-shadow: var(--shadow-card);
        padding: 20px 24px;
        margin-bottom: 24px;
        border: none;
    }
    .filter-card .form-label {
        font-weight: 600;
        font-size: 0.82rem;
        color: var(--text-secondary);
        margin-bottom: 6px;
    }
    .filter-card .form-select,
    .filter-card .form-control {
        border-radius: 12px;
        padding: 10px 14px;
        border: 2px solid #E2E8F0;
        font-size: 0.88rem;
        transition: all 0.3s ease;
    }
    .filter-card .form-select:focus,
    .filter-card .form-control:focus {
        border-color: var(--primary-400);
        box-shadow: 0 0 0 4px rgba(59,130,246,0.08);
    }

    /* === EMPTY STATE === */
    .empty-state {
        text-align: center;
        padding: 60px 24px;
        color: var(--text-secondary);
    }
    .empty-state i {
        font-size: 3rem;
        opacity: 0.2;
        margin-bottom: 16px;
        display: block;
    }
    .empty-state h5 {
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 8px;
    }
    .empty-state p {
        font-size: 0.88rem;
        max-width: 400px;
        margin: 0 auto;
    }

    /* === MODAL CUSTOM === */
    .modal-custom .modal-content {
        border: none;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        overflow: hidden;
    }
    .modal-custom .modal-header {
        background: var(--gradient-main);
        color: white;
        border: none;
        padding: 20px 28px;
    }
    .modal-custom .modal-header .modal-title {
        font-family: 'Poppins', sans-serif;
        font-weight: 600;
        font-size: 1.1rem;
    }
    .modal-custom .modal-header .btn-close { filter: brightness(0) invert(1); }
    .modal-custom .modal-body { padding: 28px; }
    .modal-custom .modal-footer {
        border-top: 1px solid #F1F5F9;
        padding: 16px 28px;
    }
    .modal-custom .form-label {
        font-weight: 600;
        font-size: 0.82rem;
        color: var(--text-secondary);
        margin-bottom: 6px;
    }
    .modal-custom .form-control,
    .modal-custom .form-select {
        border-radius: 12px;
        padding: 10px 14px;
        border: 2px solid #E2E8F0;
        transition: all 0.3s;
    }
    .modal-custom .form-control:focus,
    .modal-custom .form-select:focus {
        border-color: var(--primary-400);
        box-shadow: 0 0 0 4px rgba(59,130,246,0.08);
    }

    /* === PAGINATION === */
    .pagination-custom {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 6px;
        margin-top: 24px;
    }
    .pagination-custom .page-link {
        border: none;
        border-radius: 10px;
        padding: 8px 14px;
        font-size: 0.85rem;
        font-weight: 500;
        color: var(--text-secondary);
        background: var(--bg-card);
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        transition: all 0.25s ease;
    }
    .pagination-custom .page-link:hover {
        background: var(--primary-50);
        color: var(--primary-600);
    }
    .pagination-custom .page-item.active .page-link {
        background: var(--gradient-btn);
        color: white;
        box-shadow: 0 4px 12px rgba(37,99,235,0.25);
    }
    .pagination-custom .page-item.disabled .page-link {
        opacity: 0.4;
        cursor: default;
    }

    /* === ACTION BUTTONS === */
    .btn-action {
        width: 34px;
        height: 34px;
        border-radius: 10px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: none;
        font-size: 0.82rem;
        transition: all 0.25s ease;
        cursor: pointer;
    }
    .btn-action-view  { background: rgba(6,182,212,0.1); color: var(--info); }
    .btn-action-edit  { background: rgba(245,158,11,0.1); color: var(--warning); }
    .btn-action-delete{ background: rgba(239,68,68,0.1); color: var(--danger); }
    .btn-action:hover { transform: scale(1.12); box-shadow: 0 2px 8px rgba(0,0,0,0.12); }

    /* === FORM GROUP ENHANCED === */
    .form-group-enhanced { margin-bottom: 18px; }
    .form-group-enhanced .form-label {
        font-weight: 600;
        font-size: 0.82rem;
        color: #374151;
        margin-bottom: 6px;
        display: block;
    }
    .form-group-enhanced .form-control,
    .form-group-enhanced .form-select {
        border-radius: 12px;
        padding: 10px 14px;
        border: 2px solid #E2E8F0;
        transition: border-color 0.3s, box-shadow 0.3s;
    }
    .form-group-enhanced .form-control:focus,
    .form-group-enhanced .form-select:focus {
        border-color: var(--primary-400);
        box-shadow: 0 0 0 4px rgba(59,130,246,0.08);
    }

    /* === NOTIFICATION DOT === */
    .notification-dot {
        position: absolute;
        top: -2px; right: -2px;
        width: 18px; height: 18px;
        background: var(--danger);
        color: white;
        border-radius: 50%;
        font-size: 0.6rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid white;
    }

    /* === SEARCH INPUT === */
    .search-box {
        position: relative;
        max-width: 300px;
    }
    .search-box input {
        width: 100%;
        padding: 10px 14px 10px 40px;
        border: 2px solid #E2E8F0;
        border-radius: 12px;
        font-size: 0.88rem;
        background: var(--bg-card);
        transition: all 0.3s;
    }
    .search-box input:focus {
        border-color: var(--primary-400);
        box-shadow: 0 0 0 4px rgba(59,130,246,0.08);
        outline: none;
    }
    .search-box i {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-secondary);
        font-size: 0.85rem;
    }

    /* === SIDEBAR STYLES === */
    .admin-sidebar {
        width: var(--sidebar-width);
        background: var(--gradient-sidebar);
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        z-index: 999;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
        transition: transform 0.3s ease;
    }

    /* Logo */
    .sidebar-logo {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 24px 20px 20px;
        border-bottom: 1px solid rgba(255,255,255,0.08);
    }
    .sidebar-logo-icon {
        width: 40px;
        height: 40px;
        background: var(--gradient-btn);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.1rem;
        flex-shrink: 0;
    }
    .sidebar-logo-title {
        color: white;
        font-weight: 700;
        font-size: 1.1rem;
        line-height: 1.2;
    }
    .sidebar-logo-subtitle {
        color: rgba(255,255,255,0.5);
        font-size: 0.72rem;
        letter-spacing: 0.5px;
    }

    /* Nav */
    .sidebar-nav {
        flex: 1;
        padding: 16px 12px;
        overflow-y: auto;
    }
    .sidebar-section-title {
        color: rgba(255,255,255,0.35);
        font-size: 0.68rem;
        font-weight: 700;
        letter-spacing: 1.5px;
        padding: 16px 12px 6px;
        text-transform: uppercase;
    }
    .sidebar-link {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 11px 14px;
        color: rgba(255,255,255,0.65);
        text-decoration: none;
        border-radius: 10px;
        font-size: 0.88rem;
        font-weight: 500;
        transition: all 0.25s ease;
        margin-bottom: 2px;
        position: relative;
    }
    .sidebar-link i {
        width: 20px;
        text-align: center;
        font-size: 0.92rem;
    }
    .sidebar-link:hover {
        background: rgba(255,255,255,0.08);
        color: white;
        transform: translateX(3px);
    }
    .sidebar-link.active {
        background: rgba(59,130,246,0.25);
        color: white;
        font-weight: 600;
        box-shadow: inset 3px 0 0 var(--primary-400);
    }
    .sidebar-badge {
        margin-left: auto;
        background: var(--danger);
        color: white;
        font-size: 0.68rem;
        font-weight: 700;
        padding: 2px 8px;
        border-radius: 999px;
        min-width: 22px;
        text-align: center;
    }

    /* Footer */
    .sidebar-footer {
        padding: 16px;
        border-top: 1px solid rgba(255,255,255,0.08);
    }
    .sidebar-user {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 8px 4px;
        margin-bottom: 8px;
    }
    .sidebar-avatar {
        width: 36px;
        height: 36px;
        background: rgba(59,130,246,0.3);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-300);
        font-size: 0.9rem;
    }
    .sidebar-username {
        color: white;
        font-weight: 600;
        font-size: 0.85rem;
    }
    .sidebar-role {
        color: rgba(255,255,255,0.4);
        font-size: 0.72rem;
    }
    .sidebar-logout {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 14px;
        color: rgba(239,68,68,0.8);
        text-decoration: none;
        border-radius: 10px;
        font-size: 0.85rem;
        font-weight: 500;
        transition: all 0.25s ease;
    }
    .sidebar-logout:hover {
        background: rgba(239,68,68,0.1);
        color: #EF4444;
    }

    /* Scrollbar */
    .admin-sidebar::-webkit-scrollbar { width: 4px; }
    .admin-sidebar::-webkit-scrollbar-track { background: transparent; }
    .admin-sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.15); border-radius: 4px; }

    /* === RESPONSIVE === */
    @media (max-width: 768px) {
        .admin-sidebar { transform: translateX(-100%); }
        .admin-sidebar.active { transform: translateX(0); }
        .admin-main { margin-left: 0; padding: 16px; }
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 998;
        }
        .sidebar-overlay.active { display: block; }
        .page-header { flex-direction: column; align-items: flex-start; }
        .page-header-actions { width: 100%; }
        .filter-card .row { gap: 8px; }
    }
</style>
