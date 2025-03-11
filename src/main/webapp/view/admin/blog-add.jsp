<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Add New Blog || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <!-- Include Summernote CSS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
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
        .note-editor {
            margin-bottom: 20px;
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
            <h6 class="fw-semibold mb-0">Add New Blog</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Add Blog</li>
            </ul>
        </div>

        <!-- Add Blog Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="blogForm" action="${pageContext.request.contextPath}/admin/manage-blog?action=add" method="POST">
                    <div class="row g-3">
                        <!-- Blog Information -->
                        <div class="col-md-12">
                            <label class="form-label">Blog Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="title" maxlength="150">
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label">Content <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="content" id="content" rows="10"></textarea>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select class="form-select" name="status">
                                <option value="" selected disabled>Select Status</option>
                                <option value="published">Published</option>
                                <option value="hidden">Hidden</option>
                                <option value="draft">Draft</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-md-12 mt-4">
                            <button type="submit" class="btn btn-primary">Add Blog</button>
                            <a href="${pageContext.request.contextPath}/admin/manage-blog" 
                               class="btn btn-secondary">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <!-- Include jQuery and Summernote JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize Summernote
            $('#content').summernote({
                height: 300,
                placeholder: 'Write your blog content here...',
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ]
            });
        });
        
        // Validation functions
        function validateBlogTitle(input) {
            const value = input.value.trim();
            const feedbackElement = input.nextElementSibling;
            
            if (value === '') {
                input.classList.add('is-invalid');
                feedbackElement.textContent = 'Blog title is required';
                feedbackElement.style.display = 'block';
                return false;
            } else if (value.length > 150) {
                input.classList.add('is-invalid');
                feedbackElement.textContent = 'Blog title must be less than 150 characters';
                feedbackElement.style.display = 'block';
                return false;
            } else {
                input.classList.remove('is-invalid');
                feedbackElement.style.display = 'none';
                return true;
            }
        }
        
        function validateBlogStatus(select) {
            const value = select.value;
            const feedbackElement = select.nextElementSibling;
            
            if (value === '' || value === null) {
                select.classList.add('is-invalid');
                feedbackElement.textContent = 'Please select a status';
                feedbackElement.style.display = 'block';
                return false;
            } else {
                select.classList.remove('is-invalid');
                feedbackElement.style.display = 'none';
                return true;
            }
        }
        
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
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                        }).then(response => {
                            if (!response.ok) {
                                console.error('Failed to remove toast attributes');
                            }
                        }).catch(error => {
                            console.error('Error:', error);
                        });
                    }
                });
            }
            
            // Form validation
            const form = document.getElementById('blogForm');
            const titleInput = form.querySelector('input[name="title"]');
            const statusSelect = form.querySelector('select[name="status"]');
            
            // Add input event listeners for real-time validation
            titleInput.addEventListener('input', function() {
                validateBlogTitle(this);
            });
            
            statusSelect.addEventListener('change', function() {
                validateBlogStatus(this);
            });
            
            // Validate on form submit
            form.addEventListener('submit', function(event) {
                // Prevent default form submission
                event.preventDefault();
                
                // Validate all fields
                const isTitleValid = validateBlogTitle(titleInput);
                const isStatusValid = validateBlogStatus(statusSelect);
                
                // If all validations pass, submit the form
                if (isTitleValid && isStatusValid) {
                    this.submit();
                } else {
                    // Show error message
                    iziToast.error({
                        title: 'Error',
                        message: 'Please correct the errors before submitting the form',
                        position: 'topRight',
                        timeout: 5000
                    });
                    
                    // Focus on the first invalid field
                    if (!isTitleValid) titleInput.focus();
                    else if (!isStatusValid) statusSelect.focus();
                }
            });
        });
    </script>
</body>
</html> 