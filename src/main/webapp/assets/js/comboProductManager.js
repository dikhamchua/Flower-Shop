document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo Select2 cho tất cả các select sản phẩm
    initializeSelect2();
    
    // Khởi tạo Tagify cho input tags
    initializeTagify();
    
    // Tính toán giá ban đầu
    updateTotalPrice();
    
    // Xử lý thêm sản phẩm mới
    const addProductBtn = document.querySelector('.add-product');
    if (addProductBtn) {
        addProductBtn.addEventListener('click', function() {
            addNewProductRow();
        });
    }
    
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

document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo danh sách sản phẩm từ dữ liệu được truyền từ server
    const products = window.products || [];
    const selectedProducts = window.selectedProducts || [];
    
    // Khởi tạo các phần tử DOM
    const productInput = document.querySelector('.product-select');
    const productSuggestions = document.getElementById('productSuggestions');
    const selectedProductsContainer = document.getElementById('selectedProducts');
    const productIdsInput = document.getElementById('productIdsInput');
    const quantitiesInput = document.getElementById('quantitiesInput');
    const originalPriceDisplay = document.getElementById('original-price-display');
    const originalPriceInput = document.getElementById('original_price');
    const discountPriceInput = document.getElementById('discount_price');
    const savingsDisplay = document.getElementById('savings-display');
    
    // Mảng lưu trữ các sản phẩm đã chọn
    let selectedProductsList = [...selectedProducts];
    
    // Khởi tạo Tagify cho input tags
    if (document.querySelector('#tags')) {
        new Tagify(document.querySelector('#tags'), {
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
    
    // Hiển thị các sản phẩm đã chọn ban đầu (cho trang edit)
    if (selectedProducts.length > 0) {
        renderSelectedProducts();
        updateTotalPrice();
    }
    
    // Xử lý input để hiển thị gợi yếu sản phẩm
    if (productInput) {
        productInput.addEventListener('input', function() {
            const inputValue = this.value.trim().toLowerCase();
            
            // Xóa các gợi yếu cũ
            productSuggestions.innerHTML = '';
            
            if (inputValue.length < 1) {
                productSuggestions.style.display = 'none';
                return;
            }
            
            // Lọc sản phẩm phù hợp với input và chưa được chọn
            const matchingProducts = products.filter(product => 
                product.name.toLowerCase().includes(inputValue) && 
                !selectedProductsList.some(sp => sp.id === product.id)
            );
            
            if (matchingProducts.length === 0) {
                productSuggestions.innerHTML = '<div class="product-suggestion text-muted">Không tìm thấy sản phẩm phù hợp</div>';
                productSuggestions.style.display = 'block';
                return;
            }
            
            // Hiển thị các gợi yếu
            matchingProducts.forEach(product => {
                const suggestionElement = document.createElement('div');
                suggestionElement.className = 'product-suggestion';
                suggestionElement.textContent = product.name;
                suggestionElement.dataset.id = product.id;
                suggestionElement.dataset.name = product.name;
                suggestionElement.dataset.price = product.price;
                
                suggestionElement.addEventListener('click', function() {
                    addProduct(product.id, product.name, product.price);
                    productInput.value = '';
                    productSuggestions.style.display = 'none';
                });
                
                productSuggestions.appendChild(suggestionElement);
            });
            
            productSuggestions.style.display = 'block';
        });
        
        // Ẩn gợi yếu khi click ra ngoài
        document.addEventListener('click', function(e) {
            if (!productInput.contains(e.target) && !productSuggestions.contains(e.target)) {
                productSuggestions.style.display = 'none';
            }
        });
    }
    
    // Cập nhật tiết kiệm khi thay đổi giá ưu đãi
    if (discountPriceInput) {
        discountPriceInput.addEventListener('input', function() {
            updateSavings();
        });
    }
    
    // Thêm sản phẩm vào combo
    function addProduct(id, name, price) {
        // Kiểm tra xem sản phẩm đã được thêm chưa
        if (selectedProductsList.some(product => product.id === id)) {
            return;
        }
        
        // Thêm sản phẩm vào danh sách
        selectedProductsList.push({
            id: id,
            name: name,
            price: price,
            quantity: 1
        });
        
        // Cập nhật giao diện
        renderSelectedProducts();
        updateTotalPrice();
    }
    
    // Xóa sản phẩm khỏi combo
    function removeProduct(id) {
        selectedProductsList = selectedProductsList.filter(product => product.id !== id);
        renderSelectedProducts();
        updateTotalPrice();
    }
    
    // Cập nhật số lượng sản phẩm
    function updateQuantity(id, quantity) {
        const product = selectedProductsList.find(p => p.id === id);
        if (product) {
            product.quantity = quantity;
            updateTotalPrice();
        }
    }
    
    // Hiển thị danh sách sản phẩm đã chọn
    function renderSelectedProducts() {
        selectedProductsContainer.innerHTML = '';
        
        if (selectedProductsList.length === 0) {
            selectedProductsContainer.innerHTML = '<div class="alert alert-info">Chưa có sản phẩm nào được thêm vào combo</div>';
            return;
        }
        
        selectedProductsList.forEach(product => {
            const productElement = document.createElement('div');
            productElement.className = 'selected-product mb-2 p-2 border rounded d-flex align-items-center';
            
            productElement.innerHTML = `
                <div class="flex-grow-1">
                    <strong>${product.name}</strong>
                    <div class="text-muted">Giá: ${parseFloat(product.price).toLocaleString('vi-VN')} VNĐ</div>
                </div>
                <div class="d-flex align-items-center">
                    <label class="me-2">Số lượng:</label>
                    <input type="number" class="form-control form-control-sm quantity-input" 
                           min="1" value="${product.quantity}" style="width: 70px;"
                           data-id="${product.id}">
                    <button type="button" class="btn btn-sm btn-danger ms-2 remove-product" data-id="${product.id}">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;
            
            selectedProductsContainer.appendChild(productElement);
            
            // Thêm event listener cho nút xóa
            const removeButton = productElement.querySelector('.remove-product');
            removeButton.addEventListener('click', function() {
                removeProduct(product.id);
            });
            
            // Thêm event listener cho input số lượng
            const quantityInput = productElement.querySelector('.quantity-input');
            quantityInput.addEventListener('change', function() {
                const newQuantity = parseInt(this.value) || 1;
                if (newQuantity < 1) {
                    this.value = 1;
                    updateQuantity(product.id, 1);
                } else {
                    updateQuantity(product.id, newQuantity);
                }
            });
        });
        
        // Cập nhật input hidden
        updateHiddenInputs();
    }
    
    // Cập nhật input hidden để gửi lên server
    function updateHiddenInputs() {
        const productIds = selectedProductsList.map(p => p.id).join(',');
        const quantities = selectedProductsList.map(p => p.quantity).join(',');
        
        productIdsInput.value = productIds;
        quantitiesInput.value = quantities;
    }
    
    // Cập nhật tổng giá gốc
    function updateTotalPrice() {
        let totalPrice = 0;
        
        selectedProductsList.forEach(product => {
            totalPrice += parseFloat(product.price) * parseInt(product.quantity);
        });
        
        // Cập nhật hiển thị và input hidden
        if (originalPriceDisplay) {
            originalPriceDisplay.textContent = totalPrice.toLocaleString('vi-VN');
        }
        
        if (originalPriceInput) {
            originalPriceInput.value = totalPrice;
        }
        
        // Cập nhật tiết kiệm
        updateSavings();
    }
    
    // Cập nhật số tiền tiết kiệm
    function updateSavings() {
        if (!savingsDisplay || !originalPriceInput || !discountPriceInput) return;
        
        const originalPrice = parseFloat(originalPriceInput.value) || 0;
        const discountPrice = parseFloat(discountPriceInput.value) || 0;
        const savings = originalPrice - discountPrice;
        
        savingsDisplay.textContent = savings > 0 ? savings.toLocaleString('vi-VN') : 0;
    }
    
    // Xác thực form trước khi submit
    if (document.getElementById('comboForm')) {
        document.getElementById('comboForm').addEventListener('submit', function(e) {
            // Kiểm tra có ít nhất một sản phẩm được chọn
            if (selectedProductsList.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất một sản phẩm cho combo');
                return false;
            }
            
            // Kiểm tra giá ưu đãi
            const originalPrice = parseFloat(originalPriceInput.value) || 0;
            const discountPrice = parseFloat(discountPriceInput.value) || 0;
            
            if (discountPrice <= 0) {
                e.preventDefault();
                alert('Giá ưu đãi phải lớn hơn 0');
                return false;
            }
            
            if (discountPrice >= originalPrice) {
                e.preventDefault();
                alert('Giá ưu đãi phải nhỏ hơn giá gốc');
                return false;
            }
            
            return true;
        });
    }
});