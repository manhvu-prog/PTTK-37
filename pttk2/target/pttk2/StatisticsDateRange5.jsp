<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String startValue = request.getParameter("startDate");
  String endValue = request.getParameter("endDate");
  if (startValue == null) startValue = "";
  if (endValue == null) endValue = "";
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Chọn thời gian thống kê | RestMan</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a href="ManagerHome5.jsp">Quản lý</a><a href="#">Nhập hàng</a><a href="#">Quản lý thông tin</a><a class="active" href="StatisticsMenu5.jsp">Xem thống kê</a></nav></header>
<div class="report-subnav"><a class="report-link" href="SupplierImportStatistics5.jsp?startDate=<%=startValue%>&amp;endDate=<%=endValue%>">Thống kê nhà cung cấp theo hàng nhập</a></div>
<main class="wrap"><section class="card"><h1 class="title">Chọn thời gian thống kê</h1>
<form class="field-row" method="get" action="SupplierImportStatistics5.jsp"><div class="field"><label for="startDate">Ngày bắt đầu</label><input type="date" id="startDate" name="startDate" value="<%=startValue%>" required></div><div class="field"><label for="endDate">Ngày kết thúc</label><input type="date" id="endDate" name="endDate" value="<%=endValue%>" required></div><button class="btn" type="submit">Xem thống kê</button></form>
<div class="actions"><a class="btn secondary" href="StatisticsMenu5.jsp">Quay lại</a></div></section></main></body></html>
