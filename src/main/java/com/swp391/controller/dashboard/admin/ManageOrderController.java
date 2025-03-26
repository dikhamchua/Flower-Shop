/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.dal.impl.OrderApprovalDAO;
import com.swp391.dal.impl.OrderItemDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Order;
import com.swp391.entity.OrderApproval;
import com.swp391.entity.OrderItem;
import com.swp391.entity.Product;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ManageOrderController", urlPatterns = {"/admin/manage-order"})
public class ManageOrderController extends HttpServlet {

 
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
                    listOrders(request, response);
                    break;
                case "view":
                    viewOrderDetail(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
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
                case "updateStatus":
                    updateOrderStatus(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for managing orders in the admin dashboard";
    }// </editor-fold>

    // Hiển thị danh sách đơn hàng
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        
        // Get filter parameters
        String status = request.getParameter("status");
        String paymentMethod = request.getParameter("paymentMethod");
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 10;
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            // Keep default value
        }
        
        // Get orders with filters
        List<Order> orders;
        int totalOrders;
        
        if (search != null && !search.trim().isEmpty()) {
            // If there's a search term, use search with payment method
            orders = orderDAO.searchOrders(search, status, paymentMethod, page, pageSize);
            totalOrders = orderDAO.getTotalSearchResults(search, status, paymentMethod);
        } else {
            // If no search, use regular filters
            orders = orderDAO.findOrdersWithFilters(status, paymentMethod, page, pageSize);
            totalOrders = orderDAO.getTotalFilteredOrders(status, paymentMethod);
        }
        
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        
        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("search", search);
        
        // Forward to the order list page
        request.getRequestDispatcher("/view/admin/order-list.jsp").forward(request, response);
    }
    
    // Xem chi tiết đơn hàng
    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            
            OrderDAO orderDAO = new OrderDAO();
            OrderApprovalDAO approvalDAO = new OrderApprovalDAO();
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            
            Order order = orderDAO.findById(orderId);
            List<OrderApproval> approvals = approvalDAO.getOrderApprovalsByOrderId(orderId);
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);
            
            if (order == null) {
                request.setAttribute("errorMessage", "Order not found with ID: " + orderId);
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            order.setOrderItems(orderItems);
            request.setAttribute("order", order);
            request.setAttribute("approvals", approvals);
            
            // Forward to the order detail page
            request.getRequestDispatcher("/view/admin/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID format");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    // Cập nhật trạng thái đơn hàng
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("newStatus");
            String note = request.getParameter("note");
            
            // Validate input
            if (newStatus == null || newStatus.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Status cannot be empty");
                response.sendRedirect(request.getContextPath() + "/admin/manage-order?action=view&id=" + orderId);
                return;
            }
            
            // Get admin ID from session
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/authen");
                return;
            }
            
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findById(orderId);
            
            if (order == null) {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/manage-order");
                return;
            }
            
            // Get current status for message
            String oldStatus = order.getStatus();
            
            // Log gỡ lỗi
            System.out.println("DEBUG: update order #" + orderId + " from '" + oldStatus + "' to '" + newStatus + "'");
            
            boolean updated = orderDAO.updateOrderStatus(orderId, newStatus, account.getUserId(), note);
            
            if (updated) {
                // If order is being accepted, reduce product stock
                if ("accepted".equals(newStatus) && !"accepted".equals(oldStatus)) {
                    // Log gỡ lỗi
                    System.out.println("DEBUG: trying to reduce stock for order #" + orderId);
                    
                    boolean stockUpdated = reduceProductStock(orderId);
                    
                    // Log gỡ lỗi
                    System.out.println("DEBUG: result: " + (stockUpdated ? "THÀNH CÔNG" : "THẤT BẠI"));
                    
                    if (!stockUpdated) {
                        session.setAttribute("warningMessage", "status updated but stock not updated.");
                    }
                } else {
                    // Log gỡ lỗi
                    System.out.println("DEBUG: no need to reduce stock. newStatus=" + newStatus + ", oldStatus=" + oldStatus);
                }
                
                // Create success message with status details
                String statusText = "";
                switch (newStatus) {
                    case "accepted":
                        statusText = "accepted";
                        break;
                    case "completed":
                        statusText = "completed";
                        break;
                    case "cancelled":
                        statusText = "cancelled";
                        break;
                    default:
                        statusText = newStatus;
                }
                
                session.setAttribute("successMessage", "Order #" + orderId + " has been " + statusText + " successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to update order status. Please try again.");
            }
            
            // Redirect to the order detail page
            response.sendRedirect(request.getContextPath() + "/admin/manage-order?action=view&id=" + orderId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid order ID format");
            response.sendRedirect(request.getContextPath() + "/admin/manage-order");
        }
    }

    /**
     * Reduces product stock for all items in an order
     * @param orderId The ID of the order
     * @return true if all stock updates were successful, false otherwise
     */
    private boolean reduceProductStock(int orderId) {
        try {
            // Get all items in the order
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);
            
            if (orderItems == null || orderItems.isEmpty()) {
                return false;
            }
            
            ProductDAO productDAO = new ProductDAO();
            boolean allUpdatesSuccessful = true;
            
            // Update stock for each product
            for (OrderItem item : orderItems) {
                int productId = item.getProductId();
                int quantity = item.getQuantity();
                
                // Get current product
                Product product = productDAO.getProductById(productId);
                if (product == null) {
                    allUpdatesSuccessful = false;
                    continue;
                }
                
                // Calculate new stock level
                int currentStock = product.getStock();
                int newStock = Math.max(0, currentStock - quantity); // Ensure stock doesn't go below 0
                
                // Update product stock
                product.setStock(newStock);
                boolean updated = productDAO.update(product);
                
                if (!updated) {
                    allUpdatesSuccessful = false;
                }
            }
            
            return allUpdatesSuccessful;
        } catch (SQLException e) {
            System.out.println("Error reducing product stock: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
