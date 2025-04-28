package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.ComboProduct;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for handling ComboProduct operations
 */
public class ComboProductDAO extends DBContext implements I_DAO<ComboProduct> {

    @Override
    public List<ComboProduct> findAll() {
        List<ComboProduct> comboProducts = new ArrayList<>();
        String sql = "SELECT * FROM combo_product";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboProducts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all combo products: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboProducts;
    }

    @Override
    public boolean update(ComboProduct comboProduct) {
        String sql = "UPDATE combo_product SET combo_id = ?, product_id = ?, quantity_in_combo = ? WHERE id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboProduct.getComboId());
            statement.setInt(2, comboProduct.getProductId());
            statement.setInt(3, comboProduct.getQuantityInCombo());
            statement.setInt(4, comboProduct.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating combo product: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(ComboProduct comboProduct) {
        String sql = "DELETE FROM combo_product WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboProduct.getId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting combo product: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(ComboProduct comboProduct) {
        String sql = "INSERT INTO combo_product (combo_id, product_id, quantity_in_combo) VALUES (?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, comboProduct.getComboId());
            statement.setInt(2, comboProduct.getProductId());
            statement.setInt(3, comboProduct.getQuantityInCombo());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating combo product failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating combo product failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting combo product: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public ComboProduct getFromResultSet(ResultSet rs) throws SQLException {
        ComboProduct comboProduct = new ComboProduct();
        comboProduct.setId(rs.getInt("id"));
        comboProduct.setComboId(rs.getInt("combo_id"));
        comboProduct.setProductId(rs.getInt("product_id"));
        comboProduct.setQuantityInCombo(rs.getInt("quantity_in_combo"));
        return comboProduct;
    }
    
    /**
     * Find all products in a combo
     * 
     * @param comboId The ID of the combo
     * @return List of ComboProduct objects for the specified combo
     */
    public List<ComboProduct> findByComboId(Integer comboId) {
        List<ComboProduct> comboProducts = new ArrayList<>();
        String sql = "SELECT * FROM combo_product WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboProducts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding combo products by combo ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboProducts;
    }
    
    /**
     * Delete all products in a combo
     * 
     * @param comboId The ID of the combo
     * @return True if successful, false otherwise
     */
    public boolean deleteByComboId(Integer comboId) {
        String sql = "DELETE FROM combo_product WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting combo products by combo ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Find all combos that contain a specific product
     * 
     * @param productId The ID of the product
     * @return List of ComboProduct objects containing the specified product
     */
    public List<ComboProduct> findByProductId(Integer productId) {
        List<ComboProduct> comboProducts = new ArrayList<>();
        String sql = "SELECT * FROM combo_product WHERE product_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboProducts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding combo products by product ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboProducts;
    }
}