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

<div class="hero-section text-center">
    <div class="container">
        <h1 class="display-4"><i class="fas fa-shopping-bag"></i> Welcome to Student Bazaar</h1>
        <p class="lead">Buy and Sell Products within Your Campus Community</p>
        <a href="addProduct.jsp" class="btn btn-light btn-lg mt-3">Start Selling</a>
    </div>
</div>

<div class="container my-5">
    <!-- Enhanced Search and Filter Section -->
    <div class="filter-section mb-4 animate-slide-up">
        <form action="SearchServlet" method="get" id="searchForm">
            <!-- Quick Search Options -->
            <div class="mb-3">
                <label class="form-label fw-bold"><i class="fas fa-bolt"></i> Quick Search</label>
                <div class="quick-search-tags">
                    <button type="button" class="btn btn-sm btn-outline-primary quick-search-tag" data-keyword="laptop">
                        <i class="fas fa-laptop"></i> Laptop
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary quick-search-tag" data-keyword="book">
                        <i class="fas fa-book"></i> Books
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary quick-search-tag" data-keyword="phone">
                        <i class="fas fa-mobile-alt"></i> Phone
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary quick-search-tag" data-keyword="bike">
                        <i class="fas fa-bicycle"></i> Bike
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary quick-search-tag" data-keyword="furniture">
                        <i class="fas fa-couch"></i> Furniture
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary quick-search-tag" data-keyword="electronics">
                        <i class="fas fa-plug"></i> Electronics
                    </button>
                </div>
            </div>
            
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label fw-bold"><i class="fas fa-search"></i> Search</label>
                    <div class="position-relative">
                        <input type="text" name="keyword" id="searchKeyword" class="form-control" placeholder="Search products by name or description..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" autocomplete="off">
                        <div id="searchSuggestions" class="search-suggestions"></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold"><i class="fas fa-tag"></i> Category</label>
                    <select name="category" id="categoryFilter" class="form-select">
                        <option value="All">All Categories</option>
                        <option value="Books" <%= "Books".equals(request.getParameter("category")) ? "selected" : "" %>>Books</option>
                        <option value="Electronics" <%= "Electronics".equals(request.getParameter("category")) ? "selected" : "" %>>Electronics</option>
                        <option value="Furniture" <%= "Furniture".equals(request.getParameter("category")) ? "selected" : "" %>>Furniture</option>
                        <option value="Clothing" <%= "Clothing".equals(request.getParameter("category")) ? "selected" : "" %>>Clothing</option>
                        <option value="Sports" <%= "Sports".equals(request.getParameter("category")) ? "selected" : "" %>>Sports</option>
                        <option value="Other" <%= "Other".equals(request.getParameter("category")) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold"><i class="fas fa-sort"></i> Sort By</label>
                    <select id="sortBy" class="form-select">
                        <option value="latest">Latest First</option>
                        <option value="price-low">Price: Low to High</option>
                        <option value="price-high">Price: High to Low</option>
                        <option value="name">Name A-Z</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search"></i> Search
                    </button>
                </div>
            </div>
            <div class="row g-3 mt-2">
                <div class="col-md-6">
                    <label class="form-label fw-bold"><i class="fas fa-rupee-sign"></i> Price Range</label>
                    <div class="d-flex align-items-center gap-2">
                        <input type="number" id="minPrice" class="form-control" placeholder="Min" min="0">
                        <span class="fw-bold">-</span>
                        <input type="number" id="maxPrice" class="form-control" placeholder="Max" min="0">
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold"><i class="fas fa-filter"></i> Status</label>
                    <select id="statusFilter" class="form-select">
                        <option value="all">All Status</option>
                        <option value="Active">Active Only</option>
                        <option value="Sold">Sold Only</option>
                    </select>
                </div>
            </div>
        </form>
    </div>
    
    <!-- Results Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">
            <i class="fas fa-box"></i> Products 
            <span class="badge bg-primary" id="productCount"><%= products != null ? products.size() : 0 %></span>
        </h2>
        <div>
            <button class="btn btn-outline-primary" onclick="resetFilters()">
                <i class="fas fa-redo"></i> Reset Filters
            </button>
        </div>
    </div>
    
    <!-- Products Grid -->
    <div class="row" id="productsContainer">
        <% if (products != null && !products.isEmpty()) {
            for (Product product : products) { %>
                <div class="col-md-4 mb-4 product-item" 
                     data-name="<%= product.getName().toLowerCase() %>"
                     data-category="<%= product.getCategory() %>"
                     data-price="<%= product.getPrice() %>"
                     data-status="<%= product.getStatus() %>">
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
                                    // Ensure it starts with images/ if it's a local path
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
        <%  }
        } else { %>
            <div class="col-12">
                <div class="alert alert-info text-center py-5">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <h4>No products available at the moment.</h4>
                    <p class="mb-0">Check back later or add your own product!</p>
                </div>
            </div>
        <% } %>
    </div>
