<%-- 
    Document   : feedback
    Created on : Mar 14, 2025, 11:17:52 PM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Kiểm tra đăng nhập --%>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="/authen?action=login">
        <c:param name="message" value="Vui lòng đăng nhập để gửi đánh giá" />
    </c:redirect>
</c:if>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Select Product to Review</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            .product-image {
                max-width: 80px;
                max-height: 80px;
                object-fit: contain;
                border-radius: 8px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            }
            
            .product-card {
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
                margin-bottom: 20px;
            }
            
            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            }
            
            .badge-already-reviewed {
                background-color: #6c757d;
                color: white;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 0.85rem;
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
                <h6 class="fw-semibold mb-0">Select Product to Review</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/home" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Home
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/orderControll" class="d-flex align-items-center gap-1 hover-text-primary">
                            Orders
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/feedbackControl" class="hover-text-primary">Reviews</a>
                    </li>
                </ul>
            </div>

            <!-- Product List Card -->
            <div class="card mb-24">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0">Choose a Product to Review</h5>
                    <p class="text-muted mb-0">Order #${orderId}</p>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">Product</th>
                                    <th scope="col">Price</th>
                                    <th scope="col">Quantity</th>
                                    <th scope="col">Total</th>
                                    <th scope="col">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderItems}" var="item">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}/uploads/products/${item.productImage}" 
                                                     class="product-image me-3" alt="${item.productName}">
                                                <div>
                                                    <h6 class="mb-0">${item.productName}</h6>
                                                    <small class="text-muted">SKU: ${item.productId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
                                        <td>${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reviewedOrderItems.contains(item.orderItemId)}">
                                                    <span class="badge-already-reviewed">
                                                        <i class="fas fa-check-circle me-1"></i> Already Reviewed
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/feedbackControl?action=write-review&orderItemId=${item.orderItemId}" 
                                                       class="btn btn-sm btn-primary">
                                                        <i class="fas fa-star me-1"></i> Write Review
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-white py-3">
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/orderControll" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i> Back to Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/feedbackControl" class="btn btn-outline-primary">
                            <i class="fas fa-list me-2"></i> My Reviews
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        
        <!-- Toast Container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="orderToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header" id="toast-header">
                    <strong class="me-auto" id="toast-title">Thông báo</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toast-body"></div>
            </div>
        </div>
        
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
            }
            
            // Check for messages in session
            <c:if test="${not empty sessionScope.successMessage}">
                document.addEventListener('DOMContentLoaded', function() {
                    showToast("${sessionScope.successMessage}", "success");
                    // Remove message from session
                    <% session.removeAttribute("successMessage"); %>
                });
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                document.addEventListener('DOMContentLoaded', function() {
                    showToast("${sessionScope.errorMessage}", "error");
                    // Remove message from session
                    <% session.removeAttribute("errorMessage"); %>
                });
            </c:if>
        </script>
    </body>
</html>
