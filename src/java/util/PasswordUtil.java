package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for secure password hashing using BCrypt.
 * Cost factor 12 provides ~250ms hash time — good balance of security and performance.
 */
public class PasswordUtil {

    private static final int BCRYPT_COST = 12;

    private PasswordUtil() {
        // Utility class — prevent instantiation
    }

    /**
     * Hashes a plaintext password using BCrypt with a random salt.
     *
     * @param plaintext the raw password to hash
     * @return BCrypt hash string (60 chars, starting with $2a$)
     */
    public static String hashPassword(String plaintext) {
        return BCrypt.hashpw(plaintext, BCrypt.gensalt(BCRYPT_COST));
    }

    /**
     * Verifies a plaintext password against a stored BCrypt hash.
     *
     * @param plaintext the raw password to verify
     * @param hash      the stored BCrypt hash
     * @return true if the password matches the hash
     */
    public static boolean verifyPassword(String plaintext, String hash) {
        if (plaintext == null || hash == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plaintext, hash);
        } catch (IllegalArgumentException e) {
            // Invalid hash format (e.g., legacy plaintext password)
            // Fallback: direct comparison for migration period
            return plaintext.equals(hash);
        }
    }

    /**
     * Checks if a stored password is already a BCrypt hash.
     *
     * @param password the stored password string
     * @return true if it's a BCrypt hash
     */
    public static boolean isBCryptHash(String password) {
        return password != null && password.startsWith("$2a$") && password.length() == 60;
    }
}
