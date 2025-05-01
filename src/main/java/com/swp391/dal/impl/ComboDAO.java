package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Combo;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO class for handling Combo operations
 */
public class ComboDAO extends DBContext implements I_DAO<Combo> {

    @Override
    public List<Combo> findAll() {
        List<Combo> combos = new ArrayList<>();
        String sql = "SELECT * FROM combo";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                combos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all combos: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return combos;
    }

    @Override
    public boolean update(Combo combo) {
        String sql = "UPDATE combo SET name = ?, description = ?, original_price = ?, "
                + "discount_price = ?, status = ?, image = ? WHERE combo_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, combo.getName());
            statement.setString(2, combo.getDescription());
            statement.setFloat(3, combo.getOriginalPrice());
            statement.setFloat(4, combo.getDiscountPrice());
            statement.setString(5, combo.getStatus());
            statement.setString(6, combo.getImage());
            statement.setInt(7, combo.getComboId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating combo: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Combo combo) {
        String sql = "DELETE FROM combo WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, combo.getComboId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting combo: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Combo combo) {
        String sql = "INSERT INTO combo (name, description, original_price, discount_price, status, image) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, combo.getName());
            statement.setString(2, combo.getDescription());
            statement.setFloat(3, combo.getOriginalPrice());
            statement.setFloat(4, combo.getDiscountPrice());
            statement.setString(5, combo.getStatus());
            statement.setString(6, combo.getImage());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating combo failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating combo failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting combo: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Combo getFromResultSet(ResultSet rs) throws SQLException {
        Combo combo = new Combo();
        combo.setComboId(rs.getInt("combo_id"));
        combo.setName(rs.getString("name"));
        combo.setDescription(rs.getString("description"));
        combo.setOriginalPrice(rs.getFloat("original_price"));
        combo.setDiscountPrice(rs.getFloat("discount_price"));
        combo.setStatus(rs.getString("status"));
        combo.setImage(rs.getString("image")); // Add this line to get image from result set

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            combo.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            combo.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return combo;
    }

    /**
     * Find a combo by its ID
     *
     * @param comboId The ID of the combo to find
     * @return The combo if found, null otherwise
     */
    public Combo findById(Integer comboId) {
        String sql = "SELECT * FROM combo WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding combo by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Find all active combos
     *
     * @return List of active combos
     */
    public List<Combo> findAllActive() {
        List<Combo> combos = new ArrayList<>();
        String sql = "SELECT * FROM combo WHERE status = 'active'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                combos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding active combos: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return combos;
    }

    /**
     * Update the status of a combo
     *
     * @param comboId The ID of the combo to update
     * @param status The new status (active/inactive)
     * @return True if successful, false otherwise
     */
    public boolean updateStatus(Integer comboId, String status) {
        String sql = "UPDATE combo SET status = ? WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, comboId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating combo status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Tìm kiếm combo theo nhiều tiêu chí
     *
     * @param searchTerm Từ khóa tìm kiếm (tên, mô tả)
     * @param status Trạng thái combo (active/inactive)
     * @param page Trang hiện tại
     * @param pageSize Số lượng combo mỗi trang
     * @return Danh sách combo thỏa mãn điều kiện
     */
    public List<Combo> searchCombos(String searchTerm, String status, int page, int pageSize) {
        List<Combo> combos = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM combo WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        // Thêm điều kiện lọc theo trạng thái
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        // Thêm phân trang
        sql.append(" ORDER BY combo_id DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Thiết lập tham số
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                combos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error searching combos: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return combos;
    }

    /**
     * Đếm tổng số combo thỏa mãn điều kiện tìm kiếm
     *
     * @param searchTerm Từ khóa tìm kiếm (tên, mô tả)
     * @param status Trạng thái combo (active/inactive)
     * @return Tổng số combo thỏa mãn điều kiện
     */
    public int countSearchResults(String searchTerm, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM combo WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        // Thêm điều kiện lọc theo trạng thái
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Thiết lập tham số
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
     * Get detailed information about products in a combo
     * 
     * @param comboId The ID of the combo
     * @return List of maps containing product details
     */
    public List<Map<String, Object>> getComboProductDetails(int comboId) {
        List<Map<String, Object>> productDetails = new ArrayList<>();
        String sql = "SELECT p.product_id, p.name AS productName, p.price, p.image, cp.quantity_in_combo AS quantity " +
                     "FROM combo_product cp " +
                     "JOIN products p ON cp.product_id = p.product_id " +
                     "WHERE cp.combo_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", resultSet.getInt("product_id"));
                product.put("productName", resultSet.getString("productName"));
                product.put("price", resultSet.getFloat("price"));
                product.put("image", resultSet.getString("image"));
                product.put("quantity", resultSet.getInt("quantity"));
                
                productDetails.add(product);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting combo product details: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return productDetails;
    }
    
    /**
     * Test method for getComboProductDetails
     * Run this method to test if combo product details are being retrieved correctly
     */
    public static void main(String[] args) {
        ComboDAO comboDAO = new ComboDAO();
        
        // Test with combo ID 1 - replace with an actual combo ID from your database
        int testComboId = 66;
        List<Map<String, Object>> products = comboDAO.getComboProductDetails(testComboId);
        
        System.out.println("===== Testing getComboProductDetails for Combo ID: " + testComboId + " =====");
        
        if (products.isEmpty()) {
            System.out.println("No products found for this combo. Check if the combo ID exists or if it has any products.");
        } else {
            System.out.println("Found " + products.size() + " products in this combo:");
            
            for (Map<String, Object> product : products) {
                System.out.println("\n--- Product Details ---");
                System.out.println("Product ID: " + product.get("productId"));
                System.out.println("Product Name: " + product.get("productName"));
                System.out.println("Price: " + product.get("price"));
                System.out.println("Image Path: " + product.get("image"));
                System.out.println("Quantity in Combo: " + product.get("quantity"));
            }
        }
        
        // Test SQL query directly to debug
        System.out.println("\n===== Testing SQL Query Directly =====");
        try {
            comboDAO.connection = comboDAO.getConnection();
            String sql = "SELECT cp.combo_id, cp.product_id, p.name, cp.quantity_in_combo " +
                         "FROM combo_product cp " +
                         "JOIN product p ON cp.product_id = p.product_id " +
                         "WHERE cp.combo_id = ?";
            
            comboDAO.statement = comboDAO.connection.prepareStatement(sql);
            comboDAO.statement.setInt(1, testComboId);
            comboDAO.resultSet = comboDAO.statement.executeQuery();
            
            boolean hasResults = false;
            while (comboDAO.resultSet.next()) {
                hasResults = true;
                System.out.println("Combo ID: " + comboDAO.resultSet.getInt("combo_id") + 
                                  ", Product ID: " + comboDAO.resultSet.getInt("product_id") + 
                                  ", Product Name: " + comboDAO.resultSet.getString("name") + 
                                  ", Quantity: " + comboDAO.resultSet.getInt("quantity_in_combo"));
            }
            
            if (!hasResults) {
                System.out.println("No results found with direct SQL query. Check your combo_product table.");
            }
        } catch (SQLException ex) {
            System.out.println("Error in direct SQL test: " + ex.getMessage());
        } finally {
            comboDAO.closeResources();
        }
    }
}
