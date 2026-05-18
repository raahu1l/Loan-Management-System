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

import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/ExportReportServlet")
public class ExportReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Connection con =
            DBConnection.getConnection();

            /* COUNTS */

            int totalLoans = 0;
            int activeLoans = 0;
            int closedLoans = 0;

            double totalAmount = 0;

            PreparedStatement ps =
            con.prepareStatement(
            "SELECT * FROM loans"
            );

            ResultSet rs =
            ps.executeQuery();

            while(rs.next()){

                totalLoans++;

                totalAmount +=
                rs.getDouble("amount");

                String status =
                rs.getString("status");

                if(status.equals("Active")){

                    activeLoans++;

                } else {

                    closedLoans++;
                }
            }

            /* PDF RESPONSE */

            response.setContentType(
            "application/pdf"
            );

            response.setHeader(
            "Content-Disposition",
            "attachment; filename=Loan_Report.pdf"
            );

            Document document =
            new Document();

            PdfWriter.getInstance(
            document,
            response.getOutputStream()
            );

            document.open();

            /* TITLE */

            Font titleFont =
            new Font(
            Font.FontFamily.HELVETICA,
            22,
            Font.BOLD
            );

            Paragraph title =
            new Paragraph(
            "Loan Management System Report",
            titleFont
            );

            title.setSpacingAfter(25);

            document.add(title);

            /* SUMMARY */

            Font sectionFont =
            new Font(
            Font.FontFamily.HELVETICA,
            16,
            Font.BOLD
            );

            Paragraph summary =
            new Paragraph(
            "Report Summary",
            sectionFont
            );

            summary.setSpacingAfter(15);

            document.add(summary);

            document.add(
            new Paragraph(
            "Total Loans: " + totalLoans
            )
            );

            document.add(
            new Paragraph(
            "Active Loans: " + activeLoans
            )
            );

            document.add(
            new Paragraph(
            "Closed Loans: " + closedLoans
            )
            );

            document.add(
            new Paragraph(
            "Total Loan Amount: Rs "
            + String.format("%,.2f", totalAmount)
            )
            );

            document.add(
            new Paragraph(" ")
            );

            /* TABLE */

            Paragraph tableTitle =
            new Paragraph(
            "Loan Records",
            sectionFont
            );

            tableTitle.setSpacingAfter(15);

            document.add(tableTitle);

            PdfPTable table =
            new PdfPTable(5);

            table.setWidthPercentage(100);

            table.setSpacingBefore(10);

            /* HEADERS */

            PdfPCell c1 =
            new PdfPCell(
            new Phrase("Borrower")
            );

            PdfPCell c2 =
            new PdfPCell(
            new Phrase("Amount")
            );

            PdfPCell c3 =
            new PdfPCell(
            new Phrase("Interest")
            );

            PdfPCell c4 =
            new PdfPCell(
            new Phrase("Duration")
            );

            PdfPCell c5 =
            new PdfPCell(
            new Phrase("Status")
            );

            table.addCell(c1);
            table.addCell(c2);
            table.addCell(c3);
            table.addCell(c4);
            table.addCell(c5);

            /* DATA */

            rs =
            ps.executeQuery();

            while(rs.next()){

                table.addCell(
                rs.getString("borrower_name")
                );

                table.addCell(
                "Rs " +
                rs.getDouble("amount")
                );

                table.addCell(
                rs.getDouble("interest") + "%"
                );

                table.addCell(
                rs.getInt("duration")
                + " months"
                );

                table.addCell(
                rs.getString("status")
                );
            }

            document.add(table);

            document.add(
            new Paragraph(" ")
            );

            document.add(
            new Paragraph(
            "Generated by Loan Management System"
            )
            );

            document.close();

        } catch(Exception e){

            e.printStackTrace();
        }
    }
}