package com.swp391.controller.dashboard.admin;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.swp391.dal.impl.CategoryDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Product;
import com.swp391.entity.Category;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.io.File;
import com.swp391.dal.impl.SupplierDAO;
import com.swp391.dal.impl.ProductSupplierDAO;
import com.swp391.entity.Supplier;
import java.util.Arrays;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.InputStream;
import java.util.ArrayList;
import com.swp391.dal.impl.CategoryProductDAO;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,   // 10 MB
    maxRequestSize = 1024 * 1024 * 50  // 50 MB
)
@WebServlet(name="ManageProductController", urlPatterns={"/admin/manage-product"})
public class ManageProductController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Nếu không có action, mặc định là list
        if (action == null) {
            action = "list"; // Default action
        }
        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "deactivate":
                deactivateProduct(request, response);
                break;
            case "activate":
                activateProduct(request, response);
                break;
            case "list":
            default:
                listProduct(request, response);
                break;
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }
        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "import":
                importProductsFromExcel(request, response);
                break;
            default:
                listProduct(request, response);
                break;
        }
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }


    private void listProduct(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
            // Get filter parameters
            String searchFilter = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String categoryIdFilter = request.getParameter("categoryId");

            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            List<Product> products;
            int totalProducts;
            
            // Apply filters if provided
            if ((searchFilter != null && !searchFilter.isEmpty()) || 
                (statusFilter != null && !statusFilter.isEmpty()) ||
                (categoryIdFilter != null && !categoryIdFilter.isEmpty())) {
                
                // Convert status filter to byte if provided
                Byte statusByte = null;
                if (statusFilter != null && !statusFilter.isEmpty()) {
                    statusByte = Byte.parseByte(statusFilter);
                }
                
                // Convert category ID filter to integer if provided
                Integer categoryId = null;
                if (categoryIdFilter != null && !categoryIdFilter.isEmpty()) {
                    categoryId = Integer.parseInt(categoryIdFilter);
                }
                
                // Get filtered products with pagination
                products = productDAO.findProductsWithFilter(searchFilter, statusByte, categoryId, page, pageSize);
                totalProducts = productDAO.countProductsWithFilter(searchFilter, statusByte, categoryId);
            } else {
                // Get all products with pagination
                products = productDAO.findProductsWithPagination(page, pageSize);
                totalProducts = productDAO.getTotalProducts();
            }
            
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // Get all categories for the dropdown
            List<Category> categories = categoryDAO.findAll();
            
            // Get all suppliers for the dropdown
            SupplierDAO supplierDAO = new SupplierDAO();
            List<Supplier> suppliers = supplierDAO.findAll();
            
            // Create a map of categoryId to Category for easy lookup in JSP
            Map<Integer, Category> categoryMap = new HashMap<>();
            for (Category category : categories) {
                categoryMap.put(category.getCategoryId(), category);
            }
            
            // Create a map of supplierId to Supplier for easy lookup in JSP
            Map<Integer, Supplier> supplierMap = new HashMap<>();
            for (Supplier supplier : suppliers) {
                supplierMap.put(supplier.getSupplierId(), supplier);
            }
            
            // Get supplier information for each product
            ProductSupplierDAO psDAO = new ProductSupplierDAO();
            Map<Integer, List<Supplier>> productSuppliersMap = new HashMap<>();
            for (Product product : products) {
                List<Supplier> productSuppliers = psDAO.getSuppliersByProductId(product.getProductId());
                productSuppliersMap.put(product.getProductId(), productSuppliers);
            }
            
            // Get categories for each product
            CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
            Map<Integer, List<Category>> productCategoriesMap = new HashMap<>();
            for (Product product : products) {
                List<Category> productCategories = categoryProductDAO.getCategoriesByProductId(product.getProductId());
                productCategoriesMap.put(product.getProductId(), productCategories);
            }
            
            // Set attributes for JSP
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("supplierMap", supplierMap);
            request.setAttribute("productSuppliersMap", productSuppliersMap);
            request.setAttribute("productCategoriesMap", productCategoriesMap);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);

            // Set filter values for maintaining state
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchFilter", searchFilter);
            request.setAttribute("categoryIdFilter", categoryIdFilter);

        request.getRequestDispatcher("/view/admin/product-list.jsp").forward(request, response);

    }

    private void activateProduct(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findById(productId);
            
            // Get current page for redirect
            String currentPage = request.getParameter("page");
            if (currentPage == null || currentPage.isEmpty()) {
                currentPage = "1";
            }
            
            if (product != null) {
                product.setStatus((byte) 1);
                boolean isSuccess = productDAO.update(product);
                
                if (isSuccess) {
                    setToastMessage(request, "Product activation successful!", "success");
                } else {
                    setToastMessage(request, "Product activation failed!", "error");
                }
            } else {
                setToastMessage(request, "No products found!", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        // Redirect back to the same page
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-product?page=" + currentPage);
    }

    private void deactivateProduct(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findById(productId);
            
            // Get current page for redirect
            String currentPage = request.getParameter("page");
            if (currentPage == null || currentPage.isEmpty()) {
                currentPage = "1";
            }
            
            if (product != null) {
                product.setStatus((byte) 0);
                boolean isSuccess = productDAO.update(product);
                
                if (isSuccess) {
                    setToastMessage(request, "Product deactivated successfully!", "success");
                } else {
                    setToastMessage(request, "Product deactivation failed!", "error");
                }
            } else {
                setToastMessage(request, "No products found!", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        // Redirect back to the same page
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-product?page=" + currentPage);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findById(productId);

            if (product != null) {
                // Get all categories for dropdown
                CategoryDAO categoryDAO = new CategoryDAO();
                List<Category> categories = categoryDAO.findAll();
                request.setAttribute("categories", categories);

                // Get selected categories for this product
                CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                List<Category> selectedCategories = categoryProductDAO.getCategoriesByProductId(productId);
                
                // Create a list of selected category IDs
                List<Integer> selectedCategoryIds = new ArrayList<>();
                for (Category category : selectedCategories) {
                    selectedCategoryIds.add(category.getCategoryId());
                }
                request.setAttribute("selectedCategoryIds", selectedCategoryIds);

                // Get all suppliers for dropdown
                SupplierDAO supplierDAO = new SupplierDAO();
                List<Supplier> suppliers = supplierDAO.findAll();
                request.setAttribute("suppliers", suppliers);

                // Get selected suppliers for this product
                ProductSupplierDAO psDAO = new ProductSupplierDAO();
                List<Integer> selectedSupplierIds = psDAO.getSupplierIdsByProductId(productId);
                request.setAttribute("selectedSupplierIds", selectedSupplierIds);

                request.setAttribute("product", product);
                request.getRequestDispatcher("/view/admin/product-edit.jsp").forward(request, response);
            } else {
                setToastMessage(request, "No products found!", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-product");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manage-product");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);
            
            // Lấy danh sách nhà cung cấp
            SupplierDAO supplierDAO = new SupplierDAO();
            List<Supplier> suppliers = supplierDAO.findAll();
            request.setAttribute("suppliers", suppliers);
            
            // Preserve form data if available
            if (request.getAttribute("formData") == null && request.getParameter("name") != null) {
                Map<String, String[]> formData = request.getParameterMap();
                request.setAttribute("formData", formData);
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/product-add.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            setToastMessage(request, "Error loading form data: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/admin/manage-product");
        }
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }


    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String name = request.getParameter("name");
            String categoryIdsStr = request.getParameter("categoryIds");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            byte status = Byte.parseByte(request.getParameter("status"));
            
            // Get current page for redirect
            String currentPage = request.getParameter("page");
            if (currentPage == null || currentPage.isEmpty()) {
                currentPage = "1";
            }

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findById(productId);

            if (product != null) {
                // Validate input data
                if (name == null || name.trim().isEmpty()) {
                    setToastMessage(request, "Tên sản phẩm không được để trống", "error");
                    response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=edit&id=" + productId);
                    return;
                }
                
                // Handle image upload
                Part filePart = request.getPart("image");
                String fileName = null;
                
                // Only process image if a new one is uploaded
                if (filePart != null && filePart.getSize() > 0) {
                    // Get original file name
                    String originalFileName = filePart.getSubmittedFileName();
                    // Create unique file name
                    fileName = System.currentTimeMillis() + "_" + originalFileName;
                    
                    // Upload path
                    String uploadPath = request.getServletContext().getRealPath("/uploads/products/");
                    
                    // Create directory if not exists
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    filePart.write(uploadPath + File.separator + fileName);
                    fileName = "uploads/products/" + fileName;
                    
                    product.setImage(fileName);
                }
                
                // Update fields
                product.setProductName(name);
                product.setDescription(description);
                product.setPrice(price);
                product.setStock(stock);
                product.setStatus(status);
                product.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                
                // Perform update
                boolean isSuccess = productDAO.update(product);
                
                if (isSuccess) {
                    // Update category relationships
                    CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                    
                    // Remove all existing category links
                    categoryProductDAO.removeAllCategoriesFromProduct(productId);
                    
                    // Add new category links from the comma-separated string
                    if (categoryIdsStr != null && !categoryIdsStr.isEmpty()) {
                        String[] categoryIdArray = categoryIdsStr.split(",");
                        for (String categoryIdStr : categoryIdArray) {
                            int categoryId = Integer.parseInt(categoryIdStr.trim());
                            categoryProductDAO.addCategoryToProduct(categoryId, productId);
                        }
                    }
                    
                    // Update supplier relationships
                    String supplierIdsStr = request.getParameter("supplierIds");
                    ProductSupplierDAO psDAO = new ProductSupplierDAO();
                    
                    // Remove all existing supplier links
                    psDAO.removeProductSuppliers(productId);
                    
                    // Add new supplier links
                    if (supplierIdsStr != null && !supplierIdsStr.isEmpty()) {
                        // Tách chuỗi ID thành mảng
                        String[] supplierIdArray = supplierIdsStr.split(",");
                        for (String supplierIdStr : supplierIdArray) {
                            int supplierId = Integer.parseInt(supplierIdStr.trim());
                            psDAO.addProductSupplier(productId, supplierId);
                        }
                    }
                    
                    setToastMessage(request, "Product update successful!", "success");
                } else {
                    setToastMessage(request, "Product update failed!", "error");
                }
            } else {
                setToastMessage(request, "No products found!", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        // Redirect back to the same page
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-product?page=" + currentPage);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            System.out.println("addProduct method called");

            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            // Lấy category IDs từ input hidden
            String categoryIdsStr = request.getParameter("categoryIds");
            String statusStr = request.getParameter("status");
            String supplierIdsStr = request.getParameter("supplierIds");

            System.out.println("Form data received: name=" + name + ", price=" + priceStr +
                               ", stock=" + stockStr + ", categoryIds=" + categoryIdsStr +
                               ", status=" + statusStr);

            // Validate required fields
            Map<String, String> errors = new HashMap<>();
            
            // Validate product name
            if (name == null || name.trim().isEmpty()) {
                errors.put("name", "Product name is required");
            } else {
                // Check if product name already exists
                ProductDAO productDAO = new ProductDAO();
                Product existingProduct = productDAO.findByName(name.trim());
                if (existingProduct != null) {
                    errors.put("name", "Product with this name already exists");
                }
            }
            
            // Validate price
            if (priceStr == null || priceStr.trim().isEmpty()) {
                errors.put("price", "Price is required");
            } else {
                try {
                    BigDecimal price = new BigDecimal(priceStr);
                    if (price.compareTo(BigDecimal.ZERO) < 0) {
                        errors.put("price", "Price cannot be negative");
                    }
                } catch (NumberFormatException e) {
                    errors.put("price", "Invalid price format");
                }
            }
            
            // Validate stock
            if (stockStr == null || stockStr.trim().isEmpty()) {
                errors.put("stock", "Stock is required");
            } else {
                try {
                    int stock = Integer.parseInt(stockStr);
                    if (stock < 0) {
                        errors.put("stock", "Stock cannot be negative");
                    }
                } catch (NumberFormatException e) {
                    errors.put("stock", "Invalid stock format");
                }
            }
            
            // Validate categories
            if (categoryIdsStr == null || categoryIdsStr.trim().isEmpty()) {
                errors.put("categoryIds", "At least one category is required");
            }
            
            // Validate status
            if (statusStr == null || statusStr.trim().isEmpty()) {
                errors.put("status", "Status is required");
            }
            
            // Validate suppliers
            if (supplierIdsStr == null || supplierIdsStr.trim().isEmpty()) {
                errors.put("supplierIds", "At least one supplier is required");
            }
            
            // Validate image
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                errors.put("image", "Product image is required");
            }

            // If there are validation errors, return to the form with error messages
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("formData", request.getParameterMap());
                showAddForm(request, response);
                return;
            }

            // Chuyển đổi các giá trị
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);
            byte status = Byte.parseByte(statusStr);

            // Xử lý file ảnh
            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {
                System.out.println("File received: " + filePart.getSubmittedFileName() + ", size: " + filePart.getSize());

                // Lấy tên file gốc
                String originalFileName = filePart.getSubmittedFileName();
                // Tạo tên file duy nhất
                fileName = System.currentTimeMillis() + "_" + originalFileName;

                // Đường dẫn lưu file
                String uploadPath = request.getServletContext().getRealPath("/uploads/products/");
                System.out.println("Upload path: " + uploadPath);

                // Tạo thư mục nếu chưa tồn tại
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs();
                    System.out.println("Directory created: " + created);
                }

                // Lưu file
                String fullPath = uploadPath + File.separator + fileName;
                System.out.println("Saving file to: " + fullPath);
                filePart.write(fullPath);

                // Đường dẫn tương đối để lưu vào database
                fileName = "uploads/products/" + fileName;
            }

            // Tạo đối tượng Product mới
            Product product = new Product();
            product.setProductName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setImage(fileName);
            product.setStatus(status);

            // Thiết lập thời gian tạo và cập nhật
            Timestamp now = new Timestamp(System.currentTimeMillis());
            product.setCreatedAt(now);
            product.setUpdatedAt(now);

            // Lưu sản phẩm vào database
            ProductDAO productDAO = new ProductDAO();
            int productId = productDAO.insert(product);
            System.out.println("Product insert result: " + productId);

            if (productId > 0) {
                // Xử lý quan hệ với danh mục (category) theo cách tương tự như supplier
                CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                String[] categoryIdsArray = categoryIdsStr.split(",");
                for (String categoryIdStr : categoryIdsArray) {
                    int categoryId = Integer.parseInt(categoryIdStr.trim());
                    categoryProductDAO.addCategoryToProduct(categoryId, productId);
                }

                // Xử lý quan hệ với nhà cung cấp (supplier)
                if (supplierIdsStr != null && !supplierIdsStr.isEmpty()) {
                    ProductSupplierDAO psDAO = new ProductSupplierDAO();
                    String[] supplierIdArray = supplierIdsStr.split(",");
                    for (String supplierIdStr : supplierIdArray) {
                        int supplierId = Integer.parseInt(supplierIdStr.trim());
                        psDAO.addProductSupplier(productId, supplierId);
                    }
                }

                // Thêm thành công
                setToastMessage(request, "Product added successfully", "success");
                response.sendRedirect(request.getContextPath() + "/admin/manage-product");
            } else {
                // Thêm thất bại
                setToastMessage(request, "Failed to add product", "error");
                showAddForm(request, response);
            }
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            e.printStackTrace();
            setToastMessage(request, "Invalid number format: " + e.getMessage(), "error");
            showAddForm(request, response);
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
            e.printStackTrace();
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            showAddForm(request, response);
        }
    }

    /**
     * Xử lý import sản phẩm từ file Excel
     */
    private void importProductsFromExcel(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Kiểm tra xem có file được gửi lên không
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                setToastMessage(request, "Vui lòng chọn file Excel để nhập", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-product");
                return;
            }
            
            InputStream inputStream = filePart.getInputStream();
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);
            
            ProductDAO productDAO = new ProductDAO();
            CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
            ProductSupplierDAO productSupplierDAO = new ProductSupplierDAO();
            int successCount = 0;
            int failCount = 0;
            List<String> errorMessages = new ArrayList<>();
            
            // Map để lưu thông tin sản phẩm đã cập nhật và số lượng thêm vào
            Map<String, Integer> updatedProductQuantities = new HashMap<>();
            
            // Bỏ qua dòng đầu tiên (header)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                try {
                    // Lấy dữ liệu từ các cột trong Excel theo định dạng mới
                    String name = getCellStringValue(row.getCell(0));
                    int categoryId = (int) getCellNumericValue(row.getCell(1));
                    String description = getCellStringValue(row.getCell(2));
                    BigDecimal price = new BigDecimal(getCellNumericValue(row.getCell(3)));
                    int stock = (int) getCellNumericValue(row.getCell(4));
                    byte status = (byte) getCellNumericValue(row.getCell(5));
                    String supplierIdsStr = getCellStringValue(row.getCell(6));
                    
                    // Validate data
                    if (name == null || name.trim().isEmpty()) {
                        throw new Exception("Tên sản phẩm không được để trống ở dòng " + (i+1));
                    }
                    
                    // Kiểm tra xem sản phẩm đã tồn tại chưa (dựa vào tên)
                    Product existingProduct = productDAO.findByName(name);
                    
                    if (existingProduct != null) {
                        // Sản phẩm đã tồn tại, cập nhật số lượng
                        int newStock = existingProduct.getStock() + stock;
                        existingProduct.setStock(newStock);
                        
                        // Cập nhật thông tin sản phẩm nhưng giữ nguyên status
                        existingProduct.setDescription(description);
                        existingProduct.setPrice(price);
                        existingProduct.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                        
                        // Không cập nhật status, giữ nguyên status hiện tại
                        
                        // Cập nhật sản phẩm trong database
                        boolean updated = productDAO.update(existingProduct);
                        
                        if (updated) {
                            // Thêm danh mục mới cho sản phẩm (nếu chưa có)
                            List<Category> existingCategories = categoryProductDAO.getCategoriesByProductId(existingProduct.getProductId());
                            boolean categoryExists = false;
                            
                            for (Category cat : existingCategories) {
                                if (cat.getCategoryId() == categoryId) {
                                    categoryExists = true;
                                    break;
                                }
                            }
                            
                            if (!categoryExists) {
                                categoryProductDAO.addCategoryToProduct(categoryId, existingProduct.getProductId());
                            }
                            
                            // Thêm nhà cung cấp mới cho sản phẩm (nếu có và chưa có)
                            if (supplierIdsStr != null && !supplierIdsStr.trim().isEmpty()) {
                                String[] supplierIds = supplierIdsStr.split(",");
                                List<Integer> existingSupplierIds = productSupplierDAO.getSupplierIdsByProductId(existingProduct.getProductId());
                                
                                for (String supplierId : supplierIds) {
                                    try {
                                        int id = Integer.parseInt(supplierId.trim());
                                        if (!existingSupplierIds.contains(id)) {
                                            productSupplierDAO.addProductSupplier(existingProduct.getProductId(), id);
                                        }
                                    } catch (NumberFormatException e) {
                                        System.out.println("Định dạng ID nhà cung cấp không hợp lệ: " + supplierId);
                                    }
                                }
                            }
                            
                            // Lưu thông tin sản phẩm đã cập nhật và số lượng thêm vào
                            updatedProductQuantities.put(existingProduct.getProductName(), stock);
                            
                            successCount++;
                        } else {
                            failCount++;
                            errorMessages.add("Không thể cập nhật sản phẩm '" + name + "' ở dòng " + (i+1));
                        }
                    } else {
                        // Sản phẩm chưa tồn tại, thêm mới
                        Product product = new Product();
                        product.setProductName(name);
                        product.setDescription(description);
                        product.setPrice(price);
                        product.setStock(stock);
                        // Sử dụng đường dẫn ảnh mặc định nếu không có
                        product.setImage("uploads/products/default.jpg");
                        product.setStatus(status);
                        Timestamp now = new Timestamp(System.currentTimeMillis());
                        product.setCreatedAt(now);
                        product.setUpdatedAt(now);
                        
                        // Thêm sản phẩm vào database
                        int productId = productDAO.insert(product);
                        
                        if (productId > 0) {
                            // Thêm danh mục cho sản phẩm
                            categoryProductDAO.addCategoryToProduct(categoryId, productId);
                            
                            // Thêm nhà cung cấp cho sản phẩm nếu có
                            if (supplierIdsStr != null && !supplierIdsStr.trim().isEmpty()) {
                                String[] supplierIds = supplierIdsStr.split(",");
                                for (String supplierId : supplierIds) {
                                    try {
                                        int id = Integer.parseInt(supplierId.trim());
                                        productSupplierDAO.addProductSupplier(productId, id);
                                    } catch (NumberFormatException e) {
                                        System.out.println("Định dạng ID nhà cung cấp không hợp lệ: " + supplierId);
                                    }
                                }
                            }
                            
                            successCount++;
                        } else {
                            failCount++;
                            errorMessages.add("Không thể thêm sản phẩm '" + name + "' ở dòng " + (i+1));
                        }
                    }
                } catch (Exception e) {
                    failCount++;
                    String errorMsg = "Lỗi ở dòng " + (i+1) + ": " + e.getMessage();
                    errorMessages.add(errorMsg);
                    System.out.println(errorMsg);
                    e.printStackTrace();
                }
            }
            
            workbook.close();
            inputStream.close();
            
            // Lưu danh sách lỗi vào session để hiển thị trong modal
            if (!errorMessages.isEmpty()) {
                request.getSession().setAttribute("importErrorMessages", errorMessages);
            }
            
            // Lưu thông tin sản phẩm đã cập nhật vào session
            if (!updatedProductQuantities.isEmpty()) {
                request.getSession().setAttribute("updatedProductQuantities", updatedProductQuantities);
            }
            
            setToastMessage(request, 
                "Nhập hoàn tất: " + successCount + " thành công, " + failCount + " thất bại", 
                successCount > 0 ? "success" : "error");
        } catch (Exception e) {
            setToastMessage(request, "Lỗi trong quá trình nhập: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
    }

    /**
     * Phương thức hỗ trợ để lấy giá trị chuỗi an toàn từ một ô
     */
    private String getCellStringValue(Cell cell) {
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                return String.valueOf((int)cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }

    /**
     * Phương thức hỗ trợ để lấy giá trị số an toàn từ một ô
     */
    private double getCellNumericValue(Cell cell) {
        if (cell == null) return 0;
        
        switch (cell.getCellType()) {
            case NUMERIC:
                return cell.getNumericCellValue();
            case STRING:
                try {
                    return Double.parseDouble(cell.getStringCellValue());
                } catch (NumberFormatException e) {
                    return 0;
                }
            default:
                return 0;
        }
    }

    // Add this new method
    private void checkProductName(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        response.setContentType("application/json");
        String name = request.getParameter("name");
        
        try {
            ProductDAO productDAO = new ProductDAO();
            Product existingProduct = productDAO.findByName(name.trim());
            
            // Create JSON response
            String jsonResponse = String.format("{\"exists\": %b}", existingProduct != null);
            response.getWriter().write(jsonResponse);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}