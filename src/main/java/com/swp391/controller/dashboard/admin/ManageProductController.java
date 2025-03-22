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
        String productIdStr = request.getParameter("id");
        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdStr);
                ProductDAO productDAO = new ProductDAO();
                boolean activated = productDAO.updateStatus(productId, (byte) 1);
                
                if (activated) {
                    setToastMessage(request, "Product activated successfully", "success");
                } else {
                    setToastMessage(request, "Failed to activate product", "error");
                }
            } catch (NumberFormatException e) {
                setToastMessage(request, "Invalid product ID format", "error");
            } catch (Exception e) {
                setToastMessage(request, "Error: " + e.getMessage(), "error");
                e.printStackTrace();
            }
        } else {
            setToastMessage(request, "Invalid product ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
    }

    private void deactivateProduct(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String productIdStr = request.getParameter("id");
        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdStr);
                ProductDAO productDAO = new ProductDAO();
                boolean deactivated = productDAO.updateStatus(productId, (byte) 0);
                
                if (deactivated) {
                    setToastMessage(request, "Product deactivated successfully", "success");
                } else {
                    setToastMessage(request, "Failed to deactivate product", "error");
                }
            } catch (NumberFormatException e) {
                setToastMessage(request, "Invalid product ID format", "error");
            } catch (Exception e) {
                setToastMessage(request, "Error: " + e.getMessage(), "error");
                e.printStackTrace();
            }
        } else {
            setToastMessage(request, "Invalid product ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String productIdStr = request.getParameter("id");
        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdStr);
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.findById(productId);
                
                if (product != null) {
                    CategoryDAO categoryDAO = new CategoryDAO();
                    List<Category> categories = categoryDAO.findAll();
                    
                    // Lấy danh sách ID danh mục của sản phẩm
                    List<Integer> selectedCategoryIds = new ArrayList<>();
                    if (product.getCategories() != null) {
                        for (Category category : product.getCategories()) {
                            selectedCategoryIds.add(category.getCategoryId());
                        }
                    }
                    
                    // Lấy danh sách nhà cung cấp
                    SupplierDAO supplierDAO = new SupplierDAO();
                    List<Supplier> suppliers = supplierDAO.findAll();
                    
                    // Lấy danh sách ID nhà cung cấp của sản phẩm
                    ProductSupplierDAO psDAO = new ProductSupplierDAO();
                    List<Integer> selectedSupplierIds = psDAO.getSupplierIdsByProductId(productId);
                    
                    request.setAttribute("product", product);
                    request.setAttribute("categories", categories);
                    request.setAttribute("selectedCategoryIds", selectedCategoryIds);
                    request.setAttribute("suppliers", suppliers);
                    request.setAttribute("selectedSupplierIds", selectedSupplierIds);
            
                    request.getRequestDispatcher("/view/admin/product-edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid product ID format: " + e.getMessage());
                setToastMessage(request, "Invalid product ID format", "error");
            } catch (Exception e) {
                System.out.println("Error when showing edit form: " + e.getMessage());
                e.printStackTrace();
                setToastMessage(request, "Error: " + e.getMessage(), "error");
            }
        }
        
        // Nếu có lỗi hoặc không tìm thấy sản phẩm, chuyển hướng về trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
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
                    
                    setToastMessage(request, "Cập nhật sản phẩm thành công!", "success");
                } else {
                    setToastMessage(request, "Cập nhật sản phẩm thất bại!", "error");
                }
            } else {
                setToastMessage(request, "Không tìm thấy sản phẩm!", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
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

            System.out.println("Form data received: name=" + name + ", price=" + priceStr +
                               ", stock=" + stockStr + ", categoryIds=" + categoryIdsStr +
                               ", status=" + statusStr);

            // Kiểm tra dữ liệu đầu vào
            if (name == null || name.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                stockStr == null || stockStr.trim().isEmpty() ||
                categoryIdsStr == null || categoryIdsStr.trim().isEmpty() ||
                statusStr == null || statusStr.trim().isEmpty()) {

                setToastMessage(request, "Vui lòng điền đầy đủ thông tin bắt buộc", "error");
                showAddForm(request, response);
                return;
            }

            // Chuyển đổi các giá trị
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);
            byte status = Byte.parseByte(statusStr);

            // Xử lý file ảnh
            Part filePart = request.getPart("image");
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
            } else {
                System.out.println("No file received or file is empty");
                setToastMessage(request, "Product image is required", "error");
                showAddForm(request, response);
                return;
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
                String supplierIdsStr = request.getParameter("supplierIds");
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
            Part filePart = request.getPart("file");
            InputStream inputStream = filePart.getInputStream();
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);
            
            ProductDAO productDAO = new ProductDAO();
            CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
            int successCount = 0;
            int failCount = 0;
            
            // Bỏ qua dòng đầu tiên (header)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                try {
                    // Lấy dữ liệu từ các cột trong Excel
                    String name = row.getCell(0).getStringCellValue();
                    String description = row.getCell(1).getStringCellValue();
                    BigDecimal price = new BigDecimal(row.getCell(2).getNumericCellValue());
                    int stock = (int) row.getCell(3).getNumericCellValue();
                    String image = row.getCell(4).getStringCellValue();
                    byte status = (byte) row.getCell(5).getNumericCellValue();
                    String[] categoryIds = row.getCell(6).getStringCellValue().split(",");
                    
                    // Tạo đối tượng Product
                    Product product = new Product();
                    product.setProductName(name);
                    product.setDescription(description);
                    product.setPrice(price);
                    product.setStock(stock);
                    product.setImage(image);
                    product.setStatus(status);
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    product.setCreatedAt(now);
                    product.setUpdatedAt(now);
                    
                    // Thêm sản phẩm vào database
                    int productId = productDAO.insert(product);
                    
                    if (productId > 0) {
                        // Thêm các danh mục cho sản phẩm
                        for (String categoryIdStr : categoryIds) {
                            int categoryId = Integer.parseInt(categoryIdStr.trim());
                            categoryProductDAO.addCategoryToProduct(categoryId, productId);
                        }
                        successCount++;
                    } else {
                        failCount++;
                    }
                } catch (Exception e) {
                    failCount++;
                    e.printStackTrace();
                }
            }
            
            workbook.close();
            inputStream.close();
            
            setToastMessage(request, 
                "Import completed: " + successCount + " successful, " + failCount + " failed", 
                successCount > 0 ? "success" : "error");
        } catch (Exception e) {
            setToastMessage(request, "Error during import: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
    }
}