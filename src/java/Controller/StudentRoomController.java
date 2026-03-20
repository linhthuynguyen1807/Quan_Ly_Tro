package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StudentRoomController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        StudentDAO studentDAO = new StudentDAO();
        RoomDAO roomDAO = new RoomDAO();
        ContractDAO contractDAO = new ContractDAO();
        NotificationDAO notiDAO = new NotificationDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();

        int studentId = studentDAO.getStudentIdByUserId(user.getUser_id());
        Student student = studentDAO.getStudentByUserId(user.getUser_id());
        Room room = roomDAO.getRoomByStudent(studentId);
        Contract contract = contractDAO.getActiveContractByStudent(studentId);

        // Pending bills for sidebar badge
        int pendingBills = invoiceDAO.countInvoicesByStudent(studentId, "unpaid");

        request.setAttribute("student", student);
        request.setAttribute("room", room);
        request.setAttribute("contract", contract);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.setAttribute("pendingBills", pendingBills);
        request.getRequestDispatcher("/student/room.jsp").forward(request, response);
    }
}
