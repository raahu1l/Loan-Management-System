<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String loanId = request.getParameter("id");

if(loanId == null){
    out.println("<h3 style='padding:20px;'>Invalid Loan ID</h3>");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Add Payment</title>

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
    font-size:38px;
    font-weight:700;

    margin-bottom:6px;
}

.hero p{
    margin:0;
    opacity:0.9;
}

/* CONTENT */

.content{
    padding:40px;
}

/* FORM CARD */

.form-card{
    background:white;

    border-radius:20px;

    padding:35px;

    max-width:700px;

    margin:auto;

    box-shadow:0 12px 28px rgba(0,0,0,0.06);
}

/* TITLE */

.form-title{
    font-size:28px;
    font-weight:700;

    margin-bottom:30px;

    color:#111827;
}

/* INPUTS */

.form-label{
    font-weight:600;
    color:#374151;
}

.form-control{
    border-radius:12px;

    padding:12px;

    border:1px solid #dbe2ea;
}

.form-control:focus{
    border-color:#7c3aed;

    box-shadow:0 0 0 4px rgba(124,58,237,0.12);
}

/* BUTTON */

.btn-primary{
    background:linear-gradient(135deg,#6366f1,#06b6d4);

    border:none;

    border-radius:12px;

    padding:12px;

    font-weight:600;

    font-size:16px;
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

<h2>Add Payment</h2>

<p>
Record borrower payment transaction
</p>

</div>

<!-- CONTENT -->

<div class="content">

<div class="form-card">

<div class="form-title">
Payment Details
</div>

<form action="AddPaymentServlet" method="post">

<div class="mb-4">

<label class="form-label">
Loan ID
</label>

<input type="text"
name="loan_id"
class="form-control"
value="<%= loanId %>"
readonly>

</div>

<div class="mb-4">

<label class="form-label">
Payment Amount
</label>

<input type="number"
name="amount_paid"
class="form-control"
placeholder="Enter payment amount"
required>

</div>

<div class="mb-4">

<label class="form-label">
Payment Date
</label>

<input type="date"
name="payment_date"
class="form-control"
required>

</div>

<button class="btn btn-primary w-100">

<i class="bi bi-cash-coin"></i>

Record Payment

</button>

</form>

</div>

</div>

</div>

</body>
</html>