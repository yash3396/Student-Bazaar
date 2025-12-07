<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Bazaar - Campus Marketplace</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .feature-card {
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin: 20px 0;
            transition: transform 0.3s;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <div class="hero-section">
        <div class="container text-center">
            <h1 class="display-3 mb-4">
                <i class="fas fa-shopping-bag"></i> Student Bazaar
            </h1>
            <p class="lead mb-5">Your Campus Marketplace - Buy and Sell with Fellow Students</p>
            
            <% if (System.getenv("DATABASE_URL") == null) { %>
                <div class="alert alert-warning d-inline-block">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Setup Required:</strong> Please configure the database to use this application.
                    <br><small>Add a PostgreSQL database in Railway and set the DATABASE_URL variable.</small>
                </div>
            <% } else { %>
                <div class="mb-4">
                    <a href="login.jsp" class="btn btn-light btn-lg mx-2">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                    <a href="register.jsp" class="btn btn-outline-light btn-lg mx-2">
                        <i class="fas fa-user-plus"></i> Register
                    </a>
                </div>
            <% } %>
            
            <div class="row mt-5">
                <div class="col-md-4">
                    <div class="feature-card bg-white text-dark">
                        <i class="fas fa-tags fa-3x text-primary mb-3"></i>
                        <h4>Buy & Sell</h4>
                        <p>Find great deals on textbooks, electronics, furniture and more from fellow students.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card bg-white text-dark">
                        <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                        <h4>Safe & Secure</h4>
                        <p>Trade within your campus community with verified student accounts.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card bg-white text-dark">
                        <i class="fas fa-comments fa-3x text-info mb-3"></i>
                        <h4>Easy Communication</h4>
                        <p>Built-in messaging system to connect buyers and sellers instantly.</p>
                    </div>
                </div>
            </div>
            
            <div class="mt-5">
                <p class="text-white-50">
                    <i class="fas fa-check-circle"></i> Deployment Status: 
                    <span class="badge bg-success">Active</span>
                </p>
                <p class="text-white-50">
                    <i class="fas fa-server"></i> Server: Jetty 9.4.51
                </p>
            </div>
        </div>
    </div>
</body>
</html>
