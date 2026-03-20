package Controller;

import dal.*;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        StudentDAO studentDAO = new StudentDAO();
        Student student = studentDAO.getStudentByUserId(user.getUser_id());

        if (student != null) {
            ContractDAO contractDAO = new ContractDAO();
            Contract contract = contractDAO.getActiveContractByStudent(student.getStudent_id());

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            List<Invoice> invoices = invoiceDAO.getInvoicesByStudent(student.getStudent_id());

            RequestDAO requestDAO = new RequestDAO();
            List<Request> requests = requestDAO.getRequestsByStudentId(student.getStudent_id());

            RoomDAO roomDAO = new RoomDAO();
            Room room = roomDAO.getRoomByStudent(student.getStudent_id());

            NotificationDAO notifDAO = new NotificationDAO();
            List<Notification> notifications = notifDAO.getNotificationsByUserId(user.getUser_id());
            int unreadNotifications = notifDAO.countUnreadByUserId(user.getUser_id());

            // Count unpaid invoices
            int unpaidInvoices = 0;
            double totalDebt = 0;
            for (Invoice inv : invoices) {
                if ("unpaid".equals(inv.getStatus()) || "overdue".equals(inv.getStatus())) {
                    unpaidInvoices++;
                    totalDebt += inv.getTotalAmount();
                }
            }

            request.setAttribute("student", student);
            request.setAttribute("contract", contract);
            request.setAttribute("invoices", invoices);
            request.setAttribute("requests", requests);
            request.setAttribute("room", room);
            request.setAttribute("notifications", notifications);
            request.setAttribute("unreadNotifications", unreadNotifications);
            request.setAttribute("unpaidInvoices", unpaidInvoices);
            request.setAttribute("totalDebt", totalDebt);
        }

        request.getRequestDispatcher("/student/student-dashboard.jsp").forward(request, response);
    }
}
