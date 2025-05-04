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