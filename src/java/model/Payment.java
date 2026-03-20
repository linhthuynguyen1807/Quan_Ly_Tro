package model;

import java.util.Date;

public class Payment {
    private int payment_id;
    private int invoice_id;
    private double amount;
    private String paymentMethod;
    private String transactionRef;
    private Date paymentDate;
    // Transient
    private String studentName;
    private String invoiceMonth;

    public Payment() {}

    public int getPayment_id() { return payment_id; }
    public void setPayment_id(int payment_id) { this.payment_id = payment_id; }

    public int getInvoice_id() { return invoice_id; }
    public void setInvoice_id(int invoice_id) { this.invoice_id = invoice_id; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getInvoiceMonth() { return invoiceMonth; }
    public void setInvoiceMonth(String invoiceMonth) { this.invoiceMonth = invoiceMonth; }
}
