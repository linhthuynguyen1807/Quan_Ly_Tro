package Controller;

import dal.HostelDAO;
import dal.NotificationDAO;
import dal.RoomDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminRoomsController extends HttpServlet {

    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        HostelDAO hostelDAO = new HostelDAO();
        RoomDAO roomDAO = new RoomDAO();
        NotificationDAO notiDAO = new NotificationDAO();

        List<Hostel> hostels = hostelDAO.getHostelsByLandlord(user.getUser_id());
        request.setAttribute("hostels", hostels);

        String hostelIdStr = request.getParameter("hostelId");
        if (hostelIdStr != null && !hostelIdStr.isEmpty()) {
            int hostelId;
            try {
                hostelId = Integer.parseInt(hostelIdStr);
            } catch (NumberFormatException e) {
                request.getRequestDispatcher("/admin/rooms.jsp").forward(request, response);
                return;
            }

            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String floorStr = request.getParameter("floor");
            Integer floor = null;
            if (floorStr != null && !floorStr.isEmpty()) {
                try { floor = Integer.parseInt(floorStr); } catch (NumberFormatException ignored) {}
            }

            int page = 1;
            try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            if (page < 1) page = 1;
            int offset = (page - 1) * PAGE_SIZE;

            int totalRecords = roomDAO.countRoomsByHostel(hostelId, status, search, floor);
            List<Room> rooms = roomDAO.getRoomsByHostelPaginated(hostelId, status, search, floor, offset, PAGE_SIZE);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

            // Get distinct floors for filter dropdown
            List<Integer> floors = roomDAO.getDistinctFloors(hostelId);

            request.setAttribute("rooms", rooms);
            request.setAttribute("hostelId", hostelId);
            request.setAttribute("selectedHostelId", hostelId);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("search", search);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("selectedFloor", floor);
            request.setAttribute("floors", floors);

            // Room status counts for stat badges
            int[] statusCounts = roomDAO.getRoomStatusCounts(hostelId);
            request.setAttribute("availableRooms", statusCounts[0]);
            request.setAttribute("fullRooms", statusCounts[1]);
            request.setAttribute("partialRooms", statusCounts[2]);
        }

        request.setAttribute("unreadCount", notiDAO.countUnreadByUserId(user.getUser_id()));
        request.getRequestDispatcher("/admin/rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        RoomDAO roomDAO = new RoomDAO();
        String hostelIdParam = request.getParameter("hostelId");

        try {
            if ("add".equals(action)) {
                Room room = new Room();
                room.setHostel_id(Integer.parseInt(hostelIdParam));
                room.setRoom_number(request.getParameter("roomNumber"));
                room.setArea(Float.parseFloat(request.getParameter("area")));
                room.setPrice(Double.parseDouble(request.getParameter("price")));
                room.setMax_capacity(Integer.parseInt(request.getParameter("capacity")));
                room.setRoomType(request.getParameter("roomType"));
                String floorStr = request.getParameter("floorNumber");
                room.setFloorNumber(floorStr != null && !floorStr.isEmpty() ? Integer.parseInt(floorStr) : 1);
                room.setStatus("Trống");
                roomDAO.addRoom(room);
                response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + room.getHostel_id());
            } else if ("update".equals(action)) {
                Room room = new Room();
                room.setRoom_id(Integer.parseInt(request.getParameter("roomId")));
                room.setRoom_number(request.getParameter("roomNumber"));
                room.setArea(Float.parseFloat(request.getParameter("area")));
                room.setPrice(Double.parseDouble(request.getParameter("price")));
                room.setMax_capacity(Integer.parseInt(request.getParameter("capacity")));
                room.setRoomType(request.getParameter("roomType"));
                String floorStr = request.getParameter("floorNumber");
                room.setFloorNumber(floorStr != null && !floorStr.isEmpty() ? Integer.parseInt(floorStr) : 1);
                room.setStatus(request.getParameter("status"));
                roomDAO.updateRoom(room);
                response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelIdParam);
            } else if ("delete".equals(action)) {
                roomDAO.deleteRoom(Integer.parseInt(request.getParameter("roomId")));
                response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelIdParam);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelIdParam + "&error=invalid_input");
        }
    }
}
