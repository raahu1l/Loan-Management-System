<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>

<%
Connection con = DBConnection.getConnection();

int total = 0;
double totalAmount = 0;

int low = 0;
int medium = 0;
int high = 0;

double totalInterest = 0;
double totalEMI = 0;

int shortTerm = 0;
int midTerm = 0;
int longTerm = 0;

int lowAmountLoans = 0;
int mediumAmountLoans = 0;
int highAmountLoans = 0;

String names = "";
String durations = "";
String emis = "";
String interests = "";
String amounts = "";

ResultSet rs = con.createStatement().executeQuery(
"SELECT * FROM loans ORDER BY id DESC"
);

while(rs.next()){

    total++;

    double amt = rs.getDouble("amount");
    double intr = rs.getDouble("interest");
    int duration = rs.getInt("duration");

    totalAmount += amt;

    totalInterest += intr;

    /* LOAN SIZE SEGMENT */

    if(amt < 5000){
        low++;
        lowAmountLoans++;
    }
    else if(amt < 100000){
        medium++;
        mediumAmountLoans++;
    }
    else{
        high++;
        highAmountLoans++;
    }

    /* DURATION CATEGORY */

    if(duration <= 12)
        shortTerm++;
    else if(duration <= 36)
        midTerm++;
    else
        longTerm++;

    names += "'" + rs.getString("borrower_name") + "',";

    durations += duration + ",";

    interests += intr + ",";

    amounts += amt + ",";

    /* EMI */

    double r = intr / (12 * 100);

    double emi = 0;

    if(r > 0 && duration > 0){

        emi =
        (amt * r * Math.pow(1 + r, duration)) /
        (Math.pow(1 + r, duration) - 1);
    }

    totalEMI += emi;

    emis += emi + ",";
}

double avgInterest = 0;

if(total > 0){
    avgInterest = totalInterest / total;
}

if(names.length() > 0){

    names = names.substring(0, names.length()-1);

    durations = durations.substring(0, durations.length()-1);

    emis = emis.substring(0, emis.length()-1);

    interests = interests.substring(0, interests.length()-1);

    amounts = amounts.substring(0, amounts.length()-1);
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Reports</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

body{
    margin:0;
    background:#f4f6fb;
    font-family:'Segoe UI';
}

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

.main{
    margin-left:250px;
    min-height:100vh;
}

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

.content{
    padding:35px;
}

.report-card{
    background:white;
    border-radius:18px;
    padding:26px;
    box-shadow:0 10px 24px rgba(0,0,0,0.05);
    min-height:150px;
    display:flex;
    flex-direction:column;
    justify-content:center;
}

.report-card small{
    color:#6b7280;
    font-size:15px;
}

.report-card h4{
    margin-top:14px;
    font-size:32px;
    font-weight:700;
    color:#111827;
}

.chart-card{
    background:white;
    border-radius:18px;
    padding:22px;
    box-shadow:0 10px 24px rgba(0,0,0,0.05);
    height:100%;
}

.chart-card h5{
    font-size:20px;
    font-weight:700;
    margin-bottom:18px;
}

.chart-box{
    height:320px;
    position:relative;
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

<div class="hero">

<h2>Reports & Analytics</h2>

</div>

<div class="content">

<!-- STATS -->

<div class="row g-4 mb-4">

<div class="col-md-3">
<div class="report-card">
<small>Total Monthly EMI</small>
<h4>Rs <%= String.format("%,.0f", totalEMI) %></h4>
</div>
</div>

<div class="col-md-3">
<div class="report-card">
<small>Short Term Loans</small>
<h4><%= shortTerm %></h4>
</div>
</div>

<div class="col-md-3">
<div class="report-card">
<small>Medium Term Loans</small>
<h4><%= midTerm %></h4>
</div>
</div>

<div class="col-md-3">
<div class="report-card">
<small>Long Term Loans</small>
<h4><%= longTerm %></h4>
</div>
</div>

</div>

<!-- CHARTS -->

<div class="row g-4">

<!-- LOAN SEGMENT -->

<div class="col-lg-6">

<div class="chart-card">

<h5>Loan Segmentation</h5>

<div class="chart-box">
<canvas id="segmentChart"></canvas>
</div>

</div>

</div>

<!-- LOAN SIZE -->

<div class="col-lg-6">

<div class="chart-card">

<h5>Loan Size Distribution</h5>

<div class="chart-box">
<canvas id="sizeChart"></canvas>
</div>

</div>

</div>

<!-- DURATION -->

<div class="col-lg-6">

<div class="chart-card">

<h5>Loan Duration Analysis</h5>

<div class="chart-box">
<canvas id="durationChart"></canvas>
</div>

</div>

</div>

<!-- EMI -->

<div class="col-lg-6">

<div class="chart-card">

<h5>Monthly EMI Distribution</h5>

<div class="chart-box">
<canvas id="emiChart"></canvas>
</div>

</div>

</div>

<!-- AMOUNT TREND -->

<div class="col-12">

<div class="chart-card">

<h5>Loan Amount Trend</h5>

<div class="chart-box">
<canvas id="amountTrendChart"></canvas>
</div>

</div>

</div>

</div>

</div>

</div>

<script>

/* SEGMENT */

new Chart(document.getElementById("segmentChart"), {

type:'doughnut',

data:{
labels:["Low","Medium","High"],

datasets:[{
data:[<%= low %>,<%= medium %>,<%= high %>],
backgroundColor:["#3b82f6","#f59e0b","#ef4444"]
}]
},

options:{
maintainAspectRatio:false
}

});

/* SIZE */

new Chart(document.getElementById("sizeChart"), {

type:'bar',

data:{
labels:["Low Amount","Medium Amount","High Amount"],

datasets:[{
label:"Loans",
data:[
<%= lowAmountLoans %>,
<%= mediumAmountLoans %>,
<%= highAmountLoans %>
],
backgroundColor:[
"#22c55e",
"#f59e0b",
"#ef4444"
],
borderRadius:8
}]
},

options:{
maintainAspectRatio:false
}

});

/* DURATION */

new Chart(document.getElementById("durationChart"), {

type:'bar',

data:{
labels:[<%= names %>],

datasets:[{
label:"Duration",
data:[<%= durations %>],
backgroundColor:"#8b5cf6",
borderRadius:8
}]
},

options:{
maintainAspectRatio:false
}

});

/* EMI */

new Chart(document.getElementById("emiChart"), {

type:'line',

data:{
labels:[<%= names %>],

datasets:[{
label:"Monthly EMI",
data:[<%= emis %>],
borderColor:"#06b6d4",
backgroundColor:"#06b6d4",
fill:false,
tension:0.4
}]
},

options:{
maintainAspectRatio:false
}

});

/* AMOUNT TREND */

new Chart(document.getElementById("amountTrendChart"), {

type:'line',

data:{
labels:[<%= names %>],

datasets:[{
label:"Loan Amount",
data:[<%= amounts %>],
borderColor:"#7c3aed",
backgroundColor:"#7c3aed",
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