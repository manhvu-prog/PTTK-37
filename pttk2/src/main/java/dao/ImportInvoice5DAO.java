package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ImportInvoice5DAO extends DAO {
    public List<ImportInvoice5> getImportInvoices(int supplierId, LocalDate startDate, LocalDate endDate) throws SQLException {
        List<ImportInvoice5> invoices = new ArrayList<>();
        String sql = "SELECT i.id, i.idSupplier5, i.trackingNumber, i.createdDate, s.name AS supplierName, " +
            "CONCAT_WS(' ', m.firstName, m.middleName, m.lastName) AS staffName, " +
            "SUM(d.quantity) AS importVolume, SUM(d.quantity*d.price) AS totalAmount " +
            "FROM tblImportInvoices5 i JOIN tblSuppliers5 s ON s.id=i.idSupplier5 " +
            "JOIN tblManagers5 mg ON mg.id=i.idManager5 JOIN tblStaffs5 st ON st.id=mg.idStaff5 " +
            "JOIN tblMembers5 m ON m.id=st.idMember5 JOIN tblImportInvoiceDetails5 d ON d.idImportInvoice5=i.id " +
            "WHERE i.idSupplier5=? AND i.createdDate>=? AND i.createdDate<DATE_ADD(?, INTERVAL 1 DAY) " +
            "GROUP BY i.id, i.idSupplier5, i.trackingNumber, i.createdDate, s.name, m.firstName, m.middleName, m.lastName ORDER BY i.createdDate DESC";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setDate(2, java.sql.Date.valueOf(startDate));
            ps.setDate(3, java.sql.Date.valueOf(endDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) invoices.add(readInvoice(rs));
            }
        }
        return invoices;
    }

    public ImportInvoice5 getImportInvoice(int invoiceId) throws SQLException {
        ImportInvoice5 invoice = null;
        String sql = "SELECT i.id, i.idSupplier5, i.trackingNumber, i.createdDate, s.name AS supplierName, " +
            "CONCAT_WS(' ', m.firstName, m.middleName, m.lastName) AS staffName, " +
            "SUM(d.quantity) AS importVolume, SUM(d.quantity*d.price) AS totalAmount " +
            "FROM tblImportInvoices5 i JOIN tblSuppliers5 s ON s.id=i.idSupplier5 " +
            "JOIN tblManagers5 mg ON mg.id=i.idManager5 JOIN tblStaffs5 st ON st.id=mg.idStaff5 " +
            "JOIN tblMembers5 m ON m.id=st.idMember5 JOIN tblImportInvoiceDetails5 d ON d.idImportInvoice5=i.id " +
            "WHERE i.id=? GROUP BY i.id, i.idSupplier5, i.trackingNumber, i.createdDate, s.name, m.firstName, m.middleName, m.lastName";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) invoice = readInvoice(rs); }
            if (invoice == null) return null;
            List<ImportInvoiceDetail5> details = new ArrayList<>();
            String detailSql = "SELECT p.id, p.name, d.quantity, d.price FROM tblImportInvoiceDetails5 d " +
                "JOIN tblProducts5 p ON p.id=d.idProduct5 WHERE d.idImportInvoice5=? ORDER BY d.id";
            try (PreparedStatement detailPs = c.prepareStatement(detailSql)) {
                detailPs.setInt(1, invoiceId);
                try (ResultSet rs = detailPs.executeQuery()) {
                    while (rs.next()) details.add(new ImportInvoiceDetail5(
                        String.format("SP%03d", rs.getInt("id")), rs.getString("name"), rs.getInt("quantity"), rs.getBigDecimal("price")));
                }
            }
            invoice.setDetails(details);
        }
        return invoice;
    }

    public String getSupplierName(int supplierId) throws SQLException {
        String sql = "SELECT name FROM tblSuppliers5 WHERE id=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("name") : "Nhà cung cấp";
            }
        }
    }

    private ImportInvoice5 readInvoice(ResultSet rs) throws SQLException {
        ImportInvoice5 invoice = new ImportInvoice5();
        invoice.setId(rs.getInt("id"));
        invoice.setSupplierId(rs.getInt("idSupplier5"));
        invoice.setInvoiceCode(rs.getString("trackingNumber"));
        invoice.setCreatedDate(rs.getTimestamp("createdDate"));
        invoice.setSupplierName(rs.getString("supplierName"));
        invoice.setStaffName(rs.getString("staffName"));
        invoice.setImportVolume(rs.getLong("importVolume"));
        invoice.setTotalAmount(rs.getBigDecimal("totalAmount"));
        return invoice;
    }
}
