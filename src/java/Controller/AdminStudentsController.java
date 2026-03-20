package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminStudentsController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        StudentDAO studentDAO = new StudentDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());

        // --- Read filter parameters ---
        String search = request.getParameter("search");
        String gender = request.getParameter("gender");
        String contractExpiry = request.getParameter("contractExpiry");

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        // Safe parse hostelId
        String hostelIdParam = request.getParameter("hostelId");
        Integer hostelId = null;
        if (hostelIdParam != null && !hostelIdParam.isEmpty()) {
            try { hostelId = Integer.parseInt(hostelIdParam); } catch (NumberFormatException e) {}
        }

        // Safe parse floor
        String floorParam = request.getParameter("floor");
        Integer floor = null;
        if (floorParam != null && !floorParam.isEmpty()) {
            try { floor = Integer.parseInt(floorParam); } catch (NumberFormatException e) {}
        }

        int totalRecords;
        List<Student> students;
        List<Integer> floors;

        if (hostelId != null) {
            totalRecords = studentDAO.countStudentsByHostel(hostelId, search, gender, floor, contractExpiry);
            students = studentDAO.getStudentsByHostelPaginated(hostelId, search, gender, floor, contractExpiry, offset, PAGE_SIZE);
            floors = studentDAO.getDistinctFloorsByHostel(hostelId);
            request.setAttribute("selectedHostelId", hostelId);
        } else {
            totalRecords = studentDAO.countAllStudentsByLandlord(user.getUser_id(), search, gender, floor, contractExpiry);
            students = studentDAO.getAllStudentsByLandlordPaginated(user.getUser_id(), search, gender, floor, contractExpiry, offset, PAGE_SIZE);
            floors = studentDAO.getDistinctFloorsByLandlord(user.getUser_id());
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        // Set attributes
        request.setAttribute("hostels", hostels);
        request.setAttribute("students", students);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("gender", gender);
        request.setAttribute("floor", floor);
        request.setAttribute("contractExpiry", contractExpiry);
        request.setAttribute("floors", floors);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));

        // Student contract status counts for stat cards
        int[] statusCounts = studentDAO.getStudentStatusCounts(user.getUser_id());
        request.setAttribute("activeStudents", statusCounts[0]);
        request.setAttribute("pendingStudents", statusCounts[1]);
        request.setAttribute("expiredStudents", statusCounts[2]);

        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        StudentDAO studentDAO = new StudentDAO();

        try {
            if ("add".equals(action)) {
                Student student = new Student();
                student.setUser_id(Integer.parseInt(request.getParameter("userId")));
                student.setFull_name(request.getParameter("fullName"));
                student.setCccd(request.getParameter("cccd"));
                student.setSchool(request.getParameter("school"));
                student.setPhone(request.getParameter("phone"));
                student.setGender(request.getParameter("gender"));
                student.setAddress(request.getParameter("address"));
                studentDAO.addStudent(student);
            } else if ("delete".equals(action)) {
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                studentDAO.deleteStudent(studentId);
            }
        } catch (NumberFormatException e) {
            // Invalid input — skip action
        }

        response.sendRedirect(request.getContextPath() + "/admin/students");
    }
}
