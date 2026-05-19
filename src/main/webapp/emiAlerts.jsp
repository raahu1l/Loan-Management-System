<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="com.db.DBConnection" %>

<%
Connection con = DBConnection.getConnection();

int dueLoans = 0;
int overdueLoans = 0;

double totalPending = 0;
double totalOverdue = 0;
%>

<!DOCTYPE html>
<html>
<head>

<title>EMI Alerts</title>

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

    min-height:150px;
}

.card-pro small{
    color:#6b7280;
    font-size:14px;
}

.card-pro h4{
    margin-top:10px;

    font-size:28px;
    font-weight:700;

    color:#111827;
}

.card-icon{
    width:60px;
    height:60px;

    display:flex;
    align-items:center;
    justify-content:center;

    border-radius:14px;

    font-size:24px;
}

.yellow{
    background:#fef9c3;
    color:#ca8a04;
}

.red{
    background:#fee2e2;
    color:#dc2626;
}

.blue{
    background:#dbeafe;
    color:#2563eb;
}

.green{
    background:#dcfce7;
    color:#16a34a;
}

/* TABLE */

.table-box{
    background:white;

    border-radius:16px;

    padding:20px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);
}

.table th{
    background:#f8fafc;
}

.badge-due{
    background:#fef9c3;
    color:#ca8a04;
}