</div>

<style>
/* Quick Search Tags */
.quick-search-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 10px;
}

.quick-search-tag {
    transition: all 0.3s ease;
    animation: fadeInScale 0.5s ease backwards;
}

.quick-search-tag:nth-child(1) { animation-delay: 0.1s; }
.quick-search-tag:nth-child(2) { animation-delay: 0.2s; }
.quick-search-tag:nth-child(3) { animation-delay: 0.3s; }
.quick-search-tag:nth-child(4) { animation-delay: 0.4s; }
.quick-search-tag:nth-child(5) { animation-delay: 0.5s; }
.quick-search-tag:nth-child(6) { animation-delay: 0.6s; }

.quick-search-tag:hover {
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.quick-search-tag.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-color: transparent;
}

/* Search Suggestions */
.search-suggestions {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border-radius: 10px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    z-index: 1000;
    max-height: 300px;
    overflow-y: auto;
    display: none;
    margin-top: 5px;
    animation: slideDown 0.3s ease;
}

.search-suggestions.show {
    display: block;
}

.suggestion-item {
    padding: 12px 15px;
    cursor: pointer;
    border-bottom: 1px solid #eee;
    transition: all 0.2s ease;
}

.suggestion-item:hover {
    background: #f8f9fa;
    transform: translateX(5px);
}

.suggestion-item:last-child {
    border-bottom: none;
}

/* Animations */
@keyframes fadeInScale {
    from {
        opacity: 0;
        transform: scale(0.8);
    }
    to {
        opacity: 1;
        transform: scale(1);
    }
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-slide-up {
    animation: slideUp 0.6s ease;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Product Card Animations */
.product-item {
    animation: fadeInUp 0.6s ease backwards;
}

.product-item:nth-child(1) { animation-delay: 0.1s; }
.product-item:nth-child(2) { animation-delay: 0.2s; }
.product-item:nth-child(3) { animation-delay: 0.3s; }
.product-item:nth-child(4) { animation-delay: 0.4s; }
.product-item:nth-child(5) { animation-delay: 0.5s; }
.product-item:nth-child(6) { animation-delay: 0.6s; }

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Pulse Animation for Badges */
.badge {
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0%, 100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.05);
    }
}

