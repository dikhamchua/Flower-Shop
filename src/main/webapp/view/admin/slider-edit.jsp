<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Edit Slider || Clothing</title>
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
        .image-preview {
            width: 100%;
            height: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-top: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .image-preview img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        .preview-placeholder {
            color: #6c757d;
            font-size: 14px;
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
            <h6 class="fw-semibold mb-0">Edit Slider</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Edit Slider</li>
            </ul>
        </div>

        <!-- Edit Slider Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="sliderForm" action="${pageContext.request.contextPath}/admin/manage-slider?action=update" method="POST">
                    <input type="hidden" name="id" value="${slider.sliderId}">
                    <div class="row g-3">
                        <!-- Slider Information -->
                        <div class="col-md-12">
                            <label class="form-label">Image URL <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="image_url" id="imageUrl" value="${slider.imageUrl}">
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label">Link</label>
                            <input type="text" class="form-control" name="link" placeholder="https://example.com" value="${slider.link}">
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label">Caption</label>
                            <textarea class="form-control" name="caption" rows="3">${slider.caption}</textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select class="form-select" name="status">
                                <option value="" disabled>Select Status</option>
                                <option value="1" ${slider.status == 1 ? 'selected' : ''}>Active</option>
                                <option value="0" ${slider.status == 0 ? 'selected' : ''}>Inactive</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-md-12 mt-4">
                            <button type="submit" class="btn btn-primary">Update Slider</button>
                            <a href="${pageContext.request.contextPath}/admin/manage-slider" 
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
            
            // Image preview functionality
            const imageUrlInput = document.getElementById('imageUrl');
            const imagePreview = document.getElementById('imagePreview');
            
            imageUrlInput.addEventListener('input', function() {
                updateImagePreview(this.value);
            });
            
            function updateImagePreview(url) {
                if (url && isValidImageUrl(url)) {
                    imagePreview.innerHTML = `<img src="${url}" alt="Preview">`;
                } else {
                    imagePreview.innerHTML = `<span class="preview-placeholder">Image preview will appear here</span>`;
                }
            }
            
            function isValidImageUrl(url) {
                return url.match(/\.(jpeg|jpg|gif|png|bmp|webp)$/i) != null;
            }
            
            // Form validation
            const form = document.getElementById('sliderForm');
            const imageUrlField = form.querySelector('input[name="image_url"]');
            const statusSelect = form.querySelector('select[name="status"]');
            
            // Add input event listeners for real-time validation
            imageUrlField.addEventListener('input', function() {
                validateRequired(this, 'Image URL is required');
            });
            
            statusSelect.addEventListener('change', function() {
                validateRequired(this, 'Please select a status');
            });
            
            function validateRequired(input, errorMessage) {
                const value = input.value.trim();
                const feedbackElement = input.nextElementSibling;
                
                if (value === '') {
                    input.classList.add('is-invalid');
                    feedbackElement.textContent = errorMessage;
                    feedbackElement.style.display = 'block';
                    return false;
                } else {
                    input.classList.remove('is-invalid');
                    feedbackElement.style.display = 'none';
                    return true;
                }
            }
            
            // Validate on form submit
            form.addEventListener('submit', function(event) {
                // Prevent default form submission
                event.preventDefault();
                
                // Validate required fields
                const isImageUrlValid = validateRequired(imageUrlField, 'Image URL is required');
                const isStatusValid = validateRequired(statusSelect, 'Please select a status');
                
                // If all validations pass, submit the form
                if (isImageUrlValid && isStatusValid) {
                    this.submit();
                } else {
                    // Show error message
                    iziToast.error({
                        title: 'Error',
                        message: 'Please fill in all required fields',
                        position: 'topRight',
                        timeout: 1000
                    });
                    
                    // Focus on the first invalid field
                    if (!isImageUrlValid) imageUrlField.focus();
                    else if (!isStatusValid) statusSelect.focus();
                }
            });
        });
    </script>
</body>
</html> 