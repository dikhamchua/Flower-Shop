package com.swp391.dal.impl;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.swp391.entity.Category;
import com.swp391.dal.I_DAO;
import com.swp391.dal.DBContext;

/**
 *
 * @author ADMIN
 */
public class CategoryDAO extends DBContext implements I_DAO<Category> {

    @Override
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all categories: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ?, status = ? WHERE category_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setByte(3, category.getStatus());
            statement.setInt(4, category.getCategoryId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating category: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Category category) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, category.getCategoryId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting category: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Category category) {
        String sql = "INSERT INTO categories (name, description, status) VALUES (?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setByte(3, category.getStatus());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating category failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating category failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting category: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Category getFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getByte("status"));
        category.setCreatedAt(rs.getDate("created_at"));
        category.setUpdatedAt(rs.getDate("updated_at"));
        return category;
    }

    public Category findById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding category by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Category> findByName(String name) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE name LIKE ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, "%" + name + "%");
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding categories by name: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    public List<Category> findActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE status = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding active categories: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    public List<Category> findCategoriesWithPagination(int page, int pageSize) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_id LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, pageSize);
            statement.setInt(2, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding categories with pagination: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting categories: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public boolean updateStatus(int categoryId, byte status) {
        String sql = "UPDATE categories SET status = ? WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setByte(1, status);
            statement.setInt(2, categoryId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating category status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean isCategoryNameExists(String name) {
        String sql = "SELECT COUNT(*) FROM categories WHERE name = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking category name existence: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean isCategoryNameExists(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM categories WHERE name = ? AND category_id != ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setInt(2, excludeId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking category name existence: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public static void main(String[] args) {
        CategoryDAO categoryDAO = new CategoryDAO();
        
        // Test insert
        Category newCategory = new Category();
        newCategory.setName("Test Category");
        newCategory.setDescription("This is a test category");
        newCategory.setStatus((byte) 1);
        
        int newId = categoryDAO.insert(newCategory);
        
        if (newId > 0) {
            System.out.println("Category inserted successfully! New ID: " + newId);
            
            // Test findById
            Category found = categoryDAO.findById(newId);
            if (found != null) {
                System.out.println("Found category: " + found.getName());
                
                // Test update
                found.setName("Updated Test Category");
                boolean updated = categoryDAO.update(found);
                System.out.println("Category updated: " + updated);
                
                // Test delete
                boolean deleted = categoryDAO.delete(found);
                System.out.println("Category deleted: " + deleted);
            }
        } else {
            System.out.println("Failed to insert category.");
        }
        
        // Test findAll
        List<Category> allCategories = categoryDAO.findAll();
        System.out.println("Total categories: " + allCategories.size());
    }
}
