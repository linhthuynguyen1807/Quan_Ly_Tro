package Controller;

import dal.*;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int landlordId = user.getUser_id();

        HostelDAO hostelDAO = new HostelDAO();
        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(landlordId);

        // Aggregate stats
        int totalRooms = 0, occupiedRooms = 0, totalStudents = 0;
        for (Hostel h : hostels) {
            totalRooms += h.getTotalRooms();
            occupiedRooms += h.getOccupiedRooms();
            totalStudents += h.getTotalStudents();
        }

        // Revenue & pending
        double totalRevenue = 0;
        double monthlyRevenue = 0;
        int totalUnpaidInvoices = 0;
        int totalPendingRequests = 0;
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        RequestDAO requestDAO = new RequestDAO();
        RoomDAO roomDAO = new RoomDAO();

        // Chart data aggregation
        double[] revenueChart = new double[6];
        int roomAvailable = 0, roomFull = 0, roomPartial = 0;

        for (Hostel h : hostels) {
            int hid = h.getHostel_id();
            totalRevenue += invoiceDAO.getTotalRevenue(hid);
            monthlyRevenue += invoiceDAO.getCurrentMonthRevenue(hid);
            totalUnpaidInvoices += invoiceDAO.countUnpaid(hid);
            totalPendingRequests += requestDAO.countPendingByHostelId(hid);

            // Aggregate monthly revenue chart data
            double[] monthly = invoiceDAO.getMonthlyRevenue(hid);
            for (int i = 0; i < 6; i++) {
                revenueChart[i] += monthly[i];
            }

            // Aggregate room status counts
            int[] roomCounts = roomDAO.getRoomStatusCounts(hid);
            roomAvailable += roomCounts[0];
            roomFull += roomCounts[1];
            roomPartial += roomCounts[2];
        }

        // Notifications
        NotificationDAO notifDAO = new NotificationDAO();
        int unreadNotifications = notifDAO.countUnreadByUserId(user.getUser_id());
        List<Notification> recentActivities = notifDAO.getRecentByUserId(user.getUser_id(), 10);

        // Build revenue chart labels (last 6 months)
        Calendar cal = Calendar.getInstance();
        String[] chartLabels = new String[6];
        for (int i = 5; i >= 0; i--) {
            Calendar c = Calendar.getInstance();
            c.add(Calendar.MONTH, -(5 - i));
            chartLabels[i] = "T" + (c.get(Calendar.MONTH) + 1);
        }

        // Convert revenue to "triệu đồng" for chart display
        StringBuilder revenueDataJson = new StringBuilder("[");
        StringBuilder labelsJson = new StringBuilder("[");
        for (int i = 0; i < 6; i++) {
            if (i > 0) { revenueDataJson.append(","); labelsJson.append(","); }
            // Convert to millions, round to 1 decimal
            revenueDataJson.append(String.format("%.1f", revenueChart[i] / 1000000.0));
            labelsJson.append("'").append(chartLabels[i]).append("'");
        }
        revenueDataJson.append("]");
        labelsJson.append("]");

        // Format monthly revenue for display
        String formattedMonthlyRevenue;
        if (monthlyRevenue >= 1000000) {
            formattedMonthlyRevenue = String.format("%.1f tr", monthlyRevenue / 1000000.0);
        } else if (monthlyRevenue >= 1000) {
            formattedMonthlyRevenue = String.format("%.0f k", monthlyRevenue / 1000.0);
        } else {
            formattedMonthlyRevenue = String.format("%.0f", monthlyRevenue);
        }

        request.setAttribute("hostels", hostels);
        request.setAttribute("totalHostels", hostels.size());
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("occupiedRooms", occupiedRooms);
        request.setAttribute("emptyRooms", totalRooms - occupiedRooms);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("monthlyRevenue", formattedMonthlyRevenue);
        request.setAttribute("totalUnpaidInvoices", totalUnpaidInvoices);
        request.setAttribute("totalPendingRequests", totalPendingRequests);
        request.setAttribute("unreadNotifications", unreadNotifications);

        // Chart data
        request.setAttribute("revenueChartData", revenueDataJson.toString());
        request.setAttribute("revenueChartLabels", labelsJson.toString());
        request.setAttribute("roomAvailable", roomAvailable);
        request.setAttribute("roomFull", roomFull);
        request.setAttribute("roomPartial", roomPartial);
        request.setAttribute("recentActivities", recentActivities);

        request.getRequestDispatcher("/admin/admin-dashboard.jsp").forward(request, response);
    }
}
