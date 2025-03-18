/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.CouponDAO;
import com.swp391.dal.impl.CouponUsageDAO;
import com.swp391.entity.Coupon;
import com.swp391.entity.CouponUsage;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ManageCouponController", urlPatterns = {"/admin/manage-coupon"})
public class ManageCouponController extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listCoupons(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteCoupon(request, response);
                    break;
                case "usage":
                    viewCouponUsage(request, response);
                    break;
                default:
                    listCoupons(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
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
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "insert":
                    insertCoupon(request, response);
                    break;
                case "update":
                    updateCoupon(request, response);
                    break;
                default:
                    listCoupons(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Quản lý mã giảm giá";
    }// </editor-fold>

    private void listCoupons(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CouponDAO couponDAO = new CouponDAO();
        
        // Lấy các tham số lọc
        String status = request.getParameter("status");
        String discountType = request.getParameter("discountType");
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 10;
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định
        }
        
        // Lấy danh sách coupon với bộ lọc
        List<Coupon> coupons;
        int totalCoupons;
        
        if (search != null && !search.trim().isEmpty()) {
            // Nếu có từ khóa tìm kiếm, sử dụng tìm kiếm với các bộ lọc
            coupons = couponDAO.searchCoupons(search, status, discountType, page, pageSize);
            totalCoupons = couponDAO.getTotalSearchResults(search, status, discountType);
        } else {
            // Nếu không có từ khóa tìm kiếm, chỉ sử dụng bộ lọc
            coupons = couponDAO.findCouponsWithFilters(status, discountType, page, pageSize);
            totalCoupons = couponDAO.getTotalFilteredCoupons(status, discountType);
        }
        
        int totalPages = (int) Math.ceil((double) totalCoupons / pageSize);
        
        // Đặt các thuộc tính
        request.setAttribute("coupons", coupons);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("discountType", discountType);
        request.setAttribute("search", search);
        
        // Chuyển hướng đến trang danh sách coupon
        request.getRequestDispatcher("/view/admin/coupon-list.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/coupon-add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int couponId = Integer.parseInt(request.getParameter("id"));
        CouponDAO couponDAO = new CouponDAO();
        Coupon coupon = couponDAO.getCouponById(couponId);
        
        if (coupon != null) {
            request.setAttribute("coupon", coupon);
            request.getRequestDispatcher("/view/admin/coupon-edit.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("errorMessage", "Coupon not found");
            response.sendRedirect(request.getContextPath() + "/admin/manage-coupon");
        }
    }
    
    private void insertCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        // Lấy dữ liệu từ form
        String code = request.getParameter("code");
        String description = request.getParameter("description");
        String discountType = request.getParameter("discountType");
        BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
        
        String minPurchaseStr = request.getParameter("minPurchase");
        BigDecimal minPurchase = (minPurchaseStr != null && !minPurchaseStr.isEmpty()) 
                ? new BigDecimal(minPurchaseStr) : null;
        
        String maxDiscountStr = request.getParameter("maxDiscount");
        BigDecimal maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty() && "percentage".equals(discountType)) 
                ? new BigDecimal(maxDiscountStr) : null;
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = dateFormat.parse(request.getParameter("startDate"));
        Date endDate = dateFormat.parse(request.getParameter("endDate"));
        
        String usageLimitStr = request.getParameter("usageLimit");
        Integer usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) 
                ? Integer.parseInt(usageLimitStr) : null;
        
        boolean isActive = request.getParameter("isActive") != null;
        
        // Validate dữ liệu
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Mã coupon không được để trống");
            showAddForm(request, response);
            return;
        }
        
        // Kiểm tra xem mã coupon đã tồn tại chưa
        CouponDAO couponDAO = new CouponDAO();
        Coupon existingCoupon = couponDAO.getCouponByCode(code);
        if (existingCoupon != null) {
            request.setAttribute("errorMessage", "Mã coupon đã tồn tại");
            showAddForm(request, response);
            return;
        }
        
        // Tạo coupon mới
        Coupon coupon = new Coupon();
        coupon.setCode(code);
        coupon.setDescription(description);
        coupon.setDiscountType(discountType);
        coupon.setDiscountValue(discountValue);
        coupon.setMinPurchase(minPurchase);
        coupon.setMaxDiscount(maxDiscount);
        coupon.setStartDate(startDate);
        coupon.setEndDate(endDate);
        coupon.setUsageLimit(usageLimit);
        coupon.setUsageCount(0);
        coupon.setActive(isActive);
        coupon.setCreatedAt(new Date());
        coupon.setUpdatedAt(new Date());
        
        // Lưu vào database
        if (couponDAO.insertCoupon(coupon)) {
            request.getSession().setAttribute("successMessage", "Coupon created successfully");
            response.sendRedirect(request.getContextPath() + "/admin/manage-coupon");
        } else {
            request.setAttribute("errorMessage", "Failed to create coupon");
            request.getRequestDispatcher("/view/admin/coupon-add.jsp").forward(request, response);
        }
    }
    
    private void updateCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        int couponId = Integer.parseInt(request.getParameter("couponId"));
        String code = request.getParameter("code");
        String description = request.getParameter("description");
        String discountType = request.getParameter("discountType");
        BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
        
        String minPurchaseStr = request.getParameter("minPurchase");
        BigDecimal minPurchase = (minPurchaseStr != null && !minPurchaseStr.isEmpty()) 
                ? new BigDecimal(minPurchaseStr) : null;
        
        String maxDiscountStr = request.getParameter("maxDiscount");
        BigDecimal maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty() && "percentage".equals(discountType)) 
                ? new BigDecimal(maxDiscountStr) : null;
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = dateFormat.parse(request.getParameter("startDate"));
        Date endDate = dateFormat.parse(request.getParameter("endDate"));
        
        String usageLimitStr = request.getParameter("usageLimit");
        Integer usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) 
                ? Integer.parseInt(usageLimitStr) : null;
        
        boolean isActive = request.getParameter("isActive") != null;
        
        // Validate dữ liệu
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Coupon code cannot be empty");
            request.setAttribute("couponId", couponId);
            showEditForm(request, response);
            return;
        }
        
        // Kiểm tra xem mã coupon đã tồn tại chưa (trừ chính mã hiện tại)
        CouponDAO couponDAO = new CouponDAO();
        Coupon existingCoupon = couponDAO.getCouponByCode(code);
        if (existingCoupon != null && existingCoupon.getCouponId() != couponId) {
            request.setAttribute("errorMessage", "Coupon code already exists");
            request.setAttribute("couponId", couponId);
            showEditForm(request, response);
            return;
        }
        
        // Lấy coupon hiện tại từ database
        Coupon coupon = couponDAO.getCouponById(couponId);
        if (coupon != null) {
            // Cập nhật thông tin
            coupon.setCode(code);
            coupon.setDescription(description);
            coupon.setDiscountType(discountType);
            coupon.setDiscountValue(discountValue);
            coupon.setMinPurchase(minPurchase);
            coupon.setMaxDiscount(maxDiscount);
            coupon.setStartDate(startDate);
            coupon.setEndDate(endDate);
            coupon.setUsageLimit(usageLimit);
            coupon.setActive(isActive);
            coupon.setUpdatedAt(new Date());
            
            // Lưu vào database
            if (couponDAO.updateCoupon(coupon)) {
                request.getSession().setAttribute("successMessage", "Coupon updated successfully");
                response.sendRedirect(request.getContextPath() + "/admin/manage-coupon");
            } else {
                request.setAttribute("errorMessage", "Failed to update coupon");
                request.setAttribute("coupon", coupon);
                request.getRequestDispatcher("/view/admin/coupon-edit.jsp").forward(request, response);
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Coupon not found");
            response.sendRedirect(request.getContextPath() + "/admin/manage-coupon");
        }
    }
    
    private void deleteCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int couponId = Integer.parseInt(request.getParameter("id"));
        CouponDAO couponDAO = new CouponDAO();
        
        if (couponDAO.deleteCoupon(couponId)) {
            request.getSession().setAttribute("successMessage", "Coupon deleted successfully");
            response.sendRedirect(request.getContextPath() + "/admin/manage-coupon");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to delete coupon");
            response.sendRedirect(request.getContextPath() + "/admin/manage-coupon");
        }
    }
    
    private void viewCouponUsage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int couponId = Integer.parseInt(request.getParameter("id"));
        
        CouponDAO couponDAO = new CouponDAO();
        Coupon coupon = couponDAO.getCouponById(couponId);
        
        CouponUsageDAO usageDAO = new CouponUsageDAO();
        List<CouponUsage> usages = usageDAO.getCouponUsagesByCouponId(couponId);
        
        request.setAttribute("coupon", coupon);
        request.setAttribute("usages", usages);
        request.getRequestDispatcher("/view/admin/coupon-usage.jsp").forward(request, response);
    }
}
