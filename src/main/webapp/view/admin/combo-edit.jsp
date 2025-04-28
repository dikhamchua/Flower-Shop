<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chỉnh sửa Combo | Admin</title>
    <!-- <jsp:include page="../common/head.jsp"/> -->
    <!-- Select2 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/plugins/select2/css/select2.min.css">
    <!-- Tagify -->
    <link rel="stylesheet" href="https://unpkg.com/@yaireo/tagify/dist/tagify.css">
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <jsp:include page="../common/admin-header.jsp"/>
    
    <!-- Main Sidebar Container -->
    <jsp:include page="../common/admin-sidebar.jsp"/>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
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
            </div><!-- /.container-fluid -->
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">Thông tin Combo</h3>
                    </div>
                    <!-- /.card-header -->
                    
                    <!-- form start -->
                    <form id="comboForm" action="${pageContext.request.contextPath}/admin/manage-combo?action=update" method="post">
                        <input type="hidden" name="id" value="${combo.comboId}">
                        <input type="hidden" name="page" value="${param.page}">
                        
                        <div class="card-body">
                            <!-- Display validation errors if any -->
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
                            
                            <!-- Basic Combo Info Section -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="name">Tên Combo <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="name" name="name" 
                                               placeholder="Nhập tên combo" required
                                               value="${combo.name}">
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="status">Trạng thái <span class="text-danger">*</span></label>
                                        <select class="form-control" id="status" name="status" required>
                                            <option value="active" ${combo.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${combo.status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="description">Mô tả Combo</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="3" placeholder="Nhập mô tả chi tiết về combo">${combo.description}</textarea>
                            </div>
                            
                            <!-- Product Selection Section -->
                            <div class="card card-info">
                                <div class="card-header">
                                    <h3 class="card-title">Chọn sản phẩm cho Combo</h3>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <p class="text-muted">
                                                <i class="fas fa-info-circle"></i> Chọn ít nhất một sản phẩm cho combo và số lượng cần thiết
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <div class="product-selection-container">
                                        <c:forEach items="${comboProducts}" var="comboProduct" varStatus="status">
                                            <div class="product-selection-row row mb-3">
                                                <div class="col-md-8">
                                                    <div class="form-group">
                                                        <label>Sản phẩm <span class="text-danger">*</span></label>
                                                        <select class="form-control product-select" name="product_id" required>
                                                            <option value="">-- Chọn sản phẩm --</option>
                                                            <c:forEach items="${allProducts}" var="product">
                                                                <option value="${product.productId}" 
                                                                        data-price="${product.price}"
                                                                        ${product.productId == comboProduct.productId ? 'selected' : ''}>
                                                                    ${product.name} - ${product.price}đ
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label>Số lượng <span class="text-danger">*</span></label>
                                                        <input type="number" class="form-control product-quantity" name="quantity" 
                                                               min="1" value="${comboProduct.quantityInCombo}" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-1 d-flex align-items-center">
                                                    <button type="button" class="btn btn-danger remove-product" ${status.index == 0 && comboProducts.size() == 1 ? 'disabled' : ''}>
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        
                                        <c:if test="${empty comboProducts}">
                                            <div class="product-selection-row row mb-3">
                                                <div class="col-md-8">
                                                    <div class="form-group">
                                                        <label>Sản phẩm <span class="text-danger">*</span></label>
                                                        <select class="form-control product-select" name="product_id" required>
                                                            <option value="">-- Chọn sản phẩm --</option>
                                                            <c:forEach items="${allProducts}" var="product">
                                                                <option value="${product.productId}" data-price="${product.price}">
                                                                    ${product.name} - ${product.price}đ
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label>Số lượng <span class="text-danger">*</span></label>
                                                        <input type="number" class="form-control product-quantity" name="quantity" 
                                                               min="1" value="1" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-1 d-flex align-items-center">
                                                    <button type="button" class="btn btn-danger remove-product" disabled>
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="row mt-2">
                                        <div class="col-md-12">
                                            <button type="button" class="btn btn-success add-product">
                                                <i class="fas fa-plus"></i> Thêm sản phẩm
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <!-- Price Summary -->
                                    <div class="row mt-4">
                                        <div class="col-md-6 offset-md-6">
                                            <div class="table-responsive">
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <th>Tổng giá gốc:</th>
                                                        <td>
                                                            <span id="original-price-display">${combo.originalPrice}</span>đ
                                                            <input type="hidden" id="original_price" name="original_price" value="${combo.originalPrice}">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Giá ưu đãi: <span class="text-danger">*</span></th>
                                                        <td>
                                                            <input type="number" class="form-control" id="discount_price" 
                                                                   name="discount_price" min="0" step="0.01" required
                                                                   value="${combo.discountPrice}">
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
                                </div>
                            </div>
                            
                            <!-- Tags Section -->
                            <div class="form-group">
                                <label for="tags">Tags (dịp lễ, chủ đề)</label>
                                <input id="tags" name="tags" class="form-control" 
                                       placeholder="Thêm các tag, cách nhau bằng dấu phẩy (ví dụ: sinh nhật, lễ tình nhân)"
                                       value="<c:forEach items="${comboTags}" var="tag" varStatus="status">${tag.tagName}${!status.last ? ',' : ''}</c:forEach>">
                                <small class="form-text text-muted">
                                    Nhập các tag để phân loại combo (ví dụ: #sinh nhật, #hoa hồng, #valentine)
                                </small>
                            </div>
                        </div>
                        <!-- /.card-body -->

                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Cập nhật Combo
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/manage-combo${not empty param.page ? '?page='.concat(param.page) : ''}" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                    </form>
                </div>
                <!-- /.card -->
            </div>
            <!-- /.container-fluid -->
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <jsp:include page="../common/admin-footer.jsp"/>
</div>
<!-- ./wrapper -->

<jsp:include page="../common/admin-js.jsp"/>
<!-- Select2 -->
<script src="${pageContext.request.contextPath}/assets/admin/plugins/select2/js/select2.full.min.js"></script>
<!-- Tagify -->
<script src="https://unpkg.com/@yaireo/tagify"></script>

<!-- Product selection and price calculation -->
<script>
    $(function () {
        // Initialize select2
        $('.product-select').select2({
            theme: 'bootstrap4',
            placeholder: 'Chọn sản phẩm',
            allowClear: true
        });
        
        // Initialize tagify for tags input
        var tagifyInput = document.querySelector('#tags');
        new Tagify(tagifyInput, {
            delimiters: ',',
            pattern: /#/,
            transformTag: function(tagData) {
                // Ensure tag starts with #
                if (!tagData.value.startsWith('#')) {
                    tagData.value = '#' + tagData.value;
                }
            }
        });
        
        // Calculate initial price
        updateTotalPrice();
        
        // Add new product row
        $('.add-product').click(function() {
            var newRow = $('.product-selection-row:first').clone();
            newRow.find('select').val('').trigger('change');
            newRow.find('input').val(1);
            newRow.find('.remove-product').prop('disabled', false);
            
            // Reinitialize select2 for the new row
            newRow.find('.product-select').select2({
                theme: 'bootstrap4',
                placeholder: 'Chọn sản phẩm',
                allowClear: true
            });
            
            $('.product-selection-container').append(newRow);
            updateTotalPrice();
        });
        
        // Remove product row
        $(document).on('click', '.remove-product', function() {
            $(this).closest('.product-selection-row').remove();
            updateTotalPrice();
            
            // If only one row remains, disable its remove button
            if ($('.product-selection-row').length === 1) {
                $('.remove-product').prop('disabled', true);
            }
        });
        
        // Update price on product or quantity change
        $(document).on('change', '.product-select, .product-quantity', function() {
            updateTotalPrice();
        });
        
        // Update discount savings when discount price changes
        $('#discount_price').on('input', function() {
            updateSavings();
        });
        
        // Function to update total original price
        function updateTotalPrice() {
            var totalPrice = 0;
            
            $('.product-selection-row').each(function() {
                var productSelect = $(this).find('.product-select');
                var quantity = parseInt($(this).find('.product-quantity').val()) || 0;
                
                if (productSelect.val()) {
                    var price = parseFloat(productSelect.find(':selected').data('price')) || 0;
                    totalPrice += price * quantity;
                }
            });
            
            $('#original-price-display').text(totalPrice.toFixed(2));
            $('#original_price').val(totalPrice.toFixed(2));
            
            // Update savings whenever original price changes
            updateSavings();
        }
        
        // Function to update savings amount
        function updateSavings() {
            var originalPrice = parseFloat($('#original_price').val()) || 0;
            var discountPrice = parseFloat($('#discount_price').val()) || 0;
            var savings = originalPrice - discountPrice;
            
            // Handle negative savings (discount price higher than original)
            if (savings < 0) {
                $('#savings-display').text('0.00');
                // Show warning if discount price is higher than original
                if (discountPrice > originalPrice) {
                    $('#discount_price').addClass('is-invalid');
                } else {
                    $('#discount_price').removeClass('is-invalid');
                }
            } else {
                $('#savings-display').text(savings.toFixed(2));
                $('#discount_price').removeClass('is-invalid');
            }
        }
        
        // Form validation before submit
        $('#comboForm').on('submit', function(e) {
            var isValid = true;
            var originalPrice = parseFloat($('#original_price').val()) || 0;
            var discountPrice = parseFloat($('#discount_price').val()) || 0;
            
            // Check if at least one product is selected
            if ($('.product-select option:selected[value!=""]').length === 0) {
                alert('Vui lòng chọn ít nhất một sản phẩm cho combo');
                isValid = false;
            }
            
            // Check if discount price is less than original price
            if (discountPrice >= originalPrice) {
                alert('Giá ưu đãi phải nhỏ hơn giá gốc');
                $('#discount_price').focus();
                isValid = false;
            }
            
            return isValid;
        });
    });
</script>
</body>
</html>