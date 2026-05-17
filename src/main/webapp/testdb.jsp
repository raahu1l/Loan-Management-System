<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>

<%
try {
    Connection con = DBConnection.getConnection();

    if(con != null){
        out.println("Connected ✅");
    } else {
        out.println("Connection Failed ❌");
    }
} catch(Exception e){
    out.println("ERROR: " + e.getMessage());
    e.printStackTrace();
}
%>