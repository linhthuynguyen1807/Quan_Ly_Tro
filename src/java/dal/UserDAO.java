package dal;

import model.User;
import util.PasswordUtil;
import java.sql.*;

public class UserDAO extends DBContext {

    /**
     * Authenticates a user by username and BCrypt password verification.
     * Supports legacy plaintext passwords during migration period.
     */
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM USERS WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (PasswordUtil.verifyPassword(password, storedPassword)) {
                        User user = mapUser(rs);

                        // Auto-migrate: if password is still plaintext, upgrade to BCrypt
                        if (!PasswordUtil.isBCryptHash(storedPassword)) {
                            upgradePasswordHash(user.getUser_id(), password);
                        }
                        return user;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Registers a new user with BCrypt-hashed password.
     */
    public boolean register(String username, String password, String role, String fullName, String email, String phone) {
        String sql = "INSERT INTO USERS (username, password, role, full_name, email, phone) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, PasswordUtil.hashPassword(password));
            ps.setString(3, role);
            ps.setString(4, fullName);
            ps.setString(5, email);
            ps.setString(6, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Registers a new user and returns the auto-generated user_id.
     * Returns -1 if registration fails.
     */
    public int registerAndGetId(String username, String password, String role, String fullName, String email, String phone) {
        String sql = "INSERT INTO USERS (username, password, role, full_name, email, phone) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, PasswordUtil.hashPassword(password));
            ps.setString(3, role);
            ps.setString(4, fullName);
            ps.setString(5, email);
            ps.setString(6, phone);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM USERS WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM USERS WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE USERS SET full_name=?, email=?, phone=?, avatar=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAvatar());
            ps.setInt(5, user.getUser_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Changes password with BCrypt verification and hashing.
     * Verifies old password against stored hash, then stores new hash.
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        // Step 1: Fetch stored password hash
        String selectSql = "SELECT password FROM USERS WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(selectSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    // Step 2: Verify old password
                    if (!PasswordUtil.verifyPassword(oldPassword, storedPassword)) {
                        return false;
                    }

                    // Step 3: Update with new BCrypt hash
                    String updateSql = "UPDATE USERS SET password = ? WHERE user_id = ?";
                    try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                        updatePs.setString(1, PasswordUtil.hashPassword(newPassword));
                        updatePs.setInt(2, userId);
                        return updatePs.executeUpdate() > 0;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Auto-migrates a plaintext password to BCrypt hash.
     * Called transparently during login for legacy accounts.
     */
    private void upgradePasswordHash(int userId, String plaintext) {
        String sql = "UPDATE USERS SET password = ? WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hashPassword(plaintext));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUser_id(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setAvatar(rs.getString("avatar"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
