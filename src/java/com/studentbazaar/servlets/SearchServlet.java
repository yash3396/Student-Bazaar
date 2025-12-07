package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        
        List<Product> products = productDAO.searchProducts(keyword, category);
        
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }
}