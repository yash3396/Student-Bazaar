<%@ page import="com.studentbazaar.dao.TransactionDAO" %>
<%@ page import="com.studentbazaar.models.Transaction" %>
<%@ page import="java.util.List" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    TransactionDAO transactionDAO = new TransactionDAO();
    List<Transaction> purchases = transactionDAO.getTransactionsByBuyer(userId);
%>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">
            <i class="fas fa-shopping-bag"></i> My Purchases
        </h2>
        <a href="home.jsp" class="btn btn-primary">
            <i class="fas fa-plus"></i> Browse More Products
        </a>
    </div>
    
    <% if (purchases != null && !purchases.isEmpty()) { %>
        <div class="row">
            <% for (Transaction transaction : purchases) { %>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card product-card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="card-title mb-1">
                                        <i class="fas fa-box text-primary"></i> Product #<%= transaction.getProductId() %>
                                    </h5>
                                    <p class="text-muted small mb-0">
                                        <i class="fas fa-calendar"></i> <%= transaction.getDate() %>
                                    </p>
                                </div>
                                <span class="badge bg-success">
                                    <i class="fas fa-check-circle"></i> Completed
                                </span>
                            </div>
                            
                            <div class="mb-3">
                                <p class="mb-2">
                                    <strong><i class="fas fa-credit-card"></i> Payment Mode:</strong>
                                    <span class="badge bg-info"><%= transaction.getMode() %></span>
                                </p>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <a href="ProductDetailsServlet?id=<%= transaction.getProductId() %>" class="btn btn-primary">
                                    <i class="fas fa-eye"></i> View Product Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
        
        <!-- Summary Card -->
        <div class="card shadow-sm mt-4">
            <div class="card-body">
                <div class="row text-center">
                    <div class="col-md-4">
                        <h3 class="text-primary"><%= purchases.size() %></h3>
                        <p class="text-muted mb-0">Total Purchases</p>
                    </div>
                    <div class="col-md-4">
                        <h3 class="text-success">
                            <i class="fas fa-check-circle"></i>
                        </h3>
                        <p class="text-muted mb-0">All Completed</p>
                    </div>
                    <div class="col-md-4">
                        <h3 class="text-info">
                            <i class="fas fa-shopping-bag"></i>
                        </h3>
                        <p class="text-muted mb-0">Active Orders</p>
                    </div>
                </div>
            </div>
        </div>
    <% } else { %>
        <div class="alert alert-info text-center py-5">
            <i class="fas fa-shopping-bag fa-4x mb-4 text-primary"></i>
            <h3>No Purchases Yet</h3>
            <p class="lead">You haven't made any purchases yet. Start shopping now!</p>
            <a href="home.jsp" class="btn btn-primary btn-lg mt-3">
                <i class="fas fa-search"></i> Browse Products
            </a>
        </div>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
