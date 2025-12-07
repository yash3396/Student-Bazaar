<%@ page import="com.studentbazaar.models.Product" %>
<%@ page import="java.util.List" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Product> products = (List<Product>) request.getAttribute("products");
    String keyword = (String) request.getAttribute("keyword");
    String category = (String) request.getAttribute("category");
%>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="text-gradient mb-1">
                <i class="fas fa-search"></i> Search Results
            </h2>
            <p class="text-muted mb-0">
                <% if (keyword != null && !keyword.isEmpty()) { %>
                    Searching for: "<strong><%= keyword %></strong>"
                <% } %>
                <% if (category != null && !category.isEmpty() && !category.equals("All")) { %>
                    in <strong><%= category %></strong> category
                <% } %>
            </p>
        </div>
        <a href="home.jsp" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>
    </div>
    
    <% if (products != null && !products.isEmpty()) { %>
        <div class="alert alert-info mb-4">
            <i class="fas fa-info-circle"></i> Found <strong><%= products.size() %></strong> product<%= products.size() != 1 ? "s" : "" %> matching your search criteria.
        </div>
        
        <div class="row">
            <% for (Product product : products) { %>
                <div class="col-md-4 mb-4">
                    <div class="card product-card h-100">
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
                                <%= product.getStatus() %>
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
                                <%= product.getDescription().length() > 100 ? product.getDescription().substring(0, 100) + "..." : product.getDescription() %>
                            </p>
                            <div class="mt-auto">
                                <a href="ProductDetailsServlet?id=<%= product.getProductId() %>" class="btn btn-primary w-100">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="alert alert-warning text-center py-5">
            <i class="fas fa-search fa-4x mb-4 text-warning"></i>
            <h3>No Products Found</h3>
            <p class="lead">We couldn't find any products matching your search criteria.</p>
            <div class="mt-4">
                <a href="home.jsp" class="btn btn-primary btn-lg me-2">
                    <i class="fas fa-home"></i> Back to Home
                </a>
                <a href="addProduct.jsp" class="btn btn-success btn-lg">
                    <i class="fas fa-plus"></i> Add Product
                </a>
            </div>
        </div>
    <% } %>
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