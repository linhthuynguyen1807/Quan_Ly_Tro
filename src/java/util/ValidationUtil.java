package util;

import java.util.regex.Pattern;

/**
 * Centralized input validation utility for Controllers.
 * All methods are null-safe and return false/default on null input.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^(0|\\+84)[0-9]{9,10}$");

    private static final Pattern HTML_TAG_PATTERN =
            Pattern.compile("<[^>]*>");

    private ValidationUtil() {
        // Utility class — prevent instantiation
    }

    // ---- String checks ----

    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return !isNullOrEmpty(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return !isNullOrEmpty(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Trims whitespace and strips HTML tags to prevent XSS.
     */
    public static String sanitize(String input) {
        if (input == null) return null;
        return HTML_TAG_PATTERN.matcher(input.trim()).replaceAll("");
    }

    /**
     * Checks that a string doesn't exceed a maximum length.
     */
    public static boolean isWithinLength(String value, int maxLength) {
        return value != null && value.length() <= maxLength;
    }

    // ---- Numeric checks ----

    /**
     * Safely parses a string as a positive integer.
     * Returns -1 if invalid or non-positive.
     */
    public static int parsePositiveInt(String value) {
        if (isNullOrEmpty(value)) return -1;
        try {
            int n = Integer.parseInt(value.trim());
            return n > 0 ? n : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    /**
     * Safely parses a string as a non-negative double.
     * Returns -1.0 if invalid or negative.
     */
    public static double parseNonNegativeDouble(String value) {
        if (isNullOrEmpty(value)) return -1.0;
        try {
            double d = Double.parseDouble(value.trim());
            return d >= 0 ? d : -1.0;
        } catch (NumberFormatException e) {
            return -1.0;
        }
    }

    /**
     * Safely parses a string as a positive double (> 0).
     * Returns -1.0 if invalid or non-positive.
     */
    public static double parsePositiveDouble(String value) {
        if (isNullOrEmpty(value)) return -1.0;
        try {
            double d = Double.parseDouble(value.trim());
            return d > 0 ? d : -1.0;
        } catch (NumberFormatException e) {
            return -1.0;
        }
    }

    public static boolean isInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    // ---- Whitelist checks ----

    /**
     * Checks if a value is one of the allowed values (case-insensitive).
     */
    public static boolean isAllowedValue(String value, String... allowed) {
        if (isNullOrEmpty(value)) return false;
        String trimmed = value.trim().toLowerCase();
        for (String a : allowed) {
            if (a.toLowerCase().equals(trimmed)) return true;
        }
        return false;
    }
}
