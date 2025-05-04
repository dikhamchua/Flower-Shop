<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <title>Add New Product</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <style>
                .form-control.is-invalid, .form-select.is-invalid {
                    border-color: #dc3545;
                    background-image: none;
                }
                .invalid-feedback {
                    display: none;
                    color: #dc3545;
                    margin-top: 5px;
                }
                .supplier-input-container {
                    position: relative;
                }
                .supplier-suggestions {
                    position: absolute;
                    width: 100%;
                    max-height: 200px;
                    overflow-y: auto;
                    background: white;
                    border: 1px solid #ced4da;
                    border-radius: 0.25rem;
                    z-index: 1000;
                    display: none;
                }
                .supplier-suggestion {
                    padding: 8px 12px;
                    cursor: pointer;
                }
                .supplier-suggestion:hover {
                    background-color: #f8f9fa;
                }
                .selected-suppliers {
                    margin-top: 10px;
                    display: flex;
                    flex-direction: column;
                    gap: 5px;
                }
                .selected-supplier {
                    background-color: #e9ecef;
                    border: 1px solid #ced4da;
                    border-radius: 0.25rem;
                    padding: 8px 12px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
                .remove-supplier {
                    cursor: pointer;
                    color: #dc3545;
                    font-size: 16px;
                }
                .supplier-name {
                    font-weight: 500;
                    color: #333;
                    flex-grow: 1;
                    margin-right: 10px;
                    word-break: break-word;
                }
                .category-input-container {
                    position: relative;
                    margin-bottom: 15px;
                }
                .category-suggestions {
                    position: absolute;
                    width: 100%;
                    max-height: 200px;
                    overflow-y: auto;
                    background: white;
                    border: 1px solid #ced4da;
                    border-radius: 0.25rem;
                    z-index: 1050;
                    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                }
                .category-suggestion {
                    padding: 10px 15px;
                    cursor: pointer;
                    border-bottom: 1px solid #f0f0f0;
                }
                .category-suggestion:hover {
                    background-color: #f8f9fa;
                }
                .category-suggestion:last-child {
                    border-bottom: none;
                }
                .selected-categories {
                    margin-top: 10px;
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                }
                .selected-category {
                    background-color: #e9ecef;
                    border: 1px solid #ced4da;
                    border-radius: 20px;
                    padding: 5px 12px;
                    display: inline-flex;
                    align-items: center;
                    transition: all 0.3s ease;
                }
                .category-name {
                    margin-right: 8px;
                }
                .remove-category {
                    cursor: pointer;
                    color: #dc3545;
                    font-weight: bold;
                }
                #categoryDropdownBtn.is-invalid {
                    border-color: #dc3545;
                }
            </style>
        </head>

        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Add New Product</h6>

                </div>

                <!-- Add Product Form -->
                <div class="card">
                    <div class="card-body p-24">
                        <form id="productForm" action="${pageContext.request.contextPath}/admin/manage-product" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">

                        <div class="row g-3">
                            <!-- Product Information -->
                            <div class="col-md-6">
                                <label class="form-label">Product Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control ${errors.name != null ? 'is-invalid' : ''}" 
                                       name="name" value="${formData.name[0]}">
                                <div class="invalid-feedback">${errors.name}</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Category <span class="text-danger">*</span></label>
                                <div class="category-input-container">
                                    <button type="button" id="categoryDropdownBtn" 
                                            class="btn btn-outline-secondary w-100 text-start d-flex justify-content-between align-items-center ${errors.categoryIds != null ? 'is-invalid' : ''}">
                                        <span>Choose category</span>
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <div id="categorySuggestions" class="category-suggestions" style="display: none;"></div>
                                    <div id="selectedCategories" class="selected-categories"></div>
                                    <input type="hidden" name="categoryIds" id="categoryIds" value="${formData.categoryIds[0]}">
                                    <div class="invalid-feedback">${errors.categoryIds != null ? errors.categoryIds : 'Please select at least one category'}</div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="4">${formData.description[0]}</textarea>
                                <div class="invalid-feedback"></div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Price <span class="text-danger">*</span></label>
                                <input type="number" class="form-control ${errors.price != null ? 'is-invalid' : ''}" 
                                       name="price" step="0.01" min="0" value="${formData.price[0]}">
                                <div class="invalid-feedback">${errors.price}</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Stock <span class="text-danger">*</span></label>
                                <input type="number" class="form-control ${errors.stock != null ? 'is-invalid' : ''}" 
                                       name="stock" min="0" value="${formData.stock[0]}">
                                <div class="invalid-feedback">${errors.stock}</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Product Image <span class="text-danger">*</span></label>
                                <input type="file" class="form-control ${errors.image != null ? 'is-invalid' : ''}" 
                                       name="image" accept="image/*">
                                <div class="invalid-feedback">${errors.image}</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Status <span class="text-danger">*</span></label>
                                <select class="form-select ${errors.status != null ? 'is-invalid' : ''}" name="status">
                                    <option value="" selected disabled>Select Status</option>
                                    <option value="1" ${formData.status != null && formData.status[0] == '1' ? 'selected' : ''}>Active</option>
                                    <option value="0" ${formData.status != null && formData.status[0] == '0' ? 'selected' : ''}>Inactive</option>
                                </select>
                                <div class="invalid-feedback">${errors.status}</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Suppliers <span class="text-danger">*</span></label>
                                <div class="supplier-input-container">
                                    <input type="text" class="form-control ${errors.supplierIds != null ? 'is-invalid' : ''}" 
                                           id="supplierInput" placeholder="Type to search suppliers...">
                                    <div id="supplierSuggestions" class="supplier-suggestions"></div>
                                    <div class="selected-suppliers" id="selectedSuppliers"></div>
                                    <input type="hidden" name="supplierIds" id="supplierIdsInput" value="${formData.supplierIds[0]}">
                                    <div class="invalid-feedback">${errors.supplierIds}</div>
                                </div>
                                <small class="text-muted">Type supplier name and select from suggestions</small>
                            </div>

                            <!-- Submit Button -->
                            <div class="col-md-12 mt-4">
                                <button type="submit" class="btn btn-primary">Add Product</button>
                                <a href="${pageContext.request.contextPath}/admin/manage-product"
                                   class="btn btn-secondary">Cancel</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Thêm đoạn này trước khi include file JS -->
        <script>
            // Khởi tạo biến categories để có thể truy cập từ file JS
            window.categories = [
            <c:forEach var="category" items="${categories}" varStatus="status">
                {
                    id: ${category.categoryId},
                    name: "${fn:escapeXml(category.name)}"
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            
            console.log("Categories initialized:", window.categories);
            
            // Khởi tạo biến suppliers để có thể truy cập từ file JS
            window.suppliers = [];
            <c:forEach var="supplier" items="${suppliers}">
            window.suppliers.push({
                id: '<c:out value="${supplier.supplierId}"/>',
                name: '<c:out value="${supplier.name}"/>'
            });
            </c:forEach>
        </script>

        <!-- Include file JS -->
        <script src="${pageContext.request.contextPath}/assets/js/productAdd.js"></script>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/categoryAdd.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Restore selected categories if form validation failed
                const categoryIdsValue = document.getElementById('categoryIds').value;
                if (categoryIdsValue) {
                    const categoryIds = categoryIdsValue.split(',');
                    categoryIds.forEach(id => {
                        const categoryId = parseInt(id.trim());
                        const category = window.categories.find(c => c.id === categoryId);
                        if (category) {
                            addSelectedCategory(category.id, category.name);
                        }
                    });
                }
                
                // Restore selected suppliers if form validation failed
                const supplierIdsValue = document.getElementById('supplierIdsInput').value;
                if (supplierIdsValue) {
                    const supplierIds = supplierIdsValue.split(',');
                    supplierIds.forEach(id => {
                        const supplierId = parseInt(id.trim());
                        const supplier = window.suppliers.find(s => s.id == supplierId);
                        if (supplier) {
                            addSelectedSupplier(supplier.id, supplier.name);
                        }
                    });
                }
                
                // Helper function to add a selected category to the UI
                function addSelectedCategory(id, name) {
                    const selectedCategoriesDiv = document.getElementById('selectedCategories');
                    
                    // Check if category is already selected
                    if (document.querySelector(`.selected-category[data-id="${id}"]`)) {
                        return;
                    }
                    
                    const categoryElement = document.createElement('div');
                    categoryElement.className = 'selected-category';
                    categoryElement.setAttribute('data-id', id);
                    categoryElement.innerHTML = `
                        <span class="category-name">${name}</span>
                        <span class="remove-category">&times;</span>
                    `;
                    
                    // Add event listener to remove button
                    categoryElement.querySelector('.remove-category').addEventListener('click', function() {
                        categoryElement.remove();
                        updateCategoryIds();
                    });
                    
                    selectedCategoriesDiv.appendChild(categoryElement);
                    updateCategoryIds();
                }
                
                // Helper function to add a selected supplier to the UI
                function addSelectedSupplier(id, name) {
                    const selectedSuppliersDiv = document.getElementById('selectedSuppliers');
                    
                    // Check if supplier is already selected
                    if (document.querySelector(`.selected-supplier[data-id="${id}"]`)) {
                        return;
                    }
                    
                    const supplierElement = document.createElement('div');
                    supplierElement.className = 'selected-supplier';
                    supplierElement.setAttribute('data-id', id);
                    supplierElement.innerHTML = `
                        <span class="supplier-name">${name}</span>
                        <span class="remove-supplier">&times;</span>
                    `;
                    
                    // Add event listener to remove button
                    supplierElement.querySelector('.remove-supplier').addEventListener('click', function() {
                        supplierElement.remove();
                        updateSupplierIds();
                    });
                    
                    selectedSuppliersDiv.appendChild(supplierElement);
                    updateSupplierIds();
                }
                
                // Helper function to update category IDs hidden input
                function updateCategoryIds() {
                    const selectedCategories = document.querySelectorAll('.selected-category');
                    const categoryIds = Array.from(selectedCategories).map(el => el.getAttribute('data-id'));
                    document.getElementById('categoryIds').value = categoryIds.join(',');
                }
                
                // Helper function to update supplier IDs hidden input
                function updateSupplierIds() {
                    const selectedSuppliers = document.querySelectorAll('.selected-supplier');
                    const supplierIds = Array.from(selectedSuppliers).map(el => el.getAttribute('data-id'));
                    document.getElementById('supplierIdsInput').value = supplierIds.join(',');
                }
            });
        </script>

    </body>
</html>