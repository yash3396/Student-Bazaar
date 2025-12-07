<%@ page import="com.studentbazaar.dao.OfferDAO" %>
<%@ page import="com.studentbazaar.models.Offer" %>
<%@ page import="java.util.List" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    OfferDAO offerDAO = new OfferDAO();
    List<Offer> receivedOffers = offerDAO.getOffersBySeller(userId);
    List<Offer> sentOffers = offerDAO.getOffersByBuyer(userId);
    
    // Count pending offers
    int pendingCount = 0;
    for (Offer offer : receivedOffers) {
        if (offer.getStatus().equals("Pending")) {
            pendingCount++;
        }
    }
%>

<div class="container my-5">
    <h2 class="mb-4"><i class="fas fa-inbox"></i> My Inbox</h2>
    
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success alert-dismissible fade show">
            <%= request.getParameter("success") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show">
            <%= request.getParameter("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    
    <!-- Received Offers Tab -->
    <ul class="nav nav-tabs mb-4" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" data-bs-toggle="tab" href="#received">
                <i class="fas fa-envelope"></i> Received Offers 
                <% if (pendingCount > 0) { %>
                    <span class="badge bg-danger"><%= pendingCount %></span>
                <% } %>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#sent">
                <i class="fas fa-paper-plane"></i> Sent Offers
            </a>
        </li>
    </ul>
    
    <div class="tab-content">
        <!-- Received Offers -->
        <div id="received" class="tab-pane fade show active">
            <% if (receivedOffers != null && !receivedOffers.isEmpty()) { %>
                <% for (Offer offer : receivedOffers) { %>
                    <div class="card mb-3 offer-card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <h5 class="card-title">
                                        <%= offer.getProductName() %>
                                        <span class="badge bg-<%= offer.getStatus().equals("Pending") ? "warning" : offer.getStatus().equals("Accepted") ? "success" : "danger" %>">
                                            <%= offer.getStatus() %>
                                        </span>
                                    </h5>
                                    <p class="mb-2">
                                        <strong>From:</strong> <%= offer.getBuyerName() %> 
                                        (<a href="mailto:<%= offer.getBuyerEmail() %>"><%= offer.getBuyerEmail() %></a>)
                                    </p>
                                    <p class="mb-2">
                                        <strong>Phone:</strong> <a href="tel:<%= offer.getBuyerPhone() %>"><%= offer.getBuyerPhone() %></a>
                                    </p>
                                    <p class="mb-2">
                                        <strong>Your Price:</strong> <span class="text-muted">Rs. <%= offer.getProductPrice() %></span> | 
                                        <strong>Offered Price:</strong> <span class="text-primary fw-bold">Rs. <%= offer.getOfferedPrice() %></span>
                                    </p>
                                    <% if (offer.getMessage() != null && !offer.getMessage().isEmpty()) { %>
                                        <p class="mb-2"><strong>Message:</strong> <%= offer.getMessage() %></p>
                                    <% } %>
                                    <p class="text-muted small mb-0">
                                        <i class="fas fa-clock"></i> <%= offer.getCreatedAt() %>
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <% if (offer.getStatus().equals("Pending")) { %>
                                        <form action="ManageOfferServlet" method="post" class="d-inline">
                                            <input type="hidden" name="offerId" value="<%= offer.getOfferId() %>">
                                            <input type="hidden" name="action" value="accept">
                                            <button type="submit" class="btn btn-success mb-2 w-100">
                                                <i class="fas fa-check"></i> Accept
                                            </button>
                                        </form>
                                        <form action="ManageOfferServlet" method="post" class="d-inline">
                                            <input type="hidden" name="offerId" value="<%= offer.getOfferId() %>">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn btn-danger w-100">
                                                <i class="fas fa-times"></i> Reject
                                            </button>
                                        </form>
                                    <% } %>
                                    <a href="ProductDetailsServlet?id=<%= offer.getProductId() %>" class="btn btn-outline-primary w-100 mt-2">
                                        <i class="fas fa-eye"></i> View Product
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="alert alert-info text-center">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <h4>No offers received yet</h4>
                    <p>When buyers make offers on your products, they will appear here.</p>
                </div>
            <% } %>
        </div>
        
        <!-- Sent Offers -->
        <div id="sent" class="tab-pane fade">
            <% if (sentOffers != null && !sentOffers.isEmpty()) { %>
                <% for (Offer offer : sentOffers) { %>
                    <div class="card mb-3 offer-card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-9">
                                    <h5 class="card-title">
                                        <%= offer.getProductName() %>
                                        <span class="badge bg-<%= offer.getStatus().equals("Pending") ? "warning" : offer.getStatus().equals("Accepted") ? "success" : "danger" %>">
                                            <%= offer.getStatus() %>
                                        </span>
                                    </h5>
                                    <p class="mb-2">
                                        <strong>Original Price:</strong> <span class="text-muted">Rs. <%= offer.getProductPrice() %></span> | 
                                        <strong>Your Offer:</strong> <span class="text-primary fw-bold">Rs. <%= offer.getOfferedPrice() %></span>
                                    </p>
                                    <% if (offer.getMessage() != null && !offer.getMessage().isEmpty()) { %>
                                        <p class="mb-2"><strong>Your Message:</strong> <%= offer.getMessage() %></p>
                                    <% } %>
                                    <p class="text-muted small mb-0">
                                        <i class="fas fa-clock"></i> <%= offer.getCreatedAt() %>
                                    </p>
                                </div>
                                <div class="col-md-3 text-end">
                                    <a href="ProductDetailsServlet?id=<%= offer.getProductId() %>" class="btn btn-outline-primary w-100">
                                        <i class="fas fa-eye"></i> View Product
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="alert alert-info text-center">
                    <i class="fas fa-paper-plane fa-3x mb-3"></i>
                    <h4>No offers sent yet</h4>
                    <p>Start making offers on products you're interested in!</p>
                    <a href="home.jsp" class="btn btn-primary mt-2">Browse Products</a>
                </div>
            <% } %>
        </div>
    </div>
</div>

<style>
    .offer-card {
        transition: all 0.3s ease;
        border-left: 4px solid #667eea;
    }
    
    .offer-card:hover {
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        transform: translateY(-2px);
    }
    
    .nav-tabs .nav-link {
        color: #666;
        font-weight: 500;
    }
    
    .nav-tabs .nav-link.active {
        color: #667eea;
        font-weight: 600;
    }
</style>

<%@ include file="footer.jsp" %>
