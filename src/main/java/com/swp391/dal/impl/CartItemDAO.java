package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.CartItem;
import com.swp391.entity.Product;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAO extends DBContext {

    private Connection connection = null;
    private PreparedStatement statement = null;
    private ResultSet resultSet = null;

    /**
     * Lấy danh sách các mục trong giỏ hàng
     *
     * @param cartId ID của giỏ hàng
     * @return Danh sách các mục trong giỏ hàng
     */
    public List<CartItem> getCartItemsByCartId(int cartId) {
        List<CartItem> cartItems = new ArrayList<>();

        try {
            connection = getConnection();
            String sql = "SELECT ci.*, p.name, p.price, p.image, p.stock "
                    + "FROM cart_items ci "
                    + "JOIN products p ON ci.product_id = p.product_id "
                    + "WHERE ci.cart_id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int cartItemId = resultSet.getInt("cart_item_id");
                int productId = resultSet.getInt("product_id");
                int quantity = resultSet.getInt("quantity");
                String productName = resultSet.getString("name");
                BigDecimal price = resultSet.getBigDecimal("price");
                String image = resultSet.getString("image");
                int stock = resultSet.getInt("stock");

                Product product = new Product();
                product.setProductId(productId);
                product.setProductName(productName);
                product.setPrice(price);
                product.setImage(image);
                product.setStock(stock);

                CartItem item = new CartItem();
                item.setCartItemId(cartItemId);
                item.setCartId(cartId);
                item.setProduct(product);
                item.setQuantity(quantity);

                cartItems.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart items: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return cartItems;
    }

    /**
     * Thêm mục vào giỏ hàng
     * @param cartId ID của giỏ hàng
     * @param productId ID của sản phẩm
     * @param quantity Số lượng sản phẩm
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addCartItem(int cartId, int productId, int quantity) {
        try {
            // Kiểm tra xem giỏ hàng có tồn tại không
            connection = getConnection();
            String checkCartSql = "SELECT cart_id FROM carts WHERE cart_id = ?";
            PreparedStatement checkCartStmt = connection.prepareStatement(checkCartSql);
            checkCartStmt.setInt(1, cartId);
            ResultSet cartRs = checkCartStmt.executeQuery();
            
            if (!cartRs.next()) {
                System.out.println("Cart with ID " + cartId + " does not exist");
                return false;
            }
            
            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            String checkItemSql = "SELECT cart_item_id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
            PreparedStatement checkItemStmt = connection.prepareStatement(checkItemSql);
            checkItemStmt.setInt(1, cartId);
            checkItemStmt.setInt(2, productId);
            ResultSet itemRs = checkItemStmt.executeQuery();
            
            if (itemRs.next()) {
                // Nếu sản phẩm đã có trong giỏ hàng, cập nhật số lượng
                int cartItemId = itemRs.getInt("cart_item_id");
                int currentQuantity = itemRs.getInt("quantity");
                int newQuantity = currentQuantity + quantity;
                
                String updateSql = "UPDATE cart_items SET quantity = ?, updated_at = NOW() WHERE cart_item_id = ?";
                PreparedStatement updateStmt = connection.prepareStatement(updateSql);
                updateStmt.setInt(1, newQuantity);
                updateStmt.setInt(2, cartItemId);
                
                return updateStmt.executeUpdate() > 0;
            } else {
                // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới
                String insertSql = "INSERT INTO cart_items (cart_id, product_id, quantity, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())";
                PreparedStatement insertStmt = connection.prepareStatement(insertSql);
                insertStmt.setInt(1, cartId);
                insertStmt.setInt(2, productId);
                insertStmt.setInt(3, quantity);
                
                return insertStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error adding cart item: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Cập nhật số lượng mục trong giỏ hàng
     *
     * @param cartItemId ID của mục trong giỏ hàng
     * @param quantity Số lượng mới
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        try {
            connection = getConnection();
            String sql = "UPDATE cart_items SET quantity = ?, updated_at = NOW() WHERE cart_item_id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, quantity);
            statement.setInt(2, cartItemId);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating cart item quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Xóa một mục khỏi giỏ hàng
     * @param cartId ID của giỏ hàng
     * @param productId ID của sản phẩm
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteCartItem(int cartId, int productId) {
        try {
            connection = getConnection();
            String sql = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?";
            
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            statement.setInt(2, productId);
            
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting cart item: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Xóa một mục khỏi giỏ hàng theo cart_item_id
     * @param cartItemId ID của mục trong giỏ hàng
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteCartItemById(int cartItemId) {
        try {
            connection = getConnection();
            String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
            
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartItemId);
            
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting cart item by ID: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Xóa tất cả các mục trong giỏ hàng
     *
     * @param cartId ID của giỏ hàng
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteAllCartItems(int cartId) {
        try {
            connection = getConnection();
            String sql = "DELETE FROM cart_items WHERE cart_id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting all cart items: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
     *
     * @param cartId ID của giỏ hàng
     * @param productId ID của sản phẩm
     * @return CartItem nếu tìm thấy, null nếu không tìm thấy
     */
    public CartItem findCartItem(int cartId, int productId) {
        try {
            connection = getConnection();
            String sql = "SELECT ci.*, p.name, p.price, p.image, p.stock "
                    + "FROM cart_items ci "
                    + "JOIN products p ON ci.product_id = p.product_id "
                    + "WHERE ci.cart_id = ? AND ci.product_id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            statement.setInt(2, productId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                int cartItemId = resultSet.getInt("cart_item_id");
                int quantity = resultSet.getInt("quantity");
                String productName = resultSet.getString("name");
                BigDecimal price = resultSet.getBigDecimal("price");
                String image = resultSet.getString("image");
                int stock = resultSet.getInt("stock");

                Product product = new Product();
                product.setProductId(productId);
                product.setProductName(productName);
                product.setPrice(price);
                product.setImage(image);
                product.setStock(stock);

                CartItem item = new CartItem();
                item.setCartItemId(cartItemId);
                item.setCartId(cartId);
                item.setProduct(product);
                item.setQuantity(quantity);

                return item;
            }
        } catch (SQLException e) {
            System.out.println("Error finding cart item: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return null;
    }

    /**
     * Đếm số lượng mục trong giỏ hàng
     *
     * @param cartId ID của giỏ hàng
     * @return Số lượng mục trong giỏ hàng
     */
    public int countCartItems(int cartId) {
        try {
            connection = getConnection();
            String sql = "SELECT COUNT(*) FROM cart_items WHERE cart_id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting cart items: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return 0;
    }
}
