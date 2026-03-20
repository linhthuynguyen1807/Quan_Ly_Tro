package model;

import java.util.Date;

public class Invoice {
    private int invoice_id;
    private int contract_id;
    private String invoiceMonth;
    private double roomFee;
    private double electricFee;
    private double waterFee;
    private double serviceFee;
    private double totalAmount;
    private String status;
    private Date dueDate;
    private Date createdAt;
    // Transient
    private String studentName;
    private String roomNumber;
    private String hostelName;

    public Invoice() {}

    public int getInvoice_id() { return invoice_id; }
    public void setInvoice_id(int invoice_id) { this.invoice_id = invoice_id; }

    public int getContract_id() { return contract_id; }
    public void setContract_id(int contract_id) { this.contract_id = contract_id; }

    public String getInvoiceMonth() { return invoiceMonth; }
    public void setInvoiceMonth(String invoiceMonth) { this.invoiceMonth = invoiceMonth; }

    public double getRoomFee() { return roomFee; }
    public void setRoomFee(double roomFee) { this.roomFee = roomFee; }

    public double getElectricFee() { return electricFee; }
    public void setElectricFee(double electricFee) { this.electricFee = electricFee; }

    public double getWaterFee() { return waterFee; }
    public void setWaterFee(double waterFee) { this.waterFee = waterFee; }

    public double getServiceFee() { return serviceFee; }
    public void setServiceFee(double serviceFee) { this.serviceFee = serviceFee; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getHostelName() { return hostelName; }
    public void setHostelName(String hostelName) { this.hostelName = hostelName; }
}
