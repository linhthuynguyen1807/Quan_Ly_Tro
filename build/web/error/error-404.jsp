<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@page import="model.User"%>
<%
    // Smart redirect: logged-in users go to their dashboard, others to login
    session = request.getSession(false);
    if (session != null && session.getAttribute("user") != null) {
        User user = (User) session.getAttribute("user");
        if ("landlord".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/home");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
