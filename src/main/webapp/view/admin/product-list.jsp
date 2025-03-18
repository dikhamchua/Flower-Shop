<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>

        <title>Product Management</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
            <style>
                .fixed-width-btn {
                    min-width: 120px;
                    text-align: center;
                }
                .product-image {
                    width: 100px;
                    height: 60px;
                    object-fit: cover;
                    border-radius: 4px;
                }
            </style>

        </head>

        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <c:url value="/admin/manage-product" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty searchFilter}">
                <c:param name="search" value="${searchFilter}" />
            </c:if>
            <c:if test="${not empty statusFilter}">
                <c:param name="status" value="${statusFilter}" />
            </c:if>
            <c:if test="${not empty categoryIdFilter}">
                <c:param name="categoryId" value="${categoryIdFilter}" />
            </c:if>
        </c:url>


        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Product Management</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Product List</li>
                </ul>
            </div>

            <!-- Filter Section -->
            <div class="card mb-24">
                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-product" method="GET">
                        <div class="row g-3 align-items-center">
                            <!-- Search Input -->
                            <div class="col-md-3">
                                <input type="text" class="form-control" name="search" 
                                       placeholder="Search by product name" value="${searchFilter}">
                            </div>
                            
                            <!-- Status Dropdown -->
                            <div class="col-md-2">
                                <select class="form-select" name="status">
                                    <option value="">All Status</option>
                                    <option value="1" ${statusFilter == '1' ? 'selected' : ''}>Active</option>
                                    <option value="0" ${statusFilter == '0' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            
                            <!-- Category Dropdown -->
                            <div class="col-md-2">
                                <select class="form-select" name="categoryId">
                                    <option value="">All Categories</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}" ${categoryIdFilter == category.categoryId ? 'selected' : ''}>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Filter Button -->
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">Filter</button>
                            </div>
                            
                            <!-- Add New Product Button -->
                            <div class="col-md-2">
                                <a href="${pageContext.request.contextPath}/admin/manage-product?action=add" 
                                   class="btn btn-success w-100">Add New</a>
                            </div>
                            
                            <!-- Import Button -->
                            <div class="col-md-1">
                                <button type="button" class="btn btn-info w-100" 
                                        data-bs-toggle="modal" data-bs-target="#importModal">
                                    Import
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Product Table -->
            <div class="card">
                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Image</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Supplier</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="9" class="text-center">No products found</td>
                                    </tr>
                                </c:if>
                                <c:forEach var="product" items="${products}" varStatus="loop">
                                    <tr>
                                        <td>${product.productId}</td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.productName}" class="product-image">
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.productName.length() > 30}">
                                                    ${product.productName.substring(0, 30)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${product.productName}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${categoryMap[product.categoryId].name}</td>
                                        <td>
                                            <c:if test="${not empty productSuppliersMap[product.productId]}">
                                                <c:forEach var="supplier" items="${productSuppliersMap[product.productId]}" varStatus="status">
                                                    ${supplier.name}${!status.last ? ', ' : ''}
                                                </c:forEach>
                                            </c:if>
                                            <c:if test="${empty productSuppliersMap[product.productId]}">
                                                <span class="text-muted">No supplier</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td>${product.stock}</td>
                                        <td>
                                            <span class="badge ${product.status == 1 ? 'bg-success' : 'bg-danger'}">
                                                ${product.status == 1 ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/manage-product?action=edit&id=${product.productId}"
                                                   class="btn btn-sm btn-primary">
                                                    <iconify-icon icon="material-symbols:edit"></iconify-icon>
                                                </a>
                                                <c:choose>
                                                    <c:when test="${product.status == 1}">
                                                        <button type="button"
                                                                class="btn btn-sm btn-danger fixed-width-btn"
                                                                onclick="confirmDeactivate('${product.productId}')">
                                                            <i class="fas fa-trash-alt"></i> Deactivate
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button"
                                                                class="btn btn-sm btn-success fixed-width-btn"
                                                                onclick="confirmActivate('${product.productId}')">
                                                            <i class="fas fa-check"></i> Activate
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-24">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>>
                </div>
            </div>
        </div>

        <!-- Import Modal -->
        <div class="modal fade" id="importModal" tabindex="-1" aria-labelledby="importModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="importModalLabel">Import Products from Excel</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/admin/manage-product?action=import" method="post" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label for="excelFile" class="form-label">Select Excel File</label>
                                <input type="file" class="form-control" id="excelFile" name="excelFile" accept=".xls,.xlsx" required>
                                <div class="form-text">File must be .xls or .xlsx format</div>
                            </div>
                            <div class="mb-3">
                                <a href="${pageContext.request.contextPath}/assets/templates/product_import_template.xlsx" download class="text-primary">
                                    <i class="fas fa-download"></i> Download template
                                </a>
                            </div>
                            <button type="submit" class="btn btn-primary">Import</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Import Result Modal -->
        <c:if test="${param.import_result == 'true'}">
            <div class="modal fade" id="importResultModal" tabindex="-1" aria-labelledby="importResultModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="importResultModalLabel">Import Results</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="import-summary mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title">Summary</h6>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="d-flex align-items-center">
                                                    <div class="me-2">
                                                        <span class="badge bg-success">New</span>
                                                    </div>
                                                    <div>
                                                        <span class="h5 mb-0">${newProductCount}</span> products added
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="d-flex align-items-center">
                                                    <div class="me-2">
                                                        <span class="badge bg-info">Updated</span>
                                                    </div>
                                                    <div>
                                                        <span class="h5 mb-0">${updatedProductCount}</span> products updated
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="d-flex align-items-center">
                                                    <div class="me-2">
                                                        <span class="badge bg-danger">Failed</span>
                                                    </div>
                                                    <div>
                                                        <span class="h5 mb-0">${fn:length(importErrorMessages)}</span> products failed
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty newProductQuantities}">
                                <div class="mb-3">
                                    <h6>New Products Added</h6>
                                    <div class="table-responsive">
                                        <table class="table table-sm table-bordered table-striped">
                                            <thead class="table-success">
                                                <tr>
                                                    <th>Product Name</th>
                                                    <th>Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="entry" items="${newProductQuantities}">
                                                    <tr>
                                                        <td>${entry.key}</td>
                                                        <td>${entry.value}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty updatedProductQuantities}">
                                <div class="mb-3">
                                    <h6>Updated Products</h6>
                                    <div class="table-responsive">
                                        <table class="table table-sm table-bordered table-striped">
                                            <thead class="table-info">
                                                <tr>
                                                    <th>Product Name</th>
                                                    <th>Added Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="entry" items="${updatedProductQuantities}">
                                                    <tr>
                                                        <td>${entry.key}</td>
                                                        <td>+${entry.value}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty importErrorMessages}">
                                <div>
                                    <h6>Failed Products</h6>
                                    <div class="list-group">
                                        <c:set var="displayCount" value="0" />
                                        <c:forEach var="message" items="${importErrorMessages}">
                                            <c:if test="${displayCount < 10}">
                                                <div class="list-group-item list-group-item-action list-group-item-danger">
                                                    ${message}
                                                </div>
                                                <c:set var="displayCount" value="${displayCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                <c:if test="${importErrorMessages.size() > 10}">
                                    <div class="list-group-item text-center">
                                        And ${importErrorMessages.size() - 10} more errors...
                                    </div>
                                </c:if>
                            </div>
                        </div>
                            </c:if>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    var importResultModal = new bootstrap.Modal(document.getElementById('importResultModal'));
                    importResultModal.show();
                    
                    // Xóa các thông báo import sau khi đã hiển thị
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            </script>
        </c:if>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    var toastMessage = "${sessionScope.toastMessage}";
                    var toastType = "${sessionScope.toastType}";
                    if (toastMessage) {
                        iziToast.show({
                            title: toastType === 'success' ? 'Success' : 'Error',
                            message: toastMessage,
                            position: 'topRight',
                            color: toastType === 'success' ? 'green' : 'red',
                            timeout: 1000,
                            onClosing: function () {
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
                });

                function confirmDeactivate(productId) {
                    if (confirm('Are you sure you want to deactivate this product?')) {
                        window.location.href = '${pageContext.request.contextPath}/admin/manage-product?action=deactivate&id=' + productId;
                    }
                }

                function confirmActivate(productId) {
                    if (confirm('Are you sure you want to activate this product?')) {
                        window.location.href = '${pageContext.request.contextPath}/admin/manage-product?action=activate&id=' + productId;
                    }
                }
        </script>

    </body>
</html>