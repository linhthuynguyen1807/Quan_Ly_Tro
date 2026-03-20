package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Adds security headers to all HTTP responses.
 * Prevents clickjacking, MIME-type sniffing, and XSS attacks.
 */
public class SecurityHeadersFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) res;

        // Prevent clickjacking
        response.setHeader("X-Frame-Options", "DENY");
        // Prevent MIME-type sniffing
        response.setHeader("X-Content-Type-Options", "nosniff");
        // XSS protection for older browsers
        response.setHeader("X-XSS-Protection", "1; mode=block");
        // Referrer policy
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        // Permissions policy
        response.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");

        chain.doFilter(req, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
