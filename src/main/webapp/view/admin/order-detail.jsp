<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Details</title>
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
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/manage-order" class="hover-text-primary">Order List</a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Order Details</li>
                </ul>
            </div>

            <div class="row g-24">
                <!-- Order Information -->
                <div class="col-md-4">
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

                <!-- Customer Information -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Customer Information</h6>
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
                        </div>
                    </div>
                </div>

                <!-- Update Status -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Update Status</h6>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/manage-order" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                
                                <div class="mb-3">
                                    <label class="form-label">New Status</label>
                                    <select class="form-select" name="newStatus" required>
                                        <option value="">-- Select Status --</option>
                                        <c:if test="${order.status == 'pending'}">
                                            <option value="accepted">Accept Order</option>
                                            <option value="cancelled">Cancel Order</option>
                                        </c:if>
                                        <c:if test="${order.status == 'accepted'}">
                                            <option value="completed">Complete Order</option>
                                            <option value="cancelled">Cancel Order</option>
                                        </c:if>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Note</label>
                                    <textarea class="form-control" name="note" rows="3" placeholder="Enter note..."></textarea>
                                </div>
                                
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">Update</button>
                                    <a href="${pageContext.request.contextPath}/admin/manage-order" class="btn btn-secondary">Back</a>
                                </div>
                            </form>
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
                                        <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
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

            <!-- Order History -->
            <div class="card mt-24">
                <div class="card-header">
                    <h6 class="card-title mb-0">Order History</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Updated By</th>
                                    <th>Date</th>
                                    <th>Previous Status</th>
                                    <th>New Status</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="approval" items="${approvals}">
                                    <tr>
                                        <td>${approval.adminUsername}</td>
                                        <td><fmt:formatDate value="${approval.approvedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>
                                            <span class="badge ${approval.statusBefore == 'pending' ? 'bg-warning' : 
                                                                approval.statusBefore == 'accepted' ? 'bg-info' : 
                                                                approval.statusBefore == 'completed' ? 'bg-success' : 'bg-danger'}">
                                                ${approval.statusBefore}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${approval.statusAfter == 'pending' ? 'bg-warning' : 
                                                                approval.statusAfter == 'accepted' ? 'bg-info' : 
                                                                approval.statusAfter == 'completed' ? 'bg-success' : 'bg-danger'}">
                                                ${approval.statusAfter}
                                            </span>
                                        </td>
                                        <td>${approval.note}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty approvals}">
                                    <tr>
                                        <td colspan="5" class="text-center">No update history</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
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
                    <p id="confirm-message">Are you sure you want to update this order status?</p>
                    <div class="mt-2 d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="toast">No</button>
                        <button type="button" class="btn btn-sm btn-primary" id="confirm-yes-btn">Yes, Update</button>
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
            
            // Handle form submission with confirmation
            document.addEventListener('DOMContentLoaded', function() {
                const orderForm = document.querySelector('form[action*="manage-order"]');
                if (orderForm) {
                    orderForm.addEventListener('submit', function(e) {
                        e.preventDefault();
                        
                        const statusSelect = document.querySelector('select[name="newStatus"]');
                        if (!statusSelect.value) {
                            showToast("Please select a status", "error");
                            return;
                        }
                        
                        // Get status text for confirmation message
                        const statusText = statusSelect.options[statusSelect.selectedIndex].text;
                        
                        // Update confirmation message
                        document.getElementById('confirm-message').textContent = 
                            `Are you sure you want to change the order status to "${statusText}"?`;
                        
                        // Show confirmation toast
                        const confirmToast = new bootstrap.Toast(document.getElementById('confirmToast'));
                        confirmToast.show();
                        
                        // Set up confirmation button
                        document.getElementById('confirm-yes-btn').onclick = function() {
                            confirmToast.hide();
                            showToast("Processing update...", "info");
                            orderForm.submit();
                        };
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