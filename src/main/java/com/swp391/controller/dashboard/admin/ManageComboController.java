package com.swp391.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.swp391.dal.impl.ComboDAO;
import com.swp391.dal.impl.ComboProductDAO;
import com.swp391.dal.impl.ComboTagDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Combo;
import com.swp391.entity.ComboProduct;
import com.swp391.entity.ComboTag;
import com.swp391.entity.Product;

/**
 * Controller for managing combo products in the admin dashboard
 */
// Add these imports at the top
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

// Add MultipartConfig annotation to the class
@WebServlet(name = "ManageComboController", urlPatterns = {"/admin/manage-combo"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ManageComboController extends HttpServlet {

    // Add a constant for the upload directory
//    private static final String UPLOAD_DIR = "uploads/combos";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
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
                deactivateCombo(request, response);
                break;
            case "activate":
                activateCombo(request, response);
                break;
            case "list":
            default:
                listCombos(request, response);
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
                addCombo(request, response);
                break;
            case "update":
                updateCombo(request, response);
                break;
            default:
                listCombos(request, response);
                break;
        }
    }

    /**
     * Display the list of combos with pagination and filtering
     */
    private void listCombos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");

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

        ComboDAO comboDAO = new ComboDAO();

        // Sử dụng phương thức tìm kiếm mới
        List<Combo> combos = comboDAO.searchCombos(searchFilter, statusFilter, page, pageSize);
        int totalCombos = comboDAO.countSearchResults(searchFilter, statusFilter);

        int totalPages = (int) Math.ceil((double) totalCombos / pageSize);

        // Set attributes for JSP
        request.setAttribute("combos", combos);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCombos", totalCombos);

        // Set filter values for maintaining state
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("../view/admin/combo-list.jsp").forward(request, response);
    }

    // Xóa các phương thức getFilteredCombos và getFilteredCombosCount vì không cần thiết nữa
    /**
     * Get filtered combos based on search and status filters
     */
    private List<Combo> getFilteredCombos(ComboDAO comboDAO, String searchFilter,
            String statusFilter, int page, int pageSize) {
        // This is a simplified implementation. In a real application, you would create a method
        // in ComboDAO to handle filtering with pagination in a single database query.
        List<Combo> allCombos = comboDAO.findAll();
        List<Combo> filteredCombos = new ArrayList<>();

        for (Combo combo : allCombos) {
            boolean matchesSearch = searchFilter == null || searchFilter.isEmpty()
                    || combo.getName().toLowerCase().contains(searchFilter.toLowerCase())
                    || (combo.getDescription() != null && combo.getDescription().toLowerCase().contains(searchFilter.toLowerCase()));

            boolean matchesStatus = statusFilter == null || statusFilter.isEmpty()
                    || combo.getStatus().equals(statusFilter);

            if (matchesSearch && matchesStatus) {
                filteredCombos.add(combo);
            }
        }

        // Apply pagination
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, filteredCombos.size());

        if (startIndex < filteredCombos.size()) {
            return filteredCombos.subList(startIndex, endIndex);
        } else {
            return new ArrayList<>();
        }
    }

    /**
     * Count filtered combos based on search and status filters
     */
    private int getFilteredCombosCount(ComboDAO comboDAO, String searchFilter, String statusFilter) {
        // This is a simplified implementation. In a real application, you would create a method
        // in ComboDAO to count filtered results in a single database query.
        List<Combo> allCombos = comboDAO.findAll();
        int count = 0;

        for (Combo combo : allCombos) {
            boolean matchesSearch = searchFilter == null || searchFilter.isEmpty()
                    || combo.getName().toLowerCase().contains(searchFilter.toLowerCase())
                    || (combo.getDescription() != null && combo.getDescription().toLowerCase().contains(searchFilter.toLowerCase()));

            boolean matchesStatus = statusFilter == null || statusFilter.isEmpty()
                    || combo.getStatus().equals(statusFilter);

            if (matchesSearch && matchesStatus) {
                count++;
            }
        }

        return count;
    }

    /**
     * Show the form for adding a new combo
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all active products for the combo selection
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.findAllActive();

        // Convert products to JSON for JavaScript
        StringBuilder productsJson = new StringBuilder("[");
        for (int i = 0; i < products.size(); i++) {
            Product product = products.get(i);
            productsJson.append("{")
                    .append("\"id\":").append(product.getProductId()).append(",")
                    .append("\"name\":\"").append(product.getProductName().replace("\"", "\\\"")).append("\",")
                    .append("\"price\":").append(product.getPrice())
                    .append("}");
            if (i < products.size() - 1) {
                productsJson.append(",");
            }
        }
        productsJson.append("]");

        request.setAttribute("products", products);
        request.setAttribute("productsJson", productsJson.toString());

        request.getRequestDispatcher("../view/admin/combo-add.jsp").forward(request, response);
    }

    /**
     * Show the form for editing an existing combo
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String comboIdStr = request.getParameter("id");
        if (comboIdStr != null && !comboIdStr.isEmpty()) {
            int comboId = Integer.parseInt(comboIdStr);

            // Get combo data
            ComboDAO comboDAO = new ComboDAO();
            Combo combo = comboDAO.findById(comboId);

            if (combo != null) {
                // Get products in this combo
                ComboProductDAO comboProductDAO = new ComboProductDAO();
                List<ComboProduct> comboProducts = comboProductDAO.findByComboId(comboId);

                // Get tags for this combo
                ComboTagDAO comboTagDAO = new ComboTagDAO();
                List<ComboTag> comboTags = comboTagDAO.findByComboId(comboId);

                // Get all active products for selection
                ProductDAO productDAO = new ProductDAO();
                List<Product> allProducts = productDAO.findAllActive();

                // Convert products to JSON for JavaScript
                StringBuilder productsJson = new StringBuilder("[");
                for (int i = 0; i < allProducts.size(); i++) {
                    Product product = allProducts.get(i);
                    productsJson.append("{")
                            .append("\"id\":").append(product.getProductId()).append(",")
                            .append("\"name\":\"").append(product.getProductName().replace("\"", "\\\"")).append("\",")
                            .append("\"price\":").append(product.getPrice())
                            .append("}");
                    if (i < allProducts.size() - 1) {
                        productsJson.append(",");
                    }
                }
                productsJson.append("]");

                // Convert selected products to JSON for JavaScript
                StringBuilder selectedProductsJson = new StringBuilder("[");
                for (int i = 0; i < comboProducts.size(); i++) {
                    ComboProduct cp = comboProducts.get(i);
                    Product product = productDAO.findById(cp.getProductId());
                    if (product != null) {
                        selectedProductsJson.append("{")
                                .append("\"id\":").append(product.getProductId()).append(",")
                                .append("\"name\":\"").append(product.getProductName().replace("\"", "\\\"")).append("\",")
                                .append("\"price\":").append(product.getPrice()).append(",")
                                .append("\"quantity\":").append(cp.getQuantityInCombo())
                                .append("}");
                        if (i < comboProducts.size() - 1) {
                            selectedProductsJson.append(",");
                        }
                    }
                }
                selectedProductsJson.append("]");

                // Convert tags to string
                StringBuilder tagsStr = new StringBuilder();
                for (int i = 0; i < comboTags.size(); i++) {
                    tagsStr.append(comboTags.get(i).getTagName());
                    if (i < comboTags.size() - 1) {
                        tagsStr.append(",");
                    }
                }

                // Set attributes for JSP
                request.setAttribute("combo", combo);
                request.setAttribute("comboProducts", comboProducts);
                request.setAttribute("comboTags", comboTags);
                request.setAttribute("allProducts", allProducts);
                request.setAttribute("productsJson", productsJson.toString());
                request.setAttribute("selectedProductsJson", selectedProductsJson.toString());
                request.setAttribute("tagsString", tagsStr.toString());

                request.getRequestDispatcher("../view/admin/combo-edit.jsp").forward(request, response);
                return;
            }
        }
        // If combo not found or ID not provided, redirect to list
        response.sendRedirect(request.getContextPath() + "/admin/manage-combo");
    }

    /**
     * Add a new combo
     */
    private void addCombo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            Float discountPrice = Float.parseFloat(request.getParameter("discount_price"));
            String status = request.getParameter("status");

            // Ởt image
            Part filePart = request.getPart("image");
            String imagePath = null;

            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
                String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;

                String uploadPath = request.getServletContext().getRealPath("/uploads/combos/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String fullPath = uploadPath + File.separator + uniqueFileName;
                filePart.write(fullPath);
                imagePath = "uploads/combos/" + uniqueFileName;
            }

            String productIdsStr = request.getParameter("productIds");
            String quantitiesStr = request.getParameter("quantities");
            String[] productIds = productIdsStr != null ? productIdsStr.split(",") : null;
            String[] quantities = quantitiesStr != null ? quantitiesStr.split(",") : null;

            Map<String, String> errors = validateComboData(name, discountPrice, productIds, quantities, null);
            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());
                response.sendRedirect(request.getContextPath() + "/admin/manage-combo?action=add");
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            Float originalPrice = calculateOriginalPrice(productIds, quantities, productDAO);

            Combo newCombo = Combo.builder()
                    .name(name)
                    .description(description)
                    .originalPrice(originalPrice)
                    .discountPrice(discountPrice)
                    .status(status)
                    .image(imagePath)
                    .build();

            ComboDAO comboDAO = new ComboDAO();
            int comboId = comboDAO.insert(newCombo);

            if (comboId > 0) {
                ComboProductDAO comboProductDAO = new ComboProductDAO();
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    comboProductDAO.insert(ComboProduct.builder().comboId(comboId).productId(productId).quantityInCombo(quantity).build());
                }

                String tagInput = request.getParameter("tags");
                if (tagInput != null && !tagInput.isEmpty()) {
                    ComboTagDAO comboTagDAO = new ComboTagDAO();
                    for (String tag : tagInput.split(",")) {
                        tag = tag.trim();
                        if (!tag.isEmpty()) {
                            comboTagDAO.insert(ComboTag.builder().comboId(comboId).tagName(tag).build());
                        }
                    }
                }
                request.getSession().setAttribute("toastMessage", "Combo created successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to create combo!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-combo");
    }

    private void updateCombo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int comboId = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            Float discountPrice = Float.parseFloat(request.getParameter("discount_price"));
            String status = request.getParameter("status");

            String productIdsStr = request.getParameter("productIds");
            String quantitiesStr = request.getParameter("quantities");
            String[] productIds = productIdsStr != null ? productIdsStr.split(",") : null;
            String[] quantities = quantitiesStr != null ? quantitiesStr.split(",") : null;

            Map<String, String> errors = validateComboData(name, discountPrice, productIds, quantities, comboId);
            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());
                response.sendRedirect(request.getContextPath() + "/admin/manage-combo?action=edit&id=" + comboId);
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            Float originalPrice = calculateOriginalPrice(productIds, quantities, productDAO);

            ComboDAO comboDAO = new ComboDAO();
            Combo combo = comboDAO.findById(comboId);

            if (combo != null) {
                combo.setName(name);
                combo.setDescription(description);
                combo.setOriginalPrice(originalPrice);
                combo.setDiscountPrice(discountPrice);
                combo.setStatus(status);

                // Đổi ảnh nếu có
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalFileName = filePart.getSubmittedFileName();
                    String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                    String uploadPath = request.getServletContext().getRealPath("/uploads/combos/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + uniqueFileName);
                    combo.setImage("uploads/combos/" + uniqueFileName);
                }

                boolean updated = comboDAO.update(combo);

                if (updated) {
                    ComboProductDAO comboProductDAO = new ComboProductDAO();
                    comboProductDAO.deleteByComboId(comboId);
                    for (int i = 0; i < productIds.length; i++) {
                        int productId = Integer.parseInt(productIds[i]);
                        int quantity = Integer.parseInt(quantities[i]);
                        comboProductDAO.insert(ComboProduct.builder().comboId(comboId).productId(productId).quantityInCombo(quantity).build());
                    }

                    ComboTagDAO comboTagDAO = new ComboTagDAO();
                    comboTagDAO.deleteByComboId(comboId);
                    String tagInput = request.getParameter("tags");
                    if (tagInput != null && !tagInput.isEmpty()) {
                        for (String tag : tagInput.split(",")) {
                            tag = tag.trim();
                            if (!tag.isEmpty()) {
                                comboTagDAO.insert(ComboTag.builder().comboId(comboId).tagName(tag).build());
                            }
                        }
                    }
                    setToastMessage(request, "Combo updated successfully!", "success");
                } else {
                    setToastMessage(request, "Failed to update combo!", "error");
                }
            } else {
                setToastMessage(request, "Combo not found!", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
        }
        String page = request.getParameter("page");
        String redirectUrl = request.getContextPath() + "/admin/manage-combo?action=list";
        if (page != null && !page.isEmpty()) {
            redirectUrl += "&page=" + page;
        }
        response.sendRedirect(redirectUrl);
    }

    /**
     * Deactivate a combo
     */
    private void deactivateCombo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String comboIdStr = request.getParameter("id");
        String page = request.getParameter("page");

        if (comboIdStr != null && !comboIdStr.isEmpty()) {
            int comboId = Integer.parseInt(comboIdStr);
            ComboDAO comboDAO = new ComboDAO();
            boolean deactivated = comboDAO.updateStatus(comboId, "inactive");

            if (deactivated) {
                setToastMessage(request, "Combo deactivated successfully", "success");
            } else {
                setToastMessage(request, "Failed to deactivate combo", "error");
            }
        } else {
            setToastMessage(request, "Invalid combo ID", "error");
        }

        String redirectUrl = request.getContextPath() + "/admin/manage-combo?action=list";
        if (page != null && !page.isEmpty()) {
            redirectUrl += "&page=" + page;
        }
        response.sendRedirect(redirectUrl);
    }

    /**
     * Activate a combo
     */
    private void activateCombo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String comboIdStr = request.getParameter("id");
        String page = request.getParameter("page");

        if (comboIdStr != null && !comboIdStr.isEmpty()) {
            int comboId = Integer.parseInt(comboIdStr);
            ComboDAO comboDAO = new ComboDAO();
            boolean activated = comboDAO.updateStatus(comboId, "active");

            if (activated) {
                setToastMessage(request, "Combo activated successfully", "success");
            } else {
                setToastMessage(request, "Failed to activate combo", "error");
            }
        } else {
            setToastMessage(request, "Invalid combo ID", "error");
        }

        String redirectUrl = request.getContextPath() + "/admin/manage-combo?action=list";
        if (page != null && !page.isEmpty()) {
            redirectUrl += "&page=" + page;
        }
        response.sendRedirect(redirectUrl);
    }

    /**
     * Calculate the original price of the combo based on selected products and
     * quantities
     */
    private Float calculateOriginalPrice(String[] productIds, String[] quantities, ProductDAO productDAO) {
        float originalPrice = 0.0f;

        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);

            Product product = productDAO.findById(productId);
            if (product != null) {
                originalPrice += product.getPrice().floatValue() * quantity;
            }
        }

        return originalPrice;
    }

    /**
     * Validate combo data
     */
    private Map<String, String> validateComboData(String name, Float discountPrice,
            String[] productIds, String[] quantities, Integer comboId) {
        Map<String, String> errors = new HashMap<>();
    
        // Validate name
        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Tên combo không được để trống");
        } else if (!name.matches("^[a-zA-Z0-9\\sÀ-ỹà-ỹ_.,-]+$")) {
            errors.put("name", "Tên combo không được chứa ký tự đặc biệt");
        }
    
        // Validate products
        if (productIds == null || productIds.length == 0) {
            errors.put("products", "You must select at least one product for the combo");
        }
    
        // Validate quantities
        if (quantities != null) {
            for (int i = 0; i < quantities.length; i++) {
                try {
                    int quantity = Integer.parseInt(quantities[i]);
                    if (quantity <= 0) {
                        errors.put("quantity_" + i, "Quantity must be greater than 0");
                    }
                } catch (NumberFormatException e) {
                    errors.put("quantity_" + i, "Invalid quantity");
                }
            }
        }
    
        // Validate discount price (must be less than original price)
        if (discountPrice != null && productIds != null && quantities != null) {
            ProductDAO productDAO = new ProductDAO();
            float originalPrice = calculateOriginalPrice(productIds, quantities, productDAO);

            if (discountPrice >= originalPrice) {
                errors.put("discount_price", "Discount price must be less than original price");
            }
        }

        return errors;
    }

    /**
     * Set a toast message for display
     */
    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

    /**
     * Utility method to get the submitted filename from a Part
     */
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "\"");
                return fileName.substring(fileName.lastIndexOf('/') + 1)
                        .substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
}
