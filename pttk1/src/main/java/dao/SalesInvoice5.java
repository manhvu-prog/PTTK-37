package dao;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class SalesInvoice5 {
    private int id;
    private Timestamp createdDate;
    private BigDecimal totalAmount;
    private String status;
    private String customerName;
    private String salesStaffName;
    private String deliveryStaffName;
    private List<SalesInvoiceDetail5> details = new ArrayList<>();

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getSalesStaffName() { return salesStaffName; }
    public void setSalesStaffName(String salesStaffName) { this.salesStaffName = salesStaffName; }
    public String getDeliveryStaffName() { return deliveryStaffName; }
    public void setDeliveryStaffName(String deliveryStaffName) { this.deliveryStaffName = deliveryStaffName; }
    public List<SalesInvoiceDetail5> getDetails() { return details; }
    public void setDetails(List<SalesInvoiceDetail5> details) { this.details = details; }
}
