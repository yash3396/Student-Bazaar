<%@ include file="header.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 text-center">
            <div class="card shadow">
                <div class="card-body p-5">
                    <i class="fas fa-exclamation-triangle text-danger" style="font-size: 80px;"></i>
                    <h2 class="mt-4">Oops! Something went wrong</h2>
                    <p class="text-muted">
                        <%= request.getParameter("message") != null ? request.getParameter("message") : "An unexpected error occurred." %>
                    </p>
                    <a href="home.jsp" class="btn btn-primary mt-3">
                        <i class="fas fa-home"></i> Go to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>