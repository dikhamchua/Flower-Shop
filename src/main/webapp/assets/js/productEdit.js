document.addEventListener('DOMContentLoaded', function() {
    const suppliers = window.suppliers || [];
    let selectedSupplierIds = window.selectedSupplierIds || [];

    // Các biến cần thiết
    const supplierInput = document.getElementById('supplierInput');
    const supplierSuggestions = document.getElementById('supplierSuggestions');
    const selectedSuppliers = document.getElementById('selectedSuppliers');
    const supplierIdsInput = document.getElementById('supplierIdsInput');
    const form = document.getElementById('productForm');

    // Khởi tạo các supplier đã chọn
    function initSelectedSuppliers() {
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

    // Khởi tạo ban đầu
    initSelectedSuppliers();
    
    // Ẩn gợi ý khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!supplierInput.contains(e.target) && !supplierSuggestions.contains(e.target)) {
            supplierSuggestions.style.display = 'none';
        }
    });

    // Xử lý validate form
    form.addEventListener('submit', function(event) {
        const isSupplierValid = validateSuppliers();
        if (!isSupplierValid) {
            event.preventDefault();
            iziToast.error({
                title: 'Error',
                message: 'Please select at least one supplier',
                position: 'topRight'
            });
        }
    });
}); 