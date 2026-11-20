package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SalesInvoice5DAO extends DAO {
    private static final String INVOICE_SELECT =
        "SELECT i.id, i.createdDate, i.totalAmount, i.status, " +
        "CONCAT_WS(' ', cm.firstName, cm.middleName, cm.lastName) customerName, " +
        "CONCAT_WS(' ', sm.firstName, sm.middleName, sm.lastName) salesStaffName, " +
        "ds.name deliveryStaffName " +
        "FROM tblSalesInvoices5 i " +
        "JOIN tblCustomers5 c ON c.id = i.idCustomer5 " +
        "JOIN tblMembers5 cm ON cm.id = c.idMember5 " +
        "LEFT JOIN tblSalesStaff5 ss ON ss.id = i.idSalesStaff5 " +
        "LEFT JOIN tblStaffs5 s ON s.id = ss.idStaff5 " +
        "LEFT JOIN tblMembers5 sm ON sm.id = s.idMember5 " +
        "LEFT JOIN tblDeliveryStaffs5 ds ON ds.idSalesInvoice5 = i.id ";

    public List<SalesInvoice5> getSalesInvoice(int customerId) throws SQLException {
        List<SalesInvoice5> invoices = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(INVOICE_SELECT + " WHERE i.idCustomer5 = ? ORDER BY i.createdDate DESC")) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) invoices.add(readInvoice(rs));
            }
        }
        return invoices;
    }

    public SalesInvoice5 getSalesInvoiceDetail(int invoiceId, int customerId) throws SQLException {
        SalesInvoice5 invoice = null;
        String sql = INVOICE_SELECT + " WHERE i.id = ? AND i.idCustomer5 = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) invoice = readInvoice(rs);
            }
            if (invoice == null) return null;
            String detailSql = "SELECT p.id AS productId, p.name, d.quantity, d.price FROM tblSalesInvoiceDetails5 d " +
                "JOIN tblProducts5 p ON p.id = d.idProduct5 WHERE d.idSalesInvoice5 = ? ORDER BY d.id";
            List<SalesInvoiceDetail5> details = new ArrayList<>();
            try (PreparedStatement detailPs = c.prepareStatement(detailSql)) {
                detailPs.setInt(1, invoiceId);
                try (ResultSet rs = detailPs.executeQuery()) {
                    while (rs.next()) details.add(new SalesInvoiceDetail5(
                        String.format("SP%03d", rs.getInt("productId")), rs.getString("name"), rs.getInt("quantity"), rs.getBigDecimal("price")));
                }
            }
            invoice.setDetails(details);
        }
        return invoice;
    }

    private SalesInvoice5 readInvoice(ResultSet rs) throws SQLException {
        SalesInvoice5 invoice = new SalesInvoice5();
        invoice.setId(rs.getInt("id"));
        invoice.setCreatedDate(rs.getTimestamp("createdDate"));
        invoice.setTotalAmount(rs.getBigDecimal("totalAmount"));
        invoice.setStatus(rs.getString("status"));
        invoice.setCustomerName(rs.getString("customerName"));
        invoice.setSalesStaffName(rs.getString("salesStaffName"));
        invoice.setDeliveryStaffName(rs.getString("deliveryStaffName"));
        return invoice;
    }
}
