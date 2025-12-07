<%@ page import="com.studentbazaar.dao.ProductDAO" %>
<%@ page import="com.studentbazaar.models.Product" %>
<%@ page import="java.util.List" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();
%>

<div class="container my-5">
    <h2>Image Debugging Page</h2>
    
    <div class="alert alert-info">
        <h5>Server Information:</h5>
        <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
        <p><strong>Real Path:</strong> <%= application.getRealPath("/uploads") %></p>
        <p><strong>Request URI:</strong> <%= request.getRequestURI() %></p>
    </div>
    
    <h3>Product Images Test:</h3>
    <div class="row">
        <% if (products != null && !products.isEmpty()) {
            for (Product product : products) { %>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <strong><%= product.getName() %></strong>
                        </div>
                        <div class="card-body">
                            <p><strong>Image Path in DB:</strong><br>
                            <code><%= product.getImage() != null ? product.getImage() : "NULL" %></code></p>
                            
                            <p><strong>Direct Image Tag:</strong></p>
                            <img src="<%= product.getImage() != null ? product.getImage() : "images/default" %>" 
                                 alt="<%= product.getName() %>" 
                                 style="max-width: 100%; height: 200px; object-fit: cover; border: 2px solid #ddd;"
                                 onerror="this.style.border='3px solid red'; this.alt='IMAGE FAILED TO LOAD'; console.error('Image failed:', '<%= product.getImage() %>');">
                            
                            <p class="mt-2">
                                <a href="<%= product.getImage() != null ? product.getImage() : "images/default" %>" 
                                   target="_blank" class="btn btn-sm btn-primary">
                                    Open Image URL
                                </a>
                            </p>
                        </div>
                    </div>
                </div>
            <% }
        } else { %>
            <div class="col-12">
                <div class="alert alert-warning">No products found.</div>
            </div>
        <% } %>
    </div>
    
    <div class="mt-4">
        <h3>Test Image URLs:</h3>
        <ul>
            <li><a href="images/default" target="_blank">Default Image (images/default)</a></li>
            <li><a href="<%= request.getContextPath() %>/images/default" target="_blank">Default Image (with context)</a></li>
        </ul>
    </div>
</div>

<%@ include file="footer.jsp" %>



