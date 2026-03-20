package Controller;

import dal.NotificationDAO;
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

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
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
