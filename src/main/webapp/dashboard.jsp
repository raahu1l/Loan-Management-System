<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>

<%
Connection con = DBConnection.getConnection();

int totalLoans = 0;
int activeLoans = 0;
int closedLoans = 0;

double totalAmount = 0;
double avgInterest = 0;

String names = "";
String amounts = "";
String interests = "";

/* TOTAL COUNTS */

ResultSet totalRs = con.createStatement().executeQuery(
"SELECT status FROM loans"
);

while(totalRs.next()){

    totalLoans++;

    if("Active".equals(totalRs.getString("status")))
        activeLoans++;
    else
        closedLoans++;
}

/* ACTIVE LOAN ANALYTICS */

ResultSet rs = con.createStatement().executeQuery(
"SELECT * FROM loans WHERE status='Active'"
);

while(rs.next()){

    totalAmount += rs.getDouble("amount");

    avgInterest += rs.getDouble("interest");

    names += "'" + rs.getString("borrower_name") + "',";

    amounts += rs.getDouble("amount") + ",";

    interests += rs.getDouble("interest") + ",";
}

if(activeLoans > 0){
    avgInterest /= activeLoans;
}

if(names.length() > 0){
    names = names.substring(0, names.length()-1);
    amounts = amounts.substring(0, amounts.length()-1);
    interests = interests.substring(0, interests.length()-1);
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
    padding:30px;
}

/* TITLE */

.page-title{
    font-size:34px;
    font-weight:700;
    margin-bottom:25px;
    color:#111827;
}

/* CARDS */

.card-pro{
    background:white;

    border-radius:16px;

    padding:22px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);

    display:flex;
    justify-content:space-between;
    align-items:center;

    transition:0.25s;

    min-height:150px;
}

.card-pro:hover{
    transform:translateY(-3px);
}

.card-pro small{
    color:#6b7280;
    font-size:14px;
}

.card-pro h4{
    margin-top:10px;

    font-size:28px;
    font-weight:700;

    line-height:1;

    color:#111827;

    white-space:nowrap;
}

/* CARD ICONS */

.card-icon{
    width:60px;
    height:60px;

    display:flex;
    align-items:center;
    justify-content:center;

    border-radius:14px;

    font-size:24px;
}

.blue{
    background:#dbeafe;
    color:#2563eb;
}

.green{
    background:#dcfce7;
    color:#16a34a;
}

.orange{
    background:#ffedd5;
    color:#ea580c;
}

.purple{
    background:#ede9fe;
    color:#7c3aed;
}

/* CHARTS */

.chart-card{
    background:white;

    border-radius:16px;

    padding:18px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);
}

.chart-card h6{
    font-size:17px;
    font-weight:600;
    margin-bottom:16px;
}

.chart-box{
    height:260px;
    position:relative;
}

/* TABLE */

.table-box{
    background:white;

    border-radius:16px;

    padding:20px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);
}

.table{
    margin-top:10px;
}

.table th{
    background:#f8fafc;
    color:#374151;
}

.table td{
    vertical-align:middle;
}

/* BUTTON */

.view-btn{
    border-radius:8px;
    padding:6px 14px;
    font-weight:500;
}

</style>

</head>

<body>

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

</div>

<div class="sidebar-img">
<img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">
</div>

</div>

<div class="main">

<div class="page-title">
Dashboard
</div>

<!-- STATS -->

<div class="row g-4 mb-4">

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Total Loans</small>
<h4><%= totalLoans %></h4>
</div>

<div class="card-icon blue">
<i class="bi bi-folder"></i>
</div>

</div>

</div>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Total Amount</small>
<h4>Rs <%= String.format("%,.0f", totalAmount) %></h4>
</div>

<div class="card-icon green">
<i class="bi bi-currency-rupee"></i>
</div>

</div>

</div>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Active Loans</small>
<h4><%= activeLoans %></h4>
</div>

<div class="card-icon orange">
<i class="bi bi-check-circle"></i>
</div>

</div>

</div>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Avg Interest</small>
<h4><%= String.format("%.2f", avgInterest) %>%</h4>
</div>

<div class="card-icon purple">
<i class="bi bi-graph-up-arrow"></i>
</div>

</div>

</div>

</div>

<!-- CHARTS -->

<div class="row g-4 mb-4">

<div class="col-md-4">

<div class="chart-card">

<h6>Status Distribution</h6>

<div class="chart-box">
<canvas id="pieChart"></canvas>
</div>

</div>

</div>

<div class="col-md-4">

<div class="chart-card">

<h6>Loan Amounts</h6>

<div class="chart-box">
<canvas id="barChart"></canvas>
</div>

</div>

</div>

<div class="col-md-4">

<div class="chart-card">

<h6>Interest Trend</h6>

<div class="chart-box">
<canvas id="lineChart"></canvas>
</div>

</div>

</div>

</div>

<!-- RECENT LOANS -->

<div class="table-box">

<div class="d-flex justify-content-between align-items-center">

<h5 class="mb-0">Recent Loans</h5>

<a href="loans.jsp" class="btn btn-primary view-btn">
View All
</a>

</div>

<table class="table table-hover">

<tr>
<th>Name</th>
<th>Amount</th>
<th>Interest</th>
<th>Duration</th>
<th>Status</th>
</tr>

<%
ResultSet rs2 = con.createStatement().executeQuery(
"SELECT * FROM loans WHERE status='Active' ORDER BY id DESC LIMIT 5"
);

while(rs2.next()){
%>

<tr>

<td><%= rs2.getString("borrower_name") %></td>

<td>
Rs <%= rs2.getDouble("amount") %>
</td>

<td>
<%= rs2.getDouble("interest") %>%
</td>

<td>
<%= rs2.getInt("duration") %> months
</td>

<td>
<span class="badge bg-success">
<%= rs2.getString("status") %>
</span>
</td>

</tr>

<% } %>

</table>

</div>

</div>

<script>

new Chart(document.getElementById("pieChart"), {

type:'doughnut',

data:{
labels:["Active","Closed"],

datasets:[{
data:[<%= activeLoans %>, <%= closedLoans %>],
backgroundColor:["#3b82f6","#ef4444"]
}]
},

options:{
maintainAspectRatio:false
}

});

new Chart(document.getElementById("barChart"), {

type:'bar',

data:{
labels:[<%= names %>],

datasets:[{
label:"Loan Amount (Rs)",
data:[<%= amounts %>],
backgroundColor:"#22c55e",
borderRadius:8
}]
},

options:{
maintainAspectRatio:false
}

});

new Chart(document.getElementById("lineChart"), {

type:'line',

data:{
labels:[<%= names %>],

datasets:[{
label:"Interest %",
data:[<%= interests %>],
borderColor:"#6366f1",
backgroundColor:"#6366f1",
fill:false,
tension:0.4
}]
},

options:{
maintainAspectRatio:false
}

});

</script>

</body>
</html>