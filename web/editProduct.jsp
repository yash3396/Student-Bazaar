<%@ page import="com.studentbazaar.models.Product" %>
<%@ include file="header.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("myListings.jsp");
        return;
    }
%>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="fas fa-edit"></i> Edit Product</h3>
                </div>
                <div class="card-body">
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                    <% } %>
                    
                    <form action="EditProductServlet" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                        
                        <div class="mb-3">
                            <label class="form-label">Product Name *</label>
                            <input type="text" name="name" class="form-control" value="<%= product.getName() %>" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Category *</label>
                                <select name="category" class="form-control" required>
                                    <option value="">Select Category</option>
                                    <option <%= product.getCategory().equals("Books") ? "selected" : "" %>>Books</option>
                                    <option <%= product.getCategory().equals("Electronics") ? "selected" : "" %>>Electronics</option>
                                    <option <%= product.getCategory().equals("Furniture") ? "selected" : "" %>>Furniture</option>
                                    <option <%= product.getCategory().equals("Clothing") ? "selected" : "" %>>Clothing</option>
                                    <option <%= product.getCategory().equals("Sports") ? "selected" : "" %>>Sports</option>
                                    <option <%= product.getCategory().equals("Other") ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Price (Rs.) *</label>
                                <input type="number" name="price" class="form-control" step="0.01" value="<%= product.getPrice() %>" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Description *</label>
                            <textarea name="description" class="form-control" rows="4" required><%= product.getDescription() %></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Status *</label>
                            <select name="status" class="form-control" required>
                                <option value="Active" <%= product.getStatus().equals("Active") ? "selected" : "" %>>Active</option>
                                <option value="Sold" <%= product.getStatus().equals("Sold") ? "selected" : "" %>>Sold</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Current Image</label>
                            <div class="mb-2">
                                <img src="<%= product.getImage() != null && !product.getImage().isEmpty() ? product.getImage() : "images/default" %>" 
                                     alt="Product" 
                                     class="product-image"
                                     style="max-width: 200px; max-height: 200px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); background-color: #f0f0f0;"
                                     onerror="this.onerror=null; this.src='images/default'; this.style.backgroundColor='#667eea'; this.style.color='white'; this.style.display='flex'; this.style.alignItems='center'; this.style.justifyContent='center'; this.innerHTML='<i class=\\'fas fa-image fa-2x\\'></i><br><small>No Image</small>';">
                            </div>
                            <label class="form-label">Change Image (Optional)</label>
                            <input type="file" name="image" id="imageInput" class="form-control" accept="image/jpeg,image/jpg,image/png" onchange="validateImage(this)">
                            <small class="text-muted">Max size: 2MB. Leave empty to keep current image.</small>
                            <div id="imagePreview" class="mt-2"></div>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <span id="submitText">Update Product</span>
                                <span id="loadingSpinner" class="d-none">
                                    <i class="fas fa-spinner fa-spin"></i> Updating...
                                </span>
                            </button>
                            <a href="myListings.jsp" class="btn btn-secondary">Cancel</a>
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
                    '<div class="mt-2" style="animation: fadeIn 0.3s ease;">' +
                    '<img src="' + e.target.result + '" class="img-thumbnail" style="max-width: 200px; max-height: 200px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">' +
                    '<br><small class="text-muted mt-1 d-block"><i class="fas fa-check-circle text-success"></i> New Image Preview (' + (file.size / 1024).toFixed(1) + ' KB)</small>' +
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

document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
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
