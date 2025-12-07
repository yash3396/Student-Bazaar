package com.studentbazaar.servlets;

import com.studentbazaar.dao.OfferDAO;
import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.models.Offer;
import com.studentbazaar.models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/MakeOfferServlet")
public class MakeOfferServlet extends HttpServlet {
    private OfferDAO offerDAO = new OfferDAO();
    private ProductDAO productDAO = new ProductDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int buyerId = (Integer) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            double offeredPrice = Double.parseDouble(request.getParameter("offeredPrice"));
            String message = request.getParameter("message");
            
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendRedirect("home.jsp?error=Product not found");
                return;
            }
            
            if (product.getSellerId() == buyerId) {
                response.sendRedirect("ProductDetailsServlet?id=" + productId + "&error=You cannot make offer on your own product");
                return;
            }
            
            if (!product.getStatus().equals("Active")) {
                response.sendRedirect("ProductDetailsServlet?id=" + productId + "&error=Product is no longer available");
                return;
            }
            
            Offer offer = new Offer();
            offer.setProductId(productId);
            offer.setBuyerId(buyerId);
            offer.setSellerId(product.getSellerId());
            offer.setOfferedPrice(offeredPrice);
            offer.setMessage(message != null ? message : "");
            offer.setStatus("Pending");
            
            if (offerDAO.createOffer(offer)) {
                response.sendRedirect("ProductDetailsServlet?id=" + productId + "&success=Offer sent successfully!");
            } else {
                response.sendRedirect("ProductDetailsServlet?id=" + productId + "&error=Failed to send offer");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=Error: " + e.getMessage());
        }
    }
}
