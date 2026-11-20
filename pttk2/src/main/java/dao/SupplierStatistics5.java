package dao;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SupplierStatistics5 {
    private int supplierId;
    private String supplierCode;
    private String name;
    private Timestamp lastImportDate;
    private long importVolume;
    private BigDecimal totalAmount;
    private int invoiceCount;

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    public String getSupplierCode() { return supplierCode; }
    public void setSupplierCode(String supplierCode) { this.supplierCode = supplierCode; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Timestamp getLastImportDate() { return lastImportDate; }
    public void setLastImportDate(Timestamp lastImportDate) { this.lastImportDate = lastImportDate; }
    public long getImportVolume() { return importVolume; }
    public void setImportVolume(long importVolume) { this.importVolume = importVolume; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public int getInvoiceCount() { return invoiceCount; }
    public void setInvoiceCount(int invoiceCount) { this.invoiceCount = invoiceCount; }
}
