<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Edit Product</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <style>
        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545;
            background-image: none;
        }
        .invalid-feedback {
            display: none;
            color: #dc3545;
            margin-top: 5px;
        }
        .current-image {
            max-width: 200px;
            max-height: 200px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
        }
    </style>
</head>

<body>
<!-- Sidebar -->
<jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

<!-- Header -->
<jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

<div class="dashboard-main-body">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
        <h6 class="fw-semibold mb-0">Edit Product</h6>
        <ul class="d-flex align-items-center gap-2">
            <li class="fw-medium">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                    <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                    Dashboard
                </a>
            </li>
            <li>-</li>
            <li class="fw-medium">Edit Product</li>
        </ul>
    </div>

    <!-- Edit Product Form -->
    <div class="card">
        <div class="card-body p-24">
            <form id="productForm" action="${pageContext.request.contextPath}/admin/manage-product" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="row g-3">
                    <!-- Product Information -->
                    <div class="col-md-6">
                        <label class="form-label">Product Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="name" value="${product.productName}">
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Category <span class="text-danger">*</span></label>
                        <select class="form-select" name="categoryId">
                            <option value="" disabled>Select Category</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" ${product.categoryId == category.categoryId ? 'selected' : ''}>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="4">${product.description}</textarea>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Price <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="price" step="0.01" min="0" value="${product.price}">
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Stock <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="stock" min="0" value="${product.stock}">
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Product Image</label>
                        <c:if test="${not empty product.image}">
                            <div>
                                <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.productName}" class="current-image">
                                <p class="text-muted">Current image: ${product.image}</p>
                            </div>
                        </c:if>
                        <input type="file" class="form-control" name="image" accept="image/*">
                        <div class="invalid-feedback"></div>
                        <small class="text-muted">Leave empty to keep current image</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Status <span class="text-danger">*</span></label>
                        <select class="form-select" name="status">
                            <option value="" disabled>Select Status</option>
                            <option value="1" ${product.status == 1 ? 'selected' : ''}>Active</option>
                            <option value="0" ${product.status == 0 ? 'selected' : ''}>Inactive</option>
                        </select>
                        <div class="invalid-feedback"></div>
                    </div>

                    <!-- Submit Button -->
                    <div class="col-md-12 mt-4">
                        <button type="submit" class="btn btn-primary">Update Product</button>
                        <a href="${pageContext.request.contextPath}/admin/manage-product"
                           class="btn btn-secondary">Cancel</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- JS here -->
<jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
<script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Toast message handling
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Success' : 'Error',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 5000,
                onClosing: function() {
                    fetch('${pageContext.request.contextPath}/remove-toast', {
                        method: 'POST'
                    });
                }
            });
        }

        // Form validation
        const form = document.getElementById('productForm');
        const nameInput = form.querySelector('input[name="name"]');
        const categorySelect = form.querySelector('select[name="categoryId"]');
        const priceInput = form.querySelector('input[name="price"]');
        const stockInput = form.querySelector('input[name="stock"]');
        const imageInput = form.querySelector('input[name="image"]');
        const statusSelect = form.querySelector('select[name="status"]');

        // Validate on form submit
        form.addEventListener('submit', function(event) {
            // Prevent default form submission
            event.preventDefault();
            console.log("Form submit triggered");

            // Validate all fields
            const isNameValid = validateProductName(nameInput);
            const isCategoryValid = validateCategory(categorySelect);
            const isPriceValid = validatePrice(priceInput);
            const isStockValid = validateStock(stockInput);
            // Image is optional on edit
            const isImageValid = imageInput.files.length === 0 || validateImage(imageInput);
            const isStatusValid = validateStatus(statusSelect);

            console.log("Validation results:");
            console.log("Name valid:", isNameValid);
            console.log("Category valid:", isCategoryValid);
            console.log("Price valid:", isPriceValid);
            console.log("Stock valid:", isStockValid);
            console.log("Image valid:", isImageValid);
            console.log("Status valid:", isStatusValid);
            console.log("All valid:", isNameValid && isCategoryValid && isPriceValid && isStockValid && isImageValid && isStatusValid);

            // If all validations pass, submit the form
            if (isNameValid && isCategoryValid && isPriceValid && isStockValid && isImageValid && isStatusValid) {
                console.log("All validations passed, submitting form");
                this.submit();
            } else {
                console.log("Validation failed, form not submitted");
                // Show error message
                iziToast.error({
                    title: 'Error',
                    message: 'Please correct the errors before submitting the form',
                    position: 'topRight',
                    timeout: 1000
                });

                // Focus on the first invalid field
                if (!isNameValid) nameInput.focus();
                else if (!isCategoryValid) categorySelect.focus();
                else if (!isPriceValid) priceInput.focus();
                else if (!isStockValid) stockInput.focus();
                else if (!isImageValid) imageInput.focus();
                else if (!isStatusValid) statusSelect.focus();
            }
        });

        // Validation functions
        function validateProductName(input) {
            const value = input.value.trim();
            const feedback = input.nextElementSibling;
            
            if (value === '') {
                setInvalid(input, feedback, 'Product name is required');
                return false;
            } else if (value.length < 3) {
                setInvalid(input, feedback, 'Product name must be at least 3 characters');
                return false;
            } else if (value.length > 100) {
                setInvalid(input, feedback, 'Product name must be less than 100 characters');
                return false;
            } else {
                setValid(input, feedback);
                return true;
            }
        }

        function validateCategory(select) {
            const value = select.value;
            const feedback = select.nextElementSibling;
            
            if (value === '' || value === null) {
                setInvalid(select, feedback, 'Please select a category');
                return false;
            } else {
                setValid(select, feedback);
                return true;
            }
        }

        function validatePrice(input) {
            const value = input.value.trim();
            const feedback = input.nextElementSibling;
            
            if (value === '') {
                setInvalid(input, feedback, 'Price is required');
                return false;
            } else if (isNaN(value) || parseFloat(value) < 0) {
                setInvalid(input, feedback, 'Price must be a positive number');
                return false;
            } else {
                setValid(input, feedback);
                return true;
            }
        }

        function validateStock(input) {
            const value = input.value.trim();
            const feedback = input.nextElementSibling;
            
            if (value === '') {
                setInvalid(input, feedback, 'Stock is required');
                return false;
            } else if (isNaN(value) || parseInt(value) < 0) {
                setInvalid(input, feedback, 'Stock must be a positive number');
                return false;
            } else {
                setValid(input, feedback);
                return true;
            }
        }

        function validateImage(input) {
            const feedback = input.nextElementSibling;
            
            if (input.files.length === 0) {
                // Image is optional on edit
                setValid(input, feedback);
                return true;
            } else {
                const file = input.files[0];
                const fileType = file.type;
                const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                
                console.log("File type:", fileType);
                console.log("File size:", file.size);
                
                if (!validImageTypes.includes(fileType)) {
                    setInvalid(input, feedback, 'Please select a valid image file (JPEG, PNG, GIF, WEBP)');
                    return false;
                } else if (file.size > 20 * 1024 * 1024) { // 20MB
                    setInvalid(input, feedback, 'Image size should be less than 20MB');
                    return false;
                } else {
                    setValid(input, feedback);
                    return true;
                }
            }
        }

        function validateStatus(select) {
            const value = select.value;
            const feedback = select.nextElementSibling;
            
            if (value === '' || value === null) {
                setInvalid(select, feedback, 'Please select a status');
                return false;
            } else {
                setValid(select, feedback);
                return true;
            }
        }

        function setInvalid(input, feedback, message) {
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
            feedback.textContent = message;
            feedback.style.display = 'block';
        }

        function setValid(input, feedback) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
            feedback.textContent = '';
            feedback.style.display = 'none';
        }
    });
</script>
</body>
</html> 