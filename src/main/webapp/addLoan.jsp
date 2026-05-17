<!DOCTYPE html>
<html>
<head>

<title>Add Loan</title>

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

    padding:38px 40px;

    color:white;
}

.hero h2{
    font-size:34px;
    font-weight:700;
    margin-bottom:6px;
}

.hero p{
    opacity:0.9;
    margin:0;
}

/* FORM WRAPPER */

.form-wrapper{
    padding:35px;
}

/* FORM CARD */

.form-card{
    max-width:950px;

    margin:auto;

    background:white;

    border-radius:18px;

    padding:35px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);
}

/* SECTION TITLE */

.section-title{
    font-size:24px;
    font-weight:700;
    color:#111827;

    margin-bottom:25px;
}

/* LABEL */

label{
    font-weight:600;
    margin-bottom:8px;
    color:#374151;
}

/* INPUT */

.form-control{
    border-radius:12px;

    padding:12px;

    border:1px solid #dbe2ea;

    box-shadow:none;
}

.form-control:focus{
    border-color:#7c3aed;
    box-shadow:0 0 0 4px rgba(124,58,237,0.12);
}

/* BUTTON */

.btn-primary{
    width:100%;

    padding:13px;

    border:none;

    border-radius:12px;

    background:linear-gradient(135deg,#6366f1,#06b6d4);

    font-weight:600;

    font-size:16px;

    transition:0.2s;
}

.btn-primary:hover{
    transform:translateY(-2px);
}

/* ALERT */

.alert{
    border-radius:12px;
    padding:14px;
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

<h2>Add Loan</h2>

<p>Create and manage new borrower loans</p>

</div>

<!-- FORM -->

<div class="form-wrapper">

<div class="form-card">

<div class="section-title">
Loan Information
</div>

<%
if(request.getParameter("success") != null){
%>

<div class="alert alert-success mb-4">
<i class="bi bi-check-circle-fill"></i>
Loan Added Successfully
</div>

<%
}
%>

<form action="AddLoanServlet" method="post">

<div class="row">

<div class="col-md-6 mb-4">

<label>Borrower Name</label>

<input type="text"
       name="name"
       class="form-control"
       placeholder="Enter borrower name"
       required>

</div>

<div class="col-md-6 mb-4">

<label>Loan Amount (Rs)</label>

<input type="number"
       name="amount"
       class="form-control"
       placeholder="Enter amount"
       required>

</div>

<div class="col-md-6 mb-4">

<label>Interest Rate (%)</label>

<input type="number"
       name="interest"
       class="form-control"
       placeholder="Enter interest rate"
       required>

</div>

<div class="col-md-6 mb-4">

<label>Duration (Months)</label>

<input type="number"
       name="duration"
       class="form-control"
       placeholder="Enter duration"
       required>

</div>

</div>

<button class="btn btn-primary">
<i class="bi bi-plus-circle"></i>
Add Loan
</button>

</form>

</div>

</div>

</div>

</body>
</html>