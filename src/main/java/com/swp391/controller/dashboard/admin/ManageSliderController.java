package com.swp391.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.swp391.dal.impl.SliderDAO;
import com.swp391.entity.Slider;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name="ManageSliderController", urlPatterns={"/admin/manage-slider"})
public class ManageSliderController extends HttpServlet {
   
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
                deactivateSlider(request, response);
                break;
            case "activate":
                activateSlider(request, response);
                break;
            case "list":
            default:
                listSliders(request, response);
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
                addSlider(request, response);
                break;
            case "update":
                updateSlider(request, response);
                break;
            default:
                listSliders(request, response);
                break;
        }
    }


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String sliderIdStr = request.getParameter("id");
        if (sliderIdStr != null && !sliderIdStr.isEmpty()) {
            int sliderId = Integer.parseInt(sliderIdStr);
            SliderDAO sliderDAO = new SliderDAO();
            Slider slider = sliderDAO.findById(sliderId);
            if (slider != null) {
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("/view/admin/slider-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-slider");
    }

    private void listSliders(HttpServletRequest request, HttpServletResponse response)
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

        SliderDAO sliderDAO = new SliderDAO();
        List<Slider> sliders;
        int totalSliders;
        
        // Apply filters if provided
        if ((searchFilter != null && !searchFilter.isEmpty()) || 
            (statusFilter != null && !statusFilter.isEmpty())) {
            
            // Convert status filter to byte if provided
            Byte statusByte = null;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                statusByte = Byte.parseByte(statusFilter);
            }
            
            // Get filtered sliders with pagination
            sliders = sliderDAO.findSlidersWithFilter(searchFilter, statusByte, page, pageSize);
            totalSliders = sliderDAO.countSlidersWithFilter(searchFilter, statusByte);
        } else {
            // Get all sliders with pagination
            sliders = sliderDAO.findSlidersWithPagination(page, pageSize);
            totalSliders = sliderDAO.getTotalSliders();
        }
        
        int totalPages = (int) Math.ceil((double) totalSliders / pageSize);

        // Set attributes for JSP
        request.setAttribute("sliders", sliders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSliders", totalSliders);

        // Set filter values for maintaining state
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("../view/admin/slider-list.jsp").forward(request, response);
    }

    private void updateSlider(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get information from request
            int sliderId = Integer.parseInt(request.getParameter("id"));
            String imageUrl = request.getParameter("image_url");
            String link = request.getParameter("link");
            String caption = request.getParameter("caption");
            byte status = Byte.parseByte(request.getParameter("status"));

            // Get slider from database
            SliderDAO sliderDAO = new SliderDAO();
            Slider slider = sliderDAO.findById(sliderId);

            if (slider != null) {
                // Validate input data - only check if image URL is empty
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    setToastMessage(request, "Image URL is required", "error");
                    response.sendRedirect(request.getContextPath() + "/admin/manage-slider?action=edit&id=" + sliderId);
                    return;
                }
                
                // Update fields
                slider.setImageUrl(imageUrl);
                slider.setLink(link);
                slider.setCaption(caption);
                slider.setStatus(status);
                
                // Update timestamp
                java.util.Date utilDate = new java.util.Date();
                slider.setUpdatedAt(new Timestamp(utilDate.getTime()));
                
                // Perform update
                boolean isSuccess = sliderDAO.update(slider);
                
                // Handle result
                if (isSuccess) {
                    setToastMessage(request, "Slider updated successfully!", "success");
                } else {
                    setToastMessage(request, "Failed to update slider!", "error");
                }
            } else {
                setToastMessage(request, "Slider not found!", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
        }
        
        // Redirect to list page
        response.sendRedirect(request.getContextPath() + "/admin/manage-slider?action=list");
    }

    private void deactivateSlider(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String sliderIdStr = request.getParameter("id");
        if (sliderIdStr != null && !sliderIdStr.isEmpty()) {
            int sliderId = Integer.parseInt(sliderIdStr);
            SliderDAO sliderDAO = new SliderDAO();
            boolean deactivated = sliderDAO.updateStatus(sliderId, (byte) 0);
            
            if (deactivated) {
                setToastMessage(request, "Slider deactivated successfully", "success");
            } else {
                setToastMessage(request, "Failed to deactivate slider", "error");
            }
        } else {
            setToastMessage(request, "Invalid slider ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-slider");
    }

    private void activateSlider(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String sliderIdStr = request.getParameter("id");
        if (sliderIdStr != null && !sliderIdStr.isEmpty()) {
            int sliderId = Integer.parseInt(sliderIdStr);
            SliderDAO sliderDAO = new SliderDAO();
            boolean activated = sliderDAO.updateStatus(sliderId, (byte) 1);
            
            if (activated) {
                setToastMessage(request, "Slider activated successfully", "success");
            } else {
                setToastMessage(request, "Failed to activate slider", "error");
            }
        } else {
            setToastMessage(request, "Invalid slider ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-slider");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/slider-add.jsp");
        dispatcher.forward(request, response);
    }

    private void addSlider(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        try {
            // Get information from request
            String imageUrl = request.getParameter("image_url");
            String link = request.getParameter("link");
            String caption = request.getParameter("caption");
            byte status = Byte.parseByte(request.getParameter("status"));
            
            // Validate input data - only check if image URL is empty
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                setToastMessage(request, "Image URL is required", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-slider?action=add");
                return;
            }

            // Create new Slider object
            java.util.Date utilDate = new java.util.Date();
            Timestamp timestamp = new Timestamp(utilDate.getTime());
            
            Slider newSlider = new Slider();
            newSlider.setImageUrl(imageUrl);
            newSlider.setLink(link);
            newSlider.setCaption(caption);
            newSlider.setStatus(status);
            newSlider.setCreatedAt(timestamp);
            newSlider.setUpdatedAt(timestamp);

            // Add slider to database
            SliderDAO sliderDAO = new SliderDAO();
            int newId = sliderDAO.insert(newSlider);

            // Handle result
            if (newId > 0) {
                setToastMessage(request, "Slider added successfully!", "success");
                response.sendRedirect(request.getContextPath() + "/admin/manage-slider?action=list");
            } else {
                setToastMessage(request, "Failed to add slider!", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-slider?action=add");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/admin/manage-slider?action=add");
        }
    }
} 