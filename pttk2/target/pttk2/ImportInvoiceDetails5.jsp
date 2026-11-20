<%@ page import="dao.ImportInvoice5,dao.ImportInvoiceDetail5,dao.ImportInvoice5DAO,java.text.NumberFormat,java.text.SimpleDateFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  int id=0; try{id=Integer.parseInt(request.getParameter("id"));}catch(Exception ignored){}
  ImportInvoice5 invoice=null;String error=null;
  try{if(id>0)invoice=new ImportInvoice5DAO().getImportInvoice(id);}catch(Exception ex){error="Không đọc được dữ liệu. Hãy kiểm tra kết nối cơ sở dữ liệu.";}
  NumberFormat money=NumberFormat.getNumberInstance(new Locale("vi","VN"));SimpleDateFormat date=new SimpleDateFormat("dd/MM/yyyy HH:mm");
  String startValue=request.getParameter("startDate"),endValue=request.getParameter("endDate");
  String back="ImportInvoiceList5.jsp?supplierId="+(invoice==null?"":invoice.getSupplierId())+"&amp;startDate="+(startValue==null?"":startValue)+"&amp;endDate="+(endValue==null?"":endValue);
%>
<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Chi tiết phiếu nhập | RestMan</title><link rel="stylesheet" href="<%=request.getContextPath()%>/styles.css"></head>
<body><header class="bar"><div class="brand">RestMan</div><nav class="nav"><a href="ManagerHome5.jsp">Quản lý</a><a href="#">Nhập hàng</a><a href="#">Quản lý thông tin</a><a class="active" href="StatisticsMenu5.jsp">Xem thống kê</a></nav></header>
<div class="report-subnav"><a class="report-link" href="StatisticsMenu5.jsp">Thống kê nhà cung cấp theo hàng nhập</a></div>
<main class="wrap"><section class="card"><h1 class="title">Chi tiết phiếu nhập</h1>
<% if(error!=null){ %><div class="notice"><%=error%></div><% } else if(invoice==null){ %><div class="notice">Không tìm thấy phiếu nhập.</div><% } else { %>
<div class="report-heading"><strong class="supplier-title"><%=invoice.getSupplierName()%></strong></div><div class="date-summary"><div><span>Ngày bắt đầu</span><strong><%=startValue%></strong></div><div><span>Ngày kết thúc</span><strong><%=endValue%></strong></div></div>
<div class="invoice-meta"><div><span>ID hóa đơn</span><strong>PN<%=String.format("%03d",invoice.getId())%></strong></div><div><span>Nhân viên quản lý</span><strong><%=invoice.getStaffName()%></strong></div><div><span>Nhà cung cấp</span><strong><%=invoice.getSupplierName()%></strong></div><div><span>Thời gian</span><strong><%=date.format(invoice.getCreatedDate())%></strong></div></div>
<div class="table-wrap"><table><thead><tr><th>ID sản phẩm</th><th>Tên sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr></thead><tbody>
<% for(ImportInvoiceDetail5 detail:invoice.getDetails()){ %><tr><td><%=detail.getProductCode()%></td><td><%=detail.getProductName()%></td><td><%=money.format(detail.getPrice())%></td><td><%=money.format(detail.getQuantity())%></td><td><%=money.format(detail.getLineTotal())%></td></tr><% } %>
</tbody><tfoot><tr><td colspan="3" class="right total">Tổng</td><td class="total"><%=money.format(invoice.getImportVolume())%></td><td class="total"><%=money.format(invoice.getTotalAmount())%></td></tr></tfoot></table></div><% } %>
<div class="actions"><a class="btn secondary" href="<%=back%>">Đóng</a></div></section></main></body></html>
