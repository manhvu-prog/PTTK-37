<%@ page import="dao.ImportInvoice5,dao.ImportInvoice5DAO,java.util.List,java.time.LocalDate,java.time.format.DateTimeParseException,java.text.NumberFormat,java.text.SimpleDateFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  int supplierId=0; try { supplierId=Integer.parseInt(request.getParameter("supplierId")); } catch (Exception ignored) { }
  String startValue=request.getParameter("startDate"), endValue=request.getParameter("endDate");
  if(startValue==null||startValue.isEmpty())startValue=LocalDate.now().withDayOfYear(1).toString();
  if(endValue==null||endValue.isEmpty())endValue=LocalDate.now().toString();
  List<ImportInvoice5> invoices=null; String error=null; String supplierName="Nhà cung cấp";
  try { if(supplierId<1)throw new IllegalArgumentException(); LocalDate start=LocalDate.parse(startValue),end=LocalDate.parse(endValue); if(start.isAfter(end))throw new DateTimeParseException("invalid range",startValue,0); ImportInvoice5DAO dao=new ImportInvoice5DAO(); supplierName=dao.getSupplierName(supplierId); invoices=dao.getImportInvoices(supplierId,start,end); }
  catch(DateTimeParseException ex){error="Khoảng ngày không hợp lệ.";} catch(IllegalArgumentException ex){error="Thiếu mã nhà cung cấp.";} catch(Exception ex){error="Không đọc được dữ liệu. Hãy kiểm tra kết nối cơ sở dữ liệu.";}
  NumberFormat money=NumberFormat.getNumberInstance(new Locale("vi","VN")); SimpleDateFormat date=new SimpleDateFormat("dd/MM/yyyy");
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lịch sử nhập hàng | RestMan</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a href="ManagerHome5.jsp">Quản lý</a><a href="#">Nhập hàng</a><a href="#">Quản lý thông tin</a><a class="active" href="StatisticsMenu5.jsp">Xem thống kê</a></nav></header>
<div class="report-subnav"><a class="report-link" href="StatisticsMenu5.jsp">Thống kê nhà cung cấp theo hàng nhập</a></div>
<main class="wrap"><section class="card"><div class="report-heading"><h1 class="title">Lịch sử nhập hàng</h1><strong class="supplier-title"><%=supplierName%></strong></div><div class="date-summary"><div><span>Ngày bắt đầu</span><strong><%=startValue%></strong></div><div><span>Ngày kết thúc</span><strong><%=endValue%></strong></div></div>
<% if(error!=null){ %><div class="notice"><%=error%></div><% } else if(invoices.isEmpty()){ %><div class="notice">Nhà cung cấp chưa có phiếu nhập trong khoảng ngày này.</div><% } else { %>
<div class="table-wrap"><table><thead><tr><th>ID hóa đơn</th><th>Nhà cung cấp</th><th>Thời gian</th><th>Hàng nhập</th><th>Tổng tiền (VNĐ)</th><th>Thao tác</th></tr></thead><tbody>
<% for(ImportInvoice5 invoice:invoices){ String detailUrl="ImportInvoiceDetails5.jsp?id="+invoice.getId()+"&amp;startDate="+startValue+"&amp;endDate="+endValue; %><tr><td>PN<%=String.format("%03d",invoice.getId())%></td><td><%=invoice.getSupplierName()%></td><td><%=date.format(invoice.getCreatedDate())%></td><td><%=money.format(invoice.getImportVolume())%></td><td><%=money.format(invoice.getTotalAmount())%></td><td><a class="btn secondary" href="<%=detailUrl%>">Xem chi tiết</a></td></tr><% } %>
</tbody></table></div><% } %><div class="actions"><a class="btn secondary" href="SupplierImportStatistics5.jsp?supplierId=<%=supplierId%>&amp;startDate=<%=startValue%>&amp;endDate=<%=endValue%>">Quay lại thống kê</a></div></section></main></body></html>
