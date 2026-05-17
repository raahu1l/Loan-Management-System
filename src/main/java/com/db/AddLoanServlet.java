package com.db;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.db.DBConnection;

@WebServlet("/AddLoanServlet")
public class AddLoanServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        double amount = Double.parseDouble(request.getParameter("amount"));
        double interest = Double.parseDouble(request.getParameter("interest"));
        int duration = Integer.parseInt(request.getParameter("duration"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO loans(borrower_name, amount, interest, duration, status) VALUES (?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setDouble(2, amount);
            ps.setDouble(3, interest);
            ps.setInt(4, duration);
            ps.setString(5, "Active");

            ps.executeUpdate();

            response.sendRedirect("addLoan.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}