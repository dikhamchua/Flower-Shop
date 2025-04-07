package com.swp391.dal.impl;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
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
        String sql = "UPDATE categories SET name = ?, description = ?, status = ?, is_parent = ?, " +
                     "parent_id = ?, updated_at = ? WHERE category_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setByte(3, category.getStatus());
            statement.setBoolean(4, category.getIsParent());
            
            // Handle parent_id based on isParent flag
            if (category.getIsParent()) {
                statement.setNull(5, java.sql.Types.INTEGER); // Parent categories have no parent
            } else {
                if (category.getParentId() != null) {
                    statement.setInt(5, category.getParentId());
                } else {
                    statement.setNull(5, java.sql.Types.INTEGER); // Child categories must have a parent
                }
            }
            
            // Set updated_at
            statement.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            
            statement.setInt(7, category.getCategoryId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating category: " + ex.getMessage());
            ex.printStackTrace();
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
        String sql = "INSERT INTO categories (name, description, status, is_parent, parent_id) VALUES (?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setByte(3, category.getStatus());
            statement.setBoolean(4, category.getIsParent());
            
            // Xử lý parent_id
            if (category.getIsParent()) {
                // Tạm thời set parent_id là null
                statement.setNull(5, java.sql.Types.INTEGER);
            } else {
                // Set parent_id cho danh mục con
                statement.setInt(5, category.getParentId());
            }

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating category failed, no rows affected.");
            }

            // Lấy ID mới được tạo
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                int newId = resultSet.getInt(1);
                
                // Nếu là danh mục cha, cập nhật parent_id bằng ID mới
                if (category.getIsParent()) {
                    String updateSql = "UPDATE categories SET parent_id = ? WHERE category_id = ?";
                    PreparedStatement updateStatement = connection.prepareStatement(updateSql);
                    updateStatement.setInt(1, newId);
                    updateStatement.setInt(2, newId);
                    updateStatement.executeUpdate();
                    updateStatement.close();
                }
                
                return newId;
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
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        category.setIsParent(rs.getBoolean("is_parent"));
        category.setParentId(rs.getInt("parent_id"));
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

    public List<Category> findAllWithProductCount() {
        List<Category> categories = new ArrayList<>();
        
        try {
            // Chuẩn bị kết nối
            connection = getConnection();
            
            // Tạo câu truy vấn SQL để lấy danh mục và đếm số lượng sản phẩm
            String sql = "SELECT c.category_id, c.name, c.description, c.status, " +
                         "COUNT(p.product_id) as product_count " +
                         "FROM categories c " +
                         "LEFT JOIN products p ON c.category_id = p.category_id " +
                         "WHERE c.status = 1 " +  // Chỉ lấy các danh mục đang hoạt động
                         "GROUP BY c.category_id, c.name, c.description, c.status " +
                         "ORDER BY c.name";
            
            // Tạo statement và thực thi truy vấn
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            // Xử lý kết quả
            while (resultSet.next()) {
                Category category = new Category();
                category.setCategoryId(resultSet.getInt("category_id"));
                category.setName(resultSet.getString("name"));
                category.setDescription(resultSet.getString("description"));
                category.setStatus(resultSet.getByte("status"));
                
                // Thêm số lượng sản phẩm vào đối tượng Category
                // Giả sử bạn đã thêm thuộc tính productCount vào lớp Category
                categories.add(category);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding categories with product count: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return categories;
    }

    /**
     * Lấy số lượng sản phẩm trong một danh mục cụ thể
     * @param categoryId ID của danh mục cần đếm sản phẩm
     * @return Số lượng sản phẩm trong danh mục
     */
    public int getProductCountByCategory(int categoryId) {
        int count = 0;
        
        try {
            // Chuẩn bị kết nối
            connection = getConnection();
            
            // Tạo câu truy vấn SQL để đếm số lượng sản phẩm trong danh mục
            String sql = "SELECT COUNT(*) FROM products WHERE category_id = ? AND status = 1";
            
            // Tạo statement và thiết lập tham số
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            
            // Thực thi truy vấn
            resultSet = statement.executeQuery();
            
            // Lấy kết quả
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting products in category: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return count;
    }

    /**
     * Lấy số lượng sản phẩm cho tất cả các danh mục
     * @return Map với key là category_id và value là số lượng sản phẩm
     */
    public Map<Integer, Integer> getAllCategoryProductCounts() {
        Map<Integer, Integer> countMap = new HashMap<>();
        
        try {
            // Chuẩn bị kết nối
            connection = getConnection();
            
            // Tạo câu truy vấn SQL để đếm số lượng sản phẩm cho mỗi danh mục
            // Chỉ đếm các sản phẩm có status = 1 (đang hoạt động)
            String sql = "SELECT c.category_id, COUNT(DISTINCT p.product_id) as product_count " +
                         "FROM categories c " +
                         "LEFT JOIN category_product cp ON c.category_id = cp.category_id " +
                         "LEFT JOIN products p ON cp.product_id = p.product_id AND p.status = 1 " +
                         "GROUP BY c.category_id";
            
            // Tạo statement và thực thi truy vấn
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            // Xử lý kết quả
            while (resultSet.next()) {
                int categoryId = resultSet.getInt("category_id");
                int count = resultSet.getInt("product_count");
                countMap.put(categoryId, count);
            }
            
            // Debug: In ra số lượng sản phẩm cho mỗi danh mục
            System.out.println("Category product counts:");
            for (Map.Entry<Integer, Integer> entry : countMap.entrySet()) {
                System.out.println("Category ID: " + entry.getKey() + ", Count: " + entry.getValue());
            }
            
        } catch (SQLException ex) {
            System.out.println("Error getting category product counts: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            closeResources();
        }
        
        return countMap;
    }

    /**
     * Lấy tất cả danh mục đang hoạt động
     * @return Danh sách các danh mục
     */
    public List<Category> findAllActive() {
        List<Category> categories = new ArrayList<>();
        
        try {
            // Chuẩn bị kết nối
            connection = getConnection();
            
            // Tạo câu truy vấn SQL để lấy tất cả danh mục đang hoạt động
            String sql = "SELECT * FROM categories WHERE status = 1 ORDER BY name";
            
            // Tạo statement và thực thi truy vấn
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            // Xử lý kết quả
            while (resultSet.next()) {
                Category category = new Category();
                category.setCategoryId(resultSet.getInt("category_id"));
                category.setName(resultSet.getString("name"));
                category.setDescription(resultSet.getString("description"));
                category.setStatus(resultSet.getByte("status"));
                
                categories.add(category);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all active categories: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return categories;
    }

    public List<Category> findAllParentCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE is_parent = 1 AND status = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding parent categories: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }
}
