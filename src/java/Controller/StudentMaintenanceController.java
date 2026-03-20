package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentMaintenanceController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        StudentDAO studentDAO = new StudentDAO();
        RequestDAO requestDAO = new RequestDAO();
        RoomDAO roomDAO = new RoomDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());
        Room room = roomDAO.getRoomByStudent(studentId);

        String status = request.getParameter("status");
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        int totalRecords = requestDAO.countRequestsByStudent(studentId, status);
        List<Request> requests = requestDAO.getRequestsByStudentPaginated(studentId, status, offset, PAGE_SIZE);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("requests", requests);
        request.setAttribute("room", room);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("filterStatus", status);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.getRequestDispatcher("/student/maintenance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        StudentDAO studentDAO = new StudentDAO();
        RoomDAO roomDAO = new RoomDAO();
        RequestDAO requestDAO = new RequestDAO();

        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());
        Room room = roomDAO.getRoomByStudent(studentId);

        Request req = new Request();
        req.setStudent_id(studentId);
        req.setRoom_id(room != null ? room.getRoom_id() : 0);
        req.setTitle(request.getParameter("title"));
        req.setDescription(request.getParameter("description"));
        req.setStatus("pending");

        requestDAO.addRequest(req);
        response.sendRedirect(request.getContextPath() + "/student/maintenance");
    }
}
