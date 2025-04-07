<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Edit Category || Clothing</title>
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
            <h6 class="fw-semibold mb-0">Edit Category</h6>
            
        </div>

        <!-- Edit Category Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="categoryForm" action="${pageContext.request.contextPath}/admin/manage-category?action=update" method="POST">
                    <input type="hidden" name="id" value="${category.categoryId}">
                    <input type="hidden" name="page" value="${param.page}">
                    <div class="row g-3">
                        <!-- Category Information -->
                        <div class="col-md-12">
                            <label class="form-label">Category Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" value="${category.name}">
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="4">${category.description}</textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select class="form-select" name="status">
                                <option value="" disabled>Select Status</option>
                                <option value="1" ${category.status == 1 ? 'selected' : ''}>Active</option>
                                <option value="0" ${category.status == 0 ? 'selected' : ''}>Inactive</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Created At</label>
                            <input type="text" class="form-control" value="${category.createdAt}" disabled>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Last Updated</label>
                            <input type="text" class="form-control" value="${category.updatedAt}" disabled>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Loại danh mục</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="is_parent" 
                                       id="parentCategory" value="true" ${category.isParent ? 'checked' : ''}>
                                <label class="form-check-label" for="parentCategory">
                                    Danh mục cha
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="is_parent" 
                                       id="childCategory" value="false" ${!category.isParent ? 'checked' : ''}>
                                <label class="form-check-label" for="childCategory">
                                    Danh mục con
                                </label>
                            </div>
                        </div>

                        <!-- Parent Category Select (only show if category is child) -->
                        <div class="col-md-6" id="parentCategorySelect" style="display: ${category.isParent ? 'none' : 'block'};">
                            <label class="form-label">Danh mục cha <span class="text-danger">*</span></label>
                            <select class="form-select" name="parent_id">
                                <option value="">Chọn danh mục cha</option>
                                <c:forEach var="parentCategory" items="${parentCategories}">
                                    <option value="${parentCategory.categoryId}" ${category.parentId == parentCategory.categoryId ? 'selected' : ''}>
                                        ${parentCategory.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>
                    
                    <div class="mt-3">
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                        <a href="${pageContext.request.contextPath}/admin/manage-category?action=list" class="btn btn-secondary">Hủy</a>
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
            
            // Toggle parent category select based on is_parent radio buttons
            const parentCategoryRadio = document.getElementById('parentCategory');
            const childCategoryRadio = document.getElementById('childCategory');
            const parentCategorySelect = document.getElementById('parentCategorySelect');

            parentCategoryRadio.addEventListener('change', function() {
                parentCategorySelect.style.display = 'none';
            });

            childCategoryRadio.addEventListener('change', function() {
                parentCategorySelect.style.display = 'block';
            });
            
            // Form validation
            const form = document.getElementById('categoryForm');
            const nameInput = form.querySelector('input[name="name"]');
            const statusSelect = form.querySelector('select[name="status"]');
            const parentSelect = document.getElementById('parentCategorySelect');
            
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
                const isParent = document.querySelector('input[name="is_parent"]:checked').value === 'true';
                const parentId = parentSelect.querySelector('select').value;
                
                // Additional validation for parent/child relationship
                if (!isParent && !parentId) {
                    iziToast.error({
                        title: 'Error',
                        message: 'Vui lòng chọn danh mục cha khi tạo danh mục con',
                        position: 'topRight',
                        timeout: 2000
                    });
                    return;
                }
                
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