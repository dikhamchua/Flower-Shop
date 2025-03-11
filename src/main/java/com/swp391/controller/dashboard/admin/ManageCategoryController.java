package com.swp391.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.swp391.dal.impl.CategoryDAO;
import com.swp391.entity.Category;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name="ManageCategoryController", urlPatterns={"/admin/manage-category"})
public class ManageCategoryController extends HttpServlet {
   
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
                deactivateCategory(request, response);
                break;
            case "activate":
                activateCategory(request, response);
                break;
            case "list":
            default:
                listCategories(request, response);
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
                addCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CategoryController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CategoryController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String categoryIdStr = request.getParameter("id");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdStr);
            CategoryDAO categoryDAO = new CategoryDAO();
            Category category = categoryDAO.findById(categoryId);
            if (category != null) {
                request.setAttribute("category", category);
                request.getRequestDispatcher("/view/admin/category-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-category");
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
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

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories;
        int totalCategories;
        
        // Apply filters if provided
        if ((searchFilter != null && !searchFilter.isEmpty()) || 
            (statusFilter != null && !statusFilter.isEmpty())) {
            
            // Convert status filter to byte if provided
            Byte statusByte = null;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                statusByte = Byte.parseByte(statusFilter);
            }
            
            // Get filtered categories with pagination
            categories = getFilteredCategories(categoryDAO, searchFilter, statusByte, page, pageSize);
            totalCategories = getFilteredCategoriesCount(categoryDAO, searchFilter, statusByte);
        } else {
            // Get all categories with pagination
            categories = categoryDAO.findCategoriesWithPagination(page, pageSize);
            totalCategories = categoryDAO.getTotalCategories();
        }
        
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);

        // Set attributes for JSP
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCategories", totalCategories);

        // Set filter values for maintaining state
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("../view/admin/category-list.jsp").forward(request, response);
    }

    private List<Category> getFilteredCategories(CategoryDAO categoryDAO, String searchFilter, 
            Byte statusFilter, int page, int pageSize) {
        // This is a simplified implementation. In a real application, you would create a method
        // in CategoryDAO to handle filtering with pagination in a single database query.
        List<Category> allCategories = categoryDAO.findAll();
        List<Category> filteredCategories = new java.util.ArrayList<>();
        
        for (Category category : allCategories) {
            boolean matchesSearch = searchFilter == null || searchFilter.isEmpty() || 
                    category.getName().toLowerCase().contains(searchFilter.toLowerCase());
            boolean matchesStatus = statusFilter == null || category.getStatus() == statusFilter;
            
            if (matchesSearch && matchesStatus) {
                filteredCategories.add(category);
            }
        }
        
        // Apply pagination
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, filteredCategories.size());
        
        if (startIndex < filteredCategories.size()) {
            return filteredCategories.subList(startIndex, endIndex);
        } else {
            return new java.util.ArrayList<>();
        }
    }
    
    private int getFilteredCategoriesCount(CategoryDAO categoryDAO, String searchFilter, Byte statusFilter) {
        // This is a simplified implementation. In a real application, you would create a method
        // in CategoryDAO to count filtered results in a single database query.
        List<Category> allCategories = categoryDAO.findAll();
        int count = 0;
        
        for (Category category : allCategories) {
            boolean matchesSearch = searchFilter == null || searchFilter.isEmpty() || 
                    category.getName().toLowerCase().contains(searchFilter.toLowerCase());
            boolean matchesStatus = statusFilter == null || category.getStatus() == statusFilter;
            
            if (matchesSearch && matchesStatus) {
                count++;
            }
        }
        
        return count;
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get information from request
            int categoryId = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            byte status = Byte.parseByte(request.getParameter("status"));

            // Get category from database
            CategoryDAO categoryDAO = new CategoryDAO();
            Category category = categoryDAO.findById(categoryId);

            if (category != null) {
                // Validate input data
                Map<String, String> errors = validateCategoryData(name, categoryId);
                
                if (!errors.isEmpty()) {
                    // If there are errors, save error information and entered data to session
                    request.getSession().setAttribute("errors", errors);
                    request.getSession().setAttribute("formData", request.getParameterMap());
                    
                    // Redirect back to edit form
                    response.sendRedirect(request.getContextPath() + "/admin/manage-category?action=edit&id=" + categoryId);
                    return;
                }
                
                // Update fields
                category.setName(name);
                category.setDescription(description);
                category.setStatus(status);
                
                // Update timestamp
                java.util.Date utilDate = new java.util.Date();
                category.setUpdatedAt(new Date(utilDate.getTime()));
                
                // Perform update
                boolean isSuccess = categoryDAO.update(category);
                
                // Handle result
                if (isSuccess) {
                    request.getSession().setAttribute("toastMessage", "Category updated successfully!");
                    request.getSession().setAttribute("toastType", "success");
                } else {
                    request.getSession().setAttribute("toastMessage", "Failed to update category!");
                    request.getSession().setAttribute("toastType", "error");
                }
            } else {
                request.getSession().setAttribute("toastMessage", "Category not found!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-category?action=list");
    }

    private void deactivateCategory(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String categoryIdStr = request.getParameter("id");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdStr);
            CategoryDAO categoryDAO = new CategoryDAO();
            boolean deactivated = categoryDAO.updateStatus(categoryId, (byte) 0);
            
            if (deactivated) {
                setToastMessage(request, "Category deactivated successfully", "success");
            } else {
                setToastMessage(request, "Failed to deactivate category", "error");
            }
        } else {
            setToastMessage(request, "Invalid category ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-category");
    }

    private void activateCategory(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String categoryIdStr = request.getParameter("id");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdStr);
            CategoryDAO categoryDAO = new CategoryDAO();
            boolean activated = categoryDAO.updateStatus(categoryId, (byte) 1);
            
            if (activated) {
                setToastMessage(request, "Category activated successfully", "success");
            } else {
                setToastMessage(request, "Failed to activate category", "error");
            }
        } else {
            setToastMessage(request, "Invalid category ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-category");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/category-add.jsp");
        dispatcher.forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        try {
            // Get information from request
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            byte status = Byte.parseByte(request.getParameter("status"));
            
            // Validate input data
            Map<String, String> errors = validateCategoryData(name, null);
            
            if (!errors.isEmpty()) {
                // If there are errors, save error information and entered data to session
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());
                
                // Redirect back to add form
                response.sendRedirect(request.getContextPath() + "/admin/manage-category?action=add");
                return;
            }

            // Create new Category object
            java.util.Date utilDate = new java.util.Date();
            Date sqlDate = new Date(utilDate.getTime());
            
            Category newCategory = new Category();
            newCategory.setName(name);
            newCategory.setDescription(description);
            newCategory.setStatus(status);
            newCategory.setCreatedAt(sqlDate);
            newCategory.setUpdatedAt(sqlDate);

            // Add category to database
            CategoryDAO categoryDAO = new CategoryDAO();
            int newId = categoryDAO.insert(newCategory);

            // Handle result
            if (newId > 0) {
                request.getSession().setAttribute("toastMessage", "Category added successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to add category!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-category?action=list");
    }
    
    /**
     * Validate category data
     * @param name Category name to validate
     * @param categoryId Category ID (null for new categories)
     * @return Map of field names to error messages
     */
    private Map<String, String> validateCategoryData(String name, Integer categoryId) {
        Map<String, String> errors = new HashMap<>();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        // Validate name
        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Category name is required");
        } else if (name.length() > 100) {
            errors.put("name", "Category name must be less than 100 characters");
        } else {
            // Check if name already exists
            boolean nameExists = categoryId == null ? 
                    categoryDAO.isCategoryNameExists(name) : 
                    categoryDAO.isCategoryNameExists(name, categoryId);
            
            if (nameExists) {
                errors.put("name", "Category name already exists");
            }
        }
        
        return errors;
    }
} 