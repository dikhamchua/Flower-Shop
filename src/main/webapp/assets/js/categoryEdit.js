document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM loaded - initializing category dropdown for edit");
    
    // Lấy dữ liệu categories từ window
    const categories = window.categories || [];
    console.log("Categories data:", categories);
    
    // Lấy danh sách category đã chọn từ window
    let selectedCategoryIds = window.selectedCategoryIds || [];
    console.log("Selected category IDs:", selectedCategoryIds);
    
    // Kiểm tra xem có dữ liệu categories không
    if (!categories || categories.length === 0) {
        console.error("No categories data available!");
    }

    // Lấy các phần tử DOM
    const categoryDropdownBtn = document.getElementById('categoryDropdownBtn');
    const categorySuggestions = document.getElementById('categorySuggestions');
    const selectedCategories = document.getElementById('selectedCategories');
    const categoryIds = document.getElementById('categoryIds');
    const form = document.getElementById('productForm');

    // Hiển thị danh mục đã chọn khi tải trang
    function initSelectedCategories() {
        selectedCategories.innerHTML = '';
        selectedCategoryIds.forEach(id => {
            const category = categories.find(c => c.id == id);
            if (category) {
                addCategoryToDisplay(category.id, category.name);
            }
        });
        updateCategoryIdsInput();
    }

    // Hiển thị danh mục đã chọn
    function addCategoryToDisplay(id, name) {
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

    // Hiển thị dropdown khi click vào button
    categoryDropdownBtn.addEventListener('click', function() {
        if (categorySuggestions.style.display === 'none') {
            // Hiển thị tất cả danh mục chưa được chọn
            showCategorySuggestions();
        } else {
            categorySuggestions.style.display = 'none';
        }
    });

    // Hiển thị danh sách gợi ý danh mục
    function showCategorySuggestions() {
        categorySuggestions.innerHTML = '';
        
        // Lọc ra các danh mục chưa được chọn
        const availableCategories = categories.filter(category => 
            !selectedCategoryIds.includes(category.id)
        );
        
        if (availableCategories.length === 0) {
            categorySuggestions.innerHTML = '<div class="category-suggestion text-muted">Không có danh mục nào khả dụng</div>';
        } else {
            availableCategories.forEach(category => {
                const suggestionElement = document.createElement('div');
                suggestionElement.className = 'category-suggestion';
                suggestionElement.textContent = category.name;
                
                suggestionElement.addEventListener('click', function() {
                    addCategory(category.id, category.name);
                    categorySuggestions.style.display = 'none';
                });
                
                categorySuggestions.appendChild(suggestionElement);
            });
        }
        
        categorySuggestions.style.display = 'block';
    }

    // Thêm danh mục vào danh sách đã chọn
    function addCategory(id, name) {
        if (selectedCategoryIds.includes(id)) return;
        
        selectedCategoryIds.push(id);
        addCategoryToDisplay(id, name);
        updateCategoryIdsInput();
        validateCategories();
    }

    // Xóa danh mục khỏi danh sách đã chọn
    function removeCategory(id) {
        selectedCategoryIds = selectedCategoryIds.filter(categoryId => categoryId != id);
        updateCategoryIdsInput();
        validateCategories();
    }

    // Cập nhật input hidden chứa danh sách ID danh mục
    function updateCategoryIdsInput() {
        categoryIds.value = selectedCategoryIds.join(',');
        console.log("Updated category IDs:", categoryIds.value);
    }

    // Kiểm tra xem đã chọn ít nhất một danh mục chưa
    function validateCategories() {
        if (selectedCategoryIds.length === 0) {
            categoryDropdownBtn.classList.add('is-invalid');
            document.querySelector('.category-input-container .invalid-feedback').style.display = 'block';
            return false;
        } else {
            categoryDropdownBtn.classList.remove('is-invalid');
            document.querySelector('.category-input-container .invalid-feedback').style.display = 'none';
            return true;
        }
    }

    // Ẩn dropdown khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!categoryDropdownBtn.contains(e.target) && !categorySuggestions.contains(e.target)) {
            categorySuggestions.style.display = 'none';
        }
    });

    // Kiểm tra khi submit form
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

    // Khởi tạo danh sách danh mục đã chọn
    initSelectedCategories();
    validateCategories();
}); 