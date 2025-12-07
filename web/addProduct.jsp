<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card shadow-lg border-0 fade-in">
                <div class="card-header text-center py-4" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; border-radius: 15px 15px 0 0;">
                    <i class="fas fa-plus-circle fa-3x mb-3"></i>
                    <h3 class="mb-0">Add New Product</h3>
                    <p class="mb-0 mt-2">List your product and start selling!</p>
                </div>
                <div class="card-body p-4">
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>
                    
                    <form action="AddProductServlet" method="post" enctype="multipart/form-data" id="addProductForm">
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-box"></i> Product Name *
                            </label>
                            <input type="text" name="name" class="form-control" placeholder="Enter product name" required autofocus>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-tag"></i> Category *
                                </label>
                                <select name="category" class="form-select" required>
                                    <option value="">Select Category</option>
                                    <option>Books</option>
                                    <option>Electronics</option>
                                    <option>Furniture</option>
                                    <option>Clothing</option>
                                    <option>Sports</option>
                                    <option>Other</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-4">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-rupee-sign"></i> Price (Rs.) *
                                </label>
                                <input type="number" name="price" class="form-control" step="0.01" min="0" placeholder="0.00" required>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-align-left"></i> Description *
                            </label>
                            <textarea name="description" class="form-control" rows="5" placeholder="Describe your product in detail..." required></textarea>
                            <small class="text-muted">Provide a detailed description to attract more buyers</small>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-image"></i> Product Image (Optional)
                            </label>
                            <input type="file" name="image" id="imageInput" class="form-control" accept="image/jpeg,image/jpg,image/png" onchange="validateImage(this)">
                            <small class="text-muted d-block mt-2">
                                <i class="fas fa-info-circle"></i> Max size: 2MB | Formats: JPG, PNG
                            </small>
                            <div id="imagePreview" class="mt-3"></div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success btn-lg">
                                <span id="submitText">
                                    <i class="fas fa-plus-circle"></i> Add Product
                                </span>
                                <span id="loadingSpinner" class="d-none">
                                    <span class="loading-spinner"></span> Uploading...
                                </span>
                            </button>
                            <a href="home.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function validateImage(input) {
    try {
        const file = input.files[0];
        const preview = document.getElementById('imagePreview');
        
        // Clear previous preview
        if (preview) {
            preview.innerHTML = '';
        }
        
        if (!file) {
            return;
        }
        
        // Check file size (2MB = 2 * 1024 * 1024 bytes)
        if (file.size > 2 * 1024 * 1024) {
            alert('Image size must be less than 2MB!');
            input.value = '';
            if (preview) preview.innerHTML = '';
            return;
        }
        
        // Check file type
        const validTypes = ['image/jpeg', 'image/jpg', 'image/png'];
        const fileType = file.type.toLowerCase();
        if (!validTypes.includes(fileType)) {
            alert('Only JPG and PNG images are allowed!');
            input.value = '';
            if (preview) preview.innerHTML = '';
            return;
        }
        
        // Show preview
        const reader = new FileReader();
        
        reader.onload = function(e) {
            if (preview) {
                preview.innerHTML = 
                    '<div class="card shadow-sm border-0" style="max-width: 300px; animation: fadeIn 0.3s ease;">' +
                    '<img src="' + e.target.result + '" class="card-img-top" style="max-height: 250px; width: 100%; object-fit: cover; border-radius: 10px 10px 0 0;">' +
                    '<div class="card-body text-center p-2">' +
                    '<small class="text-muted"><i class="fas fa-check-circle text-success"></i> Image Preview</small>' +
                    '<br><small class="text-muted">' + (file.size / 1024).toFixed(1) + ' KB</small>' +
                    '</div>' +
                    '</div>';
            }
        };
        
        reader.onerror = function() {
            alert('Error reading image file. Please try again.');
            input.value = '';
            if (preview) preview.innerHTML = '';
        };
        
        reader.readAsDataURL(file);
    } catch (error) {
        console.error('Image preview error:', error);
        alert('Error loading image preview. Please try again.');
    }
}

// Show loading spinner on form submit
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('addProductForm');
    if (form) {
        form.addEventListener('submit', function() {
            const submitText = document.getElementById('submitText');
            const loadingSpinner = document.getElementById('loadingSpinner');
            if (submitText) submitText.classList.add('d-none');
            if (loadingSpinner) loadingSpinner.classList.remove('d-none');
        });
    }
});
</script>

<%@ include file="footer.jsp" %>