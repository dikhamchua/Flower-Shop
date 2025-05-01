package com.swp391.dal.impl;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.swp391.entity.OrderCombo;
import com.swp391.dal.I_DAO;
import com.swp391.dal.DBContext;
import java.math.BigDecimal;

/**
 *
 * @author GitHub Copilot
 */
public class OrderComboDAO extends DBContext implements I_DAO<OrderCombo> {

    @Override
    public List<OrderCombo> findAll() {
        List<OrderCombo> orderCombos = new ArrayList<>();
        String sql = "SELECT * FROM order_combo";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orderCombos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all order combos: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orderCombos;
    }

    @Override
    public boolean update(OrderCombo orderCombo) {
        String sql = "UPDATE order_combo SET order_id = ?, combo_id = ?, combo_name = ?, " +
                "combo_discount_price = ?, quantity = ?, total_price = ? WHERE order_combo_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderCombo.getOrderId());
            statement.setInt(2, orderCombo.getComboId());
            statement.setString(3, orderCombo.getComboName());
            statement.setBigDecimal(4, orderCombo.getComboDiscountPrice());
            statement.setInt(5, orderCombo.getQuantity());
            statement.setBigDecimal(6, orderCombo.getTotalPrice());
            statement.setInt(7, orderCombo.getOrderComboId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating order combo: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(OrderCombo orderCombo) {
        String sql = "DELETE FROM order_combo WHERE order_combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderCombo.getOrderComboId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting order combo: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(OrderCombo orderCombo) {
        String sql = "INSERT INTO order_combo (order_id, combo_id, combo_name, combo_discount_price, " +
                "quantity, total_price) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, orderCombo.getOrderId());
            statement.setInt(2, orderCombo.getComboId());
            statement.setString(3, orderCombo.getComboName());
            statement.setBigDecimal(4, orderCombo.getComboDiscountPrice());
            statement.setInt(5, orderCombo.getQuantity());
            statement.setBigDecimal(6, orderCombo.getTotalPrice());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating order combo failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating order combo failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting order combo: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public OrderCombo getFromResultSet(ResultSet rs) throws SQLException {
        OrderCombo orderCombo = new OrderCombo();
        orderCombo.setOrderComboId(rs.getInt("order_combo_id"));
        orderCombo.setOrderId(rs.getInt("order_id"));
        orderCombo.setComboId(rs.getInt("combo_id"));
        orderCombo.setComboName(rs.getString("combo_name"));
        orderCombo.setComboDiscountPrice(rs.getBigDecimal("combo_discount_price"));
        orderCombo.setQuantity(rs.getInt("quantity"));
        orderCombo.setTotalPrice(rs.getBigDecimal("total_price"));
        return orderCombo;
    }
    
    /**
     * Find order combos by order ID
     * @param orderId ID of the order
     * @return List of order combos
     */
    public List<OrderCombo> findByOrderId(Integer orderId) {
        List<OrderCombo> orderCombos = new ArrayList<>();
        String sql = "SELECT * FROM order_combo WHERE order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orderCombos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding order combos by order ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orderCombos;
    }
    
    /**
     * Find order combo by its ID
     * @param orderComboId ID of the order combo
     * @return OrderCombo object or null if not found
     */
    public OrderCombo findById(Integer orderComboId) {
        String sql = "SELECT * FROM order_combo WHERE order_combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderComboId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding order combo by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Delete all order combos for a given order
     * @param orderId ID of the order
     * @return true if successful, false otherwise
     */
    public boolean deleteByOrderId(Integer orderId) {
        String sql = "DELETE FROM order_combo WHERE order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting order combos by order ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public static void main(String[] args) {
        OrderComboDAO orderComboDAO = new OrderComboDAO();
        
        // Test 1: Insert a new order combo
        System.out.println("===== Test inserting a new order combo =====");
        OrderCombo newCombo = new OrderCombo();
        newCombo.setOrderId(41); // Use an existing order ID
        newCombo.setComboId(1);  // Use an existing combo ID
        newCombo.setComboName("Test Combo Package");
        newCombo.setComboDiscountPrice(new BigDecimal("150.00"));
        newCombo.setQuantity(2);
        newCombo.setTotalPrice(new BigDecimal("300.00"));
        
        int newOrderComboId = orderComboDAO.insert(newCombo);
        
        if (newOrderComboId > 0) {
            System.out.println("Successfully inserted order combo with ID: " + newOrderComboId);
            
            // Test 2: Find by ID
            System.out.println("\n===== Test finding order combo by ID =====");
            OrderCombo foundCombo = orderComboDAO.findById(newOrderComboId);
            if (foundCombo != null) {
                System.out.println("Found order combo: " + foundCombo);
                
                // Test 3: Update the order combo
                System.out.println("\n===== Test updating order combo =====");
                foundCombo.setQuantity(3);
                foundCombo.setTotalPrice(new BigDecimal("450.00"));
                boolean updateSuccess = orderComboDAO.update(foundCombo);
                System.out.println("Update success: " + updateSuccess);
                
                // Test 4: Verify update
                OrderCombo updatedCombo = orderComboDAO.findById(newOrderComboId);
                System.out.println("Updated order combo: " + updatedCombo);
                
                // // Test 5: Delete the order combo
                // System.out.println("\n===== Test deleting order combo =====");
                // boolean deleteSuccess = orderComboDAO.delete(updatedCombo);
                // System.out.println("Delete success: " + deleteSuccess);
            } else {
                System.out.println("Failed to find order combo with ID: " + newOrderComboId);
            }
        } else {
            System.out.println("Failed to insert order combo");
        }
        
        // Test 6: Find all order combos
        System.out.println("\n===== Test finding all order combos =====");
        List<OrderCombo> allCombos = orderComboDAO.findAll();
        System.out.println("Found " + allCombos.size() + " order combos");
        for (OrderCombo combo : allCombos) {
            System.out.println(combo);
        }
    }
}