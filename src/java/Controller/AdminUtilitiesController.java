package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminUtilitiesController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        ReadingDAO readingDAO = new ReadingDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());

        String search = request.getParameter("search");
        String month = request.getParameter("month");
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        int totalRecords = 0;
        List<ElectricityWaterReading> readings;
        int selectedHostelId = 0;

        String hostelIdParam = request.getParameter("hostelId");
        if (hostelIdParam != null && !hostelIdParam.isEmpty()) {
            selectedHostelId = Integer.parseInt(hostelIdParam);
        } else if (!hostels.isEmpty()) {
            selectedHostelId = hostels.get(0).getHostel_id();
        }

        if (selectedHostelId > 0) {
            totalRecords = readingDAO.countReadingsByHostel(selectedHostelId, month, search);
            readings = readingDAO.getReadingsByHostelPaginated(selectedHostelId, month, search, offset, PAGE_SIZE);
        } else {
            readings = java.util.Collections.emptyList();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("hostels", hostels);
        request.setAttribute("readings", readings);
        request.setAttribute("selectedHostelId", selectedHostelId);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("filterMonth", month);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.getRequestDispatcher("/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ReadingDAO readingDAO = new ReadingDAO();

        ElectricityWaterReading reading = new ElectricityWaterReading();
        reading.setRoom_id(Integer.parseInt(request.getParameter("roomId")));
        reading.setReadingMonth(request.getParameter("month") + "/" + request.getParameter("year"));
        reading.setElectricOld(Integer.parseInt(request.getParameter("prevElectric")));
        reading.setElectricNew(Integer.parseInt(request.getParameter("currElectric")));
        reading.setWaterOld(Integer.parseInt(request.getParameter("prevWater")));
        reading.setWaterNew(Integer.parseInt(request.getParameter("currWater")));

        readingDAO.addReading(reading);

        String hostelId = request.getParameter("hostelId");
        response.sendRedirect(request.getContextPath() + "/admin/utilities?hostelId=" + hostelId);
    }
}
