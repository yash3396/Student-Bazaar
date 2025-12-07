<%@ page import="com.studentbazaar.dao.ProductDAO" %>
<%@ page import="com.studentbazaar.models.Product" %>
<%@ page import="java.util.List" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getProductsBySeller(userId);
%>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4 animate-slide-in-left">
        <div>
            <h2 class="text-gradient mb-1 animate-scale-in">
                <i class="fas fa-list"></i> My Listings
            </h2>
            <p class="text-muted mb-0">Manage your products and track their status</p>
        </div>
        <a href="addProduct.jsp" class="btn btn-success hover-lift">
            <i class="fas fa-plus"></i> Add New Product
        </a>
    </div>
    
    <!-- Statistics Summary -->
    <% 
        int activeCount = 0;
        int soldCount = 0;
        if (products != null) {
            for (Product p : products) {
                if (p.getStatus().equals("Active")) activeCount++;
                else if (p.getStatus().equals("Sold")) soldCount++;
            }
        }
    %>
    <div class="row mb-4">
        <div class="col-md-4 mb-3 stagger-item">
            <div class="card shadow-sm border-0 hover-lift">
                <div class="card-body text-center">
                    <h3 class="text-primary mb-1 animate-bounce"><%= products != null ? products.size() : 0 %></h3>
                    <p class="text-muted mb-0">Total Listings</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3 stagger-item">
            <div class="card shadow-sm border-0 hover-lift">
                <div class="card-body text-center">
                    <h3 class="text-success mb-1 animate-bounce"><%= activeCount %></h3>
                    <p class="text-muted mb-0">Active</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3 stagger-item">
            <div class="card shadow-sm border-0 hover-lift">
                <div class="card-body text-center">
                    <h3 class="text-secondary mb-1 animate-bounce"><%= soldCount %></h3>
                    <p class="text-muted mb-0">Sold</p>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <% if (products != null && !products.isEmpty()) {
            int index = 0;
            for (Product product : products) { 
                index++;
            %>
                <div class="col-md-4 mb-4 product-item stagger-item">
                    <div class="card product-card h-100 hover-lift">
                        <div class="position-relative">
                            <%
                                String imageUrl = product.getImage();
                                if (imageUrl == null || imageUrl.isEmpty()) {
                                    imageUrl = "images/default";
                                } else if (imageUrl.contains("via.placeholder.com") || imageUrl.contains("placeholder.com")) {
                                    // Replace old placeholder URLs with default
                                    imageUrl = "images/default";
                                } else if (!imageUrl.startsWith("http://") && !imageUrl.startsWith("https://") && !imageUrl.startsWith("images/")) {
                                    if (!imageUrl.startsWith("/")) {
                                        imageUrl = "images/" + imageUrl;
                                    }
                                }
                            %>
                            <img src="<%= imageUrl %>" 
                                 class="card-img-top product-image" 
                                 alt="<%= product.getName() %>" 
                                 style="height: 220px; object-fit: cover; background-color: #f0f0f0; width: 100%;"
                                 onerror="handleImageError(this, '<%= imageUrl.replace("'", "\\'") %>');">
                            <span class="badge bg-<%= product.getStatus().equals("Active") ? "success" : "secondary" %> position-absolute top-0 end-0 m-2">
                                <i class="fas fa-<%= product.getStatus().equals("Active") ? "check-circle" : "times-circle" %>"></i> <%= product.getStatus() %>
                            </span>
                        </div>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title text-gradient"><%= product.getName() %></h5>
                            <p class="text-muted mb-2">
                                <i class="fas fa-tag"></i> <%= product.getCategory() %>
                            </p>
                            <h4 class="text-primary mb-3">
                                <i class="fas fa-rupee-sign"></i> <%= product.getPrice() %>
                            </h4>
                            <p class="card-text flex-grow-1">
                                <%= product.getDescription().length() > 80 ? product.getDescription().substring(0, 80) + "..." : product.getDescription() %>
                            </p>
                        </div>
                        <div class="card-footer bg-light">
                            <div class="d-grid gap-2">
                                <a href="ProductDetailsServlet?id=<%= product.getProductId() %>" class="btn btn-sm btn-primary">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                                <div class="btn-group" role="group">
                                    <a href="EditProductServlet?id=<%= product.getProductId() %>" class="btn btn-sm btn-warning">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <% if (product.getStatus().equals("Active")) { %>
                                        <form action="MarkAsSoldServlet" method="post" onsubmit="return confirm('Mark this product as sold?')" class="d-inline">
                                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                            <button type="submit" class="btn btn-sm btn-success">
                                                <i class="fas fa-check"></i> Sold
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                                <a href="DeleteProductServlet?id=<%= product.getProductId() %>" 
                                   class="btn btn-sm btn-danger" 
                                   onclick="return confirm('Are you sure you want to delete this product? This action cannot be undone.')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
        <%  }
        } else { %>
            <div class="col-12">
                <div class="alert alert-info text-center py-5">
                    <i class="fas fa-box-open fa-4x mb-4 text-primary"></i>
                    <h3>No Listings Yet</h3>
                    <p class="lead">You haven't listed any products yet. Start selling today!</p>
                    <a href="addProduct.jsp" class="btn btn-success btn-lg mt-3">
                        <i class="fas fa-plus-circle"></i> Add Your First Product
                    </a>
                </div>
            </div>
        <% } %>
    </div>
</div>

<script>
function handleImageError(img, originalSrc) {
    console.error('Image load error:', originalSrc);
    img.onerror = null; // Prevent infinite loop
    img.src = 'images/default';
    img.style.backgroundColor = '#667eea';
    img.style.color = 'white';
    img.style.display = 'flex';
    img.style.alignItems = 'center';
    img.style.justifyContent = 'center';
    img.innerHTML = '<div style="text-align:center;"><i class="fas fa-image fa-3x"></i><br><small>No Image</small></div>';
}
</script>

<%@ include file="footer.jsp" %>