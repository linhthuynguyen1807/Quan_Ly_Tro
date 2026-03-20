package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Blocks direct browser access to .jsp files.
 * Only requests that arrive via RequestDispatcher.FORWARD (from controllers) are allowed.
 * Public pages (login.jsp, register.jsp, forgot-password.jsp) are whitelisted.
 */
public class JspAccessFilter implements Filter {

    private static final String[] PUBLIC_JSPS = {
        "/login.jsp",
        "/register.jsp",
        "/forgot-password.jsp"
    };

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // If this JSP was forwarded from a servlet/controller, allow it
        if (request.getAttribute(RequestDispatcher.FORWARD_REQUEST_URI) != null) {
            chain.doFilter(request, response);
            return;
        }

        // Allow public JSPs accessed directly
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        for (String publicJsp : PUBLIC_JSPS) {
            if (path.equals(publicJsp)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Block all other direct JSP access
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Direct JSP access is not allowed.");
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
