package com.swp391.dal.impl;

import com.swp391.entity.Category;
import com.swp391.entity.CategoryProduct;
import com.swp391.entity.Product;
import com.swp391.dal.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryProductDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public List<CategoryProduct> getAllCategoryProducts() {
        List<CategoryProduct> list = new ArrayList<>();
        String query = "SELECT * FROM category_product";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CategoryProduct(
                        rs.getInt("category_product_id"),
                        rs.getInt("category_id"),
                        rs.getInt("product_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Category> getCategoriesByProductId(int productId) {
        List<Category> list = new ArrayList<>();
        String query = "SELECT c.* FROM categories c " +
                "JOIN category_product cp ON c.category_id = cp.category_id " +
                "WHERE cp.product_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, productId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(Category.builder()
                        .categoryId(rs.getInt("category_id"))
                        .name(rs.getString("name"))
                        .description(rs.getString("description"))
                        .status(rs.getByte("status"))
                        .createdAt(rs.getDate("created_at"))
                        .updatedAt(rs.getDate("updated_at"))
                        .build());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Product> getProductsByCategoryId(int categoryId) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.* FROM products p " +
                "JOIN category_product cp ON p.product_id = cp.product_id " +
                "WHERE cp.category_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product product = Product.builder()
                        .productId(rs.getInt("product_id"))
                        .productName(rs.getString("name"))
                        .description(rs.getString("description"))
                        .price(rs.getBigDecimal("price"))
                        .stock(rs.getInt("stock"))
                        .image(rs.getString("image"))
                        .status(rs.getByte("status"))
                        .createdAt(rs.getTimestamp("created_at"))
                        .updatedAt(rs.getTimestamp("updated_at"))
                        .build();
                list.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public void addCategoryToProduct(int categoryId, int productId) {
        String query = "INSERT INTO category_product (category_id, product_id) VALUES (?, ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, categoryId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public void removeCategoryFromProduct(int categoryId, int productId) {
        String query = "DELETE FROM category_product WHERE category_id = ? AND product_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, categoryId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public void removeAllCategoriesFromProduct(int productId) {
        String query = "DELETE FROM category_product WHERE product_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 