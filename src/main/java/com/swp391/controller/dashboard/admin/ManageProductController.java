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

@MultipartConfig

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
            
            // Create a map of categoryId to Category for easy lookup in JSP
            Map<Integer, Category> categoryMap = new HashMap<>();
            for (Category category : categories) {
                categoryMap.put(category.getCategoryId(), category);
            }

            // Set attributes for JSP
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("categoryMap", categoryMap);
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
                    
                    request.setAttribute("product", product);
                    request.setAttribute("categories", categories);
            
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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/product-add.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            setToastMessage(request, "Error loading categories: " + e.getMessage(), "error");
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
}