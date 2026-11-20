package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SupplierStatistics5DAO extends DAO {
    public List<SupplierStatistics5> getSupplierStatistics(LocalDate startDate, LocalDate endDate) throws SQLException {
        List<SupplierStatistics5> result = new ArrayList<>();
        String sql = "SELECT s.id, s.name, MAX(i.createdDate) AS lastImportDate, " +
            "COALESCE(SUM(d.quantity), 0) AS importVolume, COALESCE(SUM(d.quantity * d.price), 0) AS totalAmount, COUNT(DISTINCT i.id) AS invoiceCount " +
            "FROM tblSuppliers5 s LEFT JOIN tblImportInvoices5 i ON i.idSupplier5=s.id " +
            "AND i.createdDate >= ? AND i.createdDate < DATE_ADD(?, INTERVAL 1 DAY) " +
            "LEFT JOIN tblImportInvoiceDetails5 d ON d.idImportInvoice5=i.id " +
            "GROUP BY s.id, s.name ORDER BY importVolume DESC, s.name";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupplierStatistics5 item = new SupplierStatistics5();
                    item.setSupplierId(rs.getInt("id"));
                    item.setSupplierCode(String.format("NCC%03d", rs.getInt("id")));
                    item.setName(rs.getString("name"));
                    item.setLastImportDate(rs.getTimestamp("lastImportDate"));
                    item.setImportVolume(rs.getLong("importVolume"));
                    item.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    item.setInvoiceCount(rs.getInt("invoiceCount"));
                    result.add(item);
                }
            }
        }
        return result;
    }
}
