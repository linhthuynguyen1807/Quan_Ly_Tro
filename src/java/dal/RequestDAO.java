package dal;

import model.Request;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RequestDAO extends DBContext {

    public List<Request> getRequestsByHostelId(int hostelId) {
        List<Request> list = new ArrayList<>();
        String sql = "SELECT req.*, s.full_name AS student_name, r.room_number FROM REQUEST req " +
                "JOIN STUDENT s ON req.student_id = s.student_id " +
                "JOIN ROOM r ON req.room_id = r.room_id " +
                "WHERE r.hostel_id = ? ORDER BY req.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Request req = mapRequest(rs);
                    list.add(req);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Request> getRequestsByStudentId(int studentId) {
        List<Request> list = new ArrayList<>();
        String sql = "SELECT req.*, r.room_number FROM REQUEST req " +
                "JOIN ROOM r ON req.room_id = r.room_id WHERE req.student_id = ? ORDER BY req.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRequest(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countRequestsByHostel(int hostelId, String status, String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM REQUEST req "
                + "JOIN STUDENT s ON req.student_id = s.student_id "
                + "JOIN ROOM r ON req.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND req.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.full_name LIKE ? OR req.title LIKE ?)");
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

    public List<Request> getRequestsByHostelPaginated(int hostelId, String status, String search, int offset, int limit) {
        List<Request> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT req.*, s.full_name AS student_name, r.room_number FROM REQUEST req "
                + "JOIN STUDENT s ON req.student_id = s.student_id "
                + "JOIN ROOM r ON req.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND req.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.full_name LIKE ? OR req.title LIKE ?)");
        }
        sql.append(" ORDER BY req.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
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
                    Request req = mapRequest(rs);
                    list.add(req);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countRequestsByStudent(int studentId, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM REQUEST req WHERE req.student_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND req.status = ?");
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

    public List<Request> getRequestsByStudentPaginated(int studentId, String status, int offset, int limit) {
        List<Request> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT req.*, r.room_number FROM REQUEST req "
                + "JOIN ROOM r ON req.room_id = r.room_id WHERE req.student_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND req.status = ?");
        }
        sql.append(" ORDER BY req.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
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
                    list.add(mapRequest(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addRequest(Request request) {
        String sql = "INSERT INTO REQUEST (student_id, room_id, title, description, status) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, request.getStudent_id());
            ps.setInt(2, request.getRoom_id());
            ps.setString(3, request.getTitle());
            ps.setString(4, request.getDescription());
            ps.setString(5, request.getStatus() != null ? request.getStatus() : "pending");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE REQUEST SET status = ? WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countPendingByHostelId(int hostelId) {
        String sql = "SELECT COUNT(*) FROM REQUEST req " +
                "JOIN ROOM r ON req.room_id = r.room_id " +
                "WHERE r.hostel_id = ? AND req.status IN ('pending','processing')";
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

    private Request mapRequest(ResultSet rs) throws SQLException {
        Request req = new Request();
        req.setRequest_id(rs.getInt("request_id"));
        req.setStudent_id(rs.getInt("student_id"));
        req.setRoom_id(rs.getInt("room_id"));
        req.setTitle(rs.getString("title"));
        req.setDescription(rs.getString("description"));
        req.setStatus(rs.getString("status"));
        req.setCreated_at(rs.getTimestamp("created_at"));
        return req;
    }
}
