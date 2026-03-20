package filter;

import util.CsrfUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet filter that enforces CSRF token validation on all POST requests.
 * GET requests auto-inject a fresh token into the session for use by JSP forms.
 *
 * JSP forms must include: <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}"/>
 */
public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession(true);

        String method = request.getMethod();

        if ("GET".equalsIgnoreCase(method)) {
            // Ensure a CSRF token exists in the session for form rendering
            CsrfUtil.getOrCreateToken(session);
            chain.doFilter(request, response);
            return;
        }

        if ("POST".equalsIgnoreCase(method)) {
            if (!CsrfUtil.validateToken(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token. Please refresh the page and try again.");
                return;
            }

            // Rotate token after successful POST to prevent replay attacks
            session.setAttribute(CsrfUtil.SESSION_KEY, CsrfUtil.generateToken());
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
