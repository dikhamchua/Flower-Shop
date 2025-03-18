/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.user;

import com.swp391.dal.impl.FeedbacksDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.dal.impl.OrderItemDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Feedbacks;
import com.swp391.entity.OrderItem;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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
@WebServlet(name = "FeedbacksController", urlPatterns = {"/feedbackControl"})
public class FeedbacksController extends HttpServlet {

    private FeedbacksDAO feedbacksDAO;
    private OrderItemDAO orderItemDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        feedbacksDAO = new FeedbacksDAO();
        orderItemDAO = new OrderItemDAO();
        orderDAO = new OrderDAO();
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
        String action = request.getParameter("action");
        
        // Kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("account");
        
        if (loggedInUser == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để thực hiện tính năng này");
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listFeedbacks(request, response, loggedInUser);
                    break;
                case "select-product":
                    showProductSelectionList(request, response, loggedInUser);
                    break;
                case "write-review":
                    showReviewForm(request, response, loggedInUser);
                    break;
                case "edit":
                    showEditFeedbackForm(request, response, loggedInUser);
                    break;
                case "delete":
                    deleteFeedback(request, response, loggedInUser);
                    break;
                default:
                    listFeedbacks(request, response, loggedInUser);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/feedbackControl");
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
        
        // Kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("account");
        
        if (loggedInUser == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để thực hiện tính năng này");
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        try {
            switch (action) {
                case "submit":
                    submitFeedback(request, response, loggedInUser);
                    break;
                case "update":
                    updateFeedback(request, response, loggedInUser);
                    break;
                default:
                    listFeedbacks(request, response, loggedInUser);
            }
        } catch (Exception ex) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/feedbackControl");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Quản lý đánh giá sản phẩm";
    }// </editor-fold>

    private void listFeedbacks(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        List<Feedbacks> feedbacks = feedbacksDAO.getFeedbacksByUserId(loggedInUser.getUserId());
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/view/user/myFeedbacks.jsp").forward(request, response);
    }

    private void showProductSelectionList(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "Không tìm thấy đơn hàng để đánh giá");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        
        // Kiểm tra xem đơn hàng có thuộc về người dùng không
        if (!orderDAO.isOrderBelongsToUser(orderId, loggedInUser.getUserId())) {
            session.setAttribute("errorMessage", "Bạn không có quyền đánh giá đơn hàng này");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        // Kiểm tra xem đơn hàng đã hoàn thành chưa
        if (!orderDAO.isOrderCompleted(orderId)) {
            session.setAttribute("errorMessage", "Bạn chỉ có thể đánh giá các đơn hàng đã hoàn thành");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        try {
            // Lấy danh sách sản phẩm trong đơn hàng
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);
            
            // Tạo danh sách các orderItem đã được đánh giá
            List<Integer> reviewedOrderItems = new ArrayList<>();
            for (OrderItem item : orderItems) {
                if (feedbacksDAO.hasUserReviewedOrderItem(loggedInUser.getUserId(), item.getOrderItemId())) {
                    reviewedOrderItems.add(item.getOrderItemId());
                }
            }
            
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("orderId", orderId);
            request.setAttribute("reviewedOrderItems", reviewedOrderItems);
            request.getRequestDispatcher("/view/user/feedback-list.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException("Lỗi khi lấy thông tin sản phẩm trong đơn hàng", ex);
        }
    }

    private void showReviewForm(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String orderItemIdParam = request.getParameter("orderItemId");
        
        if (orderItemIdParam == null || orderItemIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "Không tìm thấy sản phẩm để đánh giá");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        int orderItemId = Integer.parseInt(orderItemIdParam);
        OrderItem orderItem = orderItemDAO.getOrderItemById(orderItemId);
        
        // Kiểm tra xem orderItem có tồn tại không
        if (orderItem == null) {
            session.setAttribute("errorMessage", "Không tìm thấy sản phẩm để đánh giá");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        // Kiểm tra xem đơn hàng có thuộc về user không và đã hoàn thành chưa
        if (!orderDAO.isOrderCompletedAndBelongsToUser(orderItem.getOrderId(), loggedInUser.getUserId())) {
            session.setAttribute("errorMessage", "Bạn không có quyền đánh giá sản phẩm này hoặc đơn hàng chưa hoàn thành");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        // Kiểm tra xem đã đánh giá chưa
        if (feedbacksDAO.hasUserReviewedOrderItem(loggedInUser.getUserId(), orderItemId)) {
            session.setAttribute("errorMessage", "Bạn đã đánh giá sản phẩm này rồi");
            response.sendRedirect(request.getContextPath() + "/feedbackControl?action=select-product&orderId=" + orderItem.getOrderId());
            return;
        }
        
        request.setAttribute("orderItem", orderItem);
        request.getRequestDispatcher("/view/user/feedback-form.jsp").forward(request, response);
    }

    private void submitFeedback(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        int orderItemId = Integer.parseInt(request.getParameter("orderItemId"));
        String content = request.getParameter("content");
        int rating = Integer.parseInt(request.getParameter("rating"));
        
        // Lấy đối tượng HttpSession từ request
        HttpSession session = request.getSession();
        
        OrderItem orderItem = orderItemDAO.getOrderItemById(orderItemId);
        
        // Kiểm tra xem orderItem có thuộc về user không và đơn hàng đã hoàn thành chưa
        if (orderItem == null || !orderDAO.isOrderCompletedAndBelongsToUser(orderItem.getOrderId(), loggedInUser.getUserId())) {
            session.setAttribute("errorMessage", "Bạn không có quyền đánh giá sản phẩm này hoặc đơn hàng chưa hoàn thành");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        // Kiểm tra xem đã đánh giá chưa
        if (feedbacksDAO.hasUserReviewedOrderItem(loggedInUser.getUserId(), orderItemId)) {
            session.setAttribute("errorMessage", "Bạn đã đánh giá sản phẩm này rồi");
            response.sendRedirect(request.getContextPath() + "/orderControll");
            return;
        }
        
        Feedbacks feedback = new Feedbacks(loggedInUser.getUserId(), orderItemId, content, rating);
        feedback.setIsVisible(true);
        
        if (feedbacksDAO.addFeedback(feedback) > 0) {
            session.setAttribute("successMessage", "Đánh giá của bạn đã được gửi thành công");
            // Chuyển hướng về trang danh sách sản phẩm của đơn hàng
            response.sendRedirect(request.getContextPath() + "/feedbackControl?action=select-product&orderId=" + orderItem.getOrderId());
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi đánh giá");
            response.sendRedirect(request.getContextPath() + "/feedbackControl");
        }
    }

    private void showEditFeedbackForm(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        int feedbackId = Integer.parseInt(request.getParameter("id"));
        Feedbacks feedback = feedbacksDAO.getFeedbackById(feedbackId);
        
        if (feedback == null || feedback.getUserId() != loggedInUser.getUserId()) {
            session.setAttribute("errorMessage", "Bạn không có quyền chỉnh sửa đánh giá này");
            response.sendRedirect(request.getContextPath() + "/feedbackControl");
            return;
        }
        
        OrderItem orderItem = orderItemDAO.getOrderItemById(feedback.getOrderItemId());
        request.setAttribute("feedback", feedback);
        request.setAttribute("orderItem", orderItem);
        request.getRequestDispatcher("/view/user/editFeedback.jsp").forward(request, response);
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        String content = request.getParameter("content");
        int rating = Integer.parseInt(request.getParameter("rating"));
        
        Feedbacks feedback = feedbacksDAO.getFeedbackById(feedbackId);
        
        if (feedback == null || feedback.getUserId() != loggedInUser.getUserId()) {
            session.setAttribute("errorMessage", "Bạn không có quyền chỉnh sửa đánh giá này");
            response.sendRedirect(request.getContextPath() + "/feedbackControl");
            return;
        }
        
        feedback.setContent(content);
        feedback.setRating(rating);
        
        if (feedbacksDAO.updateFeedback(feedback)) {
            session.setAttribute("successMessage", "Đánh giá đã được cập nhật thành công");
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật đánh giá");
        }
        
        response.sendRedirect(request.getContextPath() + "/feedbackControl");
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response, Account loggedInUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        int feedbackId = Integer.parseInt(request.getParameter("id"));
        Feedbacks feedback = feedbacksDAO.getFeedbackById(feedbackId);
        
        if (feedback == null || feedback.getUserId() != loggedInUser.getUserId()) {
            session.setAttribute("errorMessage", "Bạn không có quyền xóa đánh giá này");
            response.sendRedirect(request.getContextPath() + "/feedbackControl");
            return;
        }
        
        if (feedbacksDAO.deleteFeedback(feedbackId)) {
            session.setAttribute("successMessage", "Đánh giá đã được xóa thành công");
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa đánh giá");
        }
        
        response.sendRedirect(request.getContextPath() + "/feedbackControl");
    }
}
