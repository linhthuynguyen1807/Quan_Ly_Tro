package Controller;

import dal.HostelDAO;
import dal.NotificationDAO;
import model.Hostel;
import model.User;
import util.OwnershipUtil;
import util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminHostelsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());
        int unreadCount = notiDAO.countUnreadByUserId(user.getUser_id());

        request.setAttribute("hostels", hostels);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/admin/hostels.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        String action = request.getParameter("action");
        HostelDAO hostelDAO = new HostelDAO();

        if ("delete".equals(action)) {
            int hostelId = ValidationUtil.parsePositiveInt(request.getParameter("hostelId"));
            if (hostelId < 0 || !OwnershipUtil.verifyHostelOwnership(hostelId, user.getUser_id())) {
                response.sendRedirect(request.getContextPath() + "/admin/hostels?error=unauthorized");
                return;
            }
            hostelDAO.deleteHostel(hostelId);

        } else if ("update".equals(action)) {
            int hostelId = ValidationUtil.parsePositiveInt(request.getParameter("hostelId"));
            if (hostelId < 0 || !OwnershipUtil.verifyHostelOwnership(hostelId, user.getUser_id())) {
                response.sendRedirect(request.getContextPath() + "/admin/hostels?error=unauthorized");
                return;
            }
            String name = ValidationUtil.sanitize(request.getParameter("hostelName"));
            String address = ValidationUtil.sanitize(request.getParameter("address"));
            String description = ValidationUtil.sanitize(request.getParameter("description"));

            if (ValidationUtil.isNullOrEmpty(name) || ValidationUtil.isNullOrEmpty(address)) {
                response.sendRedirect(request.getContextPath() + "/admin/hostels?error=invalid_input");
                return;
            }

            Hostel hostel = new Hostel();
            hostel.setHostel_id(hostelId);
            hostel.setHostel_name(name);
            hostel.setAddress(address);
            hostel.setDescription(description);
            hostelDAO.updateHostel(hostel);
        }

        response.sendRedirect(request.getContextPath() + "/admin/hostels");
    }
}
