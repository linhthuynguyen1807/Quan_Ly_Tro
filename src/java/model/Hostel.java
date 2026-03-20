package model;

import java.util.Date;

public class Hostel {
    private int hostel_id;
    private int landlord_id;
    private String hostel_name;
    private String address;
    private String description;
    private Date created_at;
    // Transient stats
    private int totalRooms;
    private int occupiedRooms;
    private int totalStudents;

    public Hostel() {}

    public Hostel(int hostel_id, String hostel_name, String address) {
        this.hostel_id = hostel_id;
        this.hostel_name = hostel_name;
        this.address = address;
    }

    public int getHostel_id() { return hostel_id; }
    public void setHostel_id(int hostel_id) { this.hostel_id = hostel_id; }

    public int getLandlord_id() { return landlord_id; }
    public void setLandlord_id(int landlord_id) { this.landlord_id = landlord_id; }

    public String getHostel_name() { return hostel_name; }
    public void setHostel_name(String hostel_name) { this.hostel_name = hostel_name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getCreated_at() { return created_at; }
    public void setCreated_at(Date created_at) { this.created_at = created_at; }

    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int totalRooms) { this.totalRooms = totalRooms; }

    public int getOccupiedRooms() { return occupiedRooms; }
    public void setOccupiedRooms(int occupiedRooms) { this.occupiedRooms = occupiedRooms; }

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }
}
