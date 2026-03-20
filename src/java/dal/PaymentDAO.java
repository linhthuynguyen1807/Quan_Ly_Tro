package dal;

import model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO extends DBContext {

    public List<Payment> getPaymentsByInvoiceId(int invoiceId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM PAYMENT WHERE invoice_id = ? ORDER BY payment_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPayment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO PAYMENT (invoice_id, amount, payment_method, transaction_ref) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, payment.getInvoice_id());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getTransactionRef());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPayment_id(rs.getInt("payment_id"));
        p.setInvoice_id(rs.getInt("invoice_id"));
        p.setAmount(rs.getDouble("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setTransactionRef(rs.getString("transaction_ref"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        return p;
    }
}
