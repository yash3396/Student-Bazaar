<%@ page import="com.studentbazaar.models.User" %>
<%@ page import="com.studentbazaar.dao.ProductDAO" %>
<%@ page import="com.studentbazaar.dao.TransactionDAO" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    
    ProductDAO productDAO = new ProductDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    int totalListings = productDAO.getProductsBySeller(user.getUserId()).size();
    int totalPurchases = transactionDAO.getTransactionsByBuyer(user.getUserId()).size();
%>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-lg profile-card">
                <div class="card-header bg-gradient-primary text-white text-center py-4">
                    <div class="profile-avatar">
                        <i class="fas fa-user-circle fa-5x"></i>
                    </div>
                    <h2 class="mt-3 mb-0"><%= user.getName() %></h2>
                    <p class="mb-0"><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
                </div>
                <div class="card-body p-4">
                    <h4 class="mb-4"><i class="fas fa-info-circle"></i> Profile Information</h4>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-user"></i> Full Name:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getName() %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-envelope"></i> Email:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getEmail() %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-phone"></i> Phone:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getPhone() %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-id-card"></i> College ID:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getCollegeId() != null ? user.getCollegeId() : "N/A" %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-building"></i> Department:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getDepartment() != null ? user.getDepartment() : "N/A" %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-graduation-cap"></i> Year:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getYear() != null ? user.getYear() : "N/A" %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-venus-mars"></i> Gender:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getGender() != null ? user.getGender() : "N/A" %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-map-marker-alt"></i> Address:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getAddress() != null ? user.getAddress() : "N/A" %>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <strong><i class="fas fa-calendar"></i> Member Since:</strong>
                        </div>
                        <div class="col-md-8">
                            <%= user.getDateRegistered() != null ? user.getDateRegistered().toString().substring(0, 10) : "N/A" %>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <h4 class="mb-4"><i class="fas fa-chart-bar"></i> Activity Summary</h4>
                    
                    <div class="row text-center">
                        <div class="col-md-6 mb-3">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-box fa-3x text-primary"></i>
                                </div>
                                <h3 class="mt-3"><%= totalListings %></h3>
                                <p class="text-muted">Total Listings</p>
                                <a href="myListings.jsp" class="btn btn-sm btn-outline-primary">View Listings</a>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-shopping-bag fa-3x text-success"></i>
                                </div>
                                <h3 class="mt-3"><%= totalPurchases %></h3>
                                <p class="text-muted">Total Purchases</p>
                                <a href="myPurchases.jsp" class="btn btn-sm btn-outline-success">View Purchases</a>
                            </div>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="d-grid gap-2">
                        <a href="home.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .profile-card {
        border-radius: 15px;
        overflow: hidden;
        animation: fadeInUp 0.6s ease-out;
    }
    
    .bg-gradient-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    
    .profile-avatar {
        animation: bounceIn 0.8s ease-out;
    }
    
    .stat-card {
        padding: 20px;
        border-radius: 10px;
        background: #f8f9fa;
        transition: all 0.3s ease;
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    
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
    
    @keyframes bounceIn {
        0% {
            transform: scale(0);
        }
        50% {
            transform: scale(1.1);
        }
        100% {
            transform: scale(1);
        }
    }
</style>

<%@ include file="footer.jsp" %>
