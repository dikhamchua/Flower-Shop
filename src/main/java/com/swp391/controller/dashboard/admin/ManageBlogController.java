package com.swp391.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.dal.impl.BlogDAO;
import com.swp391.entity.Blog;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name="ManageBlogController", urlPatterns={"/admin/manage-blog"})
public class ManageBlogController extends HttpServlet {
   
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
            case "delete":
                deleteBlog(request, response);
                break;
            case "publish":
                publishBlog(request, response);
                break;
            case "hide":
                hideBlog(request, response);
                break;
            case "list":
            default:
                listBlogs(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addBlog(request, response);
                break;
            case "update":
                updateBlog(request, response);
                break;
            default:
                listBlogs(request, response);
                break;
        }
    }
    
    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        BlogDAO blogDAO = new BlogDAO();
        
        // Get filter parameters
        String searchTitle = request.getParameter("searchTitle");
        String statusFilter = request.getParameter("status");
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) {
                    page = 1;
                }
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
                if (pageSize < 1) {
                    pageSize = 10;
                }
            }
        } catch (NumberFormatException e) {
            // Use default values if parameters are invalid
        }
        
        // Get blogs with filtering and pagination
        List<Blog> blogs = blogDAO.findBlogsWithFilter(searchTitle, statusFilter, page, pageSize);
        int totalBlogs = blogDAO.countBlogsWithFilter(searchTitle, statusFilter);
        
        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
        
        // Set attributes for the view
        request.setAttribute("blogs", blogs);
        request.setAttribute("searchTitle", searchTitle);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBlogs", totalBlogs);
        
        // Forward to the view
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/blog-list.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/blog-add.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.findById(id);
        
        if (blog != null) {
            request.setAttribute("blog", blog);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/blog-edit.jsp");
            dispatcher.forward(request, response);
        } else {
            request.getSession().setAttribute("toastMessage", "Blog not found");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/manage-blog");
        }
    }
    
    private void addBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Get form data
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        
        // Get current user ID (author)
        int authorId = 1; // This should be the logged-in user's ID
        
        // Validate form data
        Map<String, String> errors = validateBlogData(title, content, status, null);
        
        if (!errors.isEmpty()) {
            // Store errors and form data in session for redisplay
            request.getSession().setAttribute("errors", errors);
            Map<String, String[]> formData = new HashMap<>();
            formData.put("title", new String[]{title});
            formData.put("content", new String[]{content});
            formData.put("status", new String[]{status});
            request.getSession().setAttribute("formData", formData);
            
            // Redirect back to add form
            response.sendRedirect(request.getContextPath() + "/admin/manage-blog?action=add");
            return;
        }
        
        // Create new blog
        Blog blog = new Blog();
        blog.setTitle(title);
        blog.setContent(content);
        blog.setAuthorId(authorId);
        blog.setStatus(status);
        
        // Save to database
        BlogDAO blogDAO = new BlogDAO();
        int newBlogId = blogDAO.insert(blog);
        
        if (newBlogId > 0) {
            request.getSession().setAttribute("toastMessage", "Blog added successfully");
            request.getSession().setAttribute("toastType", "success");
        } else {
            request.getSession().setAttribute("toastMessage", "Failed to add blog");
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-blog");
    }
    
    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        
        // Validate form data
        Map<String, String> errors = validateBlogData(title, content, status, id);
        
        if (!errors.isEmpty()) {
            // Store errors and form data in session for redisplay
            request.getSession().setAttribute("errors", errors);
            Map<String, String[]> formData = new HashMap<>();
            formData.put("id", new String[]{String.valueOf(id)});
            formData.put("title", new String[]{title});
            formData.put("content", new String[]{content});
            formData.put("status", new String[]{status});
            request.getSession().setAttribute("formData", formData);
            
            // Redirect back to edit form
            response.sendRedirect(request.getContextPath() + "/admin/manage-blog?action=edit&id=" + id);
            return;
        }
        
        // Get existing blog
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.findById(id);
        
        if (blog != null) {
            // Update blog data
            blog.setTitle(title);
            blog.setContent(content);
            blog.setStatus(status);
            
            // Save to database
            boolean updated = blogDAO.update(blog);
            
            if (updated) {
                request.getSession().setAttribute("toastMessage", "Blog updated successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to update blog");
                request.getSession().setAttribute("toastType", "error");
            }
        } else {
            request.getSession().setAttribute("toastMessage", "Blog not found");
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-blog");
    }
    
    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.findById(id);
        
        if (blog != null) {
            boolean deleted = blogDAO.delete(blog);
            
            if (deleted) {
                request.getSession().setAttribute("toastMessage", "Blog deleted successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to delete blog");
                request.getSession().setAttribute("toastType", "error");
            }
        } else {
            request.getSession().setAttribute("toastMessage", "Blog not found");
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-blog");
    }
    
    private void publishBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.findById(id);
        
        if (blog != null) {
            blog.setStatus("published");
            boolean updated = blogDAO.update(blog);
            
            if (updated) {
                request.getSession().setAttribute("toastMessage", "Blog published successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to publish blog");
                request.getSession().setAttribute("toastType", "error");
            }
        } else {
            request.getSession().setAttribute("toastMessage", "Blog not found");
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-blog");
    }
    
    private void hideBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.findById(id);
        
        if (blog != null) {
            blog.setStatus("hidden");
            boolean updated = blogDAO.update(blog);
            
            if (updated) {
                request.getSession().setAttribute("toastMessage", "Blog hidden successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to hide blog");
                request.getSession().setAttribute("toastType", "error");
            }
        } else {
            request.getSession().setAttribute("toastMessage", "Blog not found");
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-blog");
    }
    
    /**
     * Validate blog data
     * @param title Blog title to validate
     * @param content Blog content to validate
     * @param status Blog status to validate
     * @param blogId Blog ID (null for new blogs)
     * @return Map of field names to error messages
     */
    private Map<String, String> validateBlogData(String title, String content, String status, Integer blogId) {
        Map<String, String> errors = new HashMap<>();
        BlogDAO blogDAO = new BlogDAO();
        
        // Validate title
        if (title == null || title.trim().isEmpty()) {
            errors.put("title", "Blog title is required");
        } else if (title.length() > 150) {
            errors.put("title", "Blog title must be less than 150 characters");
        } else {
            // Check if title already exists
            boolean titleExists = blogId == null ? 
                    blogDAO.isBlogTitleExists(title) : 
                    blogDAO.isBlogTitleExists(title, blogId);
            
            if (titleExists) {
                errors.put("title", "Blog title already exists");
            }
        }
        
        // Validate content
        if (content == null || content.trim().isEmpty()) {
            errors.put("content", "Blog content is required");
        }
        
        // Validate status
        if (status == null || status.trim().isEmpty()) {
            errors.put("status", "Blog status is required");
        } else if (!status.equals("published") && !status.equals("hidden") && !status.equals("draft")) {
            errors.put("status", "Invalid blog status");
        }
        
        return errors;
    }
    
    // Helper method for setting toast messages
    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }
} 