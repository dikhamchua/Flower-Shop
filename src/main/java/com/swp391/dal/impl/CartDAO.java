package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Cart;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {
    private Connection connection = null;
    private PreparedStatement statement = null;
    private ResultSet resultSet = null;


    /**
     * Lấy tất cả giỏ hàng
     * @return Danh sách giỏ hàng
     */
    public List<Cart> findAll() {
        List<Cart> carts = new ArrayList<>();
        String sql = "SELECT * FROM carts";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Cart cart = new Cart();
                cart.setCartId(resultSet.getInt("cart_id"));
                cart.setUserId(resultSet.getInt("user_id"));
                cart.setCreatedAt(resultSet.getTimestamp("created_at"));
                cart.setUpdatedAt(resultSet.getTimestamp("updated_at"));
                
                carts.add(cart);
            }
        } catch (SQLException e) {
            System.out.println("Error when finding all carts: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return carts;
    }

    /**
     * Tìm giỏ hàng theo ID
     * @param cartId ID của giỏ hàng
     * @return Giỏ hàng nếu tìm thấy, null nếu không
     */
    public Cart findById(int cartId) {
        String sql = "SELECT * FROM carts WHERE cart_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Cart cart = new Cart();
                cart.setCartId(resultSet.getInt("cart_id"));
                cart.setUserId(resultSet.getInt("user_id"));
                cart.setCreatedAt(resultSet.getTimestamp("created_at"));
                cart.setUpdatedAt(resultSet.getTimestamp("updated_at"));
                
                return cart;
            }
        } catch (SQLException e) {
            System.out.println("Error when finding cart by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return null;
    }

    /**
     * Lấy cart_id từ user_id
     * @param userId ID của người dùng
     * @return cart_id nếu tìm thấy, 0 nếu không tìm thấy
     */
    public int getCartIdByUserId(int userId) {
        String sql = "SELECT cart_id FROM carts WHERE user_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("cart_id");
            } else {
                // Nếu không tìm thấy giỏ hàng, tạo mới
                return createCart(userId);
            }
        } catch (SQLException e) {
            System.out.println("Error when getting cart ID by user ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return 0;
    }

    /**
     * Tạo giỏ hàng mới cho người dùng
     * @param userId ID của người dùng
     * @return cart_id của giỏ hàng mới tạo, 0 nếu có lỗi
     */
    public int createCart(int userId) {
        String sql = "INSERT INTO carts (user_id, created_at, updated_at) VALUES (?, NOW(), NOW())";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, userId);
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = statement.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error when creating cart: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return 0;
    }

    /**
     * Kiểm tra xem người dùng có giỏ hàng hay không
     * @param userId ID của người dùng
     * @return true nếu người dùng có giỏ hàng, false nếu không
     */
    public boolean hasCart(int userId) {
        String sql = "SELECT COUNT(*) FROM carts WHERE user_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error when checking if user has cart: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return false;
    }

    /**
     * Xóa giỏ hàng của người dùng
     * @param userId ID của người dùng
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteCartByUserId(int userId) {
        String sql = "DELETE FROM carts WHERE user_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error when deleting cart by user ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return false;
    }

    /**
     * Lấy số lượng sản phẩm trong giỏ hàng của người dùng
     * @param userId ID của người dùng
     * @return Số lượng sản phẩm trong giỏ hàng
     */
    public int getCartItemCount(int userId) {
        try {
            // Lấy cart_id từ user_id
            int cartId = getCartIdByUserId(userId);
            if (cartId == 0) {
                return 0;
            }
            
            connection = getConnection();
            String sql = "SELECT COUNT(*) FROM cart_items WHERE cart_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart item count: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return 0;
    }
}
