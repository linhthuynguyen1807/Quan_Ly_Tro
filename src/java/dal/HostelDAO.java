package dal;

import model.Hostel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HostelDAO extends DBContext {

    public List<Hostel> getHostelsByLandlord(int landlordId) {
        List<Hostel> list = new ArrayList<>();
        String sql = "SELECT h.*, "
                + "(SELECT COUNT(*) FROM ROOM WHERE hostel_id = h.hostel_id) AS totalRooms, "
                + "(SELECT COUNT(*) FROM ROOM WHERE hostel_id = h.hostel_id AND status = 'occupied') AS occupiedRooms, "
                + "(SELECT COUNT(DISTINCT c.student_id) FROM CONTRACT c JOIN ROOM r ON c.room_id = r.room_id "
                + " WHERE r.hostel_id = h.hostel_id AND c.status = 'active') AS totalStudents "
                + "FROM HOSTEL h WHERE h.landlord_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, landlordId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hostel h = mapHostel(rs);
                    h.setTotalRooms(rs.getInt("totalRooms"));
                    h.setOccupiedRooms(rs.getInt("occupiedRooms"));
                    h.setTotalStudents(rs.getInt("totalStudents"));
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Hostel getHostelById(int hostelId) {
        String sql = "SELECT * FROM HOSTEL WHERE hostel_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapHostel(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addHostel(Hostel hostel) {
        String sql = "INSERT INTO HOSTEL (landlord_id, hostel_name, address, description) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostel.getLandlord_id());
            ps.setString(2, hostel.getHostel_name());
            ps.setString(3, hostel.getAddress());
            ps.setString(4, hostel.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateHostel(Hostel hostel) {
        String sql = "UPDATE HOSTEL SET hostel_name=?, address=?, description=? WHERE hostel_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, hostel.getHostel_name());
            ps.setString(2, hostel.getAddress());
            ps.setString(3, hostel.getDescription());
            ps.setInt(4, hostel.getHostel_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteHostel(int hostelId) {
        String sql = "DELETE FROM HOSTEL WHERE hostel_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Checks if a hostel belongs to a specific landlord.
     * Used for ownership verification before modify/delete operations.
     */
    public boolean isHostelOwnedBy(int hostelId, int landlordId) {
        String sql = "SELECT COUNT(*) FROM HOSTEL WHERE hostel_id = ? AND landlord_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            ps.setInt(2, landlordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Safely closes the database connection.
     */
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Hostel mapHostel(ResultSet rs) throws SQLException {
        Hostel h = new Hostel();
        h.setHostel_id(rs.getInt("hostel_id"));
        h.setLandlord_id(rs.getInt("landlord_id"));
        h.setHostel_name(rs.getString("hostel_name"));
        h.setAddress(rs.getString("address"));
        h.setDescription(rs.getString("description"));
        h.setCreated_at(rs.getTimestamp("created_at"));
        return h;
    }
}