<%@ page import="dao.SalesInvoice5,dao.SalesInvoice5DAO,dao.SalesInvoiceDetail5,java.text.NumberFormat,java.text.SimpleDateFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  if (session.getAttribute("customerId") == null) session.setAttribute("customerId", 1);
  int customerId = ((Number)session.getAttribute("customerId")).intValue();
  int id = 0; try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) { }
  SalesInvoice5 invoice = null; String loadError = null;
  try { if (id > 0) invoice = new SalesInvoice5DAO().getSalesInvoiceDetail(id, customerId); } catch (Exception ex) { loadError = "Không kết nối được cơ sở dữ liệu. Hãy kiểm tra cấu hình kết nối."; }
  NumberFormat money = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
  SimpleDateFormat date = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Chi tiết hóa đơn | RestMan</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a href="CustomerHome5.jsp">Khách hàng</a><a href="#">Đặt hàng</a><a href="#">Tra cứu</a><a class="active" href="SalesInvoiceList5.jsp">Theo dõi đơn hàng</a><a href="#">Đăng ký hội viên</a></nav></header>
<main class="wrap"><section class="card"><h1 class="title">Chi tiết hóa đơn</h1>
<% if (loadError != null) { %><div class="notice"><%=loadError%></div><% } else if (invoice == null) { %><div class="notice">Không tìm thấy hóa đơn hoặc hóa đơn không thuộc tài khoản hiện tại.</div><% } else { %>
<div class="meta"><div><span>Mã hóa đơn</span><strong>HD<%=String.format("%03d",invoice.getId())%></strong></div><div><span>Ngày đặt</span><strong><%=date.format(invoice.getCreatedDate())%></strong></div><div><span>Trạng thái</span><strong><span class="badge"><%=invoice.getStatus()%></span></strong></div></div>
<div class="meta"><div><span>Khách hàng</span><strong><%=invoice.getCustomerName()%></strong></div><div><span>Nhân viên bán hàng</span><strong><%=invoice.getSalesStaffName() == null ? "Chưa phân công" : invoice.getSalesStaffName()%></strong></div><div><span>Nhân viên giao hàng</span><strong><%=invoice.getDeliveryStaffName() == null ? "Chưa phân công" : invoice.getDeliveryStaffName()%></strong></div></div>
<div class="table-wrap"><table><thead><tr><th>TT</th><th>Mã hàng</th><th>Tên sản phẩm</th><th>Số lượng</th><th>Đơn giá (VNĐ)</th><th>Thành tiền (VNĐ)</th></tr></thead><tbody>
<% int row = 1; for (SalesInvoiceDetail5 detail : invoice.getDetails()) { %><tr><td><%=row++%></td><td><%=detail.getProductCode()%></td><td><%=detail.getProductName()%></td><td><%=detail.getQuantity()%></td><td><%=money.format(detail.getPrice())%></td><td><%=money.format(detail.getLineTotal())%></td></tr><% } %>
</tbody><tfoot><tr><td colspan="5" class="right total">Tổng cộng</td><td class="total"><%=money.format(invoice.getTotalAmount())%></td></tr></tfoot></table></div><% } %>
<div class="actions"><a class="btn secondary" href="SalesInvoiceList5.jsp">Đóng</a></div></section></main></body></html>
