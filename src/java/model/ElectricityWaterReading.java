package model;

import java.util.Date;

public class ElectricityWaterReading {
    private int reading_id;
    private int room_id;
    private String readingMonth;
    private int electricOld;
    private int electricNew;
    private int waterOld;
    private int waterNew;
    private Date readingDate;
    // Transient
    private String roomNumber;
    private String hostelName;

    public ElectricityWaterReading() {}

    public int getReading_id() { return reading_id; }
    public void setReading_id(int reading_id) { this.reading_id = reading_id; }

    public int getRoom_id() { return room_id; }
    public void setRoom_id(int room_id) { this.room_id = room_id; }

    public String getReadingMonth() { return readingMonth; }
    public void setReadingMonth(String readingMonth) { this.readingMonth = readingMonth; }

    public int getElectricOld() { return electricOld; }
    public void setElectricOld(int electricOld) { this.electricOld = electricOld; }

    public int getElectricNew() { return electricNew; }
    public void setElectricNew(int electricNew) { this.electricNew = electricNew; }

    public int getWaterOld() { return waterOld; }
    public void setWaterOld(int waterOld) { this.waterOld = waterOld; }

    public int getWaterNew() { return waterNew; }
    public void setWaterNew(int waterNew) { this.waterNew = waterNew; }

    public Date getReadingDate() { return readingDate; }
    public void setReadingDate(Date readingDate) { this.readingDate = readingDate; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getHostelName() { return hostelName; }
    public void setHostelName(String hostelName) { this.hostelName = hostelName; }

    public int getElectricUsage() { return electricNew - electricOld; }
    public int getWaterUsage() { return waterNew - waterOld; }
}
