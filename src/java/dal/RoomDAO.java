package dal;

import model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO extends DBContext {

    public List<Room> getRoomsByHostel(int hostelId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, "
                + "(SELECT COUNT(*) FROM CONTRACT c WHERE c.room_id = r.room_id AND c.status = 'active') AS currentOccupants "
                + "FROM ROOM r WHERE r.hostel_id = ? ORDER BY r.room_number";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room r = mapRoom(rs);
                    r.setCurrentOccupants(rs.getInt("currentOccupants"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM ROOM WHERE room_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRoom(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Room getRoomByStudent(int studentId) {
        String sql = "SELECT r.* FROM ROOM r "
                + "JOIN CONTRACT c ON r.room_id = c.room_id "
                + "WHERE c.student_id = ? AND c.status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRoom(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countRoomsByHostel(int hostelId, String status, String search, Integer floor) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM ROOM r WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND r.room_number LIKE ?");
        }
        if (floor != null) {
            sql.append(" AND r.floor_number = ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search.trim() + "%");
            }
            if (floor != null) {
                ps.setInt(idx++, floor);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Room> getRoomsByHostelPaginated(int hostelId, String status, String search, Integer floor, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, "
                + "(SELECT COUNT(*) FROM CONTRACT c WHERE c.room_id = r.room_id AND c.status = 'active') AS currentOccupants "
                + "FROM ROOM r WHERE r.hostel_id = ?");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND r.room_number LIKE ?");
        }
        if (floor != null) {
            sql.append(" AND r.floor_number = ?");
        }
        sql.append(" ORDER BY r.floor_number, r.room_number OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search.trim() + "%");
            }
            if (floor != null) {
                ps.setInt(idx++, floor);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room r = mapRoom(rs);
                    r.setCurrentOccupants(rs.getInt("currentOccupants"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addRoom(Room room) {
        String sql = "INSERT INTO ROOM (hostel_id, room_number, area, price, max_capacity, status, room_type, floor_number) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, room.getHostel_id());
            ps.setString(2, room.getRoom_number());
            ps.setFloat(3, room.getArea());
            ps.setDouble(4, room.getPrice());
            ps.setInt(5, room.getMax_capacity());
            ps.setString(6, room.getStatus());
            ps.setString(7, room.getRoomType());
            ps.setInt(8, room.getFloorNumber());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE ROOM SET room_number=?, area=?, price=?, max_capacity=?, status=?, room_type=?, floor_number=? WHERE room_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, room.getRoom_number());
            ps.setFloat(2, room.getArea());
            ps.setDouble(3, room.getPrice());
            ps.setInt(4, room.getMax_capacity());
            ps.setString(5, room.getStatus());
            ps.setString(6, room.getRoomType());
            ps.setInt(7, room.getFloorNumber());
            ps.setInt(8, room.getRoom_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM ROOM WHERE room_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Integer> getDistinctFloors(int hostelId) {
        List<Integer> floors = new ArrayList<>();
        String sql = "SELECT DISTINCT floor_number FROM ROOM WHERE hostel_id = ? AND floor_number IS NOT NULL ORDER BY floor_number";
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

    /**
     * Get room status counts for a hostel.
     * Returns int[3]: [0]=available, [1]=full, [2]=partial (has some occupants but not full).
     */
    public int[] getRoomStatusCounts(int hostelId) {
        int[] counts = new int[3]; // 0=available, 1=full, 2=partial
        String sql = "SELECT r.room_id, r.max_capacity, r.status, "
                + "(SELECT COUNT(*) FROM CONTRACT c WHERE c.room_id = r.room_id AND c.status = 'active') AS occupants "
                + "FROM ROOM r WHERE r.hostel_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int occupants = rs.getInt("occupants");
                    int maxCap = rs.getInt("max_capacity");
                    String status = rs.getString("status");
                    if ("maintenance".equalsIgnoreCase(status)) continue;
                    if (occupants == 0) {
                        counts[0]++; // available
                    } else if (occupants >= maxCap) {
                        counts[1]++; // full
                    } else {
                        counts[2]++; // partial
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    private Room mapRoom(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setRoom_id(rs.getInt("room_id"));
        r.setHostel_id(rs.getInt("hostel_id"));
        r.setRoom_number(rs.getString("room_number"));
        r.setArea(rs.getFloat("area"));
        r.setPrice(rs.getDouble("price"));
        r.setMax_capacity(rs.getInt("max_capacity"));
        r.setStatus(rs.getString("status"));
        r.setRoomType(rs.getString("room_type"));
        r.setFloorNumber(rs.getInt("floor_number"));
        return r;
    }
}
