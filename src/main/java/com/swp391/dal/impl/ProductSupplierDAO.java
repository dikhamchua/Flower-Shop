/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Supplier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
public class ProductSupplierDAO extends DBContext {
    
    /**
     * Thêm mối quan hệ giữa sản phẩm và nhà cung cấp
     * @param productId ID của sản phẩm
     * @param supplierId ID của nhà cung cấp
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean addProductSupplier(int productId, int supplierId) {
        String sql = "INSERT INTO product_suppliers (product_id, supplier_id) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, supplierId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding product-supplier relation: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Xóa tất cả mối quan hệ của một sản phẩm với các nhà cung cấp
     * @param productId ID của sản phẩm
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean removeProductSuppliers(int productId) {
        String sql = "DELETE FROM product_suppliers WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            return stmt.executeUpdate() >= 0; // Trả về true ngay cả khi không có bản ghi nào bị xóa
        } catch (SQLException e) {
            System.out.println("Error removing product-supplier relations: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Lấy danh sách ID của các nhà cung cấp cho một sản phẩm
     * @param productId ID của sản phẩm
     * @return Danh sách ID của các nhà cung cấp
     */
    public List<Integer> getSupplierIdsByProductId(int productId) {
        List<Integer> supplierIds = new ArrayList<>();
        String sql = "SELECT supplier_id FROM product_suppliers WHERE product_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                supplierIds.add(resultSet.getInt("supplier_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error when getting supplier IDs by product ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return supplierIds;
    }
    
    /**
     * Lấy danh sách nhà cung cấp cho một sản phẩm
     * @param productId ID của sản phẩm
     * @return Danh sách các nhà cung cấp
     */
    public List<Supplier> getSuppliersByProductId(int productId) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT s.* FROM suppliers s " +
                     "JOIN product_suppliers ps ON s.supplier_id = ps.supplier_id " +
                     "WHERE ps.product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Supplier supplier = new Supplier();
                    supplier.setSupplierId(rs.getInt("supplier_id"));
                    supplier.setName(rs.getString("name"));
                    supplier.setEmail(rs.getString("email"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setAddress(rs.getString("address"));
                    suppliers.add(supplier);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting suppliers: " + e.getMessage());
        }
        return suppliers;
    }
    
    /**
     * Kiểm tra xem một sản phẩm có được cung cấp bởi một nhà cung cấp hay không
     * @param productId ID của sản phẩm
     * @param supplierId ID của nhà cung cấp
     * @return true nếu có mối quan hệ, false nếu không
     */
    public boolean isProductSuppliedBy(int productId, int supplierId) {
        String sql = "SELECT COUNT(*) FROM product_suppliers WHERE product_id = ? AND supplier_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, supplierId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking product-supplier relation: " + e.getMessage());
        }
        return false;
    }
}
