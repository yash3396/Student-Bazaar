package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/MyListingsServlet")
public class MyListingsServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        List<Product> products = productDAO.getProductsBySeller(userId);
        
        request.setAttribute("products", products);
        request.getRequestDispatcher("myListings.jsp").forward(request, response);
    }
}