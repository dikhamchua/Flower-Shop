document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM loaded - initializing category dropdown");
    
    // Lấy dữ liệu categories từ window
    const categories = window.categories || [];
    console.log("Categories data:", categories);
    
    // Kiểm tra xem có dữ liệu categories không
    if (!categories || categories.length === 0) {
        console.error("No categories data available!");
    }
    
    let selectedCategoryIds = [];

    // Lấy các phần tử DOM
    const categoryDropdownBtn = document.getElementById('categoryDropdownBtn');
    const categorySuggestions = document.getElementById('categorySuggestions');
    const selectedCategories = document.getElementById('selectedCategories');
    const categoryIdsInput = document.getElementById('categoryIds');
    
    console.log("DOM Elements:");
    console.log("- categoryDropdownBtn:", categoryDropdownBtn);
    console.log("- categorySuggestions:", categorySuggestions);
    console.log("- selectedCategories:", selectedCategories);
    console.log("- categoryIdsInput:", categoryIdsInput);

    // Kiểm tra xem các phần tử DOM có tồn tại không
    if (!categoryDropdownBtn || !categorySuggestions || !selectedCategories || !categoryIdsInput) {
        console.error("One or more required DOM elements not found!");
        return; // Dừng thực thi nếu thiếu phần tử
    }

    // Hiển thị danh mục đã chọn
    function addCategoryToDisplay(id, name) {
        console.log("Adding category to display:", id, name);
        const categoryElement = document.createElement('div');
        categoryElement.className = 'selected-category';
        categoryElement.innerHTML = `
            <span class="category-name">${name}</span>
            <span class="remove-category" data-id="${id}">&times;</span>
        `;
        
        categoryElement.querySelector('.remove-category').addEventListener('click', function() {
            removeCategory(id);
            categoryElement.remove();
        });
        
        selectedCategories.appendChild(categoryElement);
    }

    // Xử lý sự kiện click vào nút dropdown
    categoryDropdownBtn.addEventListener('click', function(e) {
        e.preventDefault();
        console.log("Category dropdown button clicked");
        
        // Toggle dropdown visibility
        if (categorySuggestions.style.display === 'block') {
            categorySuggestions.style.display = 'none';
            return;
        }
        
        // Xóa các gợi ý cũ
        categorySuggestions.innerHTML = '';
        
        // Lọc ra các danh mục chưa được chọn
        const availableCategories = categories.filter(category => {
            return !selectedCategoryIds.includes(parseInt(category.id));
        });
        
        console.log("Available categories:", availableCategories);
        
        if (availableCategories.length === 0) {
            categorySuggestions.innerHTML = '<div class="category-suggestion text-muted">Tất cả danh mục đã được chọn</div>';
            categorySuggestions.style.display = 'block';
            return;
        }
        
        // Tạo các phần tử gợi ý
        availableCategories.forEach(category => {
            const suggestionElement = document.createElement('div');
            suggestionElement.className = 'category-suggestion';
            suggestionElement.textContent = category.name;
            suggestionElement.dataset.id = category.id;
            
            suggestionElement.addEventListener('click', function() {
                console.log("Category selected:", category.id, category.name);
                addCategory(parseInt(category.id), category.name);
            });
            
            categorySuggestions.appendChild(suggestionElement);
        });
        
        categorySuggestions.style.display = 'block';
    });

    // Thêm danh mục vào danh sách đã chọn
    function addCategory(id, name) {
        console.log("Adding category:", id, name);
        if (selectedCategoryIds.includes(id)) {
            console.log("Category already selected, skipping");
            return;
        }
        
        selectedCategoryIds.push(id);
        console.log("Updated selectedCategoryIds:", selectedCategoryIds);
        
        addCategoryToDisplay(id, name);
        updateCategoryIdsInput();
        
        // Xóa danh mục đã chọn khỏi dropdown
        const selectedElement = categorySuggestions.querySelector(`[data-id="${id}"]`);
        if (selectedElement) {
            selectedElement.remove();
        }
        
        // Nếu không còn danh mục nào, cập nhật dropdown
        if (categorySuggestions.querySelectorAll('.category-suggestion').length === 0) {
            categorySuggestions.innerHTML = '<div class="category-suggestion text-muted">Tất cả danh mục đã được chọn</div>';
        }
    }

    // Xóa danh mục khỏi danh sách đã chọn
    function removeCategory(id) {
        console.log("Removing category:", id);
        selectedCategoryIds = selectedCategoryIds.filter(categoryId => categoryId != id);
        console.log("Updated selectedCategoryIds after removal:", selectedCategoryIds);
        updateCategoryIdsInput();
        
        // Nếu dropdown đang mở, cập nhật lại
        if (categorySuggestions.style.display === 'block') {
            categoryDropdownBtn.click(); // Đóng
            categoryDropdownBtn.click(); // Mở lại với danh sách đã cập nhật
        }
    }

    // Cập nhật giá trị input hidden
    function updateCategoryIdsInput() {
        categoryIdsInput.value = selectedCategoryIds.join(',');
        console.log("Updated categoryIdsInput value:", categoryIdsInput.value);
    }

    // Đóng dropdown khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!categoryDropdownBtn.contains(e.target) && 
            !categorySuggestions.contains(e.target)) {
            categorySuggestions.style.display = 'none';
        }
    });

    // Xác thực form khi submit
    const form = document.getElementById('productForm');
    if (form) {
        form.addEventListener('submit', function(event) {
            if (selectedCategoryIds.length === 0) {
                event.preventDefault();
                categoryDropdownBtn.classList.add('is-invalid');
                document.querySelector('.category-input-container .invalid-feedback').style.display = 'block';
                
                iziToast.error({
                    title: 'Lỗi',
                    message: 'Vui lòng chọn ít nhất một danh mục',
                    position: 'topRight'
                });
            } else {
                categoryDropdownBtn.classList.remove('is-invalid');
                document.querySelector('.category-input-container .invalid-feedback').style.display = 'none';
            }
        });
    }
}); 