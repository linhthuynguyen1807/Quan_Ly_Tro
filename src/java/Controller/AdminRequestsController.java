package Controller;

import dal.*;
import model.*;
import util.OwnershipUtil;
import util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminRequestsController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        RequestDAO requestDAO = new RequestDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        String hostelIdParam = request.getParameter("hostelId");
        int totalRecords = 0;
        List<Request> requests;

        if (hostelIdParam != null && !hostelIdParam.isEmpty()) {
            int hostelId;
            try { hostelId = Integer.parseInt(hostelIdParam); } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/requests?error=invalid_input");
                return;
            }
            // Ownership verification: prevent IDOR
            if (!OwnershipUtil.verifyHostelOwnership(hostelId, user.getUser_id())) {
                response.sendRedirect(request.getContextPath() + "/admin/requests?error=unauthorized");
                return;
            }
            totalRecords = requestDAO.countRequestsByHostel(hostelId, status, search);
            requests = requestDAO.getRequestsByHostelPaginated(hostelId, status, search, offset, PAGE_SIZE);
            request.setAttribute("selectedHostelId", hostelId);
        } else if (!hostels.isEmpty()) {
            int hostelId = hostels.get(0).getHostel_id();
            totalRecords = requestDAO.countRequestsByHostel(hostelId, status, search);
            requests = requestDAO.getRequestsByHostelPaginated(hostelId, status, search, offset, PAGE_SIZE);
            request.setAttribute("selectedHostelId", hostelId);
        } else {
            requests = java.util.Collections.emptyList();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("hostels", hostels);
        request.setAttribute("requests", requests);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("filterStatus", status);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.getRequestDispatcher("/admin/maintenance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        RequestDAO requestDAO = new RequestDAO();

        if ("updateStatus".equals(action)) {
            int requestId = ValidationUtil.parsePositiveInt(request.getParameter("requestId"));
            String status = ValidationUtil.sanitize(request.getParameter("status"));

            if (requestId < 0 || ValidationUtil.isNullOrEmpty(status)) {
                response.sendRedirect(request.getContextPath() + "/admin/requests?error=invalid_input");
                return;
            }

            // Whitelist allowed status values
            if (!ValidationUtil.isAllowedValue(status, "pending", "in_progress", "resolved", "rejected")) {
                response.sendRedirect(request.getContextPath() + "/admin/requests?error=invalid_status");
                return;
            }

            requestDAO.updateRequestStatus(requestId, status);
        }

        response.sendRedirect(request.getContextPath() + "/admin/requests");
    }
}
