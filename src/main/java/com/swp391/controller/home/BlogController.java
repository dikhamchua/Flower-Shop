/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.home;

import com.swp391.dal.impl.BlogDAO;
import com.swp391.dal.impl.SliderDAO;
import com.swp391.entity.Blog;
import com.swp391.entity.Slider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller for blog functionality
 */
@WebServlet(name = "BlogController", urlPatterns = {"/blog"})
public class BlogController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }
        
        switch (action) {
            case "detail":
                showBlogDetail(request, response);
                break;
            case "list":
            default:
                showBlogList(request, response);
                break;
        }
    }
    
    /**
     * Show blog list with pagination and filtering
     */
    private void showBlogList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get parameters for filtering and pagination
        String searchTitle = request.getParameter("search");
        String status = "published"; // Only show published blogs on the public site
        
        // Pagination parameters
        int page = 1;
        int pageSize = 5; // Number of blogs per page
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Get blogs from database
        BlogDAO blogDAO = new BlogDAO();
        List<Blog> blogs = blogDAO.findBlogsWithFilter(searchTitle, status, page, pageSize);
        int totalBlogs = blogDAO.countBlogsWithFilter(searchTitle, status);
        
        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
        
        // Get active sliders for the carousel
        SliderDAO sliderDAO = new SliderDAO();
        List<Slider> activeSliders = sliderDAO.findActiveSliders();
        
        // Set attributes for the JSP
        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTitle", searchTitle);
        request.setAttribute("sliders", activeSliders);
        
        // Forward to the JSP
        request.getRequestDispatcher("/view/home/blog.jsp").forward(request, response);
    }
    
    /**
     * Show blog detail by ID
     */
    private void showBlogDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get blog ID from request parameter
            String blogIdStr = request.getParameter("id");
            
            if (blogIdStr == null || blogIdStr.isEmpty()) {
                // If no ID provided, redirect to blog list
                setToastMessage(request, "Blog ID is required", "error");
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }
            
            int blogId = Integer.parseInt(blogIdStr);
            
            // Get blog from database
            BlogDAO blogDAO = new BlogDAO();
            Blog blog = blogDAO.findById(blogId);
            
            if (blog == null) {
                // If blog not found, redirect to blog list
                setToastMessage(request, "Blog not found", "error");
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }
            
            // Check if blog is published
            if (!"published".equals(blog.getStatus())) {
                // If blog is not published, redirect to blog list
                setToastMessage(request, "Blog is not available", "error");
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }
            
            // Get recent blogs for sidebar (limit to 5)
            List<Blog> recentBlogs = blogDAO.findBlogsWithFilter(null, "published", 1, 5);
            
            // Thêm mã để loại bỏ blog hiện tại khỏi danh sách blog gần đây (nếu có)
            if (blog != null) {
                recentBlogs.removeIf(b -> b.getId() == blog.getId());
            }
            
            // Giới hạn số lượng blog gần đây (để tránh vấn đề với Math.min trong JSP)
            if (recentBlogs.size() > 4) {
                recentBlogs = recentBlogs.subList(0, 4);
            }
            
            // Set attributes for the JSP
            request.setAttribute("blog", blog);
            request.setAttribute("recentBlogs", recentBlogs);
            
            // Forward to the JSP
            request.getRequestDispatcher("/view/home/blog-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // If ID is not a number, redirect to blog list
            setToastMessage(request, "Invalid blog ID", "error");
            response.sendRedirect(request.getContextPath() + "/blog");
        } catch (Exception e) {
            // Handle other exceptions
            setToastMessage(request, "Error loading blog: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/blog");
        }
    }
    
    /**
     * Set toast message in session
     * 
     * @param request The HTTP request
     * @param message The message to display
     * @param type The type of message (success, error, etc.)
     */
    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Blog Controller";
    }
}
