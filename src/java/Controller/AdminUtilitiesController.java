package Controller;

import dal.*;
import model.*;
import util.OwnershipUtil;
import util.ValidationUtil;
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
            try { selectedHostelId = Integer.parseInt(hostelIdParam); } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/utilities?error=invalid_input");
                return;
            }
            // Ownership verification: prevent IDOR
            if (!OwnershipUtil.verifyHostelOwnership(selectedHostelId, user.getUser_id())) {
                response.sendRedirect(request.getContextPath() + "/admin/utilities?error=unauthorized");
                return;
            }
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

        // Provide room list for the add-reading modal
        RoomDAO roomDAO = new RoomDAO();
        if (selectedHostelId > 0) {
            request.setAttribute("rooms", roomDAO.getRoomsByHostel(selectedHostelId));
        }

        request.getRequestDispatcher("/admin/utilities.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        int roomId = ValidationUtil.parsePositiveInt(request.getParameter("roomId"));
        String monthStr = ValidationUtil.sanitize(request.getParameter("month"));
        String yearStr = ValidationUtil.sanitize(request.getParameter("year"));
        int prevElectric = ValidationUtil.parsePositiveInt(request.getParameter("prevElectric"));
        int currElectric = ValidationUtil.parsePositiveInt(request.getParameter("currElectric"));
        int prevWater = ValidationUtil.parsePositiveInt(request.getParameter("prevWater"));
        int currWater = ValidationUtil.parsePositiveInt(request.getParameter("currWater"));
        String hostelId = request.getParameter("hostelId");

        // Validate numeric inputs (allow 0 for meter readings as they could be starting values)
        if (roomId < 0 || ValidationUtil.isNullOrEmpty(monthStr) || ValidationUtil.isNullOrEmpty(yearStr)) {
            response.sendRedirect(request.getContextPath() + "/admin/utilities?hostelId=" + hostelId + "&error=invalid_input");
            return;
        }

        // Ownership verification
        int hostelIdInt = ValidationUtil.parsePositiveInt(hostelId);
        if (hostelIdInt > 0 && !OwnershipUtil.verifyHostelOwnership(hostelIdInt, user.getUser_id())) {
            response.sendRedirect(request.getContextPath() + "/admin/utilities?error=unauthorized");
            return;
        }

        ReadingDAO readingDAO = new ReadingDAO();
        ElectricityWaterReading reading = new ElectricityWaterReading();
        reading.setRoom_id(roomId);
        reading.setReadingMonth(monthStr + "/" + yearStr);
        reading.setElectricOld(prevElectric > 0 ? prevElectric : 0);
        reading.setElectricNew(currElectric > 0 ? currElectric : 0);
        reading.setWaterOld(prevWater > 0 ? prevWater : 0);
        reading.setWaterNew(currWater > 0 ? currWater : 0);

        readingDAO.addReading(reading);

        response.sendRedirect(request.getContextPath() + "/admin/utilities?hostelId=" + hostelId);
    }
}
