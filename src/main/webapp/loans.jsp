<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>

<%
Connection con = DBConnection.getConnection();

String search = request.getParameter("search");
String filter = request.getParameter("status");

String query = "SELECT * FROM loans WHERE 1=1";

if(search != null && !search.equals("")){
    query += " AND borrower_name LIKE '%" + search + "%'";
}

if(filter != null && !filter.equals("")){
    query += " AND status='" + filter + "'";
}

query += " ORDER BY id DESC";

ResultSet rs = con.createStatement().executeQuery(query);
%>

<!DOCTYPE html>
<html>
<head>

<title>Loans Overview</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>

body{
    margin:0;
    background:#f4f6fb;
    font-family:'Segoe UI';
}

/* SIDEBAR */

.sidebar{
    width:250px;
    height:100vh;

    background:linear-gradient(180deg,#4c1d95,#6d28d9);

    position:fixed;
    left:0;
    top:0;

    padding:28px 22px;

    display:flex;
    flex-direction:column;
    justify-content:space-between;
}

/* LOGO */

.logo{
    display:flex;
    align-items:center;
    gap:12px;

    color:white;

    font-size:20px;
    font-weight:700;

    margin-bottom:35px;
}

.logo i{
    font-size:28px;
}

/* LINKS */

.sidebar a{
    display:flex;
    align-items:center;
    gap:12px;

    color:#f3e8ff;
    text-decoration:none;

    padding:12px 10px;

    border-radius:10px;

    margin-bottom:8px;

    font-size:18px;
    font-weight:500;

    transition:0.2s;
}

.sidebar a:hover{
    background:rgba(255,255,255,0.12);
    color:white;
}

.sidebar a i{
    font-size:20px;
    width:24px;
}

/* IMAGE */

.sidebar-img{
    text-align:center;
    padding-top:20px;
}

.sidebar-img img{
    width:88%;
    max-width:170px;
    opacity:0.95;
}

/* MAIN */

.main{
    margin-left:250px;
    min-height:100vh;
}

/* HERO */

.hero{
    background:linear-gradient(180deg,#3b0764,#4c1d95);

    padding:40px;

    color:white;
}

.hero h2{
    font-size:34px;
    font-weight:700;

    margin-bottom:6px;
}

.hero p{
    margin:0;
    opacity:0.9;
}

/* CONTENT */

.content{
    padding:35px;
}

/* CARD */

.card-box{
    background:white;

    border-radius:18px;

    padding:24px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);
}

/* FILTER SECTION */

.filter-title{
    font-size:22px;
    font-weight:700;

    color:#111827;

    margin-bottom:20px;
}

/* INPUTS */

.form-control,
.form-select{
    border-radius:12px;

    padding:12px;

    border:1px solid #dbe2ea;

    box-shadow:none;
}

.form-control:focus,
.form-select:focus{
    border-color:#7c3aed;
    box-shadow:0 0 0 4px rgba(124,58,237,0.12);
}

/* BUTTONS */

.btn{
    border-radius:10px;
    font-weight:600;
    padding:9px 16px;
}

.btn-primary{
    background:linear-gradient(135deg,#6366f1,#06b6d4);
    border:none;
}

.btn-warning{
    color:white;
}

/* TABLE */

.table{
    margin-top:10px;
}

.table th{
    background:#f8fafc;

    color:#374151;

    font-weight:600;

    border:none;
}

.table td{
    vertical-align:middle;
    border-color:#eef2f7;
}

/* STATUS */

.badge{
    padding:8px 12px;
    border-radius:999px;
    font-size:13px;
}

/* ACTION BUTTONS */

.action-buttons{
    display:flex;
    gap:8px;
    flex-wrap:wrap;
}

</style>

</head>

<body>

<!-- SIDEBAR -->

<div class="sidebar">

<div>

<h4 class="logo">
<i class="bi bi-bank"></i>
<span>Loan System</span>
</h4>

<a href="dashboard.jsp">
<i class="bi bi-speedometer2"></i>
<span>Dashboard</span>
</a>

<a href="addLoan.jsp">
<i class="bi bi-plus-circle"></i>
<span>Add Loan</span>
</a>

<a href="loans.jsp">
<i class="bi bi-list"></i>
<span>Loans</span>
</a>

<a href="reports.jsp">
<i class="bi bi-bar-chart"></i>
<span>Reports</span>
</a>

<a href="emi.jsp">
<i class="bi bi-calculator"></i>
<span>EMI Calculator</span>
</a>

<a href="emiAlerts.jsp">
<i class="bi bi-bell"></i>
<span>EMI Alerts</span>
</a>

</div>

<div class="sidebar-img">
<img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">
</div>

</div>

<!-- MAIN -->

<div class="main">

<!-- HERO -->

<div class="hero">

<h2>Loans Overview</h2>

<p>
Manage and monitor all borrower loans
</p>

</div>

<!-- CONTENT -->

<div class="content">

<div class="card-box">

<div class="filter-title">
Loan Management
</div>

<!-- FILTERS -->

<form method="get" class="row g-3 mb-4">

<div class="col-md-5">

<input type="text"
       name="search"
       class="form-control"
       placeholder="Search borrower name"
       value="<%= search != null ? search : "" %>">

</div>

<div class="col-md-3">

<select name="status" class="form-select">

<option value="">All Status</option>

<option value="Active"
<%= "Active".equals(filter) ? "selected" : "" %>>
Active
</option>

<option value="Closed"
<%= "Closed".equals(filter) ? "selected" : "" %>>
Closed
</option>

</select>

</div>

<div class="col-md-2">

<button class="btn btn-primary w-100">
<i class="bi bi-funnel"></i>
Filter
</button>

</div>

<div class="col-md-2">

<a href="loans.jsp" class="btn btn-dark w-100">
Reset
</a>

</div>

</form>

<!-- TABLE -->

<div class="table-responsive">

<table class="table table-hover align-middle">

<tr>
<th>Borrower</th>
<th>Loan Amount</th>
<th>Interest</th>
<th>Duration</th>
<th>Status</th>
<th>Actions</th>
</tr>

<%
while(rs.next()){

String status = rs.getString("status");
int loanId = rs.getInt("id");
%>

<tr>

<td>
<b><%= rs.getString("borrower_name") %></b>
</td>

<td>
Rs <%= rs.getDouble("amount") %>
</td>

<td>
<%= rs.getDouble("interest") %>%
</td>

<td>
<%= rs.getInt("duration") %> months
</td>

<td>

<% if(status.equals("Active")){ %>

<span class="badge bg-success">
Active
</span>

<% } else { %>

<span class="badge bg-danger">
Closed
</span>

<% } %>

</td>

<td>

<div class="action-buttons">

<!-- VIEW -->

<a href="loanDetails.jsp?id=<%= loanId %>"
   class="btn btn-success btn-sm">

<i class="bi bi-eye"></i>

View

</a>

<!-- TOGGLE -->

<a href="<%= request.getContextPath() %>/ToggleStatusServlet?id=<%= loanId %>&status=<%= status %>"
   class="btn btn-warning btn-sm">

<i class="bi bi-arrow-repeat"></i>

<%= status.equals("Active") ? "Close" : "Activate" %>

</a>

<!-- DELETE -->

<a href="#"
   class="btn btn-danger btn-sm"
   data-bs-toggle="modal"
   data-bs-target="#deleteModal<%= loanId %>">

<i class="bi bi-trash"></i>

Delete

</a>

</div>

<!-- DELETE MODAL -->

<div class="modal fade"
id="deleteModal<%= loanId %>"
tabindex="-1">

<div class="modal-dialog modal-dialog-centered">

<div class="modal-content">

<div class="modal-header">

<h5 class="modal-title">
Delete Loan
</h5>

<button type="button"
class="btn-close"
data-bs-dismiss="modal"></button>

</div>

<div class="modal-body">

Are you sure you want to permanently delete this loan?

</div>

<div class="modal-footer">

<button type="button"
class="btn btn-secondary"
data-bs-dismiss="modal">

Cancel

</button>

<a href="DeleteLoanServlet?id=<%= loanId %>"
class="btn btn-danger">

Delete

</a>

</div>

</div>

</div>

</div>

</td>

</tr>

<% } %>

</table>

</div>

</div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>