package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/MarkAsSoldServlet")
public class MarkAsSoldServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int userId = (Integer) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            Product product = productDAO.getProductById(productId);
            
            if (product == null || product.getSellerId() != userId) {
                response.sendRedirect("myListings.jsp?error=Unauthorized access");
                return;
            }
            
            product.setStatus("Sold");
            
            if (productDAO.updateProduct(product)) {
                response.sendRedirect("myListings.jsp?success=Product marked as sold!");
            } else {
                response.sendRedirect("myListings.jsp?error=Failed to update product");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myListings.jsp?error=Error: " + e.getMessage());
        }
    }
}