/* Hover Animations */
.card {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.card:hover {
    transform: translateY(-5px);
}

.btn {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn:hover {
    transform: translateY(-2px);
}

/* Loading Animation */
@keyframes shimmer {
    0% {
        background-position: -1000px 0;
    }
    100% {
        background-position: 1000px 0;
    }
}

.loading-shimmer {
    animation: shimmer 2s infinite;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 1000px 100%;
}
</style>

<script>
// Quick Search Tags
document.addEventListener('DOMContentLoaded', function() {
    // Quick search tag click handlers
    document.querySelectorAll('.quick-search-tag').forEach(tag => {
        tag.addEventListener('click', function() {
            const keyword = this.dataset.keyword;
            document.getElementById('searchKeyword').value = keyword;
            
            // Remove active class from all tags
            document.querySelectorAll('.quick-search-tag').forEach(t => t.classList.remove('active'));
            // Add active class to clicked tag
            this.classList.add('active');
            
            // Trigger search
            document.getElementById('searchForm').submit();
        });
    });
    
    // Search autocomplete
    const searchInput = document.getElementById('searchKeyword');
    const suggestionsDiv = document.getElementById('searchSuggestions');
    const allProducts = Array.from(document.querySelectorAll('.product-item'));
    
    // Popular search terms
    const popularSearches = ['laptop', 'books', 'phone', 'bike', 'furniture', 'electronics', 'clothing', 'sports'];
    
    // Show suggestions on focus
    searchInput.addEventListener('focus', function() {
        showSuggestions();
    });
    
    // Hide suggestions when clicking outside
    document.addEventListener('click', function(e) {
        if (!searchInput.contains(e.target) && !suggestionsDiv.contains(e.target)) {
            suggestionsDiv.classList.remove('show');
        }
    });
    
    // Show suggestions based on input
    searchInput.addEventListener('input', function() {
        const value = this.value.toLowerCase().trim();
        if (value.length > 0) {
            showSuggestions(value);
        } else {
            showSuggestions();
        }
    });
    
    function showSuggestions(filter = '') {
        suggestionsDiv.innerHTML = '';
        
        if (filter.length === 0) {
            // Show popular searches
            const popularDiv = document.createElement('div');
            popularDiv.className = 'suggestion-item fw-bold text-muted';
            popularDiv.innerHTML = '<i class="fas fa-fire"></i> Popular Searches';
            suggestionsDiv.appendChild(popularDiv);
            
            popularSearches.forEach(term => {
                const item = document.createElement('div');
                item.className = 'suggestion-item';
                item.innerHTML = `<i class="fas fa-search"></i> ${term}`;
                item.addEventListener('click', function() {
                    searchInput.value = term;
                    document.getElementById('searchForm').submit();
                });
                suggestionsDiv.appendChild(item);
            });
        } else {
            // Show matching products
            const matching = allProducts.filter(product => {
                const name = product.dataset.name;
                const category = product.dataset.category.toLowerCase();
                return name.includes(filter) || category.includes(filter);
            }).slice(0, 5);
            
            if (matching.length > 0) {
                matching.forEach(product => {
                    const item = document.createElement('div');
                    item.className = 'suggestion-item';
                    const productName = product.querySelector('.card-title').textContent;
                    item.innerHTML = `<i class="fas fa-box"></i> ${productName}`;
                    item.addEventListener('click', function() {
                        const link = product.querySelector('a[href*="ProductDetailsServlet"]');
                        if (link) window.location.href = link.href;
                    });
                    suggestionsDiv.appendChild(item);
                });
            } else {
                const noResults = document.createElement('div');
                noResults.className = 'suggestion-item text-muted';
                noResults.innerHTML = '<i class="fas fa-info-circle"></i> No matches found';
                suggestionsDiv.appendChild(noResults);
            }
        }
        
        suggestionsDiv.classList.add('show');
    }
    
    // Client-side filtering and sorting
    const sortSelect = document.getElementById('sortBy');
    const statusFilter = document.getElementById('statusFilter');
    const minPrice = document.getElementById('minPrice');
    const maxPrice = document.getElementById('maxPrice');
    
    function filterAndSort() {
        const products = document.querySelectorAll('.product-item');
        const sortValue = sortSelect.value;
        const statusValue = statusFilter.value;
        const minPriceValue = parseFloat(minPrice.value) || 0;
        const maxPriceValue = parseFloat(maxPrice.value) || Infinity;
        
        let visibleProducts = Array.from(products).filter(product => {
            const price = parseFloat(product.dataset.price);
            const status = product.dataset.status;
            
            // Filter by status
            if (statusValue !== 'all' && status !== statusValue) {
                return false;
            }
            
            // Filter by price range
            if (price < minPriceValue || price > maxPriceValue) {
                return false;
            }
            
            return true;
        });
        
        // Sort products
        visibleProducts.sort((a, b) => {
            switch(sortValue) {
                case 'price-low':
                    return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                case 'price-high':
                    return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                case 'name':
                    return a.dataset.name.localeCompare(b.dataset.name);
                default: // latest
                    return 0;
            }
        });
        
        // Hide all products
        products.forEach(p => p.style.display = 'none');
        
        // Show filtered and sorted products
        visibleProducts.forEach(p => p.style.display = 'block');
        
        // Update count
        document.getElementById('productCount').textContent = visibleProducts.length;
        
        // Show message if no products
        const container = document.getElementById('productsContainer');
        if (visibleProducts.length === 0) {
            if (!container.querySelector('.no-results')) {
                const noResults = document.createElement('div');
                noResults.className = 'col-12 no-results';
                noResults.innerHTML = `
                    <div class="alert alert-warning text-center py-5">
                        <i class="fas fa-search fa-3x mb-3"></i>
                        <h4>No products match your filters.</h4>
                        <button class="btn btn-primary mt-3" onclick="resetFilters()">Reset Filters</button>
                    </div>
                `;
                container.appendChild(noResults);
            }
        } else {
            const noResults = container.querySelector('.no-results');
            if (noResults) noResults.remove();
        }
    }
    
    if (sortSelect) sortSelect.addEventListener('change', filterAndSort);
    if (statusFilter) statusFilter.addEventListener('change', filterAndSort);
    if (minPrice) minPrice.addEventListener('input', filterAndSort);
    if (maxPrice) maxPrice.addEventListener('input', filterAndSort);
});

function resetFilters() {
    document.getElementById('searchKeyword').value = '';
    document.getElementById('categoryFilter').value = 'All';
    document.getElementById('sortBy').value = 'latest';
    document.getElementById('statusFilter').value = 'all';
    document.getElementById('minPrice').value = '';
    document.getElementById('maxPrice').value = '';
    
    // Show all products
    document.querySelectorAll('.product-item').forEach(p => p.style.display = 'block');
    document.getElementById('productCount').textContent = document.querySelectorAll('.product-item').length;
    
    const noResults = document.querySelector('.no-results');
    if (noResults) noResults.remove();
}

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