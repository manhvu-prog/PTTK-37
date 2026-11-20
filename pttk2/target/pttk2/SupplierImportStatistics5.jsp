<%@ page import="dao.SupplierStatistics5,dao.SupplierStatistics5DAO,java.util.List,java.time.LocalDate,java.time.format.DateTimeParseException,java.text.NumberFormat,java.text.SimpleDateFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String startValue = request.getParameter("startDate");
  String endValue = request.getParameter("endDate");
  if (startValue == null || startValue.isEmpty() || endValue == null || endValue.isEmpty()) {
    response.sendRedirect("StatisticsDateRange5.jsp");
    return;
  }
  LocalDate startDate = null, endDate = null;
  String error = null;
  List<SupplierStatistics5> statistics = null;
  try {
    startDate = LocalDate.parse(startValue);
    endDate = LocalDate.parse(endValue);
    if (startDate.isAfter(endDate)) error = "Ngày bắt đầu phải trước hoặc bằng ngày kết thúc.";
    else statistics = new SupplierStatistics5DAO().getSupplierStatistics(startDate, endDate);
  } catch (DateTimeParseException ex) {
    error = "Hãy nhập khoảng ngày hợp lệ.";
  } catch (Exception ex) {
    error = "Không kết nối được cơ sở dữ liệu. Hãy kiểm tra cấu hình DB_URL, DB_USER, DB_PASSWORD.";
  }
  NumberFormat money = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
  SimpleDateFormat date = new SimpleDateFormat("dd/MM/yyyy");
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Thống kê nhà cung cấp | RestMan</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a href="ManagerHome5.jsp">Quản lý</a><a href="#">Nhập hàng</a><a href="#">Quản lý thông tin</a><a class="active" href="StatisticsMenu5.jsp">Xem thống kê</a></nav></header>
<div class="report-subnav"><a class="report-link" href="StatisticsMenu5.jsp">Thống kê nhà cung cấp theo hàng nhập</a></div>
<main class="wrap"><section class="card"><div class="report-heading"><h1 class="title">Thống kê nhà cung cấp theo hàng nhập</h1><a class="btn secondary" href="StatisticsDateRange5.jsp?startDate=<%=startValue%>&amp;endDate=<%=endValue%>">Đổi thời gian</a></div>
<div class="date-summary"><div><span>Ngày bắt đầu</span><strong><%=startValue%></strong></div><div><span>Ngày kết thúc</span><strong><%=endValue%></strong></div></div>
<% if (error != null) { %><div class="notice"><%=error%></div><% } else if (statistics.isEmpty()) { %><div class="notice">Không có dữ liệu nhập hàng trong khoảng thời gian này.</div><% } else { %>
<div class="table-wrap"><table><thead><tr><th>ID nhà cung cấp</th><th>Nhà cung cấp</th><th>Thời gian</th><th>Hàng nhập</th><th>Tổng tiền (VNĐ)</th><th>Thao tác</th></tr></thead><tbody>
<% for (SupplierStatistics5 item : statistics) { String historyUrl="ImportInvoiceList5.jsp?supplierId="+item.getSupplierId()+"&amp;startDate="+startValue+"&amp;endDate="+endValue; %><tr><td><%=item.getSupplierCode()%></td><td><%=item.getName()%></td><td><%=item.getLastImportDate()==null?"—":date.format(item.getLastImportDate())%></td><td><%=money.format(item.getImportVolume())%></td><td><%=money.format(item.getTotalAmount())%></td><td><a class="btn secondary" href="<%=historyUrl%>">Xem chi tiết</a></td></tr><% } %>
</tbody></table></div><% } %>
<div class="actions"><a class="btn secondary" href="StatisticsDateRange5.jsp?startDate=<%=startValue%>&amp;endDate=<%=endValue%>">Quay lại</a></div></section></main></body></html>
