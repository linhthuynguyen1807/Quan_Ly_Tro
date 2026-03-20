package Controller;

import dal.HostelDAO;
import dal.NotificationDAO;
import model.Hostel;
import model.User;
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
            int hostelId = Integer.parseInt(request.getParameter("hostelId"));
            hostelDAO.deleteHostel(hostelId);
        } else if ("update".equals(action)) {
            int hostelId = Integer.parseInt(request.getParameter("hostelId"));
            String name = request.getParameter("hostelName");
            String address = request.getParameter("address");
            String description = request.getParameter("description");

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
