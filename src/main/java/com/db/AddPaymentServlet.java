package com.db;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddPaymentServlet")
public class AddPaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int loanId =
            Integer.parseInt(
            request.getParameter("loan_id")
            );

            double amountPaid =
            Double.parseDouble(
            request.getParameter("amount_paid")
            );

            String paymentDate =
            request.getParameter("payment_date");

            Connection con =
            DBConnection.getConnection();

            /* GET LOAN DETAILS */

            PreparedStatement loanPs =
            con.prepareStatement(
            "SELECT * FROM loans WHERE id=?"
            );

            loanPs.setInt(1, loanId);

            ResultSet loanRs =
            loanPs.executeQuery();

            if(!loanRs.next()){

                response.sendRedirect(
                "loanDetails.jsp?id=" + loanId
                );

                return;
            }

            double amount =
            loanRs.getDouble("amount");

            double interest =
            loanRs.getDouble("interest");

            int duration =
            loanRs.getInt("duration");

            String status =
            loanRs.getString("status");

            /* BLOCK CLOSED LOAN */

            if(status.equals("Closed")){

                response.sendRedirect(
                "loanDetails.jsp?id=" + loanId
                );

                return;
            }

            /* BLOCK INVALID PAYMENT */

            if(amountPaid <= 0){

                response.sendRedirect(
                "loanDetails.jsp?id=" + loanId
                );

                return;
            }

            /* EMI CALCULATION */

            double r = interest / (12 * 100);

            double emi = 0;

            if(r > 0 && duration > 0){

                emi =
                (amount * r * Math.pow(1 + r, duration)) /
                (Math.pow(1 + r, duration) - 1);
            }

            double totalPay =
            emi * duration;

            /* TOTAL PAID */

            PreparedStatement totalPs =
            con.prepareStatement(
            "SELECT SUM(amount_paid) AS totalPaid FROM payments WHERE loan_id=?"
            );

            totalPs.setInt(1, loanId);

            ResultSet totalRs =
            totalPs.executeQuery();

            double currentPaid = 0;

            if(totalRs.next()){

                currentPaid =
                totalRs.getDouble("totalPaid");
            }

            /* BLOCK OVERPAYMENT */

            if(currentPaid + amountPaid > totalPay){

                response.sendRedirect(
                "loanDetails.jsp?id=" + loanId
                );

                return;
            }

            /* INSERT PAYMENT */

            PreparedStatement insertPs =
            con.prepareStatement(
            "INSERT INTO payments(loan_id, amount_paid, payment_date) VALUES(?,?,?)"
            );

            insertPs.setInt(1, loanId);

            insertPs.setDouble(2, amountPaid);

            insertPs.setString(3, paymentDate);

            insertPs.executeUpdate();

            /* UPDATED TOTAL */

            double updatedPaid =
            currentPaid + amountPaid;

            /* AUTO CLOSE LOAN */

            if(updatedPaid >= totalPay){

                PreparedStatement closePs =
                con.prepareStatement(
                "UPDATE loans SET status='Closed' WHERE id=?"
                );

                closePs.setInt(1, loanId);

                closePs.executeUpdate();
            }

            /* REDIRECT TO RECEIPT */

            response.sendRedirect(
            "paymentReceipt.jsp?id=" + loanId
            );

        } catch(Exception e){

            e.printStackTrace();
        }
    }
}