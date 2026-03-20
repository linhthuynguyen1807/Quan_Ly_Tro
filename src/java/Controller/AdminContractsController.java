package Controller;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

public class AdminContractsController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        ContractDAO contractDAO = new ContractDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        String hostelIdParam = request.getParameter("hostelId");
        int totalRecords = 0;
        List<Contract> contracts;

        if (hostelIdParam != null && !hostelIdParam.isEmpty()) {
            int hostelId = Integer.parseInt(hostelIdParam);
            totalRecords = contractDAO.countContractsByHostel(hostelId, status, search);
            contracts = contractDAO.getContractsByHostelPaginated(hostelId, status, search, offset, PAGE_SIZE);
            request.setAttribute("selectedHostelId", hostelId);
        } else if (!hostels.isEmpty()) {
            int hostelId = hostels.get(0).getHostel_id();
            totalRecords = contractDAO.countContractsByHostel(hostelId, status, search);
            contracts = contractDAO.getContractsByHostelPaginated(hostelId, status, search, offset, PAGE_SIZE);
            request.setAttribute("selectedHostelId", hostelId);
        } else {
            contracts = java.util.Collections.emptyList();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("hostels", hostels);
        request.setAttribute("contracts", contracts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("filterStatus", status);
        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.getRequestDispatcher("/admin/contracts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ContractDAO contractDAO = new ContractDAO();

        if ("add".equals(action)) {
            Contract contract = new Contract();
            contract.setStudent_id(Integer.parseInt(request.getParameter("studentId")));
            contract.setRoom_id(Integer.parseInt(request.getParameter("roomId")));
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                contract.setStart_date(sdf.parse(request.getParameter("startDate")));
                contract.setEnd_date(sdf.parse(request.getParameter("endDate")));
            } catch (ParseException e) {
                e.printStackTrace();
            }
            contract.setMonthly_rent(Double.parseDouble(request.getParameter("monthlyRent")));
            contract.setDeposit(Double.parseDouble(request.getParameter("deposit")));
            contract.setStatus("active");
            contractDAO.addContract(contract);
        } else if ("terminate".equals(action)) {
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            contractDAO.updateStatus(contractId, "terminated");
        }

        response.sendRedirect(request.getContextPath() + "/admin/contracts");
    }
}
