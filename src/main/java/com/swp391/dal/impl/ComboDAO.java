package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Combo;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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
        String sql = "UPDATE combo SET name = ?, description = ?, original_price = ?, " +
                "discount_price = ?, status = ? WHERE combo_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, combo.getName());
            statement.setString(2, combo.getDescription());
            statement.setFloat(3, combo.getOriginalPrice());
            statement.setFloat(4, combo.getDiscountPrice());
            statement.setString(5, combo.getStatus());
            statement.setInt(6, combo.getComboId());

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
        String sql = "INSERT INTO combo (name, description, original_price, discount_price, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, combo.getName());
            statement.setString(2, combo.getDescription());
            statement.setFloat(3, combo.getOriginalPrice());
            statement.setFloat(4, combo.getDiscountPrice());
            statement.setString(5, combo.getStatus());

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
}