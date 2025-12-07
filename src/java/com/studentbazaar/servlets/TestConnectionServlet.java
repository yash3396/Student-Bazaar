package com.studentbazaar.servlets;

import com.studentbazaar.database.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/TestConnectionServlet")
public class TestConnectionServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        try {
            // Test connection
            Connection conn = DBConnection.getConnection();
            out.println("<p style='color:green;'>✓ Database connection successful!</p>");
            
            // Test query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM users");
            
            if (rs.next()) {
                int count = rs.getInt("count");
                out.println("<p>✓ Users table accessible. Total users: " + count + "</p>");
            }
            
            // Test if admin exists
            rs = stmt.executeQuery("SELECT * FROM users WHERE email = 'admin@studentbazaar.com'");
            if (rs.next()) {
                out.println("<p>✓ Admin user exists</p>");
                out.println("<p>Name: " + rs.getString("name") + "</p>");
                out.println("<p>Email: " + rs.getString("email") + "</p>");
                out.println("<p>Password (hashed): " + rs.getString("password") + "</p>");
            } else {
                out.println("<p style='color:orange;'>⚠ Admin user not found</p>");
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            out.println("<p style='color:red;'>✗ Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("<br><a href='login.jsp'>Go to Login</a>");
        out.println("</body></html>");
    }
}