package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.UUID;

/**
 * CSRF token management utility.
 * Tokens are stored in the session and validated on POST requests.
 */
public class CsrfUtil {

    public static final String TOKEN_NAME = "_csrf";
    public static final String SESSION_KEY = "csrfToken";

    private CsrfUtil() {
        // Utility class — prevent instantiation
    }

    /**
     * Generates a cryptographically random CSRF token.
     */
    public static String generateToken() {
        return UUID.randomUUID().toString();
    }

    /**
     * Gets the existing CSRF token from the session, or creates a new one.
     */
    public static String getOrCreateToken(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_KEY);
        if (token == null) {
            token = generateToken();
            session.setAttribute(SESSION_KEY, token);
        }
        return token;
    }

    /**
     * Validates the CSRF token from the request against the session token.
     *
     * @return true if tokens match, false otherwise
     */
    public static boolean validateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(SESSION_KEY);
        String requestToken = request.getParameter(TOKEN_NAME);

        if (sessionToken == null || requestToken == null) return false;

        return sessionToken.equals(requestToken);
    }
}
