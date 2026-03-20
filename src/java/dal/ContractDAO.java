package dal;

import model.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContractDAO extends DBContext {

    public List<Contract> getContractsByHostel(int hostelId) {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT c.*, s.full_name AS studentName, r.room_number AS roomNumber "
                + "FROM CONTRACT c "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? ORDER BY c.start_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contract c = mapContract(rs);
                    c.setStudentName(rs.getString("studentName"));
                    c.setRoomNumber(rs.getString("roomNumber"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Contract getContractById(int contractId) {
        String sql = "SELECT c.*, s.full_name AS studentName, r.room_number AS roomNumber "
                + "FROM CONTRACT c "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE c.contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = mapContract(rs);
                    c.setStudentName(rs.getString("studentName"));
                    c.setRoomNumber(rs.getString("roomNumber"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Contract getActiveContractByStudent(int studentId) {
        String sql = "SELECT c.*, s.full_name AS studentName, r.room_number AS roomNumber "
                + "FROM CONTRACT c "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE c.student_id = ? AND c.status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = mapContract(rs);
                    c.setStudentName(rs.getString("studentName"));
                    c.setRoomNumber(rs.getString("roomNumber"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countContractsByHostel(int hostelId, String status, String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM CONTRACT c "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND c.status = ?");
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

    public List<Contract> getContractsByHostelPaginated(int hostelId, String status, String search, int offset, int limit) {
        List<Contract> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, s.full_name AS studentName, r.room_number AS roomNumber "
                + "FROM CONTRACT c "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND c.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.full_name LIKE ? OR r.room_number LIKE ?)");
        }
        sql.append(" ORDER BY c.start_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
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
                    Contract c = mapContract(rs);
                    c.setStudentName(rs.getString("studentName"));
                    c.setRoomNumber(rs.getString("roomNumber"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addContract(Contract contract) {
        String sql = "INSERT INTO CONTRACT (student_id, room_id, start_date, end_date, monthly_rent, deposit, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contract.getStudent_id());
            ps.setInt(2, contract.getRoom_id());
            ps.setDate(3, new java.sql.Date(contract.getStart_date().getTime()));
            ps.setDate(4, new java.sql.Date(contract.getEnd_date().getTime()));
            ps.setDouble(5, contract.getMonthly_rent());
            ps.setDouble(6, contract.getDeposit());
            ps.setString(7, contract.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int contractId, String status) {
        String sql = "UPDATE CONTRACT SET status = ? WHERE contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Contract mapContract(ResultSet rs) throws SQLException {
        Contract c = new Contract();
        c.setContract_id(rs.getInt("contract_id"));
        c.setStudent_id(rs.getInt("student_id"));
        c.setRoom_id(rs.getInt("room_id"));
        c.setStart_date(rs.getDate("start_date"));
        c.setEnd_date(rs.getDate("end_date"));
        c.setMonthly_rent(rs.getDouble("monthly_rent"));
        c.setDeposit(rs.getDouble("deposit"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}
