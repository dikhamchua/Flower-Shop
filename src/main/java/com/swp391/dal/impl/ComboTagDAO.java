package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.ComboTag;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for handling ComboTag operations
 */
public class ComboTagDAO extends DBContext implements I_DAO<ComboTag> {

    @Override
    public List<ComboTag> findAll() {
        List<ComboTag> comboTags = new ArrayList<>();
        String sql = "SELECT * FROM combo_tag";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboTags.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all combo tags: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboTags;
    }

    @Override
    public boolean update(ComboTag comboTag) {
        String sql = "UPDATE combo_tag SET combo_id = ?, tag_name = ? WHERE id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboTag.getComboId());
            statement.setString(2, comboTag.getTagName());
            statement.setInt(3, comboTag.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating combo tag: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(ComboTag comboTag) {
        String sql = "DELETE FROM combo_tag WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboTag.getId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting combo tag: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(ComboTag comboTag) {
        String sql = "INSERT INTO combo_tag (combo_id, tag_name) VALUES (?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, comboTag.getComboId());
            statement.setString(2, comboTag.getTagName());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating combo tag failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating combo tag failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting combo tag: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public ComboTag getFromResultSet(ResultSet rs) throws SQLException {
        ComboTag comboTag = new ComboTag();
        comboTag.setId(rs.getInt("id"));
        comboTag.setComboId(rs.getInt("combo_id"));
        comboTag.setTagName(rs.getString("tag_name"));
        return comboTag;
    }
    
    /**
     * Find all tags for a specific combo
     * 
     * @param comboId The ID of the combo
     * @return List of ComboTag objects for the specified combo
     */
    public List<ComboTag> findByComboId(Integer comboId) {
        List<ComboTag> comboTags = new ArrayList<>();
        String sql = "SELECT * FROM combo_tag WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboTags.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding combo tags by combo ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboTags;
    }
    
    /**
     * Delete all tags for a specific combo
     * 
     * @param comboId The ID of the combo
     * @return True if successful, false otherwise
     */
    public boolean deleteByComboId(Integer comboId) {
        String sql = "DELETE FROM combo_tag WHERE combo_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, comboId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting combo tags by combo ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Find all combos that have a specific tag
     * 
     * @param tagName The name of the tag
     * @return List of ComboTag objects with the specified tag
     */
    public List<ComboTag> findByTagName(String tagName) {
        List<ComboTag> comboTags = new ArrayList<>();
        String sql = "SELECT * FROM combo_tag WHERE tag_name = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, tagName);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboTags.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding combo tags by tag name: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboTags;
    }
    
    /**
     * Search for combos by tag name pattern
     * 
     * @param tagPattern The pattern to search for in tag names
     * @return List of ComboTag objects matching the pattern
     */
    public List<ComboTag> searchByTagPattern(String tagPattern) {
        List<ComboTag> comboTags = new ArrayList<>();
        String sql = "SELECT * FROM combo_tag WHERE tag_name LIKE ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, "%" + tagPattern + "%");
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                comboTags.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error searching combo tags by pattern: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return comboTags;
    }
}