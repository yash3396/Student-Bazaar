package com.studentbazaar.servlets;

import com.studentbazaar.dao.OfferDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ManageOfferServlet")
public class ManageOfferServlet extends HttpServlet {
    private OfferDAO offerDAO = new OfferDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int offerId = Integer.parseInt(request.getParameter("offerId"));
            String action = request.getParameter("action");
            
            String status = action.equals("accept") ? "Accepted" : "Rejected";
            
            if (offerDAO.updateOfferStatus(offerId, status)) {
                response.sendRedirect("inbox.jsp?success=Offer " + status.toLowerCase() + " successfully!");
            } else {
                response.sendRedirect("inbox.jsp?error=Failed to update offer");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inbox.jsp?error=Error: " + e.getMessage());
        }
    }
}
