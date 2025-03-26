package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import com.swp391.entity.CategoryProduct;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.Connection;

public class ProductDAO extends DBContext implements I_DAO<Product> {

    @Override
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";

        try (PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                products.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error when finding all products: " + e.getMessage());
        }

        return products;
    }

    @Override
    public boolean update(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, " 
                + "price = ?, stock = ?, image = ?, status = ?, updated_at = ? "
                + "WHERE product_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, product.getProductName());
            statement.setString(2, product.getDescription());
            statement.setBigDecimal(3, product.getPrice());
            statement.setInt(4, product.getStock());
            statement.setString(5, product.getImage());
            statement.setByte(6, product.getStatus());
            statement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(8, product.getProductId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error when updating product: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean delete(Product product) {
        String sql = "DELETE FROM products WHERE product_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, product.getProductId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error when deleting product: " + e.getMessage());
            return false;
        }
    }

    @Override
    public int insert(Product product) {
        String sql = "INSERT INTO products (name, description, price, stock, " 
                + "image, status, created_at, updated_at) " 
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            System.out.println("Inserting product: " + product.getProductName());

            statement.setString(1, product.getProductName());
            statement.setString(2, product.getDescription());
            statement.setBigDecimal(3, product.getPrice());
            statement.setInt(4, product.getStock());
            statement.setString(5, product.getImage());
            statement.setByte(6, product.getStatus());
            statement.setTimestamp(7, product.getCreatedAt());
            statement.setTimestamp(8, product.getUpdatedAt());

            int affectedRows = statement.executeUpdate();
            System.out.println("Affected rows: " + affectedRows);

            if (affectedRows > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int productId = generatedKeys.getInt(1);
                    System.out.println("Generated product ID: " + productId);
                    return productId;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error when inserting product: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public Product getFromResultSet(ResultSet resultSet) throws SQLException {
        Product product = new Product();

        product.setProductId(resultSet.getInt("product_id"));
        product.setProductName(resultSet.getString("name"));
        product.setDescription(resultSet.getString("description"));
        product.setPrice(resultSet.getBigDecimal("price"));
        product.setStock(resultSet.getInt("stock"));
        product.setImage(resultSet.getString("image"));
        product.setStatus(resultSet.getByte("status"));

        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt((createdAt));
            ;
        }

        Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (updatedAt != null) {
            product.setUpdatedAt(updatedAt);
        }

        return product;
    }

    public static void main(String[] args) {
        ProductDAO productDAO = new ProductDAO();

        // Test findAll()
        System.out.println("===== Testing findAll() =====");
        List<Product> products = productDAO.findAll();
        System.out.println("Found " + products.size() + " products");
        for (Product p : products) {
            System.out.println(
                    "Product ID: " + p.getProductId() + ", Name: " + p.getProductName() + ", Price: " + p.getPrice());
        }

        // Test insert()
        System.out.println("\n===== Testing insert() =====");
        Product newProduct = new Product();
        newProduct.setProductName("Test Product");
        newProduct.setDescription("This is a test product");
        newProduct.setPrice(new BigDecimal("99.99"));
        newProduct.setStock(100);
        newProduct.setImage("test_image.jpg");
        newProduct.setStatus((byte) 1);

        int newProductId = productDAO.insert(newProduct);
        if (newProductId > 0) {
            System.out.println("Successfully inserted new product with ID: " + newProductId);
            newProduct.setProductId(newProductId);
        } else {
            System.out.println("Failed to insert new product");
        }

        // Test update()
        if (newProductId > 0) {
            System.out.println("\n===== Testing update() =====");
            newProduct.setProductName("Updated Test Product");
            newProduct.setPrice(new BigDecimal("149.99"));

            boolean updateSuccess = productDAO.update(newProduct);
            if (updateSuccess) {
                System.out.println("Successfully updated product with ID: " + newProductId);
            } else {
                System.out.println("Failed to update product");
            }

            // Verify update
            Product updatedProduct = null;
            List<Product> allProducts = productDAO.findAll();
            for (Product p : allProducts) {
                if (p.getProductId() == newProductId) {
                    updatedProduct = p;
                    break;
                }
            }

            if (updatedProduct != null) {
                System.out.println("Updated product details:");
                System.out.println("Name: " + updatedProduct.getProductName());
                System.out.println("Price: " + updatedProduct.getPrice());
            }

            // Test delete()
            System.out.println("\n===== Testing delete() =====");
            boolean deleteSuccess = productDAO.delete(newProduct);
            if (deleteSuccess) {
                System.out.println("Successfully deleted product with ID: " + newProductId);
            } else {
                System.out.println("Failed to delete product");
            }

            // Verify delete
            boolean productExists = false;
            List<Product> remainingProducts = productDAO.findAll();
            for (Product p : remainingProducts) {
                if (p.getProductId() == newProductId) {
                    productExists = true;
                    break;
                }
            }

            if (!productExists) {
                System.out.println("Product with ID " + newProductId + " no longer exists in the database");
            } else {
                System.out.println("Product with ID " + newProductId + " still exists in the database");
            }
        }
    }

    /**
     * Tìm sản phẩm với các bộ lọc và phân trang
     */
    public List<Product> findProductsWithFilter(String searchFilter, Byte statusByte, Integer categoryId, int page,
            int pageSize) {
        List<Product> products = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT p.* FROM products p JOIN category_product cp ON p.product_id = cp.product_id "
                + "JOIN categories c ON cp.category_id = c.category_id WHERE c.status = 1");
        List<Object> parameters = new ArrayList<>();

        // Thêm điều kiện tìm kiếm theo tên sản phẩm
        if (searchFilter != null && !searchFilter.isEmpty()) {
            sqlBuilder.append(" AND p.name LIKE ?");
            parameters.add("%" + searchFilter + "%");
        }

        // Thêm điều kiện lọc theo trạng thái
        if (statusByte != null) {
            sqlBuilder.append(" AND p.status = ?");
            parameters.add(statusByte);
        }

        // Thêm điều kiện lọc theo danh mục
        if (categoryId != null) {
            sqlBuilder.append(" AND cp.category_id = ?");
            parameters.add(categoryId);
        }

        // Thêm phân trang
        sqlBuilder.append(" ORDER BY p.product_id DESC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        try (PreparedStatement statement = connection.prepareStatement(sqlBuilder.toString())) {
            // Thiết lập các tham số
            for (int i = 0; i < parameters.size(); i++) {
                Object param = parameters.get(i);
                if (param instanceof String) {
                    statement.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    statement.setInt(i + 1, (Integer) param);
                } else if (param instanceof Byte) {
                    statement.setByte(i + 1, (Byte) param);
                }
            }

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                products.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error when finding products with filter: " + e.getMessage());
        }

        return products;
    }

    /**
     * Đếm tổng số sản phẩm theo bộ lọc
     */
    public int countProductsWithFilter(String searchFilter, Byte statusByte, Integer categoryId) {
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT COUNT(*) FROM products p JOIN category_product cp ON p.product_id = cp.product_id "
                + "JOIN categories c ON cp.category_id = c.category_id WHERE c.status = 1");
        List<Object> parameters = new ArrayList<>();

        // Thêm điều kiện tìm kiếm theo tên sản phẩm
        if (searchFilter != null && !searchFilter.isEmpty()) {
            sqlBuilder.append(" AND p.name LIKE ?");
            parameters.add("%" + searchFilter + "%");
        }

        // Thêm điều kiện lọc theo trạng thái
        if (statusByte != null) {
            sqlBuilder.append(" AND p.status = ?");
            parameters.add(statusByte);
        }

        // Thêm điều kiện lọc theo danh mục
        if (categoryId != null) {
            sqlBuilder.append(" AND cp.category_id = ?");
            parameters.add(categoryId);
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlBuilder.toString())) {
            // Thiết lập các tham số
            for (int i = 0; i < parameters.size(); i++) {
                Object param = parameters.get(i);
                if (param instanceof String) {
                    statement.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    statement.setInt(i + 1, (Integer) param);
                } else if (param instanceof Byte) {
                    statement.setByte(i + 1, (Byte) param);
                }
            }

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error when counting products with filter: " + e.getMessage());
        }

        return 0;
    }

    /**
     * Tìm sản phẩm với phân trang
     */
    public List<Product> findProductsWithPagination(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.* FROM products p " +
                     "JOIN category_product cp ON p.product_id = cp.product_id " +
                     "JOIN categories c ON cp.category_id = c.category_id " +
                     "WHERE c.status = 1 ORDER BY p.product_id DESC LIMIT ? OFFSET ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, pageSize);
            statement.setInt(2, (page - 1) * pageSize);

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                products.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error when finding products with pagination: " + e.getMessage());
        }

        return products;
    }

    /**
     * Đếm tổng số sản phẩm
     */
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products p " +
                     "JOIN category_product cp ON p.product_id = cp.product_id " +
                     "JOIN categories c ON cp.category_id = c.category_id " +
                     "WHERE c.status = 1";

        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error when getting total products: " + e.getMessage());
        }

        return 0;
    }

    /**
     * Tìm sản phẩm theo ID
     */
    public Product findById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return getFromResultSet(resultSet);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error when finding product by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
    public boolean updateStatus(int productId, byte status) {
        String sql = "UPDATE products SET status = ?, updated_at = ? WHERE product_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setByte(1, status);
            statement.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            statement.setInt(3, productId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error when updating product status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public double getMinPrice() {
        double minPrice = 0;
        try {
            connection = getConnection();
            String sql = "SELECT MIN(price) FROM products WHERE status = 1";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                minPrice = resultSet.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return minPrice;
    }

    public double getMaxPrice() {
        double maxPrice = 0;
        try {
            connection = getConnection();
            String sql = "SELECT MAX(price) FROM products WHERE status = 1";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                maxPrice = resultSet.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return maxPrice;
    }
    /**
     * Tìm kiếm sản phẩm với các bộ lọc
     * 
     * @param searchKeyword       Từ khóa tìm kiếm
     * @param selectedCategoryIds Danh sách ID danh mục được chọn
     * @param minPrice            Giá tối thiểu
     * @param maxPrice            Giá tối đa
     * @param sortParam           Tham số sắp xếp
     * @param currentPage         Trang hiện tại
     * @param pageSize            Số sản phẩm trên mỗi trang
     * @return Danh sách sản phẩm thỏa mãn điều kiện
     */
    public List<Product> findProductsWithFilters(
            String searchKeyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
            String sortType, int page, int pageSize) {
        
        List<Product> products = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder();
        
        // Base query with JOIN to handle category filtering
        sqlBuilder.append("SELECT DISTINCT p.* FROM products p ");
        
        // Only add the JOIN if we have category filters
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sqlBuilder.append("JOIN category_product cp ON p.product_id = cp.product_id ");
        }
        
        sqlBuilder.append("WHERE p.status = 1 ");
        
        // Add search condition
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sqlBuilder.append("AND p.name LIKE ? ");
        }
        
        // Add category filter
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sqlBuilder.append("AND cp.category_id IN (");
            for (int i = 0; i < categoryIds.size(); i++) {
                if (i > 0) {
                    sqlBuilder.append(",");
                }
                sqlBuilder.append("?");
            }
            sqlBuilder.append(") ");
        }
        
        // Add price range filter
        if (minPrice != null) {
            sqlBuilder.append("AND p.price >= ? ");
        }
        if (maxPrice != null) {
            sqlBuilder.append("AND p.price <= ? ");
        }
        
        // Add sorting
        if (sortType != null) {
            switch (sortType) {
                case "name_asc":
                    sqlBuilder.append("ORDER BY p.name ASC ");
                    break;
                case "name_desc":
                    sqlBuilder.append("ORDER BY p.name DESC ");
                    break;
                case "price_asc":
                    sqlBuilder.append("ORDER BY p.price ASC ");
                    break;
                case "price_desc":
                    sqlBuilder.append("ORDER BY p.price DESC ");
                    break;
                default:
                    sqlBuilder.append("ORDER BY p.product_id DESC ");
                    break;
            }
        } else {
            sqlBuilder.append("ORDER BY p.product_id DESC ");
        }
        
        // Add pagination
        sqlBuilder.append("LIMIT ? OFFSET ?");
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());
            
            int paramIndex = 1;
            
            // Set search parameter
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                statement.setString(paramIndex++, "%" + searchKeyword + "%");
            }
            
            // Set category parameters
            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (Integer categoryId : categoryIds) {
                    statement.setInt(paramIndex++, categoryId);
                }
            }
            
            // Set price parameters
            if (minPrice != null) {
                statement.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                statement.setDouble(paramIndex++, maxPrice);
            }
            
            // Set pagination parameters
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            
            resultSet = statement.executeQuery();
            
            // Process results
            while (resultSet.next()) {
                Product product = getFromResultSet(resultSet);
                
                // Load categories for this product
                CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                List<Category> categories = categoryProductDAO.getCategoriesByProductId(product.getProductId());
                product.setCategories(categories);
                
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error finding products with filters: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return products;
    }

    /**
     * Đếm số lượng sản phẩm thỏa mãn điều kiện lọc
     * 
     * @param searchKeyword       Từ khóa tìm kiếm
     * @param selectedCategoryIds Danh sách ID danh mục được chọn
     * @param minPrice            Giá tối thiểu
     * @param maxPrice            Giá tối đa
     * @return Số lượng sản phẩm
     */
    public int countProductsWithFilters(String searchKeyword, List<Integer> categoryIds, Double minPrice, Double maxPrice) {
        StringBuilder sqlBuilder = new StringBuilder();
        
        // Base query with JOIN to handle category filtering
        sqlBuilder.append("SELECT COUNT(DISTINCT p.product_id) FROM products p ");
        
        // Only add the JOIN if we have category filters
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sqlBuilder.append("JOIN category_product cp ON p.product_id = cp.product_id ");
        }
        
        sqlBuilder.append("WHERE p.status = 1 ");
        
        // Add search condition
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sqlBuilder.append("AND p.name LIKE ? ");
        }
        
        // Add category filter
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sqlBuilder.append("AND cp.category_id IN (");
            for (int i = 0; i < categoryIds.size(); i++) {
                if (i > 0) {
                    sqlBuilder.append(",");
                }
                sqlBuilder.append("?");
            }
            sqlBuilder.append(") ");
        }
        
        // Add price range filter
        if (minPrice != null) {
            sqlBuilder.append("AND p.price >= ? ");
        }
        if (maxPrice != null) {
            sqlBuilder.append("AND p.price <= ? ");
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());
            
            int paramIndex = 1;
            
            // Set search parameter
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                statement.setString(paramIndex++, "%" + searchKeyword + "%");
            }
            
            // Set category parameters
            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (Integer categoryId : categoryIds) {
                    statement.setInt(paramIndex++, categoryId);
                }
            }
            
            // Set price parameters
            if (minPrice != null) {
                statement.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                statement.setDouble(paramIndex++, maxPrice);
            }
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting products with filters: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return 0;
    }

    /**
     * Tìm kiếm các sản phẩm có đánh giá cao nhất
     * @param limit Số lượng sản phẩm cần lấy
     * @return Danh sách sản phẩm có đánh giá cao
     */
    public List<Product> findTopRatedProducts(int limit) {
        List<Product> products = new ArrayList<>();
        
        try {
            connection = getConnection();
            
            // Thay vì sử dụng bảng feedbacks, chúng ta sẽ lấy các sản phẩm mới nhất
            String sql = "SELECT * FROM products WHERE status = 1 ORDER BY created_at DESC LIMIT ?";
            
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Product product = getFromResultSet(resultSet);
        
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error finding top products: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return products;
    }

    /**
     * Tìm các sản phẩm liên quan (cùng danh mục) với sản phẩm hiện tại
     * @param categoryId ID danh mục
     * @param currentProductId ID sản phẩm hiện tại (để loại trừ)
     * @param limit Số lượng sản phẩm muốn lấy
     * @return Danh sách sản phẩm liên quan
     */
    public List<Product> findRelatedProducts(int categoryId, int currentProductId, int limit) {
        List<Product> relatedProducts = new ArrayList<>();
        
        try {
            String sql = "SELECT DISTINCT p.* FROM products p " +
                         "JOIN category_product cp ON p.product_id = cp.product_id " +
                         "WHERE cp.category_id = ? AND p.product_id != ? AND p.status = 1 " +
                         "ORDER BY RAND() LIMIT ?";
            
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            statement.setInt(2, currentProductId);
            statement.setInt(3, limit);
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStock(rs.getInt("stock"));
                product.setImage(rs.getString("image"));
                product.setStatus(rs.getByte("status"));
                product.setCreatedAt(rs.getTimestamp("created_at"));
                product.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // Lấy danh sách categories cho product
                CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                product.setCategories(categoryProductDAO.getCategoriesByProductId(product.getProductId()));
                
                relatedProducts.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return relatedProducts;
    }

    /**
     * Lấy thông tin sản phẩm theo ID
     * @param productId ID của sản phẩm cần lấy
     * @return Đối tượng Product nếu tìm thấy, null nếu không tìm thấy
     */
    public Product getProductById(int productId) {
        Product product = null;
        
        try {
            connection = getConnection();
            String sql = "SELECT * FROM products WHERE product_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                product = new Product();
                product.setProductId(resultSet.getInt("product_id"));
                product.setProductName(resultSet.getString("name"));
                product.setDescription(resultSet.getString("description"));
                product.setPrice(new java.math.BigDecimal(resultSet.getDouble("price")));
                product.setStock(resultSet.getInt("stock"));
                product.setQuantity(resultSet.getInt("quantity"));
                product.setImage(resultSet.getString("image"));
                product.setStatus(resultSet.getByte("status"));
                product.setCreatedAt(resultSet.getTimestamp("created_at"));
                product.setUpdatedAt(resultSet.getTimestamp("updated_at"));
                
                // Lấy danh sách categories cho product
                CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                product.setCategories(categoryProductDAO.getCategoriesByProductId(product.getProductId()));
            }
        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return product;
    }

    /**
     * Tìm sản phẩm theo tên
     * @param productName Tên sản phẩm cần tìm
     * @return Đối tượng Product nếu tìm thấy, null nếu không tìm thấy
     */
    public Product findByName(String productName) {
        Product product = null;
        
        try {
            String sql = "SELECT * FROM products WHERE name = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, productName);
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                product = new Product();
                product.setProductId(resultSet.getInt("product_id"));
                product.setProductName(resultSet.getString("name"));
                product.setDescription(resultSet.getString("description"));
                product.setPrice(new java.math.BigDecimal(resultSet.getDouble("price")));
                product.setStock(resultSet.getInt("stock"));
                product.setImage(resultSet.getString("image"));
                product.setStatus(resultSet.getByte("status"));
                product.setCreatedAt(resultSet.getTimestamp("created_at"));
                product.setUpdatedAt(resultSet.getTimestamp("updated_at"));
                
                // Lấy danh sách categories cho product
                CategoryProductDAO categoryProductDAO = new CategoryProductDAO();
                product.setCategories(categoryProductDAO.getCategoriesByProductId(product.getProductId()));
            }
        } catch (SQLException e) {
            System.out.println("Error finding product by name: " + e.getMessage());
            e.printStackTrace();
        }
//        } finally {
//            closeResources();
//        }
        
        return product;
    }
}
