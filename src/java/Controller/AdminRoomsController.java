package Controller;

import dal.HostelDAO;
import dal.NotificationDAO;
import dal.RoomDAO;
import model.*;
import util.OwnershipUtil;
import util.ValidationUtil;
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
        User user = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");
        RoomDAO roomDAO = new RoomDAO();
        String hostelIdParam = request.getParameter("hostelId");

        int hostelId = ValidationUtil.parsePositiveInt(hostelIdParam);
        if (hostelId < 0) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms?error=invalid_input");
            return;
        }

        // Ownership verification: ensure hostel belongs to this landlord
        if (!OwnershipUtil.verifyHostelOwnership(hostelId, user.getUser_id())) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms?error=unauthorized");
            return;
        }

        try {
            if ("add".equals(action)) {
                String roomNumber = ValidationUtil.sanitize(request.getParameter("roomNumber"));
                double area = ValidationUtil.parsePositiveDouble(request.getParameter("area"));
                double price = ValidationUtil.parsePositiveDouble(request.getParameter("price"));
                int capacity = ValidationUtil.parsePositiveInt(request.getParameter("capacity"));
                String roomType = ValidationUtil.sanitize(request.getParameter("roomType"));
                String floorStr = request.getParameter("floorNumber");
                int floorNumber = (floorStr != null && !floorStr.isEmpty()) ? ValidationUtil.parsePositiveInt(floorStr) : 1;

                if (ValidationUtil.isNullOrEmpty(roomNumber) || area < 0 || price < 0 || capacity < 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId + "&error=invalid_input");
                    return;
                }

                Room room = new Room();
                room.setHostel_id(hostelId);
                room.setRoom_number(roomNumber);
                room.setArea((float) area);
                room.setPrice(price);
                room.setMax_capacity(capacity);
                room.setRoomType(roomType);
                room.setFloorNumber(floorNumber > 0 ? floorNumber : 1);
                room.setStatus("Trống");
                roomDAO.addRoom(room);
                response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId);

            } else if ("update".equals(action)) {
                int roomId = ValidationUtil.parsePositiveInt(request.getParameter("roomId"));
                String roomNumber = ValidationUtil.sanitize(request.getParameter("roomNumber"));
                double area = ValidationUtil.parsePositiveDouble(request.getParameter("area"));
                double price = ValidationUtil.parsePositiveDouble(request.getParameter("price"));
                int capacity = ValidationUtil.parsePositiveInt(request.getParameter("capacity"));
                String roomType = ValidationUtil.sanitize(request.getParameter("roomType"));
                String floorStr = request.getParameter("floorNumber");
                int floorNumber = (floorStr != null && !floorStr.isEmpty()) ? ValidationUtil.parsePositiveInt(floorStr) : 1;
                String status = ValidationUtil.sanitize(request.getParameter("status"));

                if (roomId < 0 || ValidationUtil.isNullOrEmpty(roomNumber) || area < 0 || price < 0 || capacity < 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId + "&error=invalid_input");
                    return;
                }

                Room room = new Room();
                room.setRoom_id(roomId);
                room.setRoom_number(roomNumber);
                room.setArea((float) area);
                room.setPrice(price);
                room.setMax_capacity(capacity);
                room.setRoomType(roomType);
                room.setFloorNumber(floorNumber > 0 ? floorNumber : 1);
                room.setStatus(status);
                roomDAO.updateRoom(room);
                response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId);

            } else if ("delete".equals(action)) {
                int roomId = ValidationUtil.parsePositiveInt(request.getParameter("roomId"));
                if (roomId < 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId + "&error=invalid_input");
                    return;
                }
                roomDAO.deleteRoom(roomId);
                response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId);
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms?hostelId=" + hostelId + "&error=invalid_input");
        }
    }
}
