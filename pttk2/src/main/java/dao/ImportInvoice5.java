package dao;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ImportInvoice5 {
    private int id;
    private int supplierId;
    private String invoiceCode;
    private Timestamp createdDate;
    private String supplierName;
    private String staffName;
    private long importVolume;
    private BigDecimal totalAmount;
    private List<ImportInvoiceDetail5> details = new ArrayList<>();

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    public String getInvoiceCode() { return invoiceCode; }
    public void setInvoiceCode(String invoiceCode) { this.invoiceCode = invoiceCode; }
    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public long getImportVolume() { return importVolume; }
    public void setImportVolume(long importVolume) { this.importVolume = importVolume; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public List<ImportInvoiceDetail5> getDetails() { return details; }
    public void setDetails(List<ImportInvoiceDetail5> details) { this.details = details; }
}
