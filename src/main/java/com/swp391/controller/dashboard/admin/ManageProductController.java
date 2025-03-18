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
import java.io.PrintWriter;
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
import java.util.stream.Collectors;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

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
            
            // Set attributes for JSP
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("supplierMap", supplierMap);
            request.setAttribute("productSuppliersMap", productSuppliersMap);
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
                    
                    // Lấy danh sách nhà cung cấp
                    SupplierDAO supplierDAO = new SupplierDAO();
                    List<Supplier> suppliers = supplierDAO.findAll();
                    
                    // Lấy danh sách ID nhà cung cấp của sản phẩm
                    ProductSupplierDAO psDAO = new ProductSupplierDAO();
                    List<Integer> selectedSupplierIds = psDAO.getSupplierIdsByProductId(productId);
                    
                    request.setAttribute("product", product);
                    request.setAttribute("categories", categories);
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
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            byte status = Byte.parseByte(request.getParameter("status"));

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findById(productId);

            if (product != null) {
                // Validate input data
                if (name == null || name.trim().isEmpty()) {
                    setToastMessage(request, "Product name is required", "error");
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
                product.setCategoryId(categoryId);
                product.setDescription(description);
                product.setPrice(price);
                product.setStock(stock);
                product.setStatus(status);
                
                // Update timestamp
                product.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                
                // Perform update
                boolean isSuccess = productDAO.update(product);
                
                // Handle result
                if (isSuccess) {
                    // Cập nhật quan hệ với nhà cung cấp
                    String supplierIdsStr = request.getParameter("supplierIds");
                    ProductSupplierDAO psDAO = new ProductSupplierDAO();
                    
                    // Xóa tất cả quan hệ cũ
                    psDAO.removeProductSuppliers(productId);
                    
                    // Thêm quan hệ mới
                    if (supplierIdsStr != null && !supplierIdsStr.isEmpty()) {
                        // Tách chuỗi ID thành mảng
                        String[] supplierIdArray = supplierIdsStr.split(",");
                        for (String supplierIdStr : supplierIdArray) {
                            int supplierId = Integer.parseInt(supplierIdStr.trim());
                            psDAO.addProductSupplier(productId, supplierId);
                        }
                    }
                    
                    setToastMessage(request, "Product updated successfully!", "success");
                } else {
                    setToastMessage(request, "Failed to update product!", "error");
                }
            } else {
                setToastMessage(request, "Product not found!", "error");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid number format: " + e.getMessage(), "error");
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            e.printStackTrace();
        }
        
        // Redirect to list page
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
            String categoryIdStr = request.getParameter("categoryId");
            String statusStr = request.getParameter("status");
            
            System.out.println("Form data received: name=" + name + ", price=" + priceStr + 
                              ", stock=" + stockStr + ", categoryId=" + categoryIdStr + 
                              ", status=" + statusStr);
            
            // Kiểm tra dữ liệu đầu vào
            if (name == null || name.trim().isEmpty() || 
                priceStr == null || priceStr.trim().isEmpty() ||
                stockStr == null || stockStr.trim().isEmpty() ||
                categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
                statusStr == null || statusStr.trim().isEmpty()) {
                
                setToastMessage(request, "All required fields must be filled", "error");
                showAddForm(request, response);
                return;
            }
            
            // Chuyển đổi các giá trị
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);
            int categoryId = Integer.parseInt(categoryIdStr);
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
            product.setCategoryId(categoryId);
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
                // Xử lý quan hệ với nhà cung cấp
                String supplierIdsStr = request.getParameter("supplierIds");
                if (supplierIdsStr != null && !supplierIdsStr.isEmpty()) {
                    ProductSupplierDAO psDAO = new ProductSupplierDAO();
                    
                    // Tách chuỗi ID thành mảng
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
        List<String> successMessages = new ArrayList<>();
        List<String> errorMessages = new ArrayList<>();
        Map<String, Integer> newProductQuantities = new HashMap<>();
        Map<String, Integer> updatedProductQuantities = new HashMap<>();
        int newProductCount = 0;
        int updatedProductCount = 0;
        int errorCount = 0;
        
        try {
            // Lấy file Excel từ request
            Part filePart = request.getPart("excelFile");
            if (filePart == null || filePart.getSize() == 0) {
                setToastMessage(request, "Please select an Excel file to import", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-product");
                return;
            }
            
            // Đọc file Excel
            InputStream fileContent = filePart.getInputStream();
            Workbook workbook = null;
            
            // Xác định loại file
            String fileName = filePart.getSubmittedFileName();
            if (fileName.endsWith(".xlsx")) {
                workbook = new XSSFWorkbook(fileContent);
            } else if (fileName.endsWith(".xls")) {
                workbook = new HSSFWorkbook(fileContent);
            } else {
                setToastMessage(request, "Only .xls and .xlsx files are supported", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-product");
                return;
            }
            
            // Lấy sheet đầu tiên
            Sheet sheet = workbook.getSheetAt(0);
            
            // Khởi tạo DAO
            ProductDAO productDAO = new ProductDAO();
            ProductSupplierDAO psDAO = new ProductSupplierDAO();
            
            // Map để lưu trữ tên sản phẩm đã có trong DB và ID tương ứng
            Map<String, Integer> existingProductMap = new HashMap<>();
            for (Product product : productDAO.findAll()) {
                existingProductMap.put(product.getProductName().toLowerCase(), product.getProductId());
            }
            
            // Bỏ qua dòng tiêu đề
            boolean isFirstRow = true;
            
            // Duyệt từng dòng
            for (Row row : sheet) {
                if (isFirstRow) {
                    isFirstRow = false;
                    continue;
                }
                
                try {
                    // Đọc dữ liệu từ các ô trong dòng
                    Cell nameCell = row.getCell(0);
                    Cell categoryIdCell = row.getCell(1);
                    Cell descriptionCell = row.getCell(2);
                    Cell priceCell = row.getCell(3);
                    Cell stockCell = row.getCell(4);
                    Cell statusCell = row.getCell(5);
                    Cell supplierIdsCell = row.getCell(6);
                    
                    // Kiểm tra các trường bắt buộc
                    if (nameCell == null || categoryIdCell == null || priceCell == null || stockCell == null || statusCell == null) {
                        errorMessages.add("Row " + row.getRowNum() + ": Missing required fields");
                        errorCount++;
                        continue;
                    }
                    
                    // Lấy dữ liệu từ các ô
                    String productName = nameCell.getStringCellValue().trim();
                    int categoryId = (int) categoryIdCell.getNumericCellValue();
                    String description = descriptionCell != null ? descriptionCell.getStringCellValue() : "";
                    BigDecimal price = new BigDecimal(priceCell.getNumericCellValue());
                    int stock = (int) stockCell.getNumericCellValue();
                    byte status = (byte) statusCell.getNumericCellValue();
                    
                    // Kiểm tra sản phẩm đã tồn tại chưa
                    boolean isNewProduct = true;
                    int productId = 0;
                    
                    if (existingProductMap.containsKey(productName.toLowerCase())) {
                        // Product exists, update information
                        isNewProduct = false;
                        productId = existingProductMap.get(productName.toLowerCase());

                        Product existingProduct = productDAO.findById(productId);
                        existingProduct.setCategoryId(categoryId);
                        existingProduct.setDescription(description);
                        existingProduct.setPrice(price);
                        existingProduct.setStock(existingProduct.getStock() + stock); // Cộng dồn số lượng

                        // Không cập nhật trạng thái
                        // existingProduct.setStatus(status);

                        existingProduct.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

                        boolean updated = productDAO.update(existingProduct);

                        if (updated) {
                            // Xóa các mối quan hệ nhà cung cấp cũ
                            psDAO.removeProductSuppliers(productId);
                            
                            // Lưu thông tin số lượng cập nhật
                            if (updatedProductQuantities.containsKey(productName)) {
                                updatedProductQuantities.put(productName, updatedProductQuantities.get(productName) + stock);
                            } else {
                                updatedProductQuantities.put(productName, stock);
                            }
                            
                            successMessages.add("Updated product: " + productName + " (+" + stock + " items)");
                            updatedProductCount++;
                        } else {
                            errorMessages.add("Row " + row.getRowNum() + ": Failed to update product '" + productName + "'");
                            errorCount++;
                            continue;
                        }
                    } else {
                        // Tạo sản phẩm mới
                        Product product = new Product();
                        product.setProductName(productName);
                        product.setCategoryId(categoryId);
                        product.setDescription(description);
                        product.setPrice(price);
                        product.setStock(stock);
                        product.setStatus(status); // Chỉ đặt trạng thái cho sản phẩm mới

                        // Đặt đường dẫn ảnh mặc định
                        product.setImage("uploads/products/default_product.jpg");

                        // Thiết lập thời gian tạo và cập nhật
                        Timestamp now = new Timestamp(System.currentTimeMillis());
                        product.setCreatedAt(now);
                        product.setUpdatedAt(now);

                        // Lưu sản phẩm vào database
                        productId = productDAO.insert(product);

                        if (productId > 0) {
                            // Thêm vào map để tránh trùng lặp trong cùng file import
                            existingProductMap.put(productName.toLowerCase(), productId);
                            
                            // Lưu thông tin số lượng mới
                            if (newProductQuantities.containsKey(productName)) {
                                newProductQuantities.put(productName, newProductQuantities.get(productName) + stock);
                            } else {
                                newProductQuantities.put(productName, stock);
                            }
                            
                            successMessages.add("Added new product: " + productName + " (" + stock + " items)");
                            newProductCount++;
                        } else {
                            errorMessages.add("Row " + row.getRowNum() + ": Failed to insert product '" + productName + "'");
                            errorCount++;
                            continue;
                        }
                    }
                    
                    // Xử lý nhà cung cấp nếu có
                    if (supplierIdsCell != null) {
                        String supplierIdsStr = "";
                        if (supplierIdsCell.getCellType() == CellType.STRING) {
                            supplierIdsStr = supplierIdsCell.getStringCellValue();
                        } else if (supplierIdsCell.getCellType() == CellType.NUMERIC) {
                            supplierIdsStr = String.valueOf((int) supplierIdsCell.getNumericCellValue());
                        }

                        if (!supplierIdsStr.isEmpty()) {
                            String[] supplierIdArray = supplierIdsStr.split(",");
                            for (String supplierIdStr : supplierIdArray) {
                                try {
                                    int supplierId = Integer.parseInt(supplierIdStr.trim());
                                    psDAO.addProductSupplier(productId, supplierId);
                                } catch (NumberFormatException e) {
                                    // Bỏ qua nhà cung cấp không hợp lệ
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    errorMessages.add("Row " + row.getRowNum() + ": " + e.getMessage());
                    errorCount++;
                }
            }
            
            // Đóng workbook
            workbook.close();
            
            // Chuẩn bị thông báo kết quả
            StringBuilder resultMessage = new StringBuilder();
            resultMessage.append("Import completed. ");
            resultMessage.append(newProductCount).append(" new products added. ");
            resultMessage.append(updatedProductCount).append(" products updated. ");
            resultMessage.append(errorCount).append(" products failed.");
            
            request.getSession().setAttribute("importSuccessMessages", successMessages);
            request.getSession().setAttribute("importErrorMessages", errorMessages);
            request.getSession().setAttribute("newProductCount", newProductCount);
            request.getSession().setAttribute("updatedProductCount", updatedProductCount);
            request.getSession().setAttribute("newProductQuantities", newProductQuantities);
            request.getSession().setAttribute("updatedProductQuantities", updatedProductQuantities);
            
            setToastMessage(request, resultMessage.toString(), (newProductCount > 0 || updatedProductCount > 0) ? "success" : "error");
        } catch (Exception e) {
            e.printStackTrace();
            setToastMessage(request, "Error importing products: " + e.getMessage(), "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-product?import_result=true");
    }
}