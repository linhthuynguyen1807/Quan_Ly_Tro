package Controller;

import dal.UserDAO;
import dal.StudentDAO;
import model.Student;
import util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String fullName = ValidationUtil.sanitize(request.getParameter("fullName"));
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Basic required field validation
        if (ValidationUtil.isNullOrEmpty(username) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate email format if provided
        if (email != null && !email.trim().isEmpty() && !ValidationUtil.isValidEmail(email.trim())) {
            request.setAttribute("error", "Email không hợp lệ!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate phone format if provided
        if (phone != null && !phone.trim().isEmpty() && !ValidationUtil.isValidPhone(phone.trim())) {
            request.setAttribute("error", "Số điện thoại không hợp lệ!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Whitelist role values
        if (role == null || role.trim().isEmpty()) {
            role = "student";
        }
        if (!ValidationUtil.isAllowedValue(role.trim(), "student", "landlord")) {
            request.setAttribute("error", "Vai trò không hợp lệ!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        if (userDAO.isUsernameExists(username.trim())) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        String trimmedFullName = fullName != null ? fullName.trim() : username.trim();
        String trimmedEmail = email != null ? email.trim() : null;
        String trimmedPhone = phone != null ? phone.trim() : null;

        // Password is hashed inside UserDAO.registerAndGetId via PasswordUtil
        int newUserId = userDAO.registerAndGetId(
            username.trim(), password.trim(), role.trim(),
            trimmedFullName, trimmedEmail, trimmedPhone
        );

        if (newUserId > 0) {
            // If role is student, also create the STUDENT profile record
            if ("student".equalsIgnoreCase(role.trim())) {
                StudentDAO studentDAO = new StudentDAO();
                Student student = new Student();
                student.setUser_id(newUserId);
                student.setFull_name(trimmedFullName);
                student.setPhone(trimmedPhone);
                studentDAO.addStudent(student);
            }

            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
