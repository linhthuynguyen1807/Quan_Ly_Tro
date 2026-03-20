package dal;

import model.ElectricityWaterReading;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReadingDAO extends DBContext {

    public List<ElectricityWaterReading> getReadingsByHostelId(int hostelId) {
        List<ElectricityWaterReading> list = new ArrayList<>();
        String sql = "SELECT ew.*, r.room_number, h.hostel_name FROM ELECTRICITY_WATER_READING ew " +
                "JOIN ROOM r ON ew.room_id = r.room_id " +
                "JOIN HOSTEL h ON r.hostel_id = h.hostel_id " +
                "WHERE r.hostel_id = ? ORDER BY ew.reading_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hostelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ElectricityWaterReading reading = mapReading(rs);
                    reading.setRoomNumber(rs.getString("room_number"));
                    reading.setHostelName(rs.getString("hostel_name"));
                    list.add(reading);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ElectricityWaterReading> getReadingsByRoomId(int roomId) {
        List<ElectricityWaterReading> list = new ArrayList<>();
        String sql = "SELECT * FROM ELECTRICITY_WATER_READING WHERE room_id = ? ORDER BY reading_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReading(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countReadingsByHostel(int hostelId, String month, String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM ELECTRICITY_WATER_READING ew "
                + "JOIN ROOM r ON ew.room_id = r.room_id "
                + "WHERE r.hostel_id = ?");
        if (month != null && !month.isEmpty()) {
            sql.append(" AND ew.reading_month = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND r.room_number LIKE ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (month != null && !month.isEmpty()) {
                ps.setString(idx++, month);
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ElectricityWaterReading> getReadingsByHostelPaginated(int hostelId, String month, String search, int offset, int limit) {
        List<ElectricityWaterReading> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ew.*, r.room_number, h.hostel_name FROM ELECTRICITY_WATER_READING ew "
                + "JOIN ROOM r ON ew.room_id = r.room_id "
                + "JOIN HOSTEL h ON r.hostel_id = h.hostel_id "
                + "WHERE r.hostel_id = ?");
        if (month != null && !month.isEmpty()) {
            sql.append(" AND ew.reading_month = ?");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND r.room_number LIKE ?");
        }
        sql.append(" ORDER BY ew.reading_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, hostelId);
            if (month != null && !month.isEmpty()) {
                ps.setString(idx++, month);
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search.trim() + "%");
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ElectricityWaterReading reading = mapReading(rs);
                    reading.setRoomNumber(rs.getString("room_number"));
                    reading.setHostelName(rs.getString("hostel_name"));
                    list.add(reading);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addReading(ElectricityWaterReading reading) {
        String sql = "INSERT INTO ELECTRICITY_WATER_READING (room_id, reading_month, electric_old, electric_new, water_old, water_new) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reading.getRoom_id());
            ps.setString(2, reading.getReadingMonth());
            ps.setInt(3, reading.getElectricOld());
            ps.setInt(4, reading.getElectricNew());
            ps.setInt(5, reading.getWaterOld());
            ps.setInt(6, reading.getWaterNew());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ElectricityWaterReading getLatestReading(int roomId) {
        String sql = "SELECT TOP 1 * FROM ELECTRICITY_WATER_READING WHERE room_id = ? ORDER BY reading_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapReading(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private ElectricityWaterReading mapReading(ResultSet rs) throws SQLException {
        ElectricityWaterReading r = new ElectricityWaterReading();
        r.setReading_id(rs.getInt("reading_id"));
        r.setRoom_id(rs.getInt("room_id"));
        r.setReadingMonth(rs.getString("reading_month"));
        r.setElectricOld(rs.getInt("electric_old"));
        r.setElectricNew(rs.getInt("electric_new"));
        r.setWaterOld(rs.getInt("water_old"));
        r.setWaterNew(rs.getInt("water_new"));
        r.setReadingDate(rs.getTimestamp("reading_date"));
        return r;
    }
}
