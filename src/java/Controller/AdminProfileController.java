package Controller;

import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
public class AdminProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        UserDAO userDAO = new UserDAO();
        User profile = userDAO.getUserById(user.getUser_id());
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            User updated = new User();
            updated.setUser_id(user.getUser_id());
            updated.setFullName(fullName);
            updated.setEmail(email);
            updated.setPhone(phone);
            userDAO.updateProfile(updated);

            // Refresh session
            User refreshed = userDAO.getUserById(user.getUser_id());
            request.getSession().setAttribute("user", refreshed);
            request.setAttribute("successMsg", "Cập nhật thông tin thành công!");

        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
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

        User profile = userDAO.getUserById(user.getUser_id());
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }
}
