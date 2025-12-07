package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.dao.TransactionDAO;
import com.studentbazaar.models.Product;
import com.studentbazaar.models.Transaction;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/BuyProductServlet")
public class BuyProductServlet extends HttpServlet {
    private TransactionDAO transactionDAO = new TransactionDAO();
    private ProductDAO productDAO = new ProductDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int buyerId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendRedirect("home.jsp?error=Product not found");
                return;
            }
            
            if (product.getSellerId() == buyerId) {
                response.sendRedirect("productDetails.jsp?id=" + productId + "&error=You cannot buy your own product");
                return;
            }
            
            if (!product.getStatus().equals("Active")) {
                response.sendRedirect("productDetails.jsp?id=" + productId + "&error=Product is no longer available");
                return;
            }
            
            Transaction transaction = new Transaction();
            transaction.setProductId(productId);
            transaction.setBuyerId(buyerId);
            transaction.setSellerId(product.getSellerId());
            transaction.setMode("Online");
            
            if (transactionDAO.addTransaction(transaction)) {
                product.setStatus("Sold");
                productDAO.updateProduct(product);
                
                response.sendRedirect("home.jsp?success=Purchase successful! Seller will contact you soon.");
            } else {
                response.sendRedirect("productDetails.jsp?id=" + productId + "&error=Transaction failed. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=Error processing purchase: " + e.getMessage());
        }
    }
}
