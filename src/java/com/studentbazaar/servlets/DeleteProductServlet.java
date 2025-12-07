package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int productId = Integer.parseInt(request.getParameter("id"));
        
        if (productDAO.deleteProduct(productId)) {
            response.sendRedirect("myListings.jsp?success=Product deleted successfully!");
        } else {
            response.sendRedirect("myListings.jsp?error=Failed to delete product.");
        }
    }
}