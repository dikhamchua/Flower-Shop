document.addEventListener('DOMContentLoaded', function() {
    const suppliers = window.suppliers || [];
    // Toast message handling
    var toastMessage = "${sessionScope.toastMessage}";
    var toastType = "${sessionScope.toastType}";
    if (toastMessage) {
        iziToast.show({
            title: toastType === 'success' ? 'Success' : 'Error',
            message: toastMessage,
            position: 'topRight',
            color: toastType === 'success' ? 'green' : 'red',
            timeout: 5000,
            onClosing: function() {
                fetch('${pageContext.request.contextPath}/remove-toast', {
                    method: 'POST'
                });
            }
        });
    }

    // Form validation
    const form = document.getElementById('productForm');
    const nameInput = form.querySelector('input[name="name"]');
    const categorySelect = form.querySelector('select[name="categoryId"]');
    const priceInput = form.querySelector('input[name="price"]');
    const stockInput = form.querySelector('input[name="stock"]');
    const imageInput = form.querySelector('input[name="image"]');
    const statusSelect = form.querySelector('select[name="status"]');
    const supplierInput = document.getElementById('supplierInput');
    const supplierSuggestions = document.getElementById('supplierSuggestions');
    const selectedSuppliers = document.getElementById('selectedSuppliers');
    const supplierIdsInput = document.getElementById('supplierIdsInput');
    
    // Mảng lưu trữ các supplier đã chọn
    let selectedSupplierIds = [];
    
    // Xử lý input để hiển thị gợi ý
    supplierInput.addEventListener('input', function() {
        const inputValue = this.value.trim().toLowerCase();
        
        // Xóa các gợi ý cũ
        supplierSuggestions.innerHTML = '';
        
        if (inputValue.length < 1) {
            supplierSuggestions.style.display = 'none';
            return;
        }
        
        // Lọc suppliers phù hợp với input và chưa được chọn
        const matchingSuppliers = suppliers.filter(supplier => 
            supplier.name.toLowerCase().includes(inputValue) && 
            !selectedSupplierIds.includes(supplier.id)
        );
        
        if (matchingSuppliers.length === 0) {
            supplierSuggestions.innerHTML = '<div class="supplier-suggestion text-muted">No matching suppliers found</div>';
            supplierSuggestions.style.display = 'block';
            return;
        }
        
        // Hiển thị các gợi ý
        matchingSuppliers.forEach(supplier => {
            const suggestionElement = document.createElement('div');
            suggestionElement.className = 'supplier-suggestion';
            suggestionElement.textContent = supplier.name;
            suggestionElement.dataset.id = supplier.id;
            suggestionElement.dataset.name = supplier.name;
            
            suggestionElement.addEventListener('click', function() {
                console.log("Adding supplier:", supplier.id, supplier.name);
                addSupplier(supplier.id, supplier.name);
                supplierInput.value = '';
                supplierSuggestions.style.display = 'none';
            });
            
            supplierSuggestions.appendChild(suggestionElement);
        });
        
        supplierSuggestions.style.display = 'block';
    });
    
    // Ẩn gợi ý khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!supplierInput.contains(e.target) && !supplierSuggestions.contains(e.target)) {
            supplierSuggestions.style.display = 'none';
        }
    });
    
    // Thêm supplier đã chọn
    function addSupplier(id, name) {
        console.log("addSupplier called with:", id, name);
        if (selectedSupplierIds.includes(id)) return;
        
        selectedSupplierIds.push(id);
        updateSupplierIdsInput();
        
        const supplierElement = document.createElement('div');
        supplierElement.className = 'selected-supplier';
        supplierElement.innerHTML = `
            <span class="supplier-name">${name}</span>
            <span class="remove-supplier" data-id="${id}">&times;</span>
        `;
        
        supplierElement.querySelector('.remove-supplier').addEventListener('click', function() {
            removeSupplier(id);
            supplierElement.remove();
        });
        
        selectedSuppliers.appendChild(supplierElement);
        validateSuppliers();
    }
    
    // Xóa supplier đã chọn
    function removeSupplier(id) {
        selectedSupplierIds = selectedSupplierIds.filter(supplierId => supplierId != id);
        updateSupplierIdsInput();
        validateSuppliers();
    }
    
    // Cập nhật input hidden chứa danh sách supplier IDs
    function updateSupplierIdsInput() {
        supplierIdsInput.value = selectedSupplierIds.join(',');
    }
    
    // Thay đổi hàm validateSuppliers
    function validateSuppliers() {
        const feedback = document.querySelector('.supplier-input-container .invalid-feedback');
        
        if (selectedSupplierIds.length === 0) {
            setInvalid(supplierInput, feedback, 'Please select at least one supplier');
            return false;
        } else {
            setValid(supplierInput, feedback);
            return true;
        }
    }

    // Validate on form submit
    form.addEventListener('submit', function(event) {
        // Prevent default form submission
        event.preventDefault();
        console.log("Form submit triggered");

        // Validate all fields
        const isNameValid = validateProductName(nameInput);
        const isCategoryValid = validateCategory(categorySelect);
        const isPriceValid = validatePrice(priceInput);
        const isStockValid = validateStock(stockInput);
        const isImageValid = validateImage(imageInput);
        const isStatusValid = validateStatus(statusSelect);
        const isSupplierValid = validateSuppliers();

        console.log("Validation results:");
        console.log("Name valid:", isNameValid);
        console.log("Category valid:", isCategoryValid);
        console.log("Price valid:", isPriceValid);
        console.log("Stock valid:", isStockValid);
        console.log("Image valid:", isImageValid);
        console.log("Status valid:", isStatusValid);
        console.log("Supplier valid:", isSupplierValid);
        console.log("All valid:", isNameValid && isCategoryValid && isPriceValid && isStockValid && isImageValid && isStatusValid && isSupplierValid);

        // If all validations pass, submit the form
        if (isNameValid && isCategoryValid && isPriceValid && isStockValid && isImageValid && isStatusValid && isSupplierValid) {
            console.log("All validations passed, submitting form");
            this.submit();
        } else {
            console.log("Validation failed, form not submitted");
            // Show error message
            iziToast.error({
                title: 'Error',
                message: 'Please correct the errors before submitting the form',
                position: 'topRight',
                timeout: 1000
            });

            // Focus on the first invalid field
            if (!isNameValid) nameInput.focus();
            else if (!isCategoryValid) categorySelect.focus();
            else if (!isPriceValid) priceInput.focus();
            else if (!isStockValid) stockInput.focus();
            else if (!isImageValid) imageInput.focus();
            else if (!isStatusValid) statusSelect.focus();
            else if (!isSupplierValid) supplierInput.focus();
        }
    });

    // Validation functions
    function validateProductName(input) {
        const value = input.value.trim();
        const feedback = input.nextElementSibling;
        
        if (value === '') {
            setInvalid(input, feedback, 'Product name is required');
            return false;
        } else if (value.length < 3) {
            setInvalid(input, feedback, 'Product name must be at least 3 characters');
            return false;
        } else if (value.length > 100) {
            setInvalid(input, feedback, 'Product name must be less than 100 characters');
            return false;
        } else {
            setValid(input, feedback);
            return true;
        }
    }

    function validateCategory(select) {
        const value = select.value;
        const feedback = select.nextElementSibling;
        
        if (value === '' || value === null) {
            setInvalid(select, feedback, 'Please select a category');
            return false;
        } else {
            setValid(select, feedback);
            return true;
        }
    }

    function validatePrice(input) {
        const value = input.value.trim();
        const feedback = input.nextElementSibling;
        
        if (value === '') {
            setInvalid(input, feedback, 'Price is required');
            return false;
        } else if (isNaN(value) || parseFloat(value) < 0) {
            setInvalid(input, feedback, 'Price must be a positive number');
            return false;
        } else {
            setValid(input, feedback);
            return true;
        }
    }

    function validateStock(input) {
        const value = input.value.trim();
        const feedback = input.nextElementSibling;
        
        if (value === '') {
            setInvalid(input, feedback, 'Stock is required');
            return false;
        } else if (isNaN(value) || parseInt(value) < 0) {
            setInvalid(input, feedback, 'Stock must be a positive number');
            return false;
        } else {
            setValid(input, feedback);
            return true;
        }
    }

    function validateImage(input) {
        const feedback = input.nextElementSibling;
        
        if (input.files.length === 0) {
            setInvalid(input, feedback, 'Please select an image');
            return false;
        } else {
            const file = input.files[0];
            const fileType = file.type;
            const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            
            if (!validImageTypes.includes(fileType)) {
                setInvalid(input, feedback, 'Please select a valid image file (JPEG, PNG, GIF, WEBP)');
                return false;
            } else if (file.size > 20 * 1024 * 1024) { // 20MB
                setInvalid(input, feedback, 'Image size should be less than 5MB');
                return false;
            } else {
                setValid(input, feedback);
                return true;
            }
        }
    }

    function validateStatus(select) {
        const value = select.value;
        const feedback = select.nextElementSibling;
        
        if (value === '' || value === null) {
            setInvalid(select, feedback, 'Please select a status');
            return false;
        } else {
            setValid(select, feedback);
            return true;
        }
    }

    function setInvalid(input, feedback, message) {
        input.classList.add('is-invalid');
        input.classList.remove('is-valid');
        feedback.textContent = message;
        feedback.style.display = 'block';
    }

    function setValid(input, feedback) {
        input.classList.remove('is-invalid');
        input.classList.add('is-valid');
        feedback.textContent = '';
        feedback.style.display = 'none';
    }
});
