<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Add New Category || Clothing</title>
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
    </style>
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Add New Category</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Add Category</li>
            </ul>
        </div>

        <!-- Add Category Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="categoryForm" action="${pageContext.request.contextPath}/admin/manage-category?action=add" method="POST">
                    <div class="row g-3">
                        <!-- Category Information -->
                        <div class="col-md-12">
                            <label class="form-label">Category Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name">
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="4"></textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select class="form-select" name="status">
                                <option value="" selected disabled>Select Status</option>
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-md-12 mt-4">
                            <button type="submit" class="btn btn-primary">Add Category</button>
                            <a href="${pageContext.request.contextPath}/admin/manage-category" 
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
            const form = document.getElementById('categoryForm');
            const nameInput = form.querySelector('input[name="name"]');
            const statusSelect = form.querySelector('select[name="status"]');
            
            // Add input event listeners for real-time validation
            nameInput.addEventListener('input', function() {
                validateCategoryName(this);
            });
            
            statusSelect.addEventListener('change', function() {
                validateCategoryStatus(this);
            });
            
            // Validate on form submit
            form.addEventListener('submit', function(event) {
                // Prevent default form submission
                event.preventDefault();
                
                // Validate all fields
                const isNameValid = validateCategoryName(nameInput);
                const isStatusValid = validateCategoryStatus(statusSelect);
                
                // If all validations pass, submit the form
                if (isNameValid && isStatusValid) {
                    this.submit();
                } else {
                    // Show error message
                    iziToast.error({
                        title: 'Error',
                        message: 'Please correct the errors before submitting the form',
                        position: 'topRight',
                        timeout: 1000
                    });
                    
                    // Focus on the first invalid field
                    if (!isNameValid) nameInput.focus();
                    else if (!isStatusValid) statusSelect.focus();
                }
            });
        });
    </script>
</body>
</html> 