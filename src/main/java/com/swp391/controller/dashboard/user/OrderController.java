/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.user;

import com.swp391.dal.impl.OrderDAO;
import com.swp391.dal.impl.OrderItemDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "UserOrderController", urlPatterns = {"/orderControll"})
public class OrderController extends HttpServlet {

    private final String MY_ORDERS_PAGE = "/view/user/myOrder-list.jsp";
    private final String ORDER_DETAIL_PAGE = "/view/user/myOrder-detail.jsp";
    private final String LOGIN_PAGE = "/authen?action=login";
    
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        orderItemDAO = new OrderItemDAO();
    }

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
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }
        
        // Clear any stale messages if this is a fresh page load (not from a form submission)
        String fromPost = (String) session.getAttribute("fromPost");
        if (fromPost == null) {
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
        } else {
            session.removeAttribute("fromPost");
        }
        
        // Lấy thông tin từ request
        String action = request.getParameter("action");
        String status = request.getParameter("status");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Xử lý phân trang
        int page = 1;
        int pageSize = 10;
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Nếu action là "view" thì hiển thị chi tiết đơn hàng
        if (action != null && action.equals("view")) {
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/orderControll");
                return;
            }
            
            // Lấy thông tin đơn hàng
            Order order = orderDAO.findById(orderId);
            
            // Kiểm tra đơn hàng có thuộc về người dùng hiện tại không
            if (order == null || order.getUserId() != account.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/orderControll");
                return;
            }
            
            // Lấy danh sách sản phẩm trong đơn hàng
            List<OrderItem> orderItems = orderItemDAO.findByOrderId(orderId);
            order.setOrderItems(orderItems);
            
            // Đặt attribute và forward đến trang chi tiết
            request.setAttribute("order", order);
            request.getRequestDispatcher(ORDER_DETAIL_PAGE).forward(request, response);
            return;
        }
        
        // Lấy danh sách đơn hàng của người dùng hiện tại
        List<Order> orders = orderDAO.findOrdersByUserId(account.getUserId(), status, paymentMethod, page, pageSize);
        int totalOrders = orderDAO.getTotalOrdersByUserId(account.getUserId(), status, paymentMethod);
        
        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        
        // Đặt attribute và forward đến trang danh sách
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("paymentMethod", paymentMethod);
        
        request.getRequestDispatcher(MY_ORDERS_PAGE).forward(request, response);
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
        // Lấy thông tin từ request
        String action = request.getParameter("action");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }
        
        // Xử lý hủy đơn hàng
        if (action != null && action.equals("cancelOrder")) {
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid order ID");
                response.sendRedirect(request.getContextPath() + "/orderControll");
                return;
            }
            
            // Lấy thông tin đơn hàng
            Order order = orderDAO.findById(orderId);
            
            // Kiểm tra đơn hàng có thuộc về người dùng hiện tại không và có thể hủy không
            if (order != null && order.getUserId() == account.getUserId() && order.getStatus().equals("pending")) {
                // Cập nhật trạng thái đơn hàng
                order.setStatus("cancelled");
                boolean updated = orderDAO.update(order);
                
                if (updated) {
                    // Thêm thông báo thành công
                    session.setAttribute("successMessage", "Order #" + orderId + " has been cancelled successfully.");
                } else {
                    // Thông báo lỗi nếu cập nhật không thành công
                    session.setAttribute("errorMessage", "Failed to cancel order. Please try again.");
                }
                
                // Mark that we're coming from a POST request
                session.setAttribute("fromPost", "true");
            } else {
                // Thông báo lỗi nếu không thể hủy
                session.setAttribute("errorMessage", "Cannot cancel this order. It may not exist, not belong to you, or already processed.");
            }
            
            // Nếu request đến từ trang chi tiết, chuyển về trang chi tiết
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("action=view")) {
                response.sendRedirect(request.getContextPath() + "/orderControll?action=view&id=" + orderId);
                return;
            }
        }
        
        // Chuyển hướng về trang danh sách đơn hàng
        response.sendRedirect(request.getContextPath() + "/orderControll");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles user order operations";
    }// </editor-fold>

}
