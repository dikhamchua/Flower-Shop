function isProductAlreadyAdded(productId) {
    let isDuplicate = false;
    document.querySelectorAll('.product-select').forEach(select => {
        if (select.value === productId.toString()) {
            isDuplicate = true;
        }
    });
    return isDuplicate;
}

// Modify the product select change event
document.addEventListener('change', function(e) {
    if (e.target.classList.contains('product-select')) {
        const selectedValue = e.target.value;
        if (selectedValue) {
            let count = 0;
            document.querySelectorAll('.product-select').forEach(select => {
                if (select !== e.target && select.value === selectedValue) {
                    count++;
                }
            });
            if (count > 0) {
                alert('This product is already added to the combo!');
                e.target.value = '';
                return;
            }
        }
        // ... rest of your existing change event code ...
    }
});


function updateSavings() {
    const originalPrice = parseFloat(document.getElementById('original_price').value) || 0;
    const discountPrice = parseFloat(document.getElementById('discount_price').value) || 0;
    
    const savings = originalPrice - discountPrice;
    
    const savingsDisplay = document.getElementById('savings-display');
    if (savingsDisplay) {
        if (!isNaN(savings) && savings >= 0) {
            savingsDisplay.textContent = savings.toLocaleString('vi-VN');
        } else {
            savingsDisplay.textContent = '0';
        }
    }
}

// Thêm event listener cho input giá khuyến mãi
document.addEventListener('DOMContentLoaded', function() {
    const discountPriceInput = document.getElementById('discount_price');
    if (discountPriceInput) {
        discountPriceInput.addEventListener('input', updateSavings);
    }
});

// Cập nhật hàm updateTotalPrice để tự động gọi updateSavings
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
        }
    });

    const priceDisplay = document.getElementById('original-price-display');
    const priceInput = document.getElementById('original_price');

    if (priceDisplay && priceInput) {
        priceDisplay.textContent = totalPrice.toLocaleString('vi-VN');
        priceInput.value = totalPrice;
    }

    // Tự động cập nhật savings sau khi cập nhật giá gốc
    updateSavings();
}