document.addEventListener('DOMContentLoaded', function() {
    const suppliers = window.suppliers || [];
    let selectedSupplierIds = window.selectedSupplierIds || [];

    // Các biến cần thiết
    const supplierInput = document.getElementById('supplierInput');
    const supplierSuggestions = document.getElementById('supplierSuggestions');
    const selectedSuppliers = document.getElementById('selectedSuppliers');
    const supplierIdsInput = document.getElementById('supplierIdsInput');
    const form = document.getElementById('productForm');

    // Add references to all form fields
    const nameInput = form.querySelector('input[name="name"]');
    const priceInput = form.querySelector('input[name="price"]');
    const stockInput = form.querySelector('input[name="stock"]');
    const statusSelect = form.querySelector('select[name="status"]');
    const imageInput = form.querySelector('input[name="image"]');
    const categoryIdsInput = document.getElementById('categoryIdsInput');

    // Initialize the selected suppliers when the page loads
    initSelectedSuppliers();

    // Thêm hàm setValid và setInvalid
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

    // Các hàm validation
    function validateProductName(input) {
        const value = input.value.trim();
        const feedback = input.nextElementSibling;
        
        if (value === '') {
            setInvalid(input, feedback, 'Tên sản phẩm không được để trống');
            return false;
        } else if (value.length < 3) {
            setInvalid(input, feedback, 'Tên sản phẩm phải có ít nhất 3 ký tự');
            return false;
        } else {
            setValid(input, feedback);
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

    function validateImage(input) {
        const feedback = input.nextElementSibling;
        
        if (input.files.length === 0) {
            // Image is optional on edit
            setValid(input, feedback);
            return true;
        } else {
            const file = input.files[0];
            const fileType = file.type;
            const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            
            if (!validImageTypes.includes(fileType)) {
                setInvalid(input, feedback, 'Please select a valid image file (JPEG, PNG, GIF, WEBP)');
                return false;
            } else if (file.size > 20 * 1024 * 1024) { // 20MB
                setInvalid(input, feedback, 'Image size should be less than 20MB');
                return false;
            } else {
                setValid(input, feedback);
                return true;
            }
        }
    }

    function validateCategory() {
        const categoryIds = document.getElementById('categoryIds');
        const selectedCategoryIds = categoryIds.value.split(',').filter(id => id.trim() !== '');
        const categoryDropdownBtn = document.getElementById('categoryDropdownBtn');
        const feedback = document.querySelector('.category-input-container .invalid-feedback');
        
        if (selectedCategoryIds.length === 0) {
            categoryDropdownBtn.classList.add('is-invalid');
            feedback.style.display = 'block';
            return false;
        } else {
            categoryDropdownBtn.classList.remove('is-invalid');
            feedback.style.display = 'none';
            return true;
        }
    }

    // Khởi tạo các supplier đã chọn
    function initSelectedSuppliers() {
        selectedSuppliers.innerHTML = '';
        selectedSupplierIds.forEach(id => {
            const supplier = suppliers.find(s => s.id == id);
            if (supplier) {
                addSupplierToDisplay(supplier.id, supplier.name);
            }
        });
        updateSupplierIdsInput();
    }

    // Thêm supplier vào hiển thị
    function addSupplierToDisplay(id, name) {
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
    }

    // Xử lý input supplier
    supplierInput.addEventListener('input', function() {
        const inputValue = this.value.trim().toLowerCase();
        supplierSuggestions.innerHTML = '';
        
        if (inputValue.length < 1) {
            supplierSuggestions.style.display = 'none';
            return;
        }
        
        const matchingSuppliers = suppliers.filter(supplier => 
            supplier.name.toLowerCase().includes(inputValue) && 
            !selectedSupplierIds.includes(supplier.id)
        );
        
        if (matchingSuppliers.length === 0) {
            supplierSuggestions.innerHTML = '<div class="supplier-suggestion text-muted">No matching suppliers found</div>';
            supplierSuggestions.style.display = 'block';
            return;
        }
        
        matchingSuppliers.forEach(supplier => {
            const suggestionElement = document.createElement('div');
            suggestionElement.className = 'supplier-suggestion';
            suggestionElement.textContent = supplier.name;
            suggestionElement.dataset.id = supplier.id;
            
            suggestionElement.addEventListener('click', function() {
                addSupplier(supplier.id, supplier.name);
                supplierInput.value = '';
                supplierSuggestions.style.display = 'none';
            });
            
            supplierSuggestions.appendChild(suggestionElement);
        });
        
        supplierSuggestions.style.display = 'block';
    });

    // Các hàm xử lý chính
    function addSupplier(id, name) {
        if (selectedSupplierIds.includes(id)) return;
        selectedSupplierIds.push(id);
        addSupplierToDisplay(id, name);
        updateSupplierIdsInput();
        validateSuppliers();
    }

    function removeSupplier(id) {
        selectedSupplierIds = selectedSupplierIds.filter(supplierId => supplierId != id);
        updateSupplierIdsInput();
        validateSuppliers();
    }

    function updateSupplierIdsInput() {
        supplierIdsInput.value = selectedSupplierIds.join(',');
    }

    // Validate suppliers
    function validateSuppliers() {
        const feedback = document.querySelector('.supplier-input-container .invalid-feedback');
        if (selectedSupplierIds.length === 0) {
            supplierInput.classList.add('is-invalid');
            feedback.textContent = 'Please select at least one supplier';
            feedback.style.display = 'block';
            return false;
        } else {
            supplierInput.classList.remove('is-invalid');
            feedback.style.display = 'none';
            return true;
        }
    }

    // Ẩn gợi ý khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!supplierInput.contains(e.target) && !supplierSuggestions.contains(e.target)) {
            supplierSuggestions.style.display = 'none';
        }
    });

    // Update form submit handler
    form.addEventListener('submit', function(event) {
        event.preventDefault();
        
        // Validate all fields
        const isNameValid = validateProductName(nameInput);
        const isCategoryValid = validateCategory();
        const isPriceValid = validatePrice(priceInput);
        const isStockValid = validateStock(stockInput);
        const isImageValid = validateImage(imageInput);
        const isStatusValid = validateStatus(statusSelect);
        const isSupplierValid = validateSuppliers();

        console.log("Validation results:");
        console.log("- Name:", isNameValid);
        console.log("- Category:", isCategoryValid);
        console.log("- Price:", isPriceValid);
        console.log("- Stock:", isStockValid);
        console.log("- Image:", isImageValid);
        console.log("- Status:", isStatusValid);
        console.log("- Supplier:", isSupplierValid);

        if (isNameValid && isCategoryValid && isPriceValid && 
            isStockValid && isImageValid && isStatusValid && isSupplierValid) {
            console.log("Form is valid, submitting...");
            this.submit();
        } else {
            console.log("Form validation failed");
            iziToast.error({
                title: 'Lỗi',
                message: 'Vui lòng sửa các lỗi trước khi gửi',
                position: 'topRight'
            });
        }
    });
}); 