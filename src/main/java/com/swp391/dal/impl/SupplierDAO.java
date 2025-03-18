/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Supplier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author FPTSHOP
 */
public class SupplierDAO extends DBContext implements I_DAO<Supplier> {
    
    @Override
    public List<Supplier> findAll() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers";
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                suppliers.add(getFromResultSet(resultSet));
            }
            
            // Đóng resources
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when finding all suppliers: " + e.getMessage());
        }
        
        return suppliers;
    }
    
    @Override
    public boolean update(Supplier supplier) {
        String sql = "UPDATE suppliers SET name = ?, email = ?, phone = ?, address = ?, description = ?, status = ?, updated_at = ? WHERE supplier_id = ?";
        boolean success = false;
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, supplier.getName());
            statement.setString(2, supplier.getEmail());
            statement.setString(3, supplier.getPhone());
            statement.setString(4, supplier.getAddress());
            statement.setString(5, supplier.getDescription());
            statement.setInt(6, supplier.getStatus());
            statement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(8, supplier.getSupplierId());
            
            success = statement.executeUpdate() > 0;
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when updating supplier: " + e.getMessage());
        }
        
        return success;
    }
    
    @Override
    public boolean delete(Supplier supplier) {
        String sql = "DELETE FROM suppliers WHERE supplier_id = ?";
        boolean success = false;
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, supplier.getSupplierId());
            
            success = statement.executeUpdate() > 0;
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when deleting supplier: " + e.getMessage());
        }
        
        return success;
    }
    
    @Override
    public int insert(Supplier supplier) {
        String sql = "INSERT INTO suppliers (name, email, phone, address, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int newId = 0;
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            
            statement.setString(1, supplier.getName());
            statement.setString(2, supplier.getEmail());
            statement.setString(3, supplier.getPhone());
            statement.setString(4, supplier.getAddress());
            statement.setString(5, supplier.getDescription());
            statement.setInt(6, supplier.getStatus());
            statement.setTimestamp(7, now);
            statement.setTimestamp(8, now);
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    newId = generatedKeys.getInt(1);
                    supplier.setSupplierId(newId);
                }
                generatedKeys.close();
            }
            
            statement.close();
        } catch (SQLException e) {
            System.out.println("SQL Error when inserting supplier: " + e.getMessage());
            e.printStackTrace();
        }
        
        return newId;
    }
    
    @Override
    public Supplier getFromResultSet(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setName(rs.getString("name"));
        supplier.setEmail(rs.getString("email"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setAddress(rs.getString("address"));
        supplier.setDescription(rs.getString("description"));
        supplier.setStatus(rs.getInt("status"));
        supplier.setCreatedAt(rs.getTimestamp("created_at"));
        supplier.setUpdatedAt(rs.getTimestamp("updated_at"));
        return supplier;
    }
    
    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT * FROM suppliers WHERE supplier_id = ?";
        Supplier supplier = null;
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);
            
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                supplier = getFromResultSet(rs);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when getting supplier by ID: " + e.getMessage());
        }
        
        return supplier;
    }
    
    public List<Supplier> getSuppliersByPage(int page, int pageSize, String search, String status) {
        List<Supplier> suppliers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM suppliers WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Add search filter
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(Integer.parseInt(status));
        }
        
        // Add pagination
        sql.append(" ORDER BY supplier_id DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                suppliers.add(getFromResultSet(rs));
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when getting suppliers by page: " + e.getMessage());
        }
        
        return suppliers;
    }
    
    public int getTotalSuppliers(String search, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM suppliers WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Add search filter
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(Integer.parseInt(status));
        }
        
        int count = 0;
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when getting total suppliers: " + e.getMessage());
        }
        
        return count;
    }
    
    public boolean changeSupplierStatus(int supplierId, int status) {
        String sql = "UPDATE suppliers SET status = ?, updated_at = ? WHERE supplier_id = ?";
        boolean success = false;
        
        try {
            connection = getConnection(); // Đảm bảo kết nối được mở
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, status);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(3, supplierId);
            
            success = statement.executeUpdate() > 0;
            statement.close();
        } catch (SQLException e) {
            System.out.println("Error when updating supplier status: " + e.getMessage());
        }
        
        return success;
    }
    
    public static void main(String[] args) {
        SupplierDAO supplierDAO = new SupplierDAO();
        
        // Test findAll()
        System.out.println("===== Testing findAll() =====");
        List<Supplier> suppliers = supplierDAO.findAll();
        System.out.println("Found " + suppliers.size() + " suppliers");
        for (Supplier s : suppliers) {
            System.out.println("Supplier ID: " + s.getSupplierId() + ", Name: " + s.getName() + ", Email: " + s.getEmail());
        }
        
        // Test insert()
        System.out.println("\n===== Testing insert() =====");
        Supplier newSupplier = new Supplier();
        newSupplier.setName("Test Supplier");
        newSupplier.setEmail("test@example.com");
        newSupplier.setPhone("0123456789");
        newSupplier.setAddress("Test Address");
        newSupplier.setDescription("This is a test supplier");
        newSupplier.setStatus(1);
        
        int newSupplierId = supplierDAO.insert(newSupplier);
        if (newSupplierId > 0) {
            System.out.println("Successfully inserted new supplier with ID: " + newSupplierId);
            newSupplier.setSupplierId(newSupplierId);
        } else {
            System.out.println("Failed to insert new supplier");
        }
        
        // Test update()
        if (newSupplierId > 0) {
            System.out.println("\n===== Testing update() =====");
            newSupplier.setName("Updated Test Supplier");
            newSupplier.setEmail("updated@example.com");
            
            boolean updateSuccess = supplierDAO.update(newSupplier);
            if (updateSuccess) {
                System.out.println("Successfully updated supplier with ID: " + newSupplierId);
            } else {
                System.out.println("Failed to update supplier");
            }
            
            // Verify update
            Supplier updatedSupplier = supplierDAO.getSupplierById(newSupplierId);
            if (updatedSupplier != null) {
                System.out.println("Updated supplier details:");
                System.out.println("Name: " + updatedSupplier.getName());
                System.out.println("Email: " + updatedSupplier.getEmail());
            }
            
            // Test delete()
            System.out.println("\n===== Testing delete() =====");
            boolean deleteSuccess = supplierDAO.delete(newSupplier);
            if (deleteSuccess) {
                System.out.println("Successfully deleted supplier with ID: " + newSupplierId);
            } else {
                System.out.println("Failed to delete supplier");
            }
            
            // Verify delete
            Supplier deletedSupplier = supplierDAO.getSupplierById(newSupplierId);
            if (deletedSupplier == null) {
                System.out.println("Supplier with ID " + newSupplierId + " no longer exists in the database");
            } else {
                System.out.println("Supplier with ID " + newSupplierId + " still exists in the database");
            }
        }
    }
}
