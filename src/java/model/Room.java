package model;

import java.util.Date;

public class Room {
    private int room_id;
    private int hostel_id;
    private String room_number;
    private float area;
    private double price;
    private int max_capacity;
    private String status;
    private String roomType;
    private int floorNumber;
    private Date createdAt;
    private String hostelName;
    private int currentOccupants;

    public Room() {}

    public Room(int room_id, String room_number, double price, String roomType, String status) {
        this.room_id = room_id;
        this.room_number = room_number;
        this.price = price;
        this.roomType = roomType;
        this.status = status;
    }

    public int getRoom_id() { return room_id; }
    public void setRoom_id(int room_id) { this.room_id = room_id; }

    public int getHostel_id() { return hostel_id; }
    public void setHostel_id(int hostel_id) { this.hostel_id = hostel_id; }

    public String getRoom_number() { return room_number; }
    public void setRoom_number(String room_number) { this.room_number = room_number; }

    public float getArea() { return area; }
    public void setArea(float area) { this.area = area; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getMax_capacity() { return max_capacity; }
    public void setMax_capacity(int max_capacity) { this.max_capacity = max_capacity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public int getFloorNumber() { return floorNumber; }
    public void setFloorNumber(int floorNumber) { this.floorNumber = floorNumber; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getHostelName() { return hostelName; }
    public void setHostelName(String hostelName) { this.hostelName = hostelName; }

    public int getCurrentOccupants() { return currentOccupants; }
    public void setCurrentOccupants(int currentOccupants) { this.currentOccupants = currentOccupants; }

    public String getLoaiPhong() { return roomType; }
    public void setLoaiPhong(String loaiPhong) { this.roomType = loaiPhong; }
}
