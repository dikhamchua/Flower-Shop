document.addEventListener('DOMContentLoaded', function() {
    const categories = window.categories || [];
    let selectedCategoryIds = window.selectedCategoryIds || [];

    const categoryInput = document.getElementById('categoryInput');
    const categorySuggestions = document.getElementById('categorySuggestions');
    const selectedCategories = document.getElementById('selectedCategories');
    const categoryIdsInput = document.getElementById('categoryIdsInput');
    const form = document.getElementById('productForm');

    function initSelectedCategories() {
        selectedCategoryIds.forEach(id => {
            const category = categories.find(c => c.id == id);
            if (category) {
                addCategoryToDisplay(category.id, category.name);
            }
        });
        updateCategoryIdsInput();
    }

    function addCategoryToDisplay(id, name) {
        const categoryElement = document.createElement('div');
        categoryElement.className = 'selected-category';
        categoryElement.innerHTML = `
            <span class="category-name">${name}</span>
            <span class="remove-category" data-id="${id}">&times;</span>
        `;
        
        categoryElement.querySelector('.remove-category').addEventListener('click', function() {
            categoryElement.style.transform = 'scale(0.9)';
            categoryElement.style.opacity = '0';
            setTimeout(() => {
                removeCategory(id);
                categoryElement.remove();
            }, 300);
        });
        
        categoryElement.style.transform = 'scale(0.9)';
        categoryElement.style.opacity = '0';
        selectedCategories.appendChild(categoryElement);
        setTimeout(() => {
            categoryElement.style.transform = 'scale(1)';
            categoryElement.style.opacity = '1';
        }, 50);
    }

    function createSuggestionElement(category) {
        const suggestionElement = document.createElement('div');
        suggestionElement.className = 'category-suggestion';
        suggestionElement.textContent = category.name;
        suggestionElement.dataset.id = category.id;
        
        suggestionElement.addEventListener('mouseenter', () => {
            suggestionElement.style.backgroundColor = '#f8f9fa';
        });
        
        suggestionElement.addEventListener('mouseleave', () => {
            suggestionElement.style.backgroundColor = '';
        });
        
        suggestionElement.addEventListener('mousedown', () => {
            suggestionElement.style.transform = 'scale(0.98)';
        });
        
        suggestionElement.addEventListener('mouseup', () => {
            suggestionElement.style.transform = '';
        });
        
        suggestionElement.addEventListener('click', function() {
            addCategory(category.id, category.name);
            categoryInput.value = '';
            categorySuggestions.style.display = 'none';
        });
        
        return suggestionElement;
    }

    categoryInput.addEventListener('input', function() {
        const inputValue = this.value.trim().toLowerCase();
        categorySuggestions.innerHTML = '';
        
        if (inputValue.length < 1) {
            categorySuggestions.style.display = 'none';
            return;
        }
        
        const matchingCategories = categories.filter(category => 
            category.name.toLowerCase().includes(inputValue) && 
            !selectedCategoryIds.includes(category.id)
        );
        
        if (matchingCategories.length === 0) {
            categorySuggestions.innerHTML = '<div class="category-suggestion text-muted">No matching categories found</div>';
            categorySuggestions.style.display = 'block';
            return;
        }
        
        matchingCategories.forEach(category => {
            const suggestionElement = createSuggestionElement(category);
            categorySuggestions.appendChild(suggestionElement);
        });
        
        categorySuggestions.style.display = 'block';
    });

    function addCategory(id, name) {
        if (selectedCategoryIds.includes(id)) return;
        selectedCategoryIds.push(id);
        addCategoryToDisplay(id, name);
        updateCategoryIdsInput();
        validateCategories();
    }

    function removeCategory(id) {
        selectedCategoryIds = selectedCategoryIds.filter(categoryId => categoryId != id);
        updateCategoryIdsInput();
        validateCategories();
    }

    function updateCategoryIdsInput() {
        categoryIdsInput.value = selectedCategoryIds.join(',');
    }

    function validateCategories() {
        const feedback = document.querySelector('.category-input-container .invalid-feedback');
        if (selectedCategoryIds.length === 0) {
            categoryInput.classList.add('is-invalid');
            feedback.textContent = 'Please select at least one category';
            feedback.style.display = 'block';
            return false;
        } else {
            categoryInput.classList.remove('is-invalid');
            feedback.style.display = 'none';
            return true;
        }
    }

    initSelectedCategories();
    
    document.addEventListener('click', function(e) {
        if (!categoryInput.contains(e.target) && !categorySuggestions.contains(e.target)) {
            categorySuggestions.style.display = 'none';
        }
    });

    form.addEventListener('submit', function(event) {
        const isCategoryValid = validateCategories();
        if (!isCategoryValid) {
            event.preventDefault();
            iziToast.error({
                title: 'Error',
                message: 'Please select at least one category',
                position: 'topRight'
            });
        }
    });
}); 