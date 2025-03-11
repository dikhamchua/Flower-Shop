package com.swp391.dal.impl;

import com.swp391.entity.OrderItem;
import com.swp391.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO extends DBContext {

    // Lấy danh sách items của một đơn hàng
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();

        String sql = "SELECT oi.*, p.name as product_name, p.image as product_image "
                + "FROM order_items oi "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(resultSet.getInt("order_item_id"));
                item.setOrderId(resultSet.getInt("order_id"));
                item.setProductId(resultSet.getInt("product_id"));
                item.setQuantity(resultSet.getInt("quantity"));
                item.setPrice(resultSet.getBigDecimal("price"));
                item.setCreatedAt(resultSet.getTimestamp("created_at"));
                item.setUpdatedAt(resultSet.getTimestamp("updated_at"));

                // Thông tin sản phẩm
                item.setProductName(resultSet.getString("product_name"));
                item.setProductImage(resultSet.getString("product_image"));

                items.add(item);
            }
        } finally {
            closeResources();
        }

        return items;
    }

    /**
     * Find all order items for a specific order
     */
    public List<OrderItem> findByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as product_name, p.image as product_image "
                + "FROM order_items oi "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(resultSet.getInt("order_item_id"));
                item.setOrderId(resultSet.getInt("order_id"));
                item.setProductId(resultSet.getInt("product_id"));
                item.setQuantity(resultSet.getInt("quantity"));
                item.setPrice(resultSet.getBigDecimal("price"));
                item.setCreatedAt(resultSet.getTimestamp("created_at"));
                item.setUpdatedAt(resultSet.getTimestamp("updated_at"));

                // Thông tin sản phẩm
                item.setProductName(resultSet.getString("product_name"));
                item.setProductImage(resultSet.getString("product_image"));

                items.add(item);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding order items by order ID: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return items;
    }

    /**
     * Insert a new order item
     */
    public boolean insert(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, NOW(), NOW())";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, item.getOrderId());
            statement.setInt(2, item.getProductId());
            statement.setInt(3, item.getQuantity());
            statement.setBigDecimal(4, item.getPrice());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error inserting order item: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
}
