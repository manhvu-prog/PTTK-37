package dao;

import java.math.BigDecimal;

public class ImportInvoiceDetail5 {
    private String productCode;
    private String productName;
    private int quantity;
    private BigDecimal price;

    public ImportInvoiceDetail5(String productCode, String productName, int quantity, BigDecimal price) {
        this.productCode = productCode;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
    }
    public String getProductCode() { return productCode; }
    public String getProductName() { return productName; }
    public int getQuantity() { return quantity; }
    public BigDecimal getPrice() { return price; }
    public BigDecimal getLineTotal() { return price.multiply(BigDecimal.valueOf(quantity)); }
}
