package Controller;

import dal.*;
import model.*;
import util.OwnershipUtil;
import util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

public class AdminInvoicesController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
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
        List<Invoice> invoices;

        if (hostelIdParam != null && !hostelIdParam.isEmpty()) {
            int hostelId;
            try { hostelId = Integer.parseInt(hostelIdParam); } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_input");
                return;
            }
            // Ownership verification: prevent IDOR
            if (!OwnershipUtil.verifyHostelOwnership(hostelId, user.getUser_id())) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=unauthorized");
                return;
            }
            totalRecords = invoiceDAO.countInvoicesByHostel(hostelId, status, search);
            invoices = invoiceDAO.getInvoicesByHostelPaginated(hostelId, status, search, offset, PAGE_SIZE);
            request.setAttribute("selectedHostelId", hostelId);
        } else if (!hostels.isEmpty()) {
            int hostelId = hostels.get(0).getHostel_id();
            totalRecords = invoiceDAO.countInvoicesByHostel(hostelId, status, search);
            invoices = invoiceDAO.getInvoicesByHostelPaginated(hostelId, status, search, offset, PAGE_SIZE);
            request.setAttribute("selectedHostelId", hostelId);
        } else {
            invoices = java.util.Collections.emptyList();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("hostels", hostels);
        request.setAttribute("invoices", invoices);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("filterStatus", status);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.getRequestDispatcher("/admin/billing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");
        InvoiceDAO invoiceDAO = new InvoiceDAO();

        if ("markPaid".equals(action)) {
            int invoiceId = ValidationUtil.parsePositiveInt(request.getParameter("invoiceId"));
            if (invoiceId < 0) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_input");
                return;
            }
            invoiceDAO.updateStatus(invoiceId, "paid");

            PaymentDAO paymentDAO = new PaymentDAO();
            Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
            if (inv != null) {
                Payment payment = new Payment();
                payment.setInvoice_id(invoiceId);
                payment.setAmount(inv.getTotalAmount());
                payment.setPaymentMethod("cash");
                paymentDAO.addPayment(payment);
            }
        } else if ("add".equals(action)) {
            int contractId = ValidationUtil.parsePositiveInt(request.getParameter("contractId"));
            double roomFee = ValidationUtil.parseNonNegativeDouble(request.getParameter("roomFee"));
            double electricFee = ValidationUtil.parseNonNegativeDouble(request.getParameter("electricFee"));
            double waterFee = ValidationUtil.parseNonNegativeDouble(request.getParameter("waterFee"));
            double serviceFee = ValidationUtil.parseNonNegativeDouble(request.getParameter("serviceFee"));

            if (contractId < 0 || roomFee < 0 || electricFee < 0 || waterFee < 0 || serviceFee < 0) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_input");
                return;
            }

            Invoice invoice = new Invoice();
            invoice.setContract_id(contractId);
            invoice.setRoomFee(roomFee);
            invoice.setElectricFee(electricFee);
            invoice.setWaterFee(waterFee);
            invoice.setServiceFee(serviceFee);

            double total = roomFee + electricFee + waterFee + serviceFee;
            invoice.setTotalAmount(total);
            invoice.setStatus("unpaid");

            String dueDateStr = request.getParameter("dueDate");
            if (!ValidationUtil.isNullOrEmpty(dueDateStr)) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    invoice.setDueDate(sdf.parse(dueDateStr));
                } catch (ParseException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_date");
                    return;
                }
            }

            invoiceDAO.addInvoice(invoice);
        }

        response.sendRedirect(request.getContextPath() + "/admin/invoices");
    }
}
