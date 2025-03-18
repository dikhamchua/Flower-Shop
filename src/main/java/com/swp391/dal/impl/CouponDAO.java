/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Coupon;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CouponDAO extends DBContext {

    public List<Coupon> getAllCoupons() {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY created_at DESC";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return coupons;
    }

    public Coupon getCouponById(int couponId) {
        Coupon coupon = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = new DBContext().getConnection();
            String sql = "SELECT * FROM coupons WHERE coupon_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, couponId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                coupon = mapResultSetToCoupon(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Đảm bảo đóng các tài nguyên theo thứ tự ngược lại
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return coupon;
    }

    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ?";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCoupon(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertCoupon(Coupon coupon) {
        String sql = "INSERT INTO coupons (code, description, discount_type, discount_value, "
                + "min_purchase, max_discount, start_date, end_date, usage_limit, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = new DBContext().getConnection();
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getDescription());
            ps.setString(3, coupon.getDiscountType());
            ps.setBigDecimal(4, coupon.getDiscountValue());

            if (coupon.getMinPurchase() != null) {
                ps.setBigDecimal(5, coupon.getMinPurchase());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }

            if (coupon.getMaxDiscount() != null) {
                ps.setBigDecimal(6, coupon.getMaxDiscount());
            } else {
                ps.setNull(6, java.sql.Types.DECIMAL);
            }

            ps.setTimestamp(7, new Timestamp(coupon.getStartDate().getTime()));
            ps.setTimestamp(8, new Timestamp(coupon.getEndDate().getTime()));

            if (coupon.getUsageLimit() != null) {
                ps.setInt(9, coupon.getUsageLimit());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }

            ps.setBoolean(10, coupon.isActive());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    coupon.setCouponId(rs.getInt(1));
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Đảm bảo đóng các tài nguyên theo thứ tự ngược lại
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }

    public boolean updateCoupon(Coupon coupon) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = new DBContext().getConnection();
            String sql = "UPDATE coupons SET code = ?, description = ?, discount_type = ?, " +
                         "discount_value = ?, min_purchase = ?, max_discount = ?, " +
                         "start_date = ?, end_date = ?, usage_limit = ?, " +
                         "is_active = ?, updated_at = ? WHERE coupon_id = ?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getDescription());
            ps.setString(3, coupon.getDiscountType());
            ps.setBigDecimal(4, coupon.getDiscountValue());
            
            // Xử lý các giá trị có thể null
            if (coupon.getMinPurchase() != null) {
                ps.setBigDecimal(5, coupon.getMinPurchase());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscount() != null) {
                ps.setBigDecimal(6, coupon.getMaxDiscount());
            } else {
                ps.setNull(6, java.sql.Types.DECIMAL);
            }
            
            ps.setTimestamp(7, new java.sql.Timestamp(coupon.getStartDate().getTime()));
            ps.setTimestamp(8, new java.sql.Timestamp(coupon.getEndDate().getTime()));
            
            if (coupon.getUsageLimit() != null) {
                ps.setInt(9, coupon.getUsageLimit());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            
            ps.setBoolean(10, coupon.isActive());
            ps.setTimestamp(11, new java.sql.Timestamp(new Date().getTime()));
            ps.setInt(12, coupon.getCouponId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            // Đảm bảo đóng các tài nguyên
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public boolean deleteCoupon(int couponId) {
        String sql = "DELETE FROM coupons WHERE coupon_id = ?";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateCouponUsageCount(int couponId) {
        String sql = "UPDATE coupons SET usage_count = usage_count + 1 WHERE coupon_id = ?";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Coupon> searchCoupons(String keyword) {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "SELECT * FROM coupons WHERE code LIKE ? OR description LIKE ?";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    coupons.add(mapResultSetToCoupon(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return coupons;
    }

    // Kiểm tra tính hợp lệ của coupon
    public boolean isValidCoupon(String code, BigDecimal orderTotal) {
        Coupon coupon = getCouponByCode(code);
        if (coupon == null) {
            return false; // Không tìm thấy coupon
        }

        Date now = new Date();

        // Kiểm tra trạng thái hoạt động
        if (!coupon.isActive()) {
            return false;
        }

        // Kiểm tra thời gian hiệu lực
        if (now.before(coupon.getStartDate()) || now.after(coupon.getEndDate())) {
            return false;
        }

        // Kiểm tra giới hạn sử dụng
        if (coupon.getUsageLimit() != null && coupon.getUsageCount() >= coupon.getUsageLimit()) {
            return false;
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        if (coupon.getMinPurchase() != null && orderTotal.compareTo(coupon.getMinPurchase()) < 0) {
            return false;
        }

        return true;
    }

    // Tính toán giá trị giảm giá
    public BigDecimal calculateDiscount(String code, BigDecimal orderTotal) {
        Coupon coupon = getCouponByCode(code);
        if (coupon == null) {
            return BigDecimal.ZERO;
        }

        BigDecimal discount;
        if ("percentage".equals(coupon.getDiscountType())) {
            // Giảm giá theo phần trăm
            discount = orderTotal.multiply(coupon.getDiscountValue().divide(new BigDecimal(100)));

            // Kiểm tra giới hạn giảm giá tối đa
            if (coupon.getMaxDiscount() != null && discount.compareTo(coupon.getMaxDiscount()) > 0) {
                discount = coupon.getMaxDiscount();
            }
        } else {
            // Giảm giá cố định
            discount = coupon.getDiscountValue();

            // Đảm bảo giảm giá không vượt quá tổng giá trị đơn hàng
            if (discount.compareTo(orderTotal) > 0) {
                discount = orderTotal;
            }
        }

        return discount;
    }

    private Coupon mapResultSetToCoupon(ResultSet rs) throws SQLException {
        Coupon coupon = new Coupon();
        coupon.setCouponId(rs.getInt("coupon_id"));
        coupon.setCode(rs.getString("code"));
        coupon.setDescription(rs.getString("description"));
        coupon.setDiscountType(rs.getString("discount_type"));
        coupon.setDiscountValue(rs.getBigDecimal("discount_value"));
        coupon.setMinPurchase(rs.getBigDecimal("min_purchase"));
        coupon.setMaxDiscount(rs.getBigDecimal("max_discount"));
        coupon.setStartDate(rs.getTimestamp("start_date"));
        coupon.setEndDate(rs.getTimestamp("end_date"));

        Object usageLimitObj = rs.getObject("usage_limit");
        if (usageLimitObj != null) {
            coupon.setUsageLimit(rs.getInt("usage_limit"));
        }

        coupon.setUsageCount(rs.getInt("usage_count"));
        coupon.setActive(rs.getBoolean("is_active"));
        coupon.setCreatedAt(rs.getTimestamp("created_at"));
        coupon.setUpdatedAt(rs.getTimestamp("updated_at"));

        return coupon;
    }

    /**
     * Tìm kiếm coupon với các bộ lọc và phân trang
     */
    public List<Coupon> findCouponsWithFilters(String status, String discountType, int page, int pageSize) {
        List<Coupon> coupons = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        try {
            StringBuilder sql = new StringBuilder("SELECT * FROM coupons WHERE 1=1");
            
            if (status != null && !status.isEmpty()) {
                if ("active".equals(status)) {
                    sql.append(" AND is_active = 1");
                } else if ("inactive".equals(status)) {
                    sql.append(" AND is_active = 0");
                }
            }
            
            if (discountType != null && !discountType.isEmpty()) {
                sql.append(" AND discount_type = ?");
            }
            
            sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (discountType != null && !discountType.isEmpty()) {
                statement.setString(paramIndex++, discountType);
            }
            
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex, offset);
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return coupons;
    }

    /**
     * Tìm kiếm coupon theo từ khóa với các bộ lọc và phân trang
     */
    public List<Coupon> searchCoupons(String search, String status, String discountType, int page, int pageSize) {
        List<Coupon> coupons = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        try {
            StringBuilder sql = new StringBuilder("SELECT * FROM coupons WHERE (code LIKE ? OR description LIKE ?)");
            
            if (status != null && !status.isEmpty()) {
                if ("active".equals(status)) {
                    sql.append(" AND is_active = 1");
                } else if ("inactive".equals(status)) {
                    sql.append(" AND is_active = 0");
                }
            }
            
            if (discountType != null && !discountType.isEmpty()) {
                sql.append(" AND discount_type = ?");
            }
            
            sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            String searchPattern = "%" + search + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            
            int paramIndex = 3;
            if (discountType != null && !discountType.isEmpty()) {
                statement.setString(paramIndex++, discountType);
            }
            
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex, offset);
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                coupons.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return coupons;
    }

    /**
     * Đếm tổng số coupon với các bộ lọc
     */
    public int getTotalFilteredCoupons(String status, String discountType) {
        int count = 0;
        
        try {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM coupons WHERE 1=1");
            
            if (status != null && !status.isEmpty()) {
                if ("active".equals(status)) {
                    sql.append(" AND is_active = 1");
                } else if ("inactive".equals(status)) {
                    sql.append(" AND is_active = 0");
                }
            }
            
            if (discountType != null && !discountType.isEmpty()) {
                sql.append(" AND discount_type = ?");
            }
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (discountType != null && !discountType.isEmpty()) {
                statement.setString(paramIndex, discountType);
            }
            
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }

    /**
     * Đếm tổng số kết quả tìm kiếm với các bộ lọc
     */
    public int getTotalSearchResults(String search, String status, String discountType) {
        int count = 0;
        
        try {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM coupons WHERE (code LIKE ? OR description LIKE ?)");
            
            if (status != null && !status.isEmpty()) {
                if ("active".equals(status)) {
                    sql.append(" AND is_active = 1");
                } else if ("inactive".equals(status)) {
                    sql.append(" AND is_active = 0");
                }
            }
            
            if (discountType != null && !discountType.isEmpty()) {
                sql.append(" AND discount_type = ?");
            }
            
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            
            String searchPattern = "%" + search + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            
            int paramIndex = 3;
            if (discountType != null && !discountType.isEmpty()) {
                statement.setString(paramIndex, discountType);
            }
            
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
}
