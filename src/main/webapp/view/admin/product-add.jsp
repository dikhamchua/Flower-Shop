<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Add New Product</title>
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
        .supplier-input-container {
            position: relative;
        }
        .supplier-suggestions {
            position: absolute;
            width: 100%;
            max-height: 200px;
            overflow-y: auto;
            background: white;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            z-index: 1000;
            display: none;
        }
        .supplier-suggestion {
            padding: 8px 12px;
            cursor: pointer;
        }
        .supplier-suggestion:hover {
            background-color: #f8f9fa;
        }
        .selected-suppliers {
            margin-top: 10px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .selected-supplier {
            background-color: #e9ecef;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            padding: 8px 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .remove-supplier {
            cursor: pointer;
            color: #dc3545;
            font-size: 16px;
        }
        .supplier-name {
            font-weight: 500;
            color: #333;
            flex-grow: 1;
            margin-right: 10px;
            word-break: break-word;
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
        <h6 class="fw-semibold mb-0">Add New Product</h6>
        <ul class="d-flex align-items-center gap-2">
            <li class="fw-medium">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                    <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                    Dashboard
                </a>
            </li>
            <li>-</li>
            <li class="fw-medium">Add Product</li>
        </ul>
    </div>

    <!-- Add Product Form -->
    <div class="card">
        <div class="card-body p-24">
            <form id="productForm" action="${pageContext.request.contextPath}/admin/manage-product" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="row g-3">
                    <!-- Product Information -->
                    <div class="col-md-6">
                        <label class="form-label">Product Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="name">
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Category <span class="text-danger">*</span></label>
                        <select class="form-select" name="categoryId">
                            <option value="" selected disabled>Select Category</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}">${category.name}</option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="4"></textarea>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Price <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="price" step="0.01" min="0">
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Stock <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="stock" min="0">
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Product Image <span class="text-danger">*</span></label>
                        <input type="file" class="form-control" name="image" accept="image/*">
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

                    <div class="col-md-6">
                        <label class="form-label">Suppliers <span class="text-danger">*</span></label>
                        <div class="supplier-input-container">
                            <input type="text" class="form-control" id="supplierInput" placeholder="Type to search suppliers...">
                            <div id="supplierSuggestions" class="supplier-suggestions"></div>
                            <div class="selected-suppliers" id="selectedSuppliers"></div>
                            <input type="hidden" name="supplierIds" id="supplierIdsInput">
                            <div class="invalid-feedback"></div>
                        </div>
                        <small class="text-muted">Type supplier name and select from suggestions</small>
                    </div>

                    <!-- Submit Button -->
                    <div class="col-md-12 mt-4">
                        <button type="submit" class="btn btn-primary">Add Product</button>
                        <a href="${pageContext.request.contextPath}/admin/manage-product"
                           class="btn btn-secondary">Cancel</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Thêm đoạn này trước khi include file JS -->
<script>
    // Khởi tạo biến suppliers để có thể truy cập từ file JS
    window.suppliers = [];
    <c:forEach var="supplier" items="${suppliers}">
        window.suppliers.push({
            id: '<c:out value="${supplier.supplierId}"/>',
            name: '<c:out value="${supplier.name}"/>'
        });
    </c:forEach>
</script>

<!-- Include file JS -->
<script src="${pageContext.request.contextPath}/assets/js/productAdd.js"></script>

<!-- JS here -->
<jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
<script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>

</body>
</html>