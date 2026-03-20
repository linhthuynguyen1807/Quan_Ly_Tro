package Controller;

import dal.HostelDAO;
import model.Hostel;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AddHostelController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        String hostelName = request.getParameter("hostelName");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        if (hostelName == null || hostelName.trim().isEmpty() ||
            address == null || address.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        Hostel hostel = new Hostel();
        hostel.setLandlord_id(user.getUser_id());
        hostel.setHostel_name(hostelName.trim());
        hostel.setAddress(address.trim());
        hostel.setDescription(description != null ? description.trim() : "");

        HostelDAO hostelDAO = new HostelDAO();
        hostelDAO.addHostel(hostel);

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
