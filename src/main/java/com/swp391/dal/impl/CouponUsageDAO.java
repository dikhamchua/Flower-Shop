/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.CouponUsage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CouponUsageDAO extends DBContext {

    public List<CouponUsage> getAllCouponUsages() {
        List<CouponUsage> usages = new ArrayList<>();
        String sql = "SELECT cu.*, a.username, c.code FROM coupon_usage cu "
                + "JOIN account a ON cu.user_id = a.user_id "
                + "JOIN coupons c ON cu.coupon_id = c.coupon_id "
                + "ORDER BY cu.used_at DESC";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CouponUsage usage = mapResultSetToCouponUsage(rs);
                usage.setUserName(rs.getString("username"));
                usage.setCouponCode(rs.getString("code"));
                usages.add(usage);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usages;
    }

    public List<CouponUsage> getCouponUsagesByCouponId(int couponId) {
        List<CouponUsage> usages = new ArrayList<>();
        String sql = "SELECT cu.*, a.username, c.code FROM coupon_usage cu "
                + "JOIN account a ON cu.user_id = a.user_id "
                + "JOIN coupons c ON cu.coupon_id = c.coupon_id "
                + "WHERE cu.coupon_id = ? "
                + "ORDER BY cu.used_at DESC";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CouponUsage usage = mapResultSetToCouponUsage(rs);
                    usage.setUserName(rs.getString("username"));
                    usage.setCouponCode(rs.getString("code"));
                    usages.add(usage);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usages;
    }

    public List<CouponUsage> getCouponUsagesByUserId(int userId) {
        List<CouponUsage> usages = new ArrayList<>();
        String sql = "SELECT cu.*, a.username, c.code FROM coupon_usage cu "
                + "JOIN account a ON cu.user_id = a.user_id "
                + "JOIN coupons c ON cu.coupon_id = c.coupon_id "
                + "WHERE cu.user_id = ? "
                + "ORDER BY cu.used_at DESC";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CouponUsage usage = mapResultSetToCouponUsage(rs);
                    usage.setUserName(rs.getString("username"));
                    usage.setCouponCode(rs.getString("code"));
                    usages.add(usage);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usages;
    }

    public boolean hasCouponBeenUsedByUser(int couponId, int userId) {
        String sql = "SELECT COUNT(*) FROM coupon_usage WHERE coupon_id = ? AND user_id = ?";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, couponId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertCouponUsage(CouponUsage usage) {
        String sql = "INSERT INTO coupon_usage (coupon_id, user_id, order_id) VALUES (?, ?, ?)";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, usage.getCouponId());
            ps.setInt(2, usage.getUserId());
            ps.setInt(3, usage.getOrderId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                // Cập nhật số lần sử dụng của coupon
                CouponDAO couponDAO = new CouponDAO();
                couponDAO.updateCouponUsageCount(usage.getCouponId());

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        usage.setUsageId(rs.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteCouponUsage(int usageId) {
        String sql = "DELETE FROM coupon_usage WHERE usage_id = ?";

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private CouponUsage mapResultSetToCouponUsage(ResultSet rs) throws SQLException {
        CouponUsage usage = new CouponUsage();
        usage.setUsageId(rs.getInt("usage_id"));
        usage.setCouponId(rs.getInt("coupon_id"));
        usage.setUserId(rs.getInt("user_id"));
        usage.setOrderId(rs.getInt("order_id"));
        usage.setUsedAt(rs.getTimestamp("used_at"));
        return usage;
    }
}
