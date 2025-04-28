document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo Select2 cho tất cả các select sản phẩm
    initializeSelect2();
    
    // Khởi tạo Tagify cho input tags
    initializeTagify();
    
    // Tính toán giá ban đầu
    updateTotalPrice();
    
    // Xử lý thêm sản phẩm mới
    document.querySelector('.add-product').addEventListener('click', function() {
        addNewProductRow();
    });
    
    // Xử lý xóa sản phẩm (sử dụng event delegation)
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('remove-product') || e.target.closest('.remove-product')) {
            const button = e.target.classList.contains('remove-product') ? e.target : e.target.closest('.remove-product');
            if (!button.disabled) {
                removeProductRow(button);
            }
        }
    });
    
    // Cập nhật giá khi thay đổi sản phẩm hoặc số lượng
    document.addEventListener('change', function(e) {
        if (e.target.classList.contains('product-select') || e.target.classList.contains('product-quantity')) {
            updateTotalPrice();
        }
    });
    
    // Cập nhật tiết kiệm khi thay đổi giá ưu đãi
    document.getElementById('discount_price').addEventListener('input', function() {
        updateSavings();
    });
    
    // Xác thực form trước khi submit
    document.getElementById('comboForm').addEventListener('submit', function(e) {
        if (!validateComboForm()) {
            e.preventDefault();
        }
    });
});

// Khởi tạo Select2 cho dropdown sản phẩm
function initializeSelect2() {
    $('.product-select').select2({
        theme: 'bootstrap4',
        placeholder: 'Chọn sản phẩm',
        allowClear: true
    });
}

// Khởi tạo Tagify cho input tags
function initializeTagify() {
    var tagifyInput = document.querySelector('#tags');
    if (tagifyInput) {
        new Tagify(tagifyInput, {
            delimiters: ',',
            pattern: /#/,
            transformTag: function(tagData) {
                // Đảm bảo tag bắt đầu bằng #
                if (!tagData.value.startsWith('#')) {
                    tagData.value = '#' + tagData.value;
                }
            }
        });
    }
}

// Thêm hàng sản phẩm mới
function addNewProductRow() {
    const container = document.querySelector('.product-selection-container');
    const firstRow = container.querySelector('.product-selection-row');
    const newRow = firstRow.cloneNode(true);
    
    // Reset giá trị
    const select = newRow.querySelector('.product-select');
    select.value = '';
    select.innerHTML = firstRow.querySelector('.product-select').innerHTML;
    
    newRow.querySelector('.product-quantity').value = 1;
    newRow.querySelector('.remove-product').disabled = false;
    
    // Thêm vào container
    container.appendChild(newRow);
    
    // Khởi tạo lại Select2 cho select mới
    $(select).select2({
        theme: 'bootstrap4',
        placeholder: 'Chọn sản phẩm',
        allowClear: true
    });
    
    // Cập nhật tổng giá
    updateTotalPrice();
}

// Xóa hàng sản phẩm
function removeProductRow(button) {
    const row = button.closest('.product-selection-row');
    row.remove();
    updateTotalPrice();
    
    // Nếu chỉ còn 1 hàng, disable nút xóa
    const rows = document.querySelectorAll('.product-selection-row');
    if (rows.length === 1) {
        rows[0].querySelector('.remove-product').disabled = true;
    }
}

// Cập nhật tổng giá gốc
function updateTotalPrice() {
    let totalPrice = 0;
    
    document.querySelectorAll('.product-selection-row').forEach(function(row) {
        const select = row.querySelector('.product-select');
        const quantity = parseInt(row.querySelector('.product-quantity').value) || 0;
        
        if (select.value) {
            const selectedOption = select.options[select.selectedIndex];
            const price = parseFloat(selectedOption.dataset.price) || 0;
            totalPrice += price * quantity;
        }
    });
    
    // Cập nhật hiển thị và input hidden
    document.getElementById('original-price-display').textContent = totalPrice.toLocaleString('vi-VN');
    document.getElementById('original_price').value = totalPrice;
    
    // Cập nhật tiết kiệm
    updateSavings();
}

// Cập nhật số tiền tiết kiệm
function updateSavings() {
    const originalPrice = parseFloat(document.getElementById('original_price').value) || 0;
    const discountPrice = parseFloat(document.getElementById('discount_price').value) || 0;
    const savings = originalPrice - discountPrice;
    
    document.getElementById('savings-display').textContent = savings > 0 ? savings.toLocaleString('vi-VN') : 0;
}

// Xác thực form trước khi submit
function validateComboForm() {
    let isValid = true;
    
    // Kiểm tra tên combo
    const nameInput = document.getElementById('name');
    if (!nameInput.value.trim()) {
        showError(nameInput, 'Vui lòng nhập tên combo');
        isValid = false;
    } else {
        clearError(nameInput);
    }
    
    // Kiểm tra có ít nhất một sản phẩm được chọn
    let hasSelectedProduct = false;
    document.querySelectorAll('.product-select').forEach(function(select) {
        if (select.value) {
            hasSelectedProduct = true;
        }
    });
    
    if (!hasSelectedProduct) {
        // Hiển thị thông báo lỗi
        iziToast.error({
            title: 'Lỗi',
            message: 'Vui lòng chọn ít nhất một sản phẩm cho combo',
            position: 'topRight',
            timeout: 3000
        });
        isValid = false;
    }
    
    // Kiểm tra giá ưu đãi
    const discountPriceInput = document.getElementById('discount_price');
    const originalPrice = parseFloat(document.getElementById('original_price').value) || 0;
    const discountPrice = parseFloat(discountPriceInput.value) || 0;
    
    if (discountPrice <= 0) {
        showError(discountPriceInput, 'Giá ưu đãi phải lớn hơn 0');
        isValid = false;
    } else if (discountPrice > originalPrice) {
        showError(discountPriceInput, 'Giá ưu đãi không thể lớn hơn giá gốc');
        isValid = false;
    } else {
        clearError(discountPriceInput);
    }
    
    return isValid;
}

// Hiển thị lỗi cho input
function showError(input, message) {
    input.classList.add('is-invalid');
    
    // Tìm hoặc tạo phần tử hiển thị lỗi
    let feedback = input.nextElementSibling;
    if (!feedback || !feedback.classList.contains('invalid-feedback')) {
        feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        input.parentNode.insertBefore(feedback, input.nextSibling);
    }
    
    feedback.textContent = message;
    feedback.style.display = 'block';
}

// Xóa lỗi cho input
function clearError(input) {
    input.classList.remove('is-invalid');
    
    const feedback = input.nextElementSibling;
    if (feedback && feedback.classList.contains('invalid-feedback')) {
        feedback.style.display = 'none';
    }
}