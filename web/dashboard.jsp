<%@ page import="com.studentbazaar.dao.ProductDAO" %>
<%@ page import="com.studentbazaar.dao.TransactionDAO" %>
<%@ page import="com.studentbazaar.dao.OfferDAO" %>
<%@ page import="com.studentbazaar.models.User" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    ProductDAO productDAO = new ProductDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    OfferDAO offerDAO = new OfferDAO();
    
    int totalListings = productDAO.getProductsBySeller(userId).size();
    int activeListings = 0;
    java.util.List<com.studentbazaar.models.Product> sellerProducts = productDAO.getProductsBySeller(userId);
    for (com.studentbazaar.models.Product p : sellerProducts) {
        if (p.getStatus() != null && p.getStatus().equals("Active")) {
            activeListings++;
        }
    }
    int totalPurchases = transactionDAO.getTransactionsByBuyer(userId).size();
    int pendingOffers = offerDAO.getPendingOffersCount(userId);
    int receivedOffers = offerDAO.getOffersBySeller(userId).size();
    int sentOffers = offerDAO.getOffersByBuyer(userId).size();
%>

<div class="container my-5">
    <div class="row mb-4 animate-slide-in-left">
        <div class="col-12">
            <h1 class="text-gradient animate-scale-in">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </h1>
            <p class="text-muted">Welcome back, <%= session.getAttribute("userName") %>! Here's your activity overview.</p>
        </div>
    </div>
    
    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-md-3 col-sm-6 mb-4 stagger-item">
            <div class="dashboard-card hover-lift">
                <div class="icon">
                    <i class="fas fa-box"></i>
                </div>
                <div class="number"><%= totalListings %></div>
                <div class="label">Total Listings</div>
                <a href="myListings.jsp" class="btn btn-sm btn-outline-primary mt-3">
                    <i class="fas fa-eye"></i> View All
                </a>
            </div>
        </div>
        
        <div class="col-md-3 col-sm-6 mb-4 stagger-item">
            <div class="dashboard-card hover-lift">
                <div class="icon animate-float" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="number" style="color: #38ef7d;"><%= activeListings %></div>
                <div class="label">Active Listings</div>
                <a href="myListings.jsp" class="btn btn-sm btn-outline-success mt-3">
                    <i class="fas fa-list"></i> Manage
                </a>
            </div>
        </div>
        
        <div class="col-md-3 col-sm-6 mb-4 stagger-item">
            <div class="dashboard-card hover-lift">
                <div class="icon animate-float" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="number" style="color: #f5576c;"><%= totalPurchases %></div>
                <div class="label">Total Purchases</div>
                <a href="myPurchases.jsp" class="btn btn-sm btn-outline-danger mt-3">
                    <i class="fas fa-history"></i> View History
                </a>
            </div>
        </div>
        
        <div class="col-md-3 col-sm-6 mb-4 stagger-item">
            <div class="dashboard-card hover-lift">
                <div class="icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    <i class="fas fa-inbox"></i>
                </div>
                <div class="number" style="color: #fa709a;"><%= pendingOffers %></div>
                <div class="label">Pending Offers</div>
                <a href="inbox.jsp" class="btn btn-sm btn-outline-warning mt-3">
                    <i class="fas fa-envelope"></i> View Inbox
                </a>
            </div>
        </div>
    </div>
    
    <!-- Quick Actions -->
    <div class="row mb-4">
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="addProduct.jsp" class="btn btn-success">
                            <i class="fas fa-plus-circle"></i> Add New Product
                        </a>
                        <a href="home.jsp" class="btn btn-primary">
                            <i class="fas fa-search"></i> Browse Products
                        </a>
                        <a href="inbox.jsp" class="btn btn-warning">
                            <i class="fas fa-inbox"></i> View Offers
                            <% if (pendingOffers > 0) { %>
                                <span class="badge bg-danger"><%= pendingOffers %></span>
                            <% } %>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-line"></i> Activity Summary</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="fas fa-box text-primary"></i> Products Listed</span>
                            <strong><%= totalListings %></strong>
                        </div>
                        <div class="progress" style="height: 8px;">
                            <div class="progress-bar bg-primary" style="width: <%= totalListings > 0 ? 100 : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="fas fa-shopping-bag text-success"></i> Products Purchased</span>
                            <strong><%= totalPurchases %></strong>
                        </div>
                        <div class="progress" style="height: 8px;">
                            <div class="progress-bar bg-success" style="width: <%= totalPurchases > 0 ? 100 : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="fas fa-paper-plane text-info"></i> Offers Sent</span>
                            <strong><%= sentOffers %></strong>
                        </div>
                        <div class="progress" style="height: 8px;">
                            <div class="progress-bar bg-info" style="width: <%= sentOffers > 0 ? 100 : 0 %>%"></div>
                        </div>
                    </div>
                    
                    <div>
                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="fas fa-envelope text-warning"></i> Offers Received</span>
                            <strong><%= receivedOffers %></strong>
                        </div>
                        <div class="progress" style="height: 8px;">
                            <div class="progress-bar bg-warning" style="width: <%= receivedOffers > 0 ? 100 : 0 %>%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Recent Activity -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-clock"></i> Recent Activity</h5>
                </div>
                <div class="card-body">
                    <div class="list-group">
                        <a href="myListings.jsp" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1"><i class="fas fa-box text-primary"></i> Your Listings</h6>
                                <small class="text-muted">View all</small>
                            </div>
                            <p class="mb-1">You have <%= activeListings %> active product<%= activeListings != 1 ? "s" : "" %> listed</p>
                        </a>
                        
                        <a href="inbox.jsp" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1"><i class="fas fa-inbox text-warning"></i> Offers</h6>
                                <% if (pendingOffers > 0) { %>
                                    <span class="badge bg-danger"><%= pendingOffers %> new</span>
                                <% } else { %>
                                    <small class="text-muted">No new offers</small>
                                <% } %>
                            </div>
                            <p class="mb-1">You have <%= receivedOffers %> total offer<%= receivedOffers != 1 ? "s" : "" %> received</p>
                        </a>
                        
                        <a href="myPurchases.jsp" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1"><i class="fas fa-shopping-bag text-success"></i> Purchases</h6>
                                <small class="text-muted">View history</small>
                            </div>
                            <p class="mb-1">You have made <%= totalPurchases %> purchase<%= totalPurchases != 1 ? "s" : "" %></p>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.dashboard-card {
    background: white;
    border-radius: 15px;
    padding: 30px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    text-align: center;
    height: 100%;
}

.dashboard-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

.dashboard-card .icon {
    font-size: 48px;
    margin-bottom: 15px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.dashboard-card .number {
    font-size: 36px;
    font-weight: bold;
    color: #667eea;
    margin: 10px 0;
}

.dashboard-card .label {
    color: #6c757d;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.list-group-item {
    border: none;
    border-bottom: 1px solid #eee;
    transition: all 0.3s ease;
}

.list-group-item:hover {
    background-color: #f8f9fa;
    transform: translateX(5px);
}

.list-group-item:last-child {
    border-bottom: none;
}
</style>

<%@ include file="footer.jsp" %>

