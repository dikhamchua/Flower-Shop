<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Chỉnh sửa Combo | Admin</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <!-- Select2 -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/plugins/select2/css/select2.min.css">
        <!-- Tagify -->
        <link rel="stylesheet" href="https://unpkg.com/@yaireo/tagify/dist/tagify.css">
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
                                    <h1>Chỉnh sửa Combo</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-right">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manage-combo">Quản lý Combo</a></li>
                                    <li class="breadcrumb-item active">Chỉnh sửa Combo</li>
                                </ol>
                            </div>
                        </div>
                    </div> /.container-fluid 
                </section>-->

                <!-- Main content -->
                <section class="content">
                    <div class="dashboard-main-body">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                            <h6 class="fw-semibold mb-0">Chỉnh sửa Combo</h6>
                        </div>
                        <div class="card">
                            <div class="card-body p-24">
                                <form id="comboForm" action="${pageContext.request.contextPath}/admin/manage-combo?action=update" method="post">
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

                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="name" class="form-label">Tên Combo <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="name" name="name"
                                                   placeholder="Nhập tên combo" required
                                                   value="${combo.name}">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="active" ${combo.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${combo.status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label for="description" class="form-label">Mô tả Combo</label>
                                            <textarea class="form-control" id="description" name="description"
                                                      rows="3" placeholder="Nhập mô tả chi tiết về combo">${combo.description}</textarea>
                                        </div>
                                    </div>

                                    <!-- Product Selection Section -->
                                    <div class="card border-info mt-4 mb-4">
                                        <div class="card-header bg-info text-white">
                                            <h6 class="mb-0"><i class="fas fa-boxes me-2"></i>Chọn sản phẩm cho Combo</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="row mb-2">
                                                <div class="col-12">
                                                    <p class="text-muted mb-2">
                                                        <i class="fas fa-info-circle"></i> Chọn ít nhất một sản phẩm cho combo và số lượng cần thiết
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="product-selection-container">
                                                <c:forEach items="${comboProducts}" var="comboProduct" varStatus="status">
                                                    <div class="product-selection-row row align-items-end mb-3">
                                                        <div class="col-md-7">
                                                            <label class="form-label">Sản phẩm <span class="text-danger">*</span></label>
                                                            <select class="form-select product-select" name="product_id" required>
                                                                <option value="">-- Chọn sản phẩm --</option>
                                                                <c:forEach items="${allProducts}" var="product">
                                                                    <option value="${product.productId}" 
                                                                            data-price="${product.price}"
                                                                            ${product.productId == comboProduct.productId ? 'selected' : ''}>
                                                                        ${product.productName} - ${product.price}đ
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                                            <input type="number" class="form-control product-quantity" name="quantity" 
                                                                   min="1" value="${comboProduct.quantityInCombo}" required>
                                                        </div>
                                                        <div class="col-md-2 d-flex align-items-center">
                                                            <button type="button" class="btn btn-outline-danger remove-product w-100" ${status.index == 0 && comboProducts.size() == 1 ? 'disabled' : ''}>
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty comboProducts}">
                                                    <div class="product-selection-row row align-items-end mb-3">
                                                        <div class="col-md-7">
                                                            <label class="form-label">Sản phẩm <span class="text-danger">*</span></label>
                                                            <select class="form-select product-select" name="product_id" required>
                                                                <option value="">-- Chọn sản phẩm --</option>
                                                                <c:forEach items="${allProducts}" var="product">
                                                                    <option value="${product.productId}" data-price="${product.price}">
                                                                        ${product.productName} - ${product.price}đ
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                                            <input type="number" class="form-control product-quantity" name="quantity" 
                                                                   min="1" value="1" required>
                                                        </div>
                                                        <div class="col-md-2 d-flex align-items-center">
                                                            <button type="button" class="btn btn-outline-danger remove-product w-100" disabled>
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="row mt-2">
                                                <div class="col-12">
                                                    <button type="button" class="btn btn-success add-product">
                                                        <i class="fas fa-plus"></i> Thêm sản phẩm
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Price Summary -->
                                    <div class="row g-3">
                                        <div class="col-md-6 offset-md-6">
                                            <div class="table-responsive">
                                                <table class="table table-bordered mb-0">
                                                    <tr>
                                                        <th class="align-middle">Tổng giá gốc:</th>
                                                        <td>
                                                            <span id="original-price-display">${combo.originalPrice}</span>đ
                                                            <input type="hidden" id="original_price" name="original_price" value="${combo.originalPrice}">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th class="align-middle">Giá ưu đãi: <span class="text-danger">*</span></th>
                                                        <td>
                                                            <input type="number" class="form-control" id="discount_price"
                                                                   name="discount_price" min="0" step="0.01" required
                                                                   value="${combo.discountPrice}">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th class="align-middle">Tiết kiệm:</th>
                                                        <td><span id="savings-display">${combo.originalPrice - combo.discountPrice}</span>đ</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tags Section -->
                                    <div class="row g-3 mt-2">
                                        <div class="col-md-12">
                                            <label for="tags" class="form-label">Tags (dịp lễ, chủ đề)</label>
                                            <input id="tags" name="tags" class="form-control"
                                                   placeholder="Thêm các tag, cách nhau bằng dấu phẩy (ví dụ: sinh nhật, lễ tình nhân)"
                                                   value="<c:forEach items="${comboTags}" var="tag" varStatus="status">${tag.tagName}${!status.last ? ',' : ''}</c:forEach>">
                                            <small class="form-text text-muted">
                                                Nhập các tag để phân loại combo (ví dụ: #sinh nhật, #hoa hồng, #valentine)
                                            </small>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2 mt-4 justify-content-end">
                                        <button type="submit" class="btn btn-primary px-4">
                                            <i class="fas fa-save"></i> Cập nhật Combo
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/manage-combo${not empty param.page ? '?page='.concat(param.page) : ''}" class="btn btn-secondary px-4">
                                            <i class="fas fa-arrow-left"></i> Quay lại
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- /.content -->
            </div>
            <!-- /.content-wrapper -->

        </div>
        <!-- ./wrapper -->

        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        <!-- Select2 -->
        <script src="${pageContext.request.contextPath}/assets/admin/plugins/select2/js/select2.full.min.js"></script>
        <!-- Tagify -->
        <script src="https://unpkg.com/@yaireo/tagify"></script>
        <!-- Combo Product Manager -->
        <script src="${pageContext.request.contextPath}/assets/js/comboProductManager.js"></script>
    </body>
</html>