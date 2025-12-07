<%@ page import="utils.PasswordUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Password Hash Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Password Hash Test</h2>
        
        <form method="post">
            <div class="mb-3">
                <label class="form-label">Enter Password:</label>
                <input type="text" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Hash Password</button>
        </form>
        
        <%
            String password = request.getParameter("password");
            if (password != null && !password.isEmpty()) {
                String hashed = PasswordUtil.hashPassword(password);
        %>
                <div class="alert alert-success mt-3">
                    <h4>Results:</h4>
                    <p><strong>Original:</strong> <%= password %></p>
                    <p><strong>Hashed:</strong> <%= hashed %></p>
                    <p><strong>Length:</strong> <%= hashed.length() %> characters</p>
                </div>
                
                <div class="alert alert-info">
                    <h5>Test with admin123:</h5>
                    <p><strong>admin123 hashed:</strong> <%= PasswordUtil.hashPassword("admin123") %></p>
                </div>
        <%
            }
        %>
        
        <hr>
        <a href="TestConnectionServlet" class="btn btn-secondary">Test Database Connection</a>
        <a href="login.jsp" class="btn btn-primary">Go to Login</a>
    </div>
</body>
</html>