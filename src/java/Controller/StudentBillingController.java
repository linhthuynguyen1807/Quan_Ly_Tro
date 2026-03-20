package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentBillingController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        StudentDAO studentDAO = new StudentDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());

        // Guard: if student profile doesn't exist yet, redirect
        if (studentId <= 0) {
            request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
            request.setAttribute("invoices", java.util.Collections.emptyList());
            request.setAttribute("totalPaid", 0.0);
            request.setAttribute("totalUnpaid", 0.0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalRecords", 0);
            request.getRequestDispatcher("/student/billing.jsp").forward(request, response);
            return;
        }

        String status = request.getParameter("status");
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        int totalRecords = invoiceDAO.countInvoicesByStudent(studentId, status);
        List<Invoice> invoices = invoiceDAO.getInvoicesByStudentPaginated(studentId, status, offset, PAGE_SIZE);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        double totalPaid = 0, totalUnpaid = 0;
        for (Invoice inv : invoices) {
            if ("paid".equals(inv.getStatus())) {
                totalPaid += inv.getTotalAmount();
            } else {
                totalUnpaid += inv.getTotalAmount();
            }
        }

        // Pending bills for sidebar badge
        int pendingBills = invoiceDAO.countInvoicesByStudent(studentId, "unpaid");

        request.setAttribute("invoices", invoices);
        request.setAttribute("totalPaid", totalPaid);
        request.setAttribute("totalUnpaid", totalUnpaid);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("filterStatus", status);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.setAttribute("pendingBills", pendingBills);
        request.getRequestDispatcher("/student/billing.jsp").forward(request, response);
    }
}
