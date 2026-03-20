package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
public class AdminReportsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        RequestDAO requestDAO = new RequestDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());

        int totalRooms = 0, occupiedRooms = 0, totalStudents = 0;
        double totalRevenue = 0;
        int unpaidInvoices = 0, pendingRequests = 0;

        Map<Integer, Double> hostelRevenue = new HashMap<>();
        Map<Integer, Integer> hostelUnpaid = new HashMap<>();

        for (Hostel h : hostels) {
            totalRooms += h.getTotalRooms();
            occupiedRooms += h.getOccupiedRooms();
            totalStudents += h.getTotalStudents();

            double rev = invoiceDAO.getTotalRevenue(h.getHostel_id());
            int unpaid = invoiceDAO.countUnpaid(h.getHostel_id());

            totalRevenue += rev;
            unpaidInvoices += unpaid;
            pendingRequests += requestDAO.countPendingByHostelId(h.getHostel_id());

            hostelRevenue.put(h.getHostel_id(), rev);
            hostelUnpaid.put(h.getHostel_id(), unpaid);
        }

        int emptyRooms = totalRooms - occupiedRooms;
        double occupancyRate = totalRooms > 0 ? (double) occupiedRooms / totalRooms * 100 : 0;

        request.setAttribute("hostels", hostels);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("occupiedRooms", occupiedRooms);
        request.setAttribute("emptyRooms", emptyRooms);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("unpaidInvoices", unpaidInvoices);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("occupancyRate", String.format("%.1f", occupancyRate));
        request.setAttribute("hostelRevenue", hostelRevenue);
        request.setAttribute("hostelUnpaid", hostelUnpaid);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
