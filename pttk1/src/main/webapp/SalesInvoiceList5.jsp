<%@ page import="dao.SalesInvoice5,dao.SalesInvoice5DAO,java.util.List,java.text.NumberFormat,java.text.SimpleDateFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  if (session.getAttribute("customerId") == null) session.setAttribute("customerId", 1);
  int customerId = ((Number)session.getAttribute("customerId")).intValue();
  List<SalesInvoice5> invoices = null; String loadError = null;
  try { invoices = new SalesInvoice5DAO().getSalesInvoice(customerId); } catch (Exception ex) { loadError = "Không kết nối được cơ sở dữ liệu. Hãy chạy tệp SQL và kiểm tra cấu hình DB_URL, DB_USER, DB_PASSWORD."; }
  NumberFormat money = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
  SimpleDateFormat date = new SimpleDateFormat("dd/MM/yyyy");
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Hóa đơn của tôi | RestMan</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a href="CustomerHome5.jsp">Khách hàng</a><a href="#">Đặt hàng</a><a href="#">Tra cứu</a><a class="active" href="SalesInvoiceList5.jsp">Theo dõi đơn hàng</a><a href="#">Đăng ký hội viên</a></nav></header>
<main class="wrap"><section class="card"><h1 class="title">Hóa đơn của tôi</h1><p class="muted">Danh sách đơn hàng và trạng thái cập nhật gần nhất.</p>
<% if (loadError != null) { %><div class="notice"><%=loadError%></div><% } else if (invoices.isEmpty()) { %><div class="notice">Bạn chưa có hóa đơn nào.</div><% } else { %>
<div class="table-wrap"><table><thead><tr><th>Ngày đặt</th><th>Trạng thái</th><th>Tổng tiền (VNĐ)</th><th>Thao tác</th></tr></thead><tbody>
<% for (SalesInvoice5 invoice : invoices) { %><tr><td><%=date.format(invoice.getCreatedDate())%></td><td><span class="badge"><%=invoice.getStatus()%></span></td><td><%=money.format(invoice.getTotalAmount())%></td><td><a class="btn secondary" href="SalesInvoiceDetails5.jsp?id=<%=invoice.getId()%>">Xem chi tiết</a></td></tr><% } %>
</tbody></table></div><% } %>
<div class="actions"><a class="btn secondary" href="CustomerHome5.jsp">Quay lại</a></div></section><div class="footer">PTTK1 · Tra cứu và theo dõi hóa đơn khách hàng</div></main></body></html>
