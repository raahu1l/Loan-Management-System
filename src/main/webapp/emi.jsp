<!DOCTYPE html>
<html>
<head>

<title>EMI Calculator</title>

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
    margin:0;
    opacity:0.9;
}

/* CONTENT */

.content{
    padding:35px;
}

/* CARD */

.card-ui{
    background:white;

    border-radius:18px;

    padding:30px;

    box-shadow:0 10px 24px rgba(0,0,0,0.05);

    height:100%;
}

/* TITLE */

.section-title{
    font-size:24px;
    font-weight:700;

    margin-bottom:25px;

    color:#111827;
}

/* LABELS */

label{
    font-weight:600;
    margin-bottom:8px;
    color:#374151;
}

/* INPUT */

.form-control{
    border-radius:12px;

    padding:13px;

    border:1px solid #dbe2ea;

    box-shadow:none;
}

.form-control:focus{
    border-color:#7c3aed;
    box-shadow:0 0 0 4px rgba(124,58,237,0.12);
}

/* BUTTON */

.btn-primary{
    border:none;

    border-radius:12px;

    padding:13px;

    font-weight:600;

    background:linear-gradient(135deg,#6366f1,#06b6d4);

    transition:0.2s;
}

.btn-primary:hover{
    transform:translateY(-2px);
}

/* RESULT CARD */

.result-card{
    background:linear-gradient(135deg,#4c1d95,#7c3aed);

    border-radius:18px;

    padding:32px;

    color:white;

    box-shadow:0 10px 24px rgba(0,0,0,0.08);

    height:100%;
}

/* RESULT ITEMS */

.result-item{
    background:rgba(255,255,255,0.12);

    border-radius:14px;

    padding:18px;

    margin-bottom:18px;
}

.result-item small{
    opacity:0.85;
    font-size:14px;
}

.result-item h4{
    margin-top:8px;
    margin-bottom:0;

    font-size:28px;
    font-weight:700;
}

/* ICON */

.result-icon{
    width:55px;
    height:55px;

    display:flex;
    align-items:center;
    justify-content:center;

    border-radius:14px;

    background:rgba(255,255,255,0.15);

    font-size:24px;

    margin-bottom:18px;
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

<h2>EMI Calculator</h2>

<p>Calculate monthly loan repayment instantly</p>

</div>

<!-- CONTENT -->

<div class="content">

<div class="row g-4">

<!-- INPUT CARD -->

<div class="col-lg-5">

<div class="card-ui">

<div class="section-title">
Loan Details
</div>

<div class="mb-4">

<label>Loan Amount (Rs)</label>

<input type="number"
       id="amount"
       class="form-control"
       placeholder="Enter loan amount">

</div>

<div class="mb-4">

<label>Interest Rate (%)</label>

<input type="number"
       id="interest"
       class="form-control"
       placeholder="Enter interest rate">

</div>

<div class="mb-4">

<label>Duration (Months)</label>

<input type="number"
       id="duration"
       class="form-control"
       placeholder="Enter duration">

</div>

<button class="btn btn-primary w-100" onclick="calc()">
<i class="bi bi-calculator"></i>
Calculate EMI
</button>

</div>

</div>

<!-- RESULT CARD -->

<div class="col-lg-7">

<div class="result-card">

<div class="result-icon">
<i class="bi bi-currency-rupee"></i>
</div>

<h3 class="mb-4">
EMI Result
</h3>

<div class="result-item">

<small>Monthly EMI</small>

<h4 id="emi">Rs 0</h4>

</div>

<div class="result-item">

<small>Total Payable Amount</small>

<h4 id="total">Rs 0</h4>

</div>

<div class="result-item">

<small>Total Interest Amount</small>

<h4 id="interestTotal">Rs 0</h4>

</div>

</div>

</div>

</div>

</div>

</div>

<script>

function calc(){

let P = parseFloat(document.getElementById("amount").value);

let R = parseFloat(document.getElementById("interest").value)/12/100;

let N = parseInt(document.getElementById("duration").value);

if(!P || !R || !N){

    alert("Please fill all fields");

    return;
}

let EMI =
(P * R * Math.pow(1 + R, N)) /
(Math.pow(1 + R, N) - 1);

let total = EMI * N;

let interest = total - P;

document.getElementById("emi").innerText =
"Rs " + EMI.toFixed(2);

document.getElementById("total").innerText =
"Rs " + total.toFixed(2);

document.getElementById("interestTotal").innerText =
"Rs " + interest.toFixed(2);

}

</script>

</body>
</html>