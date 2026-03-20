package Controller;

import dal.UserDAO;
import dal.StudentDAO;
import dal.InvoiceDAO;
import model.User;
import util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StudentProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        UserDAO userDAO = new UserDAO();
        User profile = userDAO.getUserById(user.getUser_id());

        // Pending bills for sidebar badge
        StudentDAO studentDAO = new StudentDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());
        int pendingBills = invoiceDAO.countInvoicesByStudent(studentId, "unpaid");

        request.setAttribute("profile", profile);
        request.setAttribute("pendingBills", pendingBills);
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("updateProfile".equals(action)) {
            String fullName = ValidationUtil.sanitize(request.getParameter("fullName"));
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Validate email format if provided
            if (email != null && !email.trim().isEmpty() && !ValidationUtil.isValidEmail(email.trim())) {
                request.setAttribute("errorMsg", "Email không hợp lệ!");
                loadProfile(request, userDAO, user);
                request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
                return;
            }

            // Validate phone format if provided
            if (phone != null && !phone.trim().isEmpty() && !ValidationUtil.isValidPhone(phone.trim())) {
                request.setAttribute("errorMsg", "Số điện thoại không hợp lệ!");
                loadProfile(request, userDAO, user);
                request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
                return;
            }

            User updated = new User();
            updated.setUser_id(user.getUser_id());
            updated.setFullName(fullName);
            updated.setEmail(email != null ? email.trim() : null);
            updated.setPhone(phone != null ? phone.trim() : null);
            userDAO.updateProfile(updated);

            User refreshed = userDAO.getUserById(user.getUser_id());
            request.getSession().setAttribute("user", refreshed);
            request.setAttribute("successMsg", "Cập nhật thông tin thành công!");

        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (ValidationUtil.isNullOrEmpty(oldPassword) || ValidationUtil.isNullOrEmpty(newPassword)) {
                request.setAttribute("errorMsg", "Vui lòng nhập đầy đủ thông tin!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
            } else if (newPassword.length() < 6) {
                request.setAttribute("errorMsg", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            } else {
                boolean changed = userDAO.changePassword(user.getUser_id(), oldPassword, newPassword);
                if (changed) {
                    request.setAttribute("successMsg", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("errorMsg", "Mật khẩu cũ không đúng!");
                }
            }
        }

        loadProfile(request, userDAO, user);
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }

    private void loadProfile(HttpServletRequest request, UserDAO userDAO, User user) {
        StudentDAO studentDAO = new StudentDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());
        int pendingBills = invoiceDAO.countInvoicesByStudent(studentId, "unpaid");

        User profile = userDAO.getUserById(user.getUser_id());
        request.setAttribute("profile", profile);
        request.setAttribute("pendingBills", pendingBills);
    }
}
