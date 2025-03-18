/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Feedbacks;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
public class FeedbacksDAO extends DBContext {
    
    // Thêm feedback mới
    public int addFeedback(Feedbacks feedback) {
        String sql = "INSERT INTO feedbacks (user_id, order_item_id, content, rating, is_visible) "
                + "VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            statement.setInt(1, feedback.getUserId());
            statement.setInt(2, feedback.getOrderItemId());
            statement.setString(3, feedback.getContent());
            statement.setInt(4, feedback.getRating());
            statement.setBoolean(5, feedback.isIsVisible());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding feedback: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
    
    // Cập nhật feedback
    public boolean updateFeedback(Feedbacks feedback) {
        String sql = "UPDATE feedbacks SET content = ?, rating = ?, is_visible = ? "
                + "WHERE feedback_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, feedback.getContent());
            statement.setInt(2, feedback.getRating());
            statement.setBoolean(3, feedback.isIsVisible());
            statement.setInt(4, feedback.getFeedbackId());
            
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating feedback: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Xóa feedback
    public boolean deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedbacks WHERE feedback_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, feedbackId);
            
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting feedback: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Lấy feedback theo ID
    public Feedbacks getFeedbackById(int feedbackId) {
        String sql = "SELECT f.*, a.first_name, a.last_name, a.username, p.name as product_name, p.image as product_image "
                + "FROM feedbacks f "
                + "JOIN account a ON f.user_id = a.user_id "
                + "JOIN order_items oi ON f.order_item_id = oi.order_item_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE f.feedback_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, feedbackId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapFeedback(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error getting feedback by ID: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    // Lấy tất cả feedback của một sản phẩm
    public List<Feedbacks> getFeedbacksByProductId(int productId) {
        List<Feedbacks> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, a.first_name, a.last_name, a.username, p.name as product_name, p.image as product_image "
                + "FROM feedbacks f "
                + "JOIN account a ON f.user_id = a.user_id "
                + "JOIN order_items oi ON f.order_item_id = oi.order_item_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE p.product_id = ? AND f.is_visible = true "
                + "ORDER BY f.created_at DESC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, productId);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                feedbacks.add(mapFeedback(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getting feedbacks by product ID: " + e.getMessage());
        } finally {
            closeResources();
        }
        return feedbacks;
    }
    
    // Lấy feedback của một order item (kiểm tra người dùng đã đánh giá chưa)
    public Feedbacks getFeedbackByOrderItemId(int orderItemId) {
        String sql = "SELECT f.*, a.first_name, a.last_name, a.username, p.name as product_name, p.image as product_image "
                + "FROM feedbacks f "
                + "JOIN account a ON f.user_id = a.user_id "
                + "JOIN order_items oi ON f.order_item_id = oi.order_item_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE f.order_item_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, orderItemId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapFeedback(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error getting feedback by order item ID: " + e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    // Lấy tất cả feedback của một người dùng
    public List<Feedbacks> getFeedbacksByUserId(int userId) {
        List<Feedbacks> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, a.first_name, a.last_name, a.username, p.name as product_name, p.image as product_image "
                + "FROM feedbacks f "
                + "JOIN account a ON f.user_id = a.user_id "
                + "JOIN order_items oi ON f.order_item_id = oi.order_item_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE f.user_id = ? "
                + "ORDER BY f.created_at DESC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, userId);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                feedbacks.add(mapFeedback(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getting feedbacks by user ID: " + e.getMessage());
        } finally {
            closeResources();
        }
        return feedbacks;
    }
    
    // Tính rating trung bình của một sản phẩm
    public double getAverageRatingForProduct(int productId) {
        String sql = "SELECT AVG(f.rating) as avg_rating "
                + "FROM feedbacks f "
                + "JOIN order_items oi ON f.order_item_id = oi.order_item_id "
                + "WHERE oi.product_id = ? AND f.is_visible = true";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, productId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            System.out.println("Error getting average rating: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
    
    // Kiểm tra xem sản phẩm trong đơn hàng đã được đánh giá chưa
    public boolean hasUserReviewedOrderItem(int userId, int orderItemId) {
        String sql = "SELECT COUNT(*) FROM feedbacks WHERE user_id = ? AND order_item_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, userId);
            statement.setInt(2, orderItemId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking if user reviewed order item: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Lấy danh sách order item chưa được đánh giá của user
    public List<Integer> getUnreviewedOrderItemsByUser(int userId) {
        List<Integer> orderItemIds = new ArrayList<>();
        String sql = "SELECT oi.order_item_id "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "LEFT JOIN feedbacks f ON oi.order_item_id = f.order_item_id "
                + "WHERE o.user_id = ? AND o.status = 'completed' AND f.feedback_id IS NULL";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, userId);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orderItemIds.add(resultSet.getInt("order_item_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting unreviewed order items: " + e.getMessage());
        } finally {
            closeResources();
        }
        return orderItemIds;
    }
    
    // Kiểm tra xem người dùng đã đánh giá sản phẩm này chưa
    public boolean hasUserReviewedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM feedbacks f " +
                    "JOIN order_items oi ON f.order_item_id = oi.order_item_id " +
                    "WHERE f.user_id = ? AND oi.product_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking if user reviewed product: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Phương thức hỗ trợ để map ResultSet thành đối tượng Feedbacks
    private Feedbacks mapFeedback(ResultSet rs) throws SQLException {
        Feedbacks feedback = new Feedbacks();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setOrderItemId(rs.getInt("order_item_id"));
        feedback.setContent(rs.getString("content"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setIsVisible(rs.getBoolean("is_visible"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Thông tin mở rộng
        String firstName = rs.getString("first_name");
        String lastName = rs.getString("last_name");
        if (firstName != null && lastName != null) {
            feedback.setUserName(firstName + " " + lastName);
        } else {
            feedback.setUserName(rs.getString("username"));
        }
        
        feedback.setProductName(rs.getString("product_name"));
        feedback.setProductImage(rs.getString("product_image"));
        
        return feedback;
    }
}
