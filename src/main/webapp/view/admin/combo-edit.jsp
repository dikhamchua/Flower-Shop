<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
                                        <!-- Add image upload field and current image display -->
                                        <div class="col-md-12">
                                            <label for="image" class="form-label">Hình ảnh Combo</label>
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <c:if test="${not empty combo.image}">
                                                        <div class="mb-2">
                                                            <img src="${pageContext.request.contextPath}/${combo.image}" 
                                                                 alt="${combo.name}" class="img-thumbnail" style="max-width: 150px;">
                                                            <div class="form-text">Hình ảnh hiện tại</div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-9">
                                                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                                    <input type="hidden" name="currentImage" value="${combo.image}">
                                                    <small class="form-text text-muted">Chọn hình ảnh mới để thay thế (để trống nếu không muốn thay đổi)</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Replace the Product Selection Section with this -->
                                    <!-- Product Selection Section -->
                                    <div class="card border-info mt-4 mb-4">
                                        <div class="card-header bg-info text-white">
                                            <h6 class="mb-0"><i class="fas fa-boxes me-2"></i>Chọn sản phẩm cho Combo</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="product-selection-container">
                                                <c:forEach items="${comboProducts}" var="comboProduct" varStatus="status">
                                                    <div class="product-selection-row row mb-3">
                                                        <div class="col-md-8">
                                                            <select class="form-control product-select" required>
                                                                <option value="">Chọn sản phẩm</option>
                                                                <!-- Sửa phần forEach products thành allProducts -->
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
                                                            <button type="button" class="btn btn-danger remove-product" disabled>
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
                                                                <option value="">Chọn sản phẩm</option>
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
                                                            <button type="button" class="btn btn-danger remove-product" disabled title="Xóa sản phẩm">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="row mt-3">
                                                <div class="col-12">
                                                    <button type="button" class="btn btn-success add-product">
                                                        <i class="fas fa-plus"></i> Thêm sản phẩm
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
                                                        <th>Tổng giá gốc:</th>
                                                        <td>
                                                            <span id="original-price-display">${combo.originalPrice}</span>đ
                                                            <input type="hidden" id="original_price" name="original_price" 
                                                                   value="${combo.originalPrice}">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Giá ưu đãi: <span class="text-danger">*</span></th>
                                                        <td>
                                                            <input type="number" class="form-control" id="discount_price" 
                                                                   name="discount_price" value="${combo.discountPrice}" 
                                                                   min="0" required>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Tiết kiệm:</th>
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
                                                <i class="fas fa-times"></i> Hủy
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save"></i> Lưu thay đổi
                                            </button>
                                        </div>
                                    </div>
                                </form>
                                <!--                                <div class="row mt-2">
                                                                        <div class="col-12">
                                                                            <button type="button" class="btn btn-success add-product">
                                                                                <i class="fas fa-plus"></i> Thêm sản phẩm
                                                                            </button>
                                                                        </div>
                                                                    </div>-->
                            </div>
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

<!-- Thêm đoạn script này trước đóng body -->
<script>
    // Khởi tạo dữ liệu cho JavaScript
    window.products = ${productsJson};
    window.selectedProducts = ${comboProductsJson};

    $(document).ready(function () {
        // Khởi tạo Select2
        $('.product-select').select2({
            theme: 'bootstrap4',
            placeholder: 'Chọn sản phẩm',
            allowClear: true
        });

        // Cập nhật tiết kiệm khi giá ưu đãi thay đổi
        $('#discount_price').on('input', function () {
            updateSavings();
        });

        // Hàm tính và cập nhật số tiền tiết kiệm
        function updateSavings() {
            const originalPrice = parseFloat($('#original_price').val()) || 0;
            const discountPrice = parseFloat($('#discount_price').val()) || 0;

            const savings = originalPrice - discountPrice;

            if (!isNaN(savings) && savings >= 0) {
                $('#savings-display').text(savings.toLocaleString('vi-VN'));
            } else {
                $('#savings-display').text('0');
            }
        }

        // Tính toán tiết kiệm ngay khi trang load
        updateSavings();
    });
</script>
</body>
</html>