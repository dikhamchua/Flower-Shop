<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Edit Combo | Admin</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <!-- Select2 -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/plugins/select2/css/select2.min.css">
        <!-- Tagify -->
        <link rel="stylesheet" href="https://unpkg.com/@yaireo/tagify/dist/tagify.css">
        <!-- Add this with other CSS links -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body class="hold-transition sidebar-mini">
        <div class="wrapper">
            <!-- Sidebar -->
            <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

                <!-- Header -->
            <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

                <div class="content-wrapper">
                    <section class="content">
                        <div class="dashboard-main-body">
                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                                <h6 class="fw-semibold mb-0">Edit Combo</h6>
                            </div>
                            <div class="card">
                                <div class="card-body p-24">
                                    <form id="comboForm" action="${pageContext.request.contextPath}/admin/manage-combo?action=update" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="id" value="${combo.comboId}">
                                        <input type="hidden" name="page" value="${param.page}">

                                        <c:if test="${not empty sessionScope.errors}">
                                            <div class="alert alert-danger">
                                                <ul class="mb-0">
                                                    <c:forEach items="${sessionScope.errors}" var="error">
                                                        <li>${error.value}</li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                            <% session.removeAttribute("errors"); %>
                                        </c:if>

                                        <c:if test="${not empty sessionScope.errors['duplicate_product']}">
                                            <div class="alert alert-danger">
                                                <ul class="mb-0">
                                                    <li>${sessionScope.errors['duplicate_product']}</li>
                                                </ul>
                                            </div>
                                        </c:if>

                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label for="name" class="form-label">Combo Name <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="name" name="name"
                                                       placeholder="Enter combo name" required
                                                       value="${combo.name}">
                                            </div>
                                            <div class="col-md-6">
                                                <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                                <select class="form-select" id="status" name="status" required>
                                                    <option value="active" ${combo.status == 'active' ? 'selected' : ''}>Active</option>
                                                    <option value="inactive" ${combo.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-12">
                                                <label for="description" class="form-label">Combo Description</label>
                                                <textarea class="form-control" id="description" name="description"
                                                          rows="3" placeholder="Enter detailed description of the combo">${combo.description}</textarea>
                                            </div>
                                            <!-- Image upload field and current image display -->
                                            <div class="col-md-12">
                                                <label for="image" class="form-label">Combo Image</label>
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <c:if test="${not empty combo.image}">
                                                            <div class="mb-2">
                                                                <img src="${pageContext.request.contextPath}/${combo.image}" 
                                                                     alt="${combo.name}" class="img-thumbnail" style="max-width: 150px;">
                                                                <div class="form-text">Current image</div>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="col-md-9">
                                                        <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                                        <input type="hidden" name="currentImage" value="${combo.image}">
                                                        <small class="form-text text-muted">Choose a new image to replace (leave empty if you don't want to change)</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Product Selection Section -->
                                        <div class="card border-info mt-4 mb-4">
                                            <div class="card-header bg-info text-white">
                                                <h6 class="mb-0"><i class="fas fa-boxes me-2"></i>Choose Products for Combo</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="product-selection-container">
                                                    <c:forEach items="${comboProducts}" var="comboProduct" varStatus="status">
                                                        <div class="product-selection-row row mb-3">
                                                            <div class="col-md-8">
                                                                <select class="form-control product-select" required>
                                                                    <option value="">Choose a product</option>
                                                                    <c:forEach items="${allProducts}" var="product">
                                                                        <option value="${product.productId}" 
                                                                                data-price="${product.price}"
                                                                                ${product.productId == comboProduct.productId ? 'selected' : ''}>
                                                                            ${product.productName} - ${product.price}đ
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <input type="number" class="form-control product-quantity" 
                                                                       value="${comboProduct.quantityInCombo}" min="1" required>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <button type="button" class="btn btn-danger remove-product" 
                                                                        ${status.index == 0 && comboProducts.size() == 1 ? 'disabled' : ''}>
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </c:forEach>

                                                    <c:if test="${empty comboProducts}">
                                                        <div class="product-selection-row row mb-3">
                                                            <div class="col-md-8">
                                                                <select class="form-control product-select" required>
                                                                    <option value="">Choose a product</option>
                                                                    <c:forEach items="${products}" var="product">
                                                                        <option value="${product.productId}" data-price="${product.price}">
                                                                            ${product.productName} - <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <input type="number" class="form-control product-quantity" value="1" min="1" required>
                                                            </div>
                                                            <div class="col-md-1 d-flex align-items-end">
                                                                <button type="button" class="btn btn-danger remove-product" disabled title="Remove product">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <div class="row mt-3">
                                                    <div class="col-12">
                                                        <button type="button" class="btn btn-success add-product">
                                                            <i class="fas fa-plus"></i> Add Product
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Hidden inputs for form submission -->
                                        <input type="hidden" id="productIdsInput" name="productIds">
                                        <input type="hidden" id="quantitiesInput" name="quantities">

                                        <!-- Price Summary -->
                                        <div class="row mt-4">
                                            <div class="col-md-6 offset-md-6">
                                                <div class="table-responsive">
                                                    <table class="table table-bordered">
                                                        <tr>
                                                            <th>Total Original Price:</th>
                                                            <td>
                                                                <span id="original-price-display">${combo.originalPrice}</span>đ
                                                                <input type="hidden" id="original_price" name="original_price" 
                                                                       value="${combo.originalPrice}">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>Discounted Price: <span class="text-danger">*</span></th>
                                                            <td>
                                                                <input type="number" class="form-control" id="discount_price" 
                                                                       name="discount_price" value="${combo.discountPrice}" 
                                                                       min="0" required>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>Savings:</th>
                                                            <td><span id="savings-display">${combo.originalPrice - combo.discountPrice}</span>đ</td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Submit Buttons -->
                                        <div class="row mt-4">
                                            <div class="col-12 text-end">
                                                <a href="${pageContext.request.contextPath}/admin/manage-combo" 
                                                   class="btn btn-secondary me-2">
                                                    <i class="fas fa-times"></i> Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Save Changes
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function() {
                                            var comboForm = document.getElementById('comboForm');
                                            if(comboForm) {
                                                comboForm.addEventListener('submit', function(e) {
                                                    var nameInput = document.getElementById('name');
                                                    var nameValue = nameInput.value;
                                                    var regex = /^[a-zA-Z0-9\sÀ-ỹà-ỹ_.,-]+$/;
                                                    if(!regex.test(nameValue)) {
                                                        alert('Combo name cannot contain special characters!');
                                                        nameInput.focus();
                                                        e.preventDefault();
                                                        return false;
                                                    }
                                                });
                                            }
                                        });
                                    </script>
                                </div>
                            </div>
                        </div>
                </div>
            </section>
        </div>
    </div>

    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        <!-- Select2 -->
        <script src="${pageContext.request.contextPath}/assets/admin/plugins/select2/js/select2.full.min.js"></script>
    <!-- Tagify -->
    <script src="https://unpkg.com/@yaireo/tagify"></script>
    <!-- Combo Product Manager -->
    <script src="${pageContext.request.contextPath}/assets/js/comboProductManager.js"></script>
</body>
</html>