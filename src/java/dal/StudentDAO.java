package dal;

import model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO extends DBContext {

    public Student getStudentByUserId(int userId) {
        String sql = "SELECT * FROM STUDENT WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapStudent(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getStudentIdByUserId(int userId) {
        String sql = "SELECT student_id FROM STUDENT WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("student_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Student> getStudentsByHostel(int hostelId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, r.room_number FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND c.status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student s = mapStudent(rs);
                    s.setRoomNumber(rs.getString("room_number"));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get ALL students across all hostels owned by a landlord.
     */
    public List<Student> getStudentsByLandlord(int landlordId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT DISTINCT s.*, r.room_number FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN HOSTEL h ON r.hostel_id = h.hostel_id "
                + "WHERE h.landlord_id = ? AND c.status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, landlordId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student s = mapStudent(rs);
                    s.setRoomNumber(rs.getString("room_number"));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addStudent(Student student) {
        String sql = "INSERT INTO STUDENT (user_id, full_name, cccd, school, phone, gender, address) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, student.getUser_id());
            ps.setString(2, student.getFull_name());
            ps.setString(3, student.getCccd());
            ps.setString(4, student.getSchool());
            ps.setString(5, student.getPhone());
            ps.setString(6, student.getGender());
            ps.setString(7, student.getAddress());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== MULTI-CRITERIA FILTER HELPERS ==========

    /**
     * Build dynamic WHERE clause fragments for advanced student search.
     * Filters: search (name/phone/cccd), gender, floor, contractExpiry
     */
    private void appendFilters(StringBuilder sql, String search, String gender,
                               Integer floor, String contractExpiry) {
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.full_name LIKE ? OR s.phone LIKE ? OR s.cccd LIKE ? OR s.address LIKE ?)");
        }
        if (gender != null && !gender.isEmpty()) {
            sql.append(" AND s.gender = ?");
        }
        if (floor != null) {
            sql.append(" AND r.floor_number = ?");
        }
        if ("expiring".equals(contractExpiry)) {
            sql.append(" AND c.end_date BETWEEN GETDATE() AND DATEADD(day, 30, GETDATE())");
        } else if ("expired".equals(contractExpiry)) {
            sql.append(" AND c.end_date < GETDATE()");
        } else if ("active".equals(contractExpiry)) {
            sql.append(" AND c.end_date > DATEADD(day, 30, GETDATE())");
        }
    }

    private int setFilterParams(PreparedStatement ps, int idx, String search, String gender,
                                Integer floor, String contractExpiry) throws SQLException {
        if (search != null && !search.trim().isEmpty()) {
            String like = "%" + search.trim() + "%";
            ps.setString(idx++, like);
            ps.setString(idx++, like);
            ps.setString(idx++, like);
            ps.setString(idx++, like);
        }
        if (gender != null && !gender.isEmpty()) {
            ps.setString(idx++, gender);
        }
        if (floor != null) {
            ps.setInt(idx++, floor);
        }
        // contractExpiry is handled in SQL directly, no bind params needed
        return idx;
    }

    // ========== COUNT BY HOSTEL (with multi-criteria) ==========

    public int countStudentsByHostel(int hostelId, String search) {
        return countStudentsByHostel(hostelId, search, null, null, null);
    }

    public int countStudentsByHostel(int hostelId, String search, String gender,
                                     Integer floor, String contractExpiry) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND c.status = 'active'");
        appendFilters(sql, search, gender, floor, contractExpiry);
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            idx = setFilterParams(ps, idx, search, gender, floor, contractExpiry);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ========== PAGINATED BY HOSTEL (with multi-criteria) ==========

    public List<Student> getStudentsByHostelPaginated(int hostelId, String search, int offset, int limit) {
        return getStudentsByHostelPaginated(hostelId, search, null, null, null, offset, limit);
    }

    public List<Student> getStudentsByHostelPaginated(int hostelId, String search, String gender,
                                                      Integer floor, String contractExpiry,
                                                      int offset, int limit) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT s.*, r.room_number, r.floor_number, c.end_date as contract_end_date FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "WHERE r.hostel_id = ? AND c.status = 'active'");
        appendFilters(sql, search, gender, floor, contractExpiry);
        sql.append(" ORDER BY s.full_name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            idx = setFilterParams(ps, idx, search, gender, floor, contractExpiry);
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student s = mapStudent(rs);
                    s.setRoomNumber(rs.getString("room_number"));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========== COUNT ALL BY LANDLORD (with multi-criteria) ==========

    public int countAllStudentsByLandlord(int landlordId, String search) {
        return countAllStudentsByLandlord(landlordId, search, null, null, null);
    }

    public int countAllStudentsByLandlord(int landlordId, String search, String gender,
                                          Integer floor, String contractExpiry) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN HOSTEL h ON r.hostel_id = h.hostel_id "
                + "WHERE h.landlord_id = ? AND c.status = 'active'");
        appendFilters(sql, search, gender, floor, contractExpiry);
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, landlordId);
            idx = setFilterParams(ps, idx, search, gender, floor, contractExpiry);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ========== PAGINATED ALL BY LANDLORD (with multi-criteria) ==========

    public List<Student> getAllStudentsByLandlordPaginated(int landlordId, String search, int offset, int limit) {
        return getAllStudentsByLandlordPaginated(landlordId, search, null, null, null, offset, limit);
    }

    public List<Student> getAllStudentsByLandlordPaginated(int landlordId, String search, String gender,
                                                           Integer floor, String contractExpiry,
                                                           int offset, int limit) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT s.*, r.room_number, r.floor_number, c.end_date as contract_end_date FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN HOSTEL h ON r.hostel_id = h.hostel_id "
                + "WHERE h.landlord_id = ? AND c.status = 'active'");
        appendFilters(sql, search, gender, floor, contractExpiry);
        sql.append(" ORDER BY s.full_name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, landlordId);
            idx = setFilterParams(ps, idx, search, gender, floor, contractExpiry);
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student s = mapStudent(rs);
                    s.setRoomNumber(rs.getString("room_number"));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========== GET DISTINCT FLOORS FOR STUDENTS ==========

    public List<Integer> getDistinctFloorsByHostel(int hostelId) {
        List<Integer> floors = new ArrayList<>();
        String sql = "SELECT DISTINCT r.floor_number FROM ROOM r "
                + "JOIN CONTRACT c ON r.room_id = c.room_id "
                + "JOIN STUDENT s ON c.student_id = s.student_id "
                + "WHERE r.hostel_id = ? AND c.status = 'active' AND r.floor_number IS NOT NULL "
                + "ORDER BY r.floor_number";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    floors.add(rs.getInt("floor_number"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return floors;
    }

    public List<Integer> getDistinctFloorsByLandlord(int landlordId) {
        List<Integer> floors = new ArrayList<>();
        String sql = "SELECT DISTINCT r.floor_number FROM ROOM r "
                + "JOIN HOSTEL h ON r.hostel_id = h.hostel_id "
                + "JOIN CONTRACT c ON r.room_id = c.room_id "
                + "WHERE h.landlord_id = ? AND c.status = 'active' AND r.floor_number IS NOT NULL "
                + "ORDER BY r.floor_number";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, landlordId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    floors.add(rs.getInt("floor_number"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return floors;
    }

    // ========== STATUS COUNTS FOR STATS CARDS ==========

    /**
     * Count students by contract status for a landlord.
     * Returns int[3]: [0]=active (end_date > 30 days), [1]=expiring (end_date within 30 days), [2]=expired.
     */
    public int[] getStudentStatusCounts(int landlordId) {
        int[] counts = new int[3]; // 0=active, 1=expiring, 2=expired
        String sql = "SELECT "
                + "SUM(CASE WHEN c.end_date > DATEADD(day, 30, GETDATE()) THEN 1 ELSE 0 END) AS active_count, "
                + "SUM(CASE WHEN c.end_date BETWEEN GETDATE() AND DATEADD(day, 30, GETDATE()) THEN 1 ELSE 0 END) AS expiring_count, "
                + "SUM(CASE WHEN c.end_date < GETDATE() THEN 1 ELSE 0 END) AS expired_count "
                + "FROM STUDENT s "
                + "JOIN CONTRACT c ON s.student_id = c.student_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN HOSTEL h ON r.hostel_id = h.hostel_id "
                + "WHERE h.landlord_id = ? AND c.status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, landlordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts[0] = rs.getInt("active_count");
                    counts[1] = rs.getInt("expiring_count");
                    counts[2] = rs.getInt("expired_count");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    // ========== GET BY ID ==========

    public Student getStudentById(int studentId) {
        String sql = "SELECT * FROM STUDENT WHERE student_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapStudent(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========== UPDATE ==========

    public boolean updateStudent(Student student) {
        String sql = "UPDATE STUDENT SET full_name=?, cccd=?, school=?, phone=?, gender=?, address=? WHERE student_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, student.getFull_name());
            ps.setString(2, student.getCccd());
            ps.setString(3, student.getSchool());
            ps.setString(4, student.getPhone());
            ps.setString(5, student.getGender());
            ps.setString(6, student.getAddress());
            ps.setInt(7, student.getStudent_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== DELETE ==========

    public boolean deleteStudent(int studentId) {
        String sql = "DELETE FROM STUDENT WHERE student_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== MAPPER ==========

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudent_id(rs.getInt("student_id"));
        s.setUser_id(rs.getInt("user_id"));
        s.setFull_name(rs.getString("full_name"));
        s.setCccd(rs.getString("cccd"));
        s.setSchool(rs.getString("school"));
        s.setPhone(rs.getString("phone"));
        s.setGender(rs.getString("gender"));
        try { s.setAddress(rs.getString("address")); } catch (SQLException ignored) {}
        try { s.setDateOfBirth(rs.getDate("date_of_birth")); } catch (SQLException ignored) {}
        return s;
    }
}