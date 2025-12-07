<%@ page import="com.studentbazaar.models.Product" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("error.jsp");
        return;
    }
    
    int currentUserId = (Integer) session.getAttribute("userId");
    boolean isOwner = (product.getSellerId() == currentUserId);
    boolean isSold = product.getStatus().equals("Sold");
%>

<div class="container my-5">
    <div class="row mb-3 animate-slide-in-left">
        <div class="col-12">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                    <li class="breadcrumb-item"><a href="home.jsp">Products</a></li>
                    <li class="breadcrumb-item active"><%= product.getName() %></li>
                </ol>
            </nav>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-6 mb-4 animate-slide-in-left">
            <div class="card shadow-lg border-0 hover-lift">
                <div class="card-body p-0">
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
                         class="img-fluid w-100 rounded-top product-image" 
                         alt="<%= product.getName() %>" 
                         style="max-height: 500px; object-fit: cover; background-color: #f0f0f0; min-height: 300px; width: 100%;"
                         onerror="handleImageError(this, '<%= imageUrl.replace("'", "\\'") %>');">
                </div>
            </div>
        </div>
        
        <div class="col-md-6 animate-slide-in-right">
            <div class="card shadow-lg border-0 h-100 hover-lift">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="flex-grow-1">
                            <h2 class="text-gradient mb-2"><%= product.getName() %></h2>
                            <p class="text-muted mb-2">
                                <i class="fas fa-tag"></i> <span class="badge bg-info"><%= product.getCategory() %></span>
                            </p>
                        </div>
                        <span class="badge bg-<%= isSold ? "secondary" : "success" %> fs-6 px-3 py-2">
                            <i class="fas fa-<%= isSold ? "check-circle" : "circle" %>"></i> <%= product.getStatus() %>
                        </span>
                    </div>
                    
                    <div class="mb-4">
                        <h3 class="text-primary mb-0">
                            <i class="fas fa-rupee-sign"></i> <%= product.getPrice() %>
                        </h3>
                        <small class="text-muted">Listed Price</small>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="mb-4">
                        <h5 class="mb-3">
                            <i class="fas fa-align-left"></i> Description
                        </h5>
                        <p class="text-muted" style="line-height: 1.8;"><%= product.getDescription() %></p>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="mb-4">
                        <h5 class="mb-3">
                            <i class="fas fa-user-circle"></i> Seller Information
                        </h5>
                        <div class="card bg-light">
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li class="mb-2">
                                        <i class="fas fa-user text-primary"></i> 
                                        <strong>Name:</strong> <%= product.getSellerName() %>
                                    </li>
                                    <li class="mb-2">
                                        <i class="fas fa-envelope text-primary"></i> 
                                        <strong>Email:</strong> 
                                        <a href="mailto:<%= product.getSellerEmail() %>"><%= product.getSellerEmail() %></a>
                                    </li>
                                    <li class="mb-0">
                                        <i class="fas fa-phone text-primary"></i> 
                                        <strong>Phone:</strong> 
                                        <a href="tel:<%= product.getSellerPhone() %>"><%= product.getSellerPhone() %></a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="d-grid gap-2">
                        <% if (!isOwner && !isSold) { %>
                            <button type="button" class="btn btn-warning btn-lg w-100" data-bs-toggle="modal" data-bs-target="#offerModal">
                                <i class="fas fa-hand-holding-usd"></i> Make an Offer
                            </button>
                            <form action="BuyProductServlet" method="post" onsubmit="return confirm('Are you sure you want to buy this product?')">
                                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                <button type="submit" class="btn btn-success btn-lg w-100">
                                    <i class="fas fa-shopping-cart"></i> Buy Now
                                </button>
                            </form>
                        <% } else if (isSold) { %>
                            <button class="btn btn-secondary btn-lg w-100" disabled>
                                <i class="fas fa-check-circle"></i> Sold Out
                            </button>
                        <% } %>
                        
                        <div class="row g-2">
                            <div class="col-6">
                                <a href="mailto:<%= product.getSellerEmail() %>" class="btn btn-primary w-100">
                                    <i class="fas fa-envelope"></i> Email
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="tel:<%= product.getSellerPhone() %>" class="btn btn-info w-100">
                                    <i class="fas fa-phone"></i> Call
                                </a>
                            </div>
                        </div>
                        
                        <% if (!isOwner) { %>
                            <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#reportModal">
                                <i class="fas fa-flag"></i> Report as Spam
                            </button>
                        <% } %>
                        
                        <a href="home.jsp" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Products
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Make Offer Modal -->
<div class="modal fade" id="offerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg">
            <div class="modal-header" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; border-radius: 15px 15px 0 0;">
                <h5 class="modal-title">
                    <i class="fas fa-hand-holding-usd"></i> Make an Offer
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="MakeOfferServlet" method="post" id="offerForm">
                <div class="modal-body p-4">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                    <div class="alert alert-info mb-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <strong><i class="fas fa-box"></i> Product:</strong> <%= product.getName() %><br>
                                <strong><i class="fas fa-rupee-sign"></i> Listed Price:</strong> Rs. <%= product.getPrice() %>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-rupee-sign"></i> Your Offer Price (Rs.) *
                        </label>
                        <input type="number" name="offeredPrice" id="offeredPrice" class="form-control" 
                               step="0.01" min="1" max="<%= product.getPrice() %>" required 
                               placeholder="Enter your offer price" oninput="updateOfferDifference()">
                        <small class="text-muted">
                            <span id="offerDifference"></span>
                        </small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">
                            <i class="fas fa-comment"></i> Message (Optional)
                        </label>
                        <textarea name="message" class="form-control" rows="3" 
                                  placeholder="Add a message to the seller..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-paper-plane"></i> Send Offer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function updateOfferDifference() {
    const offeredPrice = parseFloat(document.getElementById('offeredPrice').value);
    const listedPrice = <%= product.getPrice() %>;
    const difference = listedPrice - offeredPrice;
    const percentage = ((difference / listedPrice) * 100).toFixed(1);
    
    const diffElement = document.getElementById('offerDifference');
    if (offeredPrice && offeredPrice <= listedPrice) {
        if (difference > 0) {
            diffElement.innerHTML = `You're offering Rs. ${difference.toFixed(2)} less (${percentage}% discount)`;
            diffElement.className = 'text-success';
        } else {
            diffElement.innerHTML = 'You're offering the full listed price';
            diffElement.className = 'text-info';
        }
    } else if (offeredPrice > listedPrice) {
        diffElement.innerHTML = 'Offer cannot exceed listed price';
        diffElement.className = 'text-danger';
    } else {
        diffElement.innerHTML = 'Enter a price lower than or equal to the listed price';
        diffElement.className = 'text-muted';
    }
}
</script>

<!-- Report Spam Modal -->
<div class="modal fade" id="reportModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Report Product as Spam</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="ReportSpamServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                    <div class="mb-3">
                        <label class="form-label">Reason for reporting *</label>
                        <textarea name="reason" class="form-control" rows="4" required placeholder="Please describe why you're reporting this product..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Submit Report</button>
                </div>
            </form>
        </div>
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
    img.innerHTML = '<div style="text-align:center;"><i class="fas fa-image fa-4x"></i><br><h5>No Image Available</h5></div>';
}
</script>

<%@ include file="footer.jsp" %>