package Controller;

import dal.*;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ViewHostelDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String hostelIdStr = request.getParameter("id");
        if (hostelIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        int hostelId = Integer.parseInt(hostelIdStr);
        HostelDAO hostelDAO = new HostelDAO();
        Hostel hostel = hostelDAO.getHostelById(hostelId);

        if (hostel == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        RoomDAO roomDAO = new RoomDAO();
        StudentDAO studentDAO = new StudentDAO();
        ContractDAO contractDAO = new ContractDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        RequestDAO requestDAO = new RequestDAO();
        ReadingDAO readingDAO = new ReadingDAO();

        List<Room> rooms = roomDAO.getRoomsByHostel(hostelId);
        List<Student> students = studentDAO.getStudentsByHostel(hostelId);
        List<Contract> contracts = contractDAO.getContractsByHostel(hostelId);
        List<Invoice> invoices = invoiceDAO.getInvoicesByHostel(hostelId);
        List<Request> requests = requestDAO.getRequestsByHostelId(hostelId);
        List<ElectricityWaterReading> readings = readingDAO.getReadingsByHostelId(hostelId);

        request.setAttribute("hostel", hostel);
        request.setAttribute("rooms", rooms);
        request.setAttribute("students", students);
        request.setAttribute("contracts", contracts);
        request.setAttribute("invoices", invoices);
        request.setAttribute("requests", requests);
        request.setAttribute("readings", readings);

        request.getRequestDispatcher("/admin/hostel-detail.jsp").forward(request, response);
    }
}
