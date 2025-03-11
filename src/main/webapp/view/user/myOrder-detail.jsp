<%-- 
    Document   : myOrder-detail
    Created on : Mar 10, 2025, 12:03:33 PM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Order Details</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <style>
            .product-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
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
                <h6 class="fw-semibold mb-0">Order Details #${order.orderId}</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/home" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Home
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/orderControll" class="hover-text-primary">My Orders</a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Order Details</li>
                </ul>
            </div>

            <div class="row g-24">
                <!-- Order Information -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Order Information</h6>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <strong>Order ID:</strong> #${order.orderId}
                            </div>
                            <div class="mb-3">
                                <strong>Order Date:</strong> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                            <div class="mb-3">
                                <strong>Payment Method:</strong> ${order.paymentMethod}
                            </div>
                            <div class="mb-3">
                                <strong>Status:</strong>
                                <span class="badge ${order.status == 'pending' ? 'bg-warning' : 
                                                    order.status == 'accepted' ? 'bg-info' : 
                                                    order.status == 'completed' ? 'bg-success' : 'bg-danger'}">
                                    ${order.status}
                                </span>
                            </div>
                            <div class="mb-3">
                                <strong>Total Amount:</strong> <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Shipping Information -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Shipping Information</h6>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <strong>Name:</strong> ${order.username}
                            </div>
                            <div class="mb-3">
                                <strong>Email:</strong> ${order.email}
                            </div>
                            <div class="mb-3">
                                <strong>Phone:</strong> ${order.phone}
                            </div>
                            <div class="mb-3">
                                <strong>Shipping Address:</strong><br>
                                ${order.shippingAddress}
                            </div>
                            
                            <!-- Cancel Order Button (only for pending orders) -->
                            <c:if test="${order.status == 'pending'}">
                                <div class="mt-4">
                                    <button type="button" class="btn btn-danger" id="cancelOrderBtn">
                                        <i class="fas fa-times-circle me-2"></i>Cancel Order
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Items -->
            <div class="card mt-24">
                <div class="card-header">
                    <h6 class="card-title mb-0">Order Items</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Image</th>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.orderItems}">
                                    <tr>
                                        <td>
                                            <img src="${item.productImage}" alt="${item.productName}" class="product-image">
                                        </td>
                                        <td>${item.productName}</td>
                                        <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
                                        <td>${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
                                    </tr>
                                </c:forEach>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                    <td><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="mt-4 d-flex justify-content-end">
                <a href="${pageContext.request.contextPath}/orderControll" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to My Orders
                </a>
            </div>
        </div>

        <!-- Toast Container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="orderToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header" id="toast-header">
                    <strong class="me-auto" id="toast-title">Thông báo</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toast-body"></div>
            </div>
            
            <!-- Confirmation Toast -->
            <div id="confirmToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
                <div class="toast-header bg-warning text-white">
                    <strong class="me-auto">Confirmation</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    <p>Are you sure you want to cancel this order?</p>
                    <div class="mt-2 d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="toast">No</button>
                        <form id="cancelOrderForm" action="${pageContext.request.contextPath}/orderControll" method="post">
                            <input type="hidden" name="action" value="cancelOrder">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <button type="submit" class="btn btn-sm btn-danger">Yes, Cancel Order</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>

        <script>
            // Function to show toast
            function showToast(message, type) {
                const toastEl = document.getElementById('orderToast');
                const toastTitle = document.getElementById('toast-title');
                const toastBody = document.getElementById('toast-body');
                const header = document.getElementById('toast-header');
                
                // Set content
                toastTitle.textContent = type === 'success' ? 'Success' : type === 'error' ? 'Error' : 'Notification';
                toastBody.textContent = message;
                
                // Set header color
                header.className = 'toast-header';
                if(type === 'success') {
                    header.classList.add('bg-success', 'text-white');
                } else if(type === 'error') {
                    header.classList.add('bg-danger', 'text-white');
                } else {
                    header.classList.add('bg-info', 'text-white');
                }
                
                // Show toast
                const toast = new bootstrap.Toast(toastEl);
                toast.show();
                
                return toast;
            }
            
            // Handle cancel order button
            document.addEventListener('DOMContentLoaded', function() {
                const cancelBtn = document.getElementById('cancelOrderBtn');
                if (cancelBtn) {
                    cancelBtn.addEventListener('click', function() {
                        // Show confirmation toast
                        const confirmToast = new bootstrap.Toast(document.getElementById('confirmToast'));
                        confirmToast.show();
                    });
                }
                
                // Check for messages in session
                <c:if test="${not empty sessionScope.successMessage}">
                    showToast("${sessionScope.successMessage}", "success");
                    // Remove message from session
                    <% session.removeAttribute("successMessage"); %>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    showToast("${sessionScope.errorMessage}", "error");
                    // Remove message from session
                    <% session.removeAttribute("errorMessage"); %>
                </c:if>
            });
        </script>
    </body>
</html>
