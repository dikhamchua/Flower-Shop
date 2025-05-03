package com.swp391.dal.impl;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.swp391.entity.OrderComboProduct;
import com.swp391.entity.OrderCombo;
import com.swp391.dal.I_DAO;
import com.swp391.dal.DBContext;
import java.math.BigDecimal;

/**
 *
 * @author GitHub Copilot
 */
public class OrderComboProductDAO extends DBContext implements I_DAO<OrderComboProduct> {

    @Override
    public List<OrderComboProduct> findAll() {
        List<OrderComboProduct> orderComboProducts = new ArrayList<>();
        String sql = "SELECT * FROM order_combo_product";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orderComboProducts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all order combo products: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orderComboProducts;
    }

    @Override
    public boolean update(OrderComboProduct orderComboProduct) {
        String sql = "UPDATE order_combo_product SET order_combo_id = ?, product_id = ?, product_name = ?, "
                + "product_price = ?, quantity_in_combo = ?, total_quantity = ? WHERE order_combo_product_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderComboProduct.getOrderComboId());
            statement.setInt(2, orderComboProduct.getProductId());
            statement.setString(3, orderComboProduct.getProductName());
            statement.setBigDecimal(4, orderComboProduct.getProductPrice());
            statement.setInt(5, orderComboProduct.getQuantityInCombo());
            statement.setInt(6, orderComboProduct.getTotalQuantity());
            statement.setInt(7, orderComboProduct.getOrderComboProductId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating order combo product: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(OrderComboProduct orderComboProduct) {
        String sql = "DELETE FROM order_combo_product WHERE order_combo_product_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderComboProduct.getOrderComboProductId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting order combo product: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(OrderComboProduct orderComboProduct) {
        String sql = "INSERT INTO order_combo_product (order_combo_id, product_id, product_name, product_price, "
                + "quantity_in_combo, total_quantity) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, orderComboProduct.getOrderComboId());
            statement.setInt(2, orderComboProduct.getProductId());
            statement.setString(3, orderComboProduct.getProductName());
            statement.setBigDecimal(4, orderComboProduct.getProductPrice());
            statement.setInt(5, orderComboProduct.getQuantityInCombo());
            statement.setInt(6, orderComboProduct.getTotalQuantity());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating order combo product failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating order combo product failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting order combo product: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public OrderComboProduct getFromResultSet(ResultSet rs) throws SQLException {
        OrderComboProduct orderComboProduct = new OrderComboProduct();
        orderComboProduct.setOrderComboProductId(rs.getInt("order_combo_product_id"));
        orderComboProduct.setOrderComboId(rs.getInt("order_combo_id"));
        orderComboProduct.setProductId(rs.getInt("product_id"));
        orderComboProduct.setProductName(rs.getString("product_name"));
        orderComboProduct.setProductPrice(rs.getBigDecimal("product_price"));
        orderComboProduct.setQuantityInCombo(rs.getInt("quantity_in_combo"));
        orderComboProduct.setTotalQuantity(rs.getInt("total_quantity"));
        return orderComboProduct;
    }

    /**
     * Find all products in an order combo
     *
     * @param orderComboId ID of the order combo
     * @return List of order combo products
     */
    public List<OrderComboProduct> findByOrderComboId(Integer orderComboId) {
        List<OrderComboProduct> orderComboProducts = new ArrayList<>();
        String sql = "SELECT * FROM order_combo_product WHERE order_combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderComboId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                orderComboProducts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding order combo products by order combo ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return orderComboProducts;
    }

    /**
     * Find an order combo product by its ID
     *
     * @param orderComboProductId ID of the order combo product
     * @return OrderComboProduct object or null if not found
     */
    public OrderComboProduct findById(Integer orderComboProductId) {
        String sql = "SELECT * FROM order_combo_product WHERE order_combo_product_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderComboProductId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding order combo product by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Delete all products for a given order combo
     *
     * @param orderComboId ID of the order combo
     * @return true if successful, false otherwise
     */
    public boolean deleteByOrderComboId(Integer orderComboId) {
        String sql = "DELETE FROM order_combo_product WHERE order_combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderComboId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting order combo products by order combo ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Batch insert multiple products for an order combo
     *
     * @param orderComboId ID of the order combo
     * @param orderComboProducts List of products to insert
     * @return true if all inserts were successful, false otherwise
     */
    public boolean batchInsert(Integer orderComboId, List<OrderComboProduct> orderComboProducts) {
        String sql = "INSERT INTO order_combo_product (order_combo_id, product_id, product_name, product_price, "
                + "quantity_in_combo, total_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            statement = connection.prepareStatement(sql);

            for (OrderComboProduct product : orderComboProducts) {
                statement.setInt(1, orderComboId);
                statement.setInt(2, product.getProductId());
                statement.setString(3, product.getProductName());
                statement.setBigDecimal(4, product.getProductPrice());
                statement.setInt(5, product.getQuantityInCombo());
                statement.setInt(6, product.getTotalQuantity());
                statement.addBatch();
            }

            int[] results = statement.executeBatch();
            connection.commit();

            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                System.out.println("Error rolling back transaction: " + rollbackEx.getMessage());
            }
            System.out.println("Error batch inserting order combo products: " + ex.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException resetAutoCommitEx) {
                System.out.println("Error resetting auto commit: " + resetAutoCommitEx.getMessage());
            }
            closeResources();
        }
    }
    
    public static void main(String[] args) {
        OrderComboProductDAO dao = new OrderComboProductDAO();
        
        // Test findAll()
        System.out.println("=== Test findAll() ===");
        List<OrderComboProduct> allProducts = dao.findAll();
        
        if (allProducts.isEmpty()) {
            System.out.println("Không tìm thấy sản phẩm nào trong order combo");
        } else {
            System.out.println("Tìm thấy " + allProducts.size() + " sản phẩm trong order combo:");
            for (OrderComboProduct product : allProducts) {
                System.out.println("ID: " + product.getOrderComboProductId());
                System.out.println("Order Combo ID: " + product.getOrderComboId());
                System.out.println("Product ID: " + product.getProductId());
                System.out.println("Product Name: " + product.getProductName());
                System.out.println("Product Price: " + product.getProductPrice());
                System.out.println("Quantity in Combo: " + product.getQuantityInCombo());
                System.out.println("Total Quantity: " + product.getTotalQuantity());
                System.out.println("------------------------");
            }
        }
    }
}
