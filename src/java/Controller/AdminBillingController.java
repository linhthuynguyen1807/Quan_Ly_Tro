package Controller;

import dal.*;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminBillingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        HostelDAO hostelDAO = new HostelDAO();
        StudentDAO studentDAO = new StudentDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        // Hostels for the dropdown
        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());
        request.setAttribute("hostels", hostels);

        // Students for the "add invoice" form
        request.setAttribute("students", studentDAO.getStudentsByLandlord(user.getUser_id()));

        // Notification badge
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));

        // Selected hostel
        String hostelIdStr = request.getParameter("hostelId");
        int hostelId = 0;
        if (hostelIdStr != null && !hostelIdStr.isEmpty()) {
            hostelId = Integer.parseInt(hostelIdStr);
        } else if (!hostels.isEmpty()) {
            hostelId = hostels.get(0).getHostel_id();
        }

        if (hostelId > 0) {
            request.setAttribute("invoices", invoiceDAO.getInvoicesByHostel(hostelId));
            request.setAttribute("hostelId", hostelId);

            // Invoice status counts for stat cards
            request.setAttribute("totalInvoices", invoiceDAO.countInvoicesByHostelStatus(hostelId, null));
            request.setAttribute("paidInvoices", invoiceDAO.countInvoicesByHostelStatus(hostelId, "paid"));
            request.setAttribute("pendingInvoices", invoiceDAO.countInvoicesByHostelStatus(hostelId, "unpaid"));
            request.setAttribute("overdueInvoices", invoiceDAO.countInvoicesByHostelStatus(hostelId, "overdue"));
        } else {
            request.setAttribute("totalInvoices", 0);
            request.setAttribute("paidInvoices", 0);
            request.setAttribute("pendingInvoices", 0);
            request.setAttribute("overdueInvoices", 0);
        }

        request.getRequestDispatcher("/admin/billing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        InvoiceDAO invoiceDAO = new InvoiceDAO();

        if ("markPaid".equals(action)) {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            invoiceDAO.updateStatus(invoiceId, "paid");

            // Record payment
            PaymentDAO paymentDAO = new PaymentDAO();
            Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
            if (inv != null) {
                Payment payment = new Payment();
                payment.setInvoice_id(invoiceId);
                payment.setAmount(inv.getTotalAmount());
                payment.setPaymentMethod(request.getParameter("paymentMethod") != null ?
                    request.getParameter("paymentMethod") : "cash");
                payment.setTransactionRef(request.getParameter("transactionRef"));
                paymentDAO.addPayment(payment);
            }
        } else if ("addInvoice".equals(action)) {
            Invoice inv = new Invoice();
            inv.setContract_id(Integer.parseInt(request.getParameter("contractId")));
            inv.setInvoiceMonth(request.getParameter("invoiceMonth"));
            inv.setRoomFee(Double.parseDouble(request.getParameter("roomFee")));
            inv.setElectricFee(Double.parseDouble(request.getParameter("electricFee")));
            inv.setWaterFee(Double.parseDouble(request.getParameter("waterFee")));
            inv.setServiceFee(Double.parseDouble(request.getParameter("serviceFee")));
            inv.setTotalAmount(inv.getRoomFee() + inv.getElectricFee() + inv.getWaterFee() + inv.getServiceFee());
            inv.setStatus("unpaid");
            invoiceDAO.addInvoice(inv);
        }

        response.sendRedirect(request.getContextPath() + "/admin/billing?hostelId=" + request.getParameter("hostelId"));
    }
}
