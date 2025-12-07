package com.studentbazaar.servlets;

import com.studentbazaar.dao.SpamReportDAO;
import com.studentbazaar.models.SpamReport;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ReportSpamServlet")
public class ReportSpamServlet extends HttpServlet {
    private SpamReportDAO spamReportDAO = new SpamReportDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int reporterId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                response.sendRedirect("productDetails.jsp?id=" + productId + "&error=Please provide a reason for reporting");
                return;
            }
            
            SpamReport report = new SpamReport();
            report.setProductId(productId);
            report.setReporterId(reporterId);
            report.setReason(reason);
            
            if (spamReportDAO.addSpamReport(report)) {
                response.sendRedirect("productDetails.jsp?id=" + productId + "&success=Report submitted successfully");
            } else {
                response.sendRedirect("productDetails.jsp?id=" + productId + "&error=Failed to submit report");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=Error submitting report: " + e.getMessage());
        }
    }
}
