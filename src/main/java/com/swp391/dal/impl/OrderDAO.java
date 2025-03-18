/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.entity.Order;
import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext implements I_DAO<Order> {

    @Override
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, a.username, a.email, a.phone "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orders;
    }

    @Override
    public int insert(Order order) {
        String sql = "INSERT INTO orders (user_id, status, total, shipping_address, payment_method) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, order.getUserId());
            statement.setString(2, order.getStatus());
            statement.setBigDecimal(3, order.getTotal());
            statement.setString(4, order.getShippingAddress());
            statement.setString(5, order.getPaymentMethod());

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting order: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean update(Order order) {
        String sql = "UPDATE orders SET status = ?, total = ?, shipping_address = ?, "
                + "payment_method = ?, updated_at = NOW() WHERE order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, order.getStatus());
            statement.setBigDecimal(2, order.getTotal());
            statement.setString(3, order.getShippingAddress());
            statement.setString(4, order.getPaymentMethod());
            statement.setInt(5, order.getOrderId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating order: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Order order) {
        throw new UnsupportedOperationException("Delete operation is not supported for orders");
    }

    @Override
    public Order getFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setStatus(rs.getString("status"));
        order.setTotal(rs.getBigDecimal("total"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Customer info from JOIN
        order.setUsername(rs.getString("username"));
        order.setEmail(rs.getString("email"));
        order.setPhone(rs.getString("phone"));

        return order;
    }

    public List<Order> findOrdersWithFilters(String status, String paymentMethod, int page, int pageSize) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.*, a.username, a.email, a.phone "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }

        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql.append("AND o.payment_method = ? ");
            params.add(paymentMethod);
        }

        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding filtered orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orders;
    }

    public int getTotalFilteredOrders(String status, String paymentMethod) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }

        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql.append("AND o.payment_method = ? ");
            params.add(paymentMethod);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting filtered orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public Order findById(int orderId) {
        String sql = "SELECT o.*, a.username, a.email, a.phone "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id "
                + "WHERE o.order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding order by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean updateOrderStatus(int orderId, String newStatus, int adminId, String note) {
        String currentStatus = null;
        
        // Get current status
        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            
            String getStatusSql = "SELECT status FROM orders WHERE order_id = ?";
            statement = connection.prepareStatement(getStatusSql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                currentStatus = resultSet.getString("status");
                System.out.println("Current status: " + currentStatus);
            } else {
                System.out.println("Order not found with ID: " + orderId);
                return false;
            }

            // Update order status
            String updateSql = "UPDATE orders SET status = ?, updated_at = NOW() WHERE order_id = ?";
            statement = connection.prepareStatement(updateSql);
            statement.setString(1, newStatus);
            statement.setInt(2, orderId);
            
            int rowsAffected = statement.executeUpdate();
            System.out.println("Update order status rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                // Add approval record directly instead of using OrderApprovalDAO
                String approvalSql = "INSERT INTO order_approvals (order_id, approved_by, status_before, status_after, note) " +
                                    "VALUES (?, ?, ?, ?, ?)";
                statement = connection.prepareStatement(approvalSql);
                statement.setInt(1, orderId);
                statement.setInt(2, adminId);
                statement.setString(3, currentStatus);
                statement.setString(4, newStatus);
                statement.setString(5, note);
                
                int approvalRowsAffected = statement.executeUpdate();
                System.out.println("Insert approval rows affected: " + approvalRowsAffected);
                
                if (approvalRowsAffected > 0) {
                    connection.commit();
                    System.out.println("Transaction committed successfully");
                    return true;
                }
            }
            
            System.out.println("Rolling back transaction");
            connection.rollback();
            return false;
            
        } catch (SQLException ex) {
            try {
                if (connection != null) {
                    System.out.println("Exception occurred, rolling back: " + ex.getMessage());
                    connection.rollback();
                }
            } catch (SQLException e) {
                System.out.println("Error rolling back transaction: " + e.getMessage());
            }
            System.out.println("Error updating order status: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException e) {
                System.out.println("Error resetting auto-commit: " + e.getMessage());
            }
            closeResources();
        }
    }

    public static void main(String[] args) {
        OrderDAO orderDAO = new OrderDAO();
        
        // Test updateOrderStatus
        System.out.println("\n--- Testing updateOrderStatus ---");
        try {
            int orderId = 1; // Thay đổi ID này thành ID đơn hàng thực tế trong DB của bạn
            String newStatus = "pending"; // Thay đổi trạng thái này nếu cần
            int adminId = 81; // Admin ID cố định để test
            String note = "Test update from main method";
            
            System.out.println("Updating order #" + orderId + " to status: " + newStatus);
            boolean result = orderDAO.updateOrderStatus(orderId, newStatus, adminId, note);
            
            if (result) {
                System.out.println("Update successful!");
                
                // Verify the update
                Order updatedOrder = orderDAO.findById(orderId);
                if (updatedOrder != null) {
                    System.out.println("Verified order #" + orderId + " now has status: " + updatedOrder.getStatus());
                }
            } else {
                System.out.println("Update failed!");
            }
        } catch (Exception e) {
            System.out.println("Exception during updateOrderStatus test: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Find orders by user ID with optional status filter and pagination
     */
    public List<Order> findOrdersByUserId(int userId, String status, String paymentMethod, int page, int pageSize) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.*, a.username, a.email, a.phone "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id "
                + "WHERE o.user_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }
        
        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql.append("AND o.payment_method = ? ");
            params.add(paymentMethod);
        }

        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding orders by user ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orders;
    }

    /**
     * Get total number of orders for a user with optional status filter
     */
    public int getTotalOrdersByUserId(int userId, String status, String paymentMethod) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) "
                + "FROM orders o "
                + "WHERE o.user_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }
        
        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql.append("AND o.payment_method = ? ");
            params.add(paymentMethod);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting orders by user ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<Order> searchOrders(String search, String status, String paymentMethod, int page, int pageSize) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.*, a.username, a.email, a.phone "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id "
                + "WHERE (a.username LIKE ? OR a.email LIKE ? OR CAST(o.order_id AS CHAR) = ?) ");
        List<Object> params = new ArrayList<>();
        
        String searchPattern = "%" + search.trim() + "%";
        params.add(searchPattern);
        params.add(searchPattern);
        params.add(search);

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }

        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql.append("AND o.payment_method = ? ");
            params.add(paymentMethod);
        }

        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error searching orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orders;
    }

    public int getTotalSearchResults(String search, String status, String paymentMethod) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) "
                + "FROM orders o "
                + "JOIN account a ON o.user_id = a.user_id "
                + "WHERE (a.username LIKE ? OR a.email LIKE ? OR CAST(o.order_id AS CHAR) = ?) ");
        List<Object> params = new ArrayList<>();
        
        String searchPattern = "%" + search.trim() + "%";
        params.add(searchPattern);
        params.add(searchPattern);
        params.add(search);

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }

        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql.append("AND o.payment_method = ? ");
            params.add(paymentMethod);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting search results: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Kiểm tra xem một đơn hàng đã hoàn thành chưa
     * @param orderId ID của đơn hàng cần kiểm tra
     * @return true nếu đơn hàng đã hoàn thành, ngược lại trả về false
     */
    public boolean isOrderCompleted(int orderId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_id = ? AND status = 'completed'";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if order is completed: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Kiểm tra xem một đơn hàng có thuộc về người dùng cụ thể hay không
     * @param orderId ID của đơn hàng cần kiểm tra
     * @param userId ID của người dùng cần kiểm tra
     * @return true nếu đơn hàng thuộc về người dùng, ngược lại trả về false
     */
    public boolean isOrderBelongsToUser(int orderId, int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_id = ? AND user_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            statement.setInt(2, userId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if order belongs to user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Kiểm tra xem một đơn hàng đã hoàn thành và thuộc về người dùng cụ thể hay không
     * @param orderId ID của đơn hàng cần kiểm tra
     * @param userId ID của người dùng cần kiểm tra
     * @return true nếu đơn hàng đã hoàn thành và thuộc về người dùng, ngược lại trả về false
     */
    public boolean isOrderCompletedAndBelongsToUser(int orderId, int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_id = ? AND user_id = ? AND status = 'completed'";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            statement.setInt(2, userId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if order completed and belongs to user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Kiểm tra xem người dùng đã mua sản phẩm này chưa và đơn hàng đã hoàn thành
     * @param userId ID của người dùng
     * @param productId ID của sản phẩm
     * @return true nếu người dùng đã mua sản phẩm và đơn hàng đã hoàn thành, ngược lại trả về false
     */
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM orders o " +
                    "JOIN order_items oi ON o.order_id = oi.order_id " +
                    "WHERE o.user_id = ? AND oi.product_id = ? AND o.status = 'completed'";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if user purchased product: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
}
