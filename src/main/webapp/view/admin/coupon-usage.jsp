<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Coupon Usage History - Flower Shop</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <style>
            .badge-success {
                background-color: #1cc88a;
                color: white;
            }
            
            .badge-danger {
                background-color: #e74a3b;
                color: white;
            }
            
            .empty-state {
                text-align: center;
                padding: 40px 0;
            }
            
            .empty-state i {
                font-size: 48px;
                color: #d1d3e2;
                margin-bottom: 15px;
                display: block;
            }
            
            .empty-state h5 {
                font-weight: 600;
                margin-bottom: 10px;
            }
            
            .empty-state p {
                color: #858796;
                max-width: 500px;
                margin: 0 auto;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

        <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Coupon Usage History</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/manage-coupon" class="hover-text-primary">
                            Coupon Management
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Usage History</li>
                </ul>
            </div>

            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header d-flex justify-content-between align-items-center bg-white py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-ticket-alt me-1"></i>Coupon Details
                    </h6>
                    <span class="badge ${coupon.active ? 'badge-success' : 'badge-danger'} ms-2">
                        ${coupon.active ? 'Active' : 'Inactive'}
                    </span>
                </div>
                <div class="card-body p-4">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Code:</strong> ${coupon.code}</p>
                            <p><strong>Type:</strong> ${coupon.discountType eq 'percentage' ? 'Percentage' : 'Fixed Amount'}</p>
                            <p><strong>Value:</strong> 
                                <c:choose>
                                    <c:when test="${coupon.discountType eq 'percentage'}">
                                        ${coupon.discountValue}%
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${coupon.discountValue}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Valid Period:</strong> 
                                <fmt:formatDate value="${coupon.startDate}" pattern="dd/MM/yyyy"/> - 
                                <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy"/>
                            </p>
                            <p><strong>Usage:</strong> ${coupon.usageCount}/${coupon.usageLimit > 0 ? coupon.usageLimit : '∞'}</p>
                            <p><strong>Description:</strong> ${coupon.description}</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-history me-1"></i>Usage History
                    </h6>
                </div>
                <div class="card-body p-4">
                    <c:choose>
                        <c:when test="${empty usages}">
                            <div class="empty-state">
                                <i class="fas fa-ticket-alt"></i>
                                <h5>No usage history found</h5>
                                <p>This coupon has not been used by any customer yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>User</th>
                                            <th>Order ID</th>
                                            <th>Used Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${usages}" var="usage">
                                            <tr>
                                                <td>${usage.usageId}</td>
                                                <td>${usage.userName}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/manage-order?action=detail&id=${usage.orderId}" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        #${usage.orderId}
                                                    </a>
                                                </td>
                                                <td><fmt:formatDate value="${usage.usedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin/manage-coupon?action=edit&id=${coupon.couponId}" class="btn btn-primary">
                            <i class="fas fa-edit me-1"></i>Edit Coupon
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/manage-coupon" class="btn btn-secondary ms-2">
                            <i class="fas fa-arrow-left me-1"></i>Back to List
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    </body>
</html> 