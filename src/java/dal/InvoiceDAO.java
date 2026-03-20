package dal;

import model.Invoice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO extends DBContext {

    public List<Invoice> getInvoicesByHostel(int hostelId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, s.full_name AS studentName, r.room_number AS roomNumber "
                + "FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? ORDER BY i.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapInvoice(rs);
                    inv.setStudentName(rs.getString("studentName"));
                    inv.setRoomNumber(rs.getString("roomNumber"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoicesByStudent(int studentId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, r.room_number AS roomNumber "
                + "FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE c.student_id = ? ORDER BY i.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapInvoice(rs);
                    inv.setRoomNumber(rs.getString("roomNumber"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT * FROM INVOICE WHERE invoice_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapInvoice(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countInvoicesByHostel(int hostelId, String status, String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.full_name LIKE ? OR r.room_number LIKE ?)");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Invoice> getInvoicesByHostelPaginated(int hostelId, String status, String search, int offset, int limit) {
        List<Invoice> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, s.full_name AS studentName, r.room_number AS roomNumber "
                + "FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.full_name LIKE ? OR r.room_number LIKE ?)");
        }
        sql.append(" ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapInvoice(rs);
                    inv.setStudentName(rs.getString("studentName"));
                    inv.setRoomNumber(rs.getString("roomNumber"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countInvoicesByStudent(int studentId, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "WHERE c.student_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.status = ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, studentId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Invoice> getInvoicesByStudentPaginated(int studentId, String status, int offset, int limit) {
        List<Invoice> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, r.room_number AS roomNumber "
                + "FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE c.student_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.status = ?");
        }
        sql.append(" ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, studentId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapInvoice(rs);
                    inv.setRoomNumber(rs.getString("roomNumber"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addInvoice(Invoice invoice) {
        String sql = "INSERT INTO INVOICE (contract_id, room_fee, electric_fee, water_fee, service_fee, total_amount, status, due_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoice.getContract_id());
            ps.setDouble(2, invoice.getRoomFee());
            ps.setDouble(3, invoice.getElectricFee());
            ps.setDouble(4, invoice.getWaterFee());
            ps.setDouble(5, invoice.getServiceFee());
            ps.setDouble(6, invoice.getTotalAmount());
            ps.setString(7, invoice.getStatus());
            if (invoice.getDueDate() != null) {
                ps.setDate(8, new java.sql.Date(invoice.getDueDate().getTime()));
            } else {
                ps.setNull(8, Types.DATE);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int invoiceId, String status) {
        String sql = "UPDATE INVOICE SET status = ? WHERE invoice_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Count invoices by hostel and specific status (paid, unpaid, overdue).
     * Pass null for status to count ALL invoices.
     */
    public int countInvoicesByHostelStatus(int hostelId, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.status = ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countUnpaid(int hostelId) {
        String sql = "SELECT COUNT(*) FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND i.status = 'unpaid'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue(int hostelId) {
        String sql = "SELECT ISNULL(SUM(i.total_amount), 0) FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND i.status = 'paid'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get monthly revenue for last 6 months for a specific hostel.
     * Returns double[6] where index 0 = 5 months ago, index 5 = current month.
     */
    public double[] getMonthlyRevenue(int hostelId) {
        double[] monthly = new double[6];
        String sql = "SELECT YEAR(i.created_at) AS yr, MONTH(i.created_at) AS mo, "
                + "ISNULL(SUM(i.total_amount), 0) AS total "
                + "FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND i.status = 'paid' "
                + "AND i.created_at >= DATEADD(MONTH, -5, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) "
                + "GROUP BY YEAR(i.created_at), MONTH(i.created_at) "
                + "ORDER BY yr, mo";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                java.util.Calendar cal = java.util.Calendar.getInstance();
                int curYear = cal.get(java.util.Calendar.YEAR);
                int curMonth = cal.get(java.util.Calendar.MONTH) + 1;
                while (rs.next()) {
                    int yr = rs.getInt("yr");
                    int mo = rs.getInt("mo");
                    // Calculate index: how many months ago from current month
                    int diff = (curYear - yr) * 12 + (curMonth - mo);
                    int idx = 5 - diff;
                    if (idx >= 0 && idx < 6) {
                        monthly[idx] += rs.getDouble("total");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return monthly;
    }

    /**
     * Get current month revenue for a hostel.
     */
    public double getCurrentMonthRevenue(int hostelId) {
        String sql = "SELECT ISNULL(SUM(i.total_amount), 0) FROM INVOICE i "
                + "JOIN CONTRACT c ON i.contract_id = c.contract_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND i.status = 'paid' "
                + "AND MONTH(i.created_at) = MONTH(GETDATE()) "
                + "AND YEAR(i.created_at) = YEAR(GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice i = new Invoice();
        i.setInvoice_id(rs.getInt("invoice_id"));
        i.setContract_id(rs.getInt("contract_id"));
        i.setRoomFee(rs.getDouble("room_fee"));
        i.setElectricFee(rs.getDouble("electric_fee"));
        i.setWaterFee(rs.getDouble("water_fee"));
        i.setServiceFee(rs.getDouble("service_fee"));
        i.setTotalAmount(rs.getDouble("total_amount"));
        i.setStatus(rs.getString("status"));
        i.setDueDate(rs.getDate("due_date"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        return i;
    }
}
