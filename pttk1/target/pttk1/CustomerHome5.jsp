<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  if (session.getAttribute("customerId") == null) session.setAttribute("customerId", 1);
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>RestMan | Khách hàng</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a class="active" href="CustomerHome5.jsp">Khách hàng</a><a href="#">Đặt hàng</a><a href="#">Tra cứu</a><a href="SalesInvoiceList5.jsp">Theo dõi đơn hàng</a><a href="#">Đăng ký hội viên</a></nav></header>
<main class="wrap"><section class="card"><h1 class="title">Xin chào, khách hàng</h1><p class="muted">Theo dõi trạng thái đơn hàng và xem lại thông tin các hóa đơn của bạn.</p><div class="actions"><a class="btn" href="SalesInvoiceList5.jsp">Theo dõi đơn hàng</a><a class="btn secondary" href="#">Đặt hàng</a></div></section><section class="card"><h2 class="title" style="font-size:19px">Chức năng</h2><p class="muted">Chọn <strong>Theo dõi đơn hàng</strong> để xem danh sách hóa đơn, trạng thái giao hàng và chi tiết từng đơn.</p></section><div class="footer">Bản giao diện PTTK1 · Vai trò khách hàng</div></main></body></html>
