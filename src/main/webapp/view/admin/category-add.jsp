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
            
        </div>

        <!-- Add Category Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="categoryForm" action="${pageContext.request.contextPath}/admin/manage-category?action=add" method="POST">
                    <div class="row g-3">
                        <!-- Category Information -->
                        <div class="col-md-12">
                            <label class="form-label">Category Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-12">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="4"></textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select class="form-select" name="status" required>
                                <option value="" selected disabled>Select Status</option>
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>

                        <!-- Category Type -->
                        <div class="col-md-6">
                            <label class="form-label">Loại danh mục</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="is_parent" 
                                       id="parentCategory" value="true" checked>
                                <label class="form-check-label" for="parentCategory">
                                    Danh mục cha
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="is_parent" 
                                       id="childCategory" value="false">
                                <label class="form-check-label" for="childCategory">
                                    Danh mục con
                                </label>
                            </div>
                        </div>

                        <!-- Parent Category Selection -->
                        <div class="col-md-6" id="parentCategorySelect" style="display:none;">
                            <label class="form-label">Danh mục cha</label>
                            <select class="form-select" name="parent_id">
                                <option value="">Chọn danh mục cha</option>
                                <c:forEach items="${parentCategories}" var="category">
                                    <option value="${category.categoryId}">${category.name}</option>
                                </c:forEach>
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
            
            // Xử lý hiển thị dropdown khi chọn loại danh mục
            document.querySelectorAll('input[name="is_parent"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    const parentSelect = document.getElementById('parentCategorySelect');
                    parentSelect.style.display = this.value === 'false' ? 'block' : 'none';
                    
                    // Reset parent_id khi chọn danh mục cha
                    if (this.value === 'true') {
                        parentSelect.querySelector('select').value = '';
                    }
                });
            });

            // Form validation
            const form = document.getElementById('categoryForm');
            form.addEventListener('submit', function(event) {
                const isChildCategory = document.querySelector('input[name="is_parent"]:checked').value === 'false';
                const parentId = document.querySelector('select[name="parent_id"]').value;
                
                if (isChildCategory && !parentId) {
                    event.preventDefault();
                    alert('Vui lòng chọn danh mục cha khi tạo danh mục con');
                }
            });
        });
    </script>
</body>
</html> 