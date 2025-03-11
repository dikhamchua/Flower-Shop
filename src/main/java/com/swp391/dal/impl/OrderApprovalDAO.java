package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.OrderApproval;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderApprovalDAO extends DBContext {

    // Thêm approval mới (sử dụng connection được truyền vào để hỗ trợ transaction)
    public boolean addOrderApproval(int orderId, int adminId, String statusBefore, String statusAfter, String note) throws SQLException {
        String sql = "INSERT INTO order_approvals (order_id, approved_by, approved_at, status_before, status_after, note) "
                + "VALUES (?, ?, NOW(), ?, ?, ?)";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            statement.setInt(2, adminId);
            statement.setString(3, statusBefore);
            statement.setString(4, statusAfter);
            statement.setString(5, note);

            return statement.executeUpdate() > 0;
        } finally {
            closeResources();
        }
    }

    // Lấy lịch sử approval của một đơn hàng
    public List<OrderApproval> getOrderApprovalsByOrderId(int orderId) throws SQLException {
        List<OrderApproval> approvals = new ArrayList<>();

        String sql = "SELECT oa.*, a.username as admin_username "
                + "FROM order_approvals oa "
                + "JOIN account a ON oa.approved_by = a.user_id "
                + "WHERE oa.order_id = ? "
                + "ORDER BY oa.approved_at DESC";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                OrderApproval approval = new OrderApproval();
                approval.setApprovalId(resultSet.getInt("approval_id"));
                approval.setOrderId(resultSet.getInt("order_id"));
                approval.setApprovedBy(resultSet.getInt("approved_by"));
                approval.setApprovedAt(resultSet.getTimestamp("approved_at"));
                approval.setStatusBefore(resultSet.getString("status_before"));
                approval.setStatusAfter(resultSet.getString("status_after"));
                approval.setNote(resultSet.getString("note"));
                approval.setAdminUsername(resultSet.getString("admin_username"));

                approvals.add(approval);
            }
        } finally {
            closeResources();
        }

        return approvals;
    }
}