.badge-overdue{
    background:#fee2e2;
    color:#dc2626;
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

<a href="emiAlerts.jsp">
<i class="bi bi-bell"></i>
<span>EMI Alerts</span>
</a>

</div>

<div class="sidebar-img">
<img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">
</div>

</div>

<div class="main">

<div class="page-title">
EMI Alerts & Monitoring
</div>

<!-- STATUS CARDS -->

<div class="row g-4 mb-4">

<%
ResultSet rs =
con.createStatement().executeQuery(
"SELECT * FROM loans WHERE status='Active'"
);

while(rs.next()){

    int loanId = rs.getInt("id");

    double amount = rs.getDouble("amount");

    double interest = rs.getDouble("interest");

    int duration = rs.getInt("duration");

    Date createdDateSql =
    rs.getDate("created_date");

    long monthsPassed = 0;

    if(createdDateSql != null){

        LocalDate createdDate =
        createdDateSql.toLocalDate();

        monthsPassed =
        ChronoUnit.MONTHS.between(
        createdDate,
        LocalDate.now()
        );

        if(monthsPassed < 0)
            monthsPassed = 0;
    }

    /* Skip new loans until first EMI cycle */

    if(monthsPassed == 0)
        continue;

    double r = interest / (12 * 100);

    double emi = 0;

    if(interest == 0){

        emi = amount / duration;

    } else {

        emi =
        (amount * r * Math.pow(1 + r, duration)) /
        (Math.pow(1 + r, duration) - 1);
    }

    double expectedPaid =
    emi * monthsPassed;

    PreparedStatement payPs =
    con.prepareStatement(
    "SELECT SUM(amount_paid) AS totalPaid FROM payments WHERE loan_id=?"
    );

    payPs.setInt(1, loanId);

    ResultSet payRs =
    payPs.executeQuery();

    double actualPaid = 0;

    if(payRs.next()){

        actualPaid =
        payRs.getDouble("totalPaid");
    }

    double pending =
    expectedPaid - actualPaid;

    if(pending < 0)
        pending = 0;

    if(pending > 0){

        totalPending += pending;

        if(pending > emi){

            overdueLoans++;

            totalOverdue += pending;

        } else {

            dueLoans++;
        }
    }
}
%>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Pending Loans</small>
<h4><%= dueLoans %></h4>
</div>

<div class="card-icon yellow">
<i class="bi bi-exclamation-circle"></i>
</div>

</div>

</div>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Overdue Loans</small>
<h4><%= overdueLoans %></h4>
</div>

<div class="card-icon red">
<i class="bi bi-exclamation-triangle"></i>
</div>

</div>

</div>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Total Pending EMI</small>
<h4>Rs <%= String.format("%,.0f", totalPending) %></h4>
</div>

<div class="card-icon blue">
<i class="bi bi-cash-stack"></i>
</div>

</div>

</div>

<div class="col-md-3">

<div class="card-pro">

<div>
<small>Total Overdue</small>
<h4>Rs <%= String.format("%,.0f", totalOverdue) %></h4>
</div>

<div class="card-icon green">
<i class="bi bi-bank"></i>
</div>

</div>

</div>

</div>

<!-- TABLE -->

<div class="table-box">

<h5 class="mb-4">
Pending EMI Monitoring
</h5>

<table class="table table-hover">

<tr>
<th>Borrower</th>
<th>Loan Amount</th>
<th>Monthly EMI</th>
<th>Total Paid</th>
<th>Remaining Loan</th>
<th>Pending EMI</th>
<th>Overdue Amount</th>
<th>Status</th>
<th>Action</th>
</tr>

<%
ResultSet tableRs =
con.createStatement().executeQuery(
"SELECT * FROM loans WHERE status='Active'"
);

while(tableRs.next()){

    int loanId =
    tableRs.getInt("id");

    String borrower =
    tableRs.getString("borrower_name");

    double amount =
    tableRs.getDouble("amount");

    double interest =
    tableRs.getDouble("interest");

    int duration =
    tableRs.getInt("duration");

    Date createdDateSql =
    tableRs.getDate("created_date");

    long monthsPassed = 0;

    if(createdDateSql != null){

        LocalDate createdDate =
        createdDateSql.toLocalDate();

        monthsPassed =
        ChronoUnit.MONTHS.between(
        createdDate,
        LocalDate.now()
        );

        if(monthsPassed < 0)
            monthsPassed = 0;
    }

    /* Don't show fresh loans */

    if(monthsPassed == 0)
        continue;

    double r = interest / (12 * 100);

    double emi = 0;

    if(interest == 0){

        emi = amount / duration;

    } else {

        emi =
        (amount * r * Math.pow(1 + r, duration)) /
        (Math.pow(1 + r, duration) - 1);
    }

    double expectedPaid =
    emi * monthsPassed;

    PreparedStatement payPs =
    con.prepareStatement(
    "SELECT SUM(amount_paid) AS totalPaid FROM payments WHERE loan_id=?"
    );

    payPs.setInt(1, loanId);

    ResultSet payRs =
    payPs.executeQuery();

    double actualPaid = 0;

    if(payRs.next()){

        actualPaid =
        payRs.getDouble("totalPaid");
    }

    double remainingLoan =
    amount - actualPaid;

    if(remainingLoan < 0)
        remainingLoan = 0;

    double pending =
    expectedPaid - actualPaid;

    if(pending < 0)
        pending = 0;

    /* Hide fully paid loans */

    if(remainingLoan <= 1)
        continue;

    /* Show only loans with pending EMI */

    if(pending <= 0)
        continue;

    String status = "Due";
    String badge = "badge-due";

    double overdueAmount = 0;

    if(pending > emi){

        status = "Overdue";

        badge = "badge-overdue";

        overdueAmount =
        pending - emi;
    }
%>

<tr>

<td>
<%= borrower %>
</td>

<td>
Rs <%= String.format("%,.2f", amount) %>
</td>

<td>
Rs <%= String.format("%,.2f", emi) %>
</td>

<td>
Rs <%= String.format("%,.2f", actualPaid) %>
</td>

<td>
Rs <%= String.format("%,.2f", remainingLoan) %>
</td>

<td>
Rs <%= String.format("%,.2f", pending) %>
</td>

<td>
Rs <%= String.format("%,.2f", overdueAmount) %>
</td>

<td>

<span class="badge <%= badge %>">
<%= status %>
</span>

</td>

<td>

<a href="loanDetails.jsp?id=<%= loanId %>"
class="btn btn-primary btn-sm">

View Details

</a>

</td>

</tr>

<%
}
%>

</table>

</div>

</div>

</body>
</html>