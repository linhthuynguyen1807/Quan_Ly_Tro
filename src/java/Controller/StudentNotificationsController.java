package Controller;

import dal.NotificationDAO;
import dal.StudentDAO;
import dal.InvoiceDAO;
import model.Notification;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentNotificationsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        NotificationDAO notiDAO = new NotificationDAO();
        List<Notification> notifications = notiDAO.getNotificationsByUserId(user.getUser_id());
        int unreadCount = notiDAO.countUnreadByUserId(user.getUser_id());

        // Pending bills for sidebar badge
        StudentDAO studentDAO = new StudentDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());
        int pendingBills = invoiceDAO.countInvoicesByStudent(studentId, "unpaid");

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("pendingBills", pendingBills);
        request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        String action = request.getParameter("action");
        NotificationDAO notiDAO = new NotificationDAO();

        if ("markRead".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            notiDAO.markAsRead(notificationId);
        } else if ("markAllRead".equals(action)) {
            notiDAO.markAllAsRead(user.getUser_id());
        }

        response.sendRedirect(request.getContextPath() + "/student/notifications");
    }
}
