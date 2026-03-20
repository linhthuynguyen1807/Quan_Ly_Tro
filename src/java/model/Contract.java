package model;

import java.util.Date;

public class Contract {
    private int contract_id;
    private int student_id;
    private int room_id;
    private Date start_date;
    private Date end_date;
    private double monthly_rent;
    private double deposit;
    private String status;
    private Date createdAt;
    private String studentName;
    private String roomNumber;
    private String hostelName;

    public Contract() {}

    public int getContract_id() { return contract_id; }
    public void setContract_id(int contract_id) { this.contract_id = contract_id; }

    public int getStudent_id() { return student_id; }
    public void setStudent_id(int student_id) { this.student_id = student_id; }

    public int getRoom_id() { return room_id; }
    public void setRoom_id(int room_id) { this.room_id = room_id; }

    public Date getStart_date() { return start_date; }
    public void setStart_date(Date start_date) { this.start_date = start_date; }

    public Date getEnd_date() { return end_date; }
    public void setEnd_date(Date end_date) { this.end_date = end_date; }

    public double getMonthly_rent() { return monthly_rent; }
    public void setMonthly_rent(double monthly_rent) { this.monthly_rent = monthly_rent; }

    public double getDeposit() { return deposit; }
    public void setDeposit(double deposit) { this.deposit = deposit; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getHostelName() { return hostelName; }
    public void setHostelName(String hostelName) { this.hostelName = hostelName; }
}
