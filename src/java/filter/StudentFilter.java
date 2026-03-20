package filter;

import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StudentFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if ("student".equals(user.getRole())) {
                chain.doFilter(request, response);
                return;
            }
            // Logged-in but wrong role → redirect to their dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        // Not logged in → redirect to login
        response.sendRedirect(request.getContextPath() + "/login");
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
