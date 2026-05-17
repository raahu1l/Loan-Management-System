<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>

<%
String idParam = request.getParameter("id");

if(idParam == null){
    out.println("<h3 style='padding:20px;'>Invalid Request: ID missing</h3>");
    return;
}

int id = Integer.parseInt(idParam);

Connection con = DBConnection.getConnection();

PreparedStatement ps =
con.prepareStatement("SELECT * FROM loans WHERE id=?");

ps.setInt(1, id);

ResultSet rs = ps.executeQuery();

if(!rs.next()){
    out.println("<h3 style='padding:20px;'>Loan not found</h3>");
    return;
}

String name = rs.getString("borrower_name");

double amount = rs.getDouble("amount");

double interest = rs.getDouble("interest");

int duration = rs.getInt("duration");

String status = rs.getString("status");

/* EMI */

double r = interest / (12 * 100);

double emi = 0;

if(r > 0 && duration > 0){

    emi =
    (amount * r * Math.pow(1 + r, duration)) /
    (Math.pow(1 + r, duration) - 1);
}

double totalPay = emi * duration;

double totalInterest = totalPay - amount;
%>

<!DOCTYPE html>
<html>
<head>

<title>Loan Details</title>

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
    font-size:42px;
    font-weight:700;

    margin-bottom:8px;
}

.hero p{
    margin:0;
    opacity:0.92;

    font-size:18px;
}

/* CONTENT */

.content{
    padding:35px;
}

/* METRIC CARD */

.metric-card{
    background:white;

    border-radius:18px;

    padding:26px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);

    height:100%;

    transition:0.2s;
}

.metric-card:hover{
    transform:translateY(-3px);
}

.metric-label{
    font-size:15px;
    color:#6b7280;

    margin-bottom:12px;
}

.metric-value{
    font-size:32px;
    font-weight:700;

    color:#111827;

    line-height:1.2;
}

/* ACCENTS */

.blue{
    border-top:4px solid #2563eb;
}

.orange{
    border-top:4px solid #f59e0b;
}

.green{
    border-top:4px solid #16a34a;
}

.purple{
    border-top:4px solid #7c3aed;
}

/* STATUS */

.badge-soft{
    padding:10px 18px;

    border-radius:999px;

    font-size:14px;
    font-weight:600;

    display:inline-block;
}

.badge-active{
    background:#dcfce7;
    color:#15803d;
}

.badge-closed{
    background:#fee2e2;
    color:#b91c1c;
}

/* SECTION */

.section-card{
    background:white;

    border-radius:18px;

    padding:28px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);

    height:100%;
}

.section-card h5{
    font-weight:700;

    margin-bottom:22px;

    color:#111827;

    font-size:22px;
}

.section-card p{
    margin-bottom:16px;

    color:#374151;

    font-size:16px;
}

.section-card b{
    color:#111827;
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

</div>

<div class="sidebar-img">
<img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">
</div>

</div>

<!-- MAIN -->

<div class="main">

<!-- HERO -->

<div class="hero">

<h2><%= name %></h2>

<p>
Loan ID #<%= id %> | Detailed Loan Overview
</p>

</div>

<!-- CONTENT -->

<div class="content">

<!-- METRICS -->

<div class="row g-4 mb-4">

<div class="col-md-3">

<div class="metric-card blue">

<div class="metric-label">
Loan Amount
</div>

<div class="metric-value">
Rs <%= String.format("%,.0f", amount) %>
</div>

</div>

</div>

<div class="col-md-3">

<div class="metric-card orange">

<div class="metric-label">
Interest Rate
</div>

<div class="metric-value">
<%= interest %>%
</div>

</div>

</div>

<div class="col-md-3">

<div class="metric-card green">

<div class="metric-label">
Duration
</div>

<div class="metric-value">
<%= duration %> Months
</div>

</div>

</div>

<div class="col-md-3">

<div class="metric-card purple">

<div class="metric-label">
Loan Status
</div>

<div class="mt-2">

<% if(status.equals("Active")){ %>

<span class="badge-soft badge-active">
Active
</span>

<% } else { %>

<span class="badge-soft badge-closed">
Closed
</span>

<% } %>

</div>

</div>

</div>

</div>

<!-- DETAILS -->

<div class="row g-4">

<!-- FINANCIAL -->

<div class="col-lg-6">

<div class="section-card">

<h5>
Financial Summary
</h5>

<p>
<b>Monthly EMI:</b>
Rs <%= String.format("%,.2f", emi) %>
</p>

<p>
<b>Total Payable Amount:</b>
Rs <%= String.format("%,.2f", totalPay) %>
</p>

<p>
<b>Total Interest Payable:</b>
Rs <%= String.format("%,.2f", totalInterest) %>
</p>

</div>

</div>

<!-- TERMS -->

<div class="col-lg-6">

<div class="section-card">

<h5>
Loan Terms & Details
</h5>

<p>
<b>Borrower Name:</b>
<%= name %>
</p>

<p>
<b>Loan ID:</b>
#<%= id %>
</p>

<p>
<b>Interest Type:</b>
Fixed Rate
</p>

<p>
<b>Repayment Method:</b>
Monthly EMI
</p>

<p>
<b>Status:</b>
<%= status %>
</p>

</div>

</div>

</div>

</div>

</div>

</body>
</html>