<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Tạo Combo Mới | Admin</title>
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

                <!-- Content Wrapper. Contains page content -->
                <div class="content-wrapper">
                    <!-- Content Header (Page header) -->
<!--                    <section class="content-header">
                        <div class="container-fluid">
                            <div class="row mb-2">
                                <div class="col-sm-6">
                                    <h1>Tạo Combo Mới</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-right">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manage-combo">Quản lý Combo</a></li>
                                    <li class="breadcrumb-item active">Tạo Combo Mới</li>
                                </ol>
                            </div>
                        </div>
                    </div> /.container-fluid 
                </section>-->

                <!-- Main content -->
                <section class="content">
                    <div class="dashboard-main-body">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                            <h6 class="fw-semibold mb-0">Tạo Combo Mới</h6>
                        </div>
                        <div class="card">
                            <div class="card-body p-24">
                                <form id="comboForm" action="${pageContext.request.contextPath}/admin/manage-combo?action=add" method="post">
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

                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="name" class="form-label">Tên Combo <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="name" name="name"
                                                   placeholder="Nhập tên combo" required
                                                   value="${param.name != null ? param.name : ''}">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label for="description" class="form-label">Mô tả Combo</label>
                                            <textarea class="form-control" id="description" name="description"
                                                      rows="3" placeholder="Nhập mô tả chi tiết về combo">${param.description != null ? param.description : ''}</textarea>
                                        </div>
                                    </div>

                                    <!-- Product Selection Section -->
                                    <div class="card border-info mt-4 mb-4">
                                        <div class="card-header bg-info text-white">
                                            <h6 class="mb-0"><i class="fas fa-boxes me-2"></i>Choose Products for Combo</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="product-selection-container">
                                                <div class="product-selection-row row mb-3">
                                                    <div class="col-md-8">
                                                        <select class="form-control product-select" required>
                                                            <option value="">Choose a product</option>
                                                            <c:forEach items="${products}" var="product">
                                                                <option value="${product.productId}" data-price="${product.price}">
                                                                    ${product.productName} - ${product.price}đ
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <input type="number" class="form-control product-quantity" value="1" min="1" required>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <button type="button" class="btn btn-danger remove-product" disabled>
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
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
                                                <table class="table table-bordered mb-0">
                                                    <tr>
                                                        <th>Tổng giá gốc:</th>
                                                        <td>
                                                            <span id="original-price-display">0</span>đ
                                                            <input type="hidden" id="original_price" name="original_price" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Giá ưu đãi: <span class="text-danger">*</span></th>
                                                        <td>
                                                            <input type="number" class="form-control" id="discount_price"
                                                                   name="discount_price" min="0" required>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Tiết kiệm:</th>
                                                        <td><span id="savings-display">0</span>đ</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- /.content -->
            </div>
        </div>
        <!-- ./wrapper -->

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
            <!-- Select2 -->
       <script src="${pageContext.request.contextPath}/assets/admin/plugins/select2/js/select2.full.min.js"></script>
        <!-- Tagify -->
        <script src="https://unpkg.com/@yaireo/tagify"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
        <!-- Combo Product Manager -->
        <script src="${pageContext.request.contextPath}/assets/js/comboProductManager.js"></script>
        <!-- Add this before closing body tag -->
        <script>
            console.log('Available products:', ${productsJson});
            console.log('jQuery loaded:', typeof jQuery !== 'undefined');
            console.log('Select2 loaded:', typeof jQuery.fn.select2 !== 'undefined');
        </script>
    </body>
</html>


<!-- Add Submit Button -->
<div class="row mt-4">
    <div class="col-12 text-end">
        <button type="submit" class="btn btn-primary">
            <i class="fas fa-save me-2"></i>Create Combo
        </button>
        <a href="${pageContext.request.contextPath}/admin/manage-combo" class="btn btn-secondary ms-2">
            <i class="fas fa-times me-2"></i>Cancel
        </a>
    </div>
</div>
</form>