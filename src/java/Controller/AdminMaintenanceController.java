package Controller;

import dal.RequestDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminMaintenanceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String hostelIdStr = request.getParameter("hostelId");
        if (hostelIdStr != null && !hostelIdStr.isEmpty()) {
            try {
                int hostelId = Integer.parseInt(hostelIdStr);
                RequestDAO requestDAO = new RequestDAO();
                request.setAttribute("requests", requestDAO.getRequestsByHostelId(hostelId));
                request.setAttribute("hostelId", hostelId);
            } catch (NumberFormatException e) {
                // Invalid hostelId — just show empty page
            }
        }
        request.getRequestDispatcher("/admin/maintenance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String hostelIdParam = request.getParameter("hostelId");
        try {
            RequestDAO requestDAO = new RequestDAO();
            if ("updateStatus".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                String status = request.getParameter("status");
                requestDAO.updateRequestStatus(requestId, status);
            }
        } catch (NumberFormatException e) {
            // Invalid input — skip
        }
        response.sendRedirect(request.getContextPath() + "/admin/maintenance?hostelId=" + hostelIdParam);
    }
}
