<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>

<%
String idParam = request.getParameter("id");

if(idParam == null){
    out.println("<h3 style='padding:20px;'>Invalid Loan ID</h3>");
    return;
}

int loanId = Integer.parseInt(idParam);

Connection con = DBConnection.getConnection();

/* LOAN DETAILS */

PreparedStatement loanPs =
con.prepareStatement(
"SELECT * FROM loans WHERE id=?"
);

loanPs.setInt(1, loanId);

ResultSet loanRs =
loanPs.executeQuery();

if(!loanRs.next()){

    out.println("<h3 style='padding:20px;'>Loan not found</h3>");
    return;
}

String borrowerName =
loanRs.getString("borrower_name");

double amount =
loanRs.getDouble("amount");

double interest =
loanRs.getDouble("interest");

int duration =
loanRs.getInt("duration");

String status =
loanRs.getString("status");

/* EMI CALCULATION */

double r = interest / (12 * 100);

double emi =
(amount * r * Math.pow(1 + r, duration)) /
(Math.pow(1 + r, duration) - 1);

double totalPay =
emi * duration;

/* LATEST PAYMENT */

PreparedStatement paymentPs =
con.prepareStatement(
"SELECT * FROM payments WHERE loan_id=? ORDER BY id DESC LIMIT 1"
);

paymentPs.setInt(1, loanId);

ResultSet paymentRs =
paymentPs.executeQuery();

if(!paymentRs.next()){

    out.println("<h3 style='padding:20px;'>No payment found</h3>");
    return;
}

double latestPaid =
paymentRs.getDouble("amount_paid");

String paymentDate =
paymentRs.getString("payment_date");

int receiptId =
paymentRs.getInt("id");

/* TOTAL PAID */

PreparedStatement totalPs =
con.prepareStatement(
"SELECT SUM(amount_paid) AS totalPaid FROM payments WHERE loan_id=?"
);

totalPs.setInt(1, loanId);

ResultSet totalRs =
totalPs.executeQuery();

double totalPaid = 0;

if(totalRs.next()){

    totalPaid =
    totalRs.getDouble("totalPaid");
}

/* REMAINING */

double remaining =
totalPay - totalPaid;

if(remaining < 0){

    remaining = 0;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Payment Receipt</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>

body{
    background:#eef2ff;
    font-family:'Segoe UI';
    padding:40px;
}

.receipt-card{

    max-width:850px;

    margin:auto;

    background:white;

    border-radius:22px;

    overflow:hidden;

    box-shadow:0 14px 34px rgba(0,0,0,0.08);
}

/* HEADER */

.receipt-header{

    background:linear-gradient(135deg,#4c1d95,#7c3aed);

    color:white;

    padding:35px;
}

.receipt-header h2{

    font-weight:700;

    margin-bottom:8px;
}

.receipt-header p{

    margin:0;

    opacity:0.9;
}

/* BODY */

.receipt-body{

    padding:35px;
}

/* SUCCESS */

.success-box{

    background:#dcfce7;

    color:#166534;

    border-radius:14px;

    padding:18px;

    margin-bottom:30px;

    font-weight:600;
}

/* INFO */

.info-grid{

    display:grid;

    grid-template-columns:1fr 1fr;

    gap:22px;
}

.info-card{

    background:#f8fafc;

    border-radius:16px;

    padding:20px;
}

.info-title{

    color:#6b7280;

    font-size:14px;

    margin-bottom:10px;
}

.info-value{

    font-size:24px;

    font-weight:700;

    color:#111827;
}

/* STATUS */

.badge-status{

    display:inline-block;

    padding:8px 16px;

    border-radius:999px;

    font-weight:600;

    margin-top:8px;
}

.active{

    background:#dcfce7;

    color:#15803d;
}

.closed{

    background:#fee2e2;

    color:#b91c1c;
}

/* BUTTONS */

.btn-area{

    margin-top:35px;

    display:flex;

    gap:15px;
}

.btn-custom{

    border:none;

    border-radius:12px;

    padding:12px 20px;

    font-weight:600;
}

.btn-print{

    background:linear-gradient(135deg,#2563eb,#06b6d4);

    color:white;
}

.btn-back{

    background:#111827;

    color:white;
}

@media print{

    .btn-area{
        display:none;
    }

    body{
        background:white;
        padding:0;
    }

    .receipt-card{
        box-shadow:none;
    }
}

</style>

</head>

<body>

<div class="receipt-card">

<!-- HEADER -->

<div class="receipt-header">

<h2>
<i class="bi bi-receipt"></i>

Payment Receipt
</h2>

<p>
Loan Repayment Confirmation
</p>

</div>

<!-- BODY -->

<div class="receipt-body">

<div class="success-box">

<i class="bi bi-check-circle-fill"></i>

Payment recorded successfully.

</div>

<div class="info-grid">

<div class="info-card">

<div class="info-title">
Receipt ID
</div>

<div class="info-value">
#<%= receiptId %>
</div>

</div>

<div class="info-card">

<div class="info-title">
Borrower Name
</div>

<div class="info-value">
<%= borrowerName %>
</div>

</div>

<div class="info-card">

<div class="info-title">
Latest Payment
</div>

<div class="info-value">
Rs <%= String.format("%,.2f", latestPaid) %>
</div>

</div>

<div class="info-card">

<div class="info-title">
Payment Date
</div>

<div class="info-value">
<%= paymentDate %>
</div>

</div>

<div class="info-card">

<div class="info-title">
Remaining Balance
</div>

<div class="info-value">
Rs <%= String.format("%,.2f", remaining) %>
</div>

</div>

<div class="info-card">

<div class="info-title">
Loan Status
</div>

<div class="info-value">

<%= status %>

<br>

<% if(status.equals("Active")){ %>

<span class="badge-status active">
Active
</span>

<% } else { %>

<span class="badge-status closed">
Closed
</span>

<% } %>

</div>

</div>

</div>

<div class="btn-area">

<button onclick="window.print()"
class="btn-custom btn-print">

<i class="bi bi-printer"></i>

Print Receipt

</button>

<a href="loanDetails.jsp?id=<%= loanId %>"
class="btn-custom btn-back text-decoration-none">

<i class="bi bi-arrow-left"></i>

Back To Loan

</a>

</div>

</div>

</div>

</body>
</html>