// comboProductManager.js sau khi chỉnh thêm console log hỗ trợ debug

document.addEventListener('DOMContentLoaded', function () {

    // Initialize Select2 for all product selects
    initializeSelect2();

    // Handle adding new product
    const addProductBtn = document.querySelector('.add-product');
    console.log('Add Product Button:', addProductBtn);

    if (addProductBtn) {
        addProductBtn.addEventListener('click', function () {
            console.log('Add Product button clicked');
            addNewProductRow();
        });
    } else {
        console.error('Add Product button not found!');
    }

    // Handle product removal
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('remove-product') || e.target.closest('.remove-product')) {
            console.log('Remove Product clicked');
            const button = e.target.classList.contains('remove-product') ? e.target : e.target.closest('.remove-product');
            if (!button.disabled) {
                removeProductRow(button);
            } else {
                console.warn('Remove button is disabled');
            }
        }
    });

    // Update price when product or quantity changes
    document.addEventListener('change', function (e) {
        if (e.target.classList.contains('product-select') || e.target.classList.contains('product-quantity')) {
            console.log('Product or quantity changed:', e.target.value);
            updateTotalPrice();
        }
    });
});

function initializeSelect2() {

    const selects = $('.product-select');

    // selects.select2({
    //     theme: 'bootstrap4',
    //     placeholder: 'Choose a product',
    //     allowClear: true
    // });
}

function addNewProductRow() {
    console.log('Adding new product row');
    const container = document.querySelector('.product-selection-container');
    console.log('Container:', container);

    if (!container) {
        console.error('No .product-selection-container found!');
        return;
    }

    const firstRow = container.querySelector('.product-selection-row');
    console.log('First row:', firstRow);

    if (!firstRow) {
        console.error('No .product-selection-row found inside container!');
        return;
    }

    const newRow = firstRow.cloneNode(true);
    console.log('Cloned new row:', newRow);

    // Reset values
    const select = newRow.querySelector('.product-select');
    if (!select) {
        console.error('No .product-select found in the new row!');
        return;
    }

    select.value = '';
    select.innerHTML = firstRow.querySelector('.product-select').innerHTML;

    const quantityInput = newRow.querySelector('.product-quantity');
    if (!quantityInput) {
        console.error('No .product-quantity found in the new row!');
        return;
    }

    quantityInput.value = 1;

    const removeButton = newRow.querySelector('.remove-product');
    if (removeButton) {
        removeButton.disabled = false;
    } else {
        console.error('No .remove-product button found in the new row!');
    }

    // Add to container
    container.appendChild(newRow);
    console.log('New row added to container');

    // Reinitialize Select2 for the new select
    console.log('Reinitializing Select2 for the new select');
    $(select).select2({
        theme: 'bootstrap4',
        placeholder: 'Choose a product',
        allowClear: true
    });

    updateTotalPrice();
}

function updateTotalPrice() {
    let totalPrice = 0;

    document.querySelectorAll('.product-selection-row').forEach(function (row) {
        const select = row.querySelector('.product-select');
        const quantity = parseInt(row.querySelector('.product-quantity')?.value) || 0;

        if (select?.value) {
            const selectedOption = select.options[select.selectedIndex];
            const price = parseFloat(selectedOption.dataset.price) || 0;
            const subtotal = price * quantity;

            totalPrice += subtotal;

            console.log('Calculating product subtotal:', {
                productId: select.value,
                price: price,
                quantity: quantity,
                subtotal: subtotal
            });
        } else {
            console.warn('Select or selected value is missing in a row');
        }
    });

    console.log('Total price calculated:', totalPrice);
    const priceDisplay = document.getElementById('original-price-display');
    const priceInput = document.getElementById('original_price');

    if (priceDisplay && priceInput) {
        priceDisplay.textContent = totalPrice.toLocaleString('vi-VN');
        priceInput.value = totalPrice;
    } else {
        console.error('Price display or input element not found');
    }

    updateSavings();
}

function updateSavings() {
    // Assuming you have a logic for savings update
    console.log('Updating savings...');
}

// Add this function
function validateComboForm() {
    // Kiểm tra xem có ít nhất một sản phẩm được chọn
    const productRows = document.querySelectorAll('.product-selection-row');
    let hasValidProduct = false;

    productRows.forEach(row => {
        const select = row.querySelector('.product-select');
        if (select && select.value) {
            hasValidProduct = true;
        }
    });

    if (!hasValidProduct) {
        alert('Vui lòng chọn ít nhất một sản phẩm cho combo');
        return false;
    }

    // Kiểm tra giá khuyến mãi
    const originalPrice = parseFloat(document.getElementById('original_price').value) || 0;
    const discountPrice = parseFloat(document.getElementById('discount_price').value) || 0;

    if (discountPrice >= originalPrice) {
        alert('Giá khuyến mãi phải nhỏ hơn giá gốc');
        return false;
    }

    return true;
}

// Thêm hàm mới để cập nhật hidden inputs trước khi submit
function updateHiddenInputs() {
    const productIds = [];
    const quantities = [];

    document.querySelectorAll('.product-selection-row').forEach(function (row) {
        const select = row.querySelector('.product-select');
        const quantity = row.querySelector('.product-quantity');

        if (select && select.value) {
            productIds.push(select.value);
            quantities.push(quantity.value);
        }
    });

    document.getElementById('productIdsInput').value = productIds.join(',');
    document.getElementById('quantitiesInput').value = quantities.join(',');
}

// Sửa lại event listener cho form submit
document.addEventListener('DOMContentLoaded', function () {
    const comboForm = document.getElementById('comboForm');
    if (comboForm) {
        // Nếu là trang edit, load sản phẩm đã chọn
        if (window.selectedProducts && Array.isArray(window.selectedProducts)) {
            console.log('Loading selected products:', window.selectedProducts);
            loadSelectedProducts();
        }

        comboForm.addEventListener('submit', function (e) {
            e.preventDefault(); // Ngăn form submit mặc định

            if (!validateComboForm()) {
                return;
            }

            // Cập nhật hidden inputs trước khi submit
            updateHiddenInputs();

            // Submit form
            this.submit();
        });
    }
});

// Thêm hàm mới để load sản phẩm đã chọn trong trang edit
function loadSelectedProducts() {
    const container = document.querySelector('.product-selection-container');
    if (!container)
        return;

    // Xóa hàng mẫu mặc định nếu có
    container.innerHTML = '';

    // Thêm lại các sản phẩm đã chọn
    window.selectedProducts.forEach((product, index) => {
        const row = createProductRow(product, index === 0);
        container.appendChild(row);
    });

    // Cập nhật tổng giá
    updateTotalPrice();
}

// Hàm tạo một hàng sản phẩm mới với dữ liệu có sẵn
function createProductRow(productData, isFirstRow) {
    const row = document.createElement('div');
    row.className = 'product-selection-row row align-items-end mb-3';

    row.innerHTML = `
        <div class="col-md-7">
            <label class="form-label">Sản phẩm <span class="text-danger">*</span></label>
            <select class="form-select product-select" required>
                <option value="">-- Chọn sản phẩm --</option>
                ${window.products.map(p => `
                    <option value="${p.id}" 
                            data-price="${p.price}"
                            ${p.id === productData.id ? 'selected' : ''}>
                        ${p.name} - ${p.price}đ
                    </option>
                `).join('')}
            </select>
        </div>
        <div class="col-md-3">
            <label class="form-label">Số lượng <span class="text-danger">*</span></label>
            <input type="number" class="form-control product-quantity" 
                   min="1" value="${productData.quantity}" required>
        </div>
        <div class="col-md-2 d-flex align-items-center">
            <button type="button" class="btn btn-outline-danger remove-product w-100" 
                    ${isFirstRow ? 'disabled' : ''}>
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;

    // Khởi tạo Select2 cho select mới
    $(row.querySelector('.product-select')).select2({
        theme: 'bootstrap4',
        placeholder: 'Chọn sản phẩm',
        allowClear: true
    });

    return row;
}