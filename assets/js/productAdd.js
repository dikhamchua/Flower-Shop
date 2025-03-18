document.addEventListener('DOMContentLoaded', function() {
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
    
    // Danh sách suppliers từ server
    const suppliers = window.suppliers || [];
    
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
}); 