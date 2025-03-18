<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Coupon Management - Flower Shop</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <style>
            .fixed-width-btn {
                min-width: 120px;
                text-align: center;
            }
            .view-btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                background: linear-gradient(135deg, #4e73df 0%, #3a54c4 100%);
                color: white;
                border-radius: 50px;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.3s ease;
                box-shadow: 0 2px 10px rgba(78, 115, 223, 0.2);
            }
            
            .view-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(78, 115, 223, 0.4);
                color: white;
            }
            
            .view-btn:active {
                transform: translateY(0);
                box-shadow: 0 2px 5px rgba(78, 115, 223, 0.3);
            }
            
            .view-icon {
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                width: 24px;
                height: 24px;
                transition: all 0.3s ease;
            }
            
            .view-btn:hover .view-icon {
                background-color: rgba(255, 255, 255, 0.3);
                transform: rotate(15deg);
            }
            
            .view-text {
                transition: all 0.3s ease;
            }
            
            .view-btn:hover .view-text {
                transform: translateX(2px);
            }
            
            /* Responsive adjustments */
            @media (max-width: 768px) {
                .view-btn {
                    padding: 6px 12px;
                    font-size: 13px;
                }
                
                .view-icon {
                    width: 20px;
                    height: 20px;
                }
            }
            
            .coupon-code {
                font-weight: bold;
                color: #4e73df;
            }
            
            .action-buttons {
                display: flex;
                gap: 8px;
            }
            
            .action-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 34px;
                height: 34px;
                border-radius: 50%;
                transition: all 0.3s ease;
            }
            
            .action-btn.edit {
                background-color: #4e73df;
                color: white;
            }
            
            .action-btn.history {
                background-color: #36b9cc;
                color: white;
            }
            
            .action-btn.delete {
                background-color: #e74a3b;
                color: white;
            }
            
            .action-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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
                <h6 class="fw-semibold mb-0">Coupon Management</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Coupon list</li>
                </ul>
            </div>

            <!-- Filter Section -->
            <div class="card mb-24">
                <div class="card-body p-24">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="card-title mb-0">Filter coupon</h5>
                        <a href="${pageContext.request.contextPath}/admin/manage-coupon?action=add" class="btn btn-success">
                            <i class="fas fa-plus-circle me-2"></i>Add new coupon
                        </a>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/manage-coupon" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <select class="form-select" name="status">
                                    <option value="">All status</option>
                                    <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                    <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" name="discountType">
                                    <option value="">All coupon</option>
                                    <option value="percentage" ${discountType == 'percentage' ? 'selected' : ''}>Percentage</option>
                                    <option value="fixed" ${discountType == 'fixed' ? 'selected' : ''}>Fixed</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" name="search" placeholder="Search by name"
                                       value="${search}">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">Filter</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Coupons Table -->
            <div class="card">
                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Coupon</th>
                                    <th>Type</th>
                                    <th>Amount</th>
                                    <th>Minimum purchase</th>
                                    <th>Max discount</th>
                                    <th>Period of validity</th>
                                    <th>Used</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty coupons}">
                                    <tr>
                                        <td colspan="10" class="text-center">
                                            <div class="py-4">
                                                <i class="fas fa-tags fs-1 text-muted mb-3"></i>
                                                <h5>Coupon not found</h5>
                                                <p class="text-muted">
                                                    <c:choose>
                                                        <c:when test="${not empty status || not empty search || not empty discountType}">
                                                            There are no coupon codes matching your search criteria. Try adjusting your filters.
                                                            <br>
                                                            <a href="${pageContext.request.contextPath}/admin/manage-coupon" class="btn btn-outline-primary mt-2">
                                                                <i class="fas fa-times me-2"></i>Clear filter
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            There are no discount codes in the system yet.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${coupons}" var="coupon">
                                    <tr>
                                        <td>${coupon.couponId}</td>
                                        <td class="coupon-code">${coupon.code}</td>
                                        <td>
                                            <span class="badge ${coupon.discountType eq 'percentage' ? 'bg-info' : 'bg-warning'}">
                                                ${coupon.discountType eq 'percentage' ? 'Percentage' : 'Fixed'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${coupon.discountType eq 'percentage'}">
                                                    ${coupon.discountValue}%
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${coupon.discountValue}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not empty coupon.minPurchase}">
                                                <fmt:formatNumber value="${coupon.minPurchase}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                            </c:if>
                                            <c:if test="${empty coupon.minPurchase}">
                                                -
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${not empty coupon.maxDiscount}">
                                                <fmt:formatNumber value="${coupon.maxDiscount}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                            </c:if>
                                            <c:if test="${empty coupon.maxDiscount}">
                                                -
                                            </c:if>
                                        </td>
                                        <td>
                                            <small>
                                                <fmt:formatDate value="${coupon.startDate}" pattern="dd/MM/yyyy"/> - 
                                                <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </td>
                                        <td>
                                            ${coupon.usageCount} / 
                                            <c:if test="${not empty coupon.usageLimit}">
                                                ${coupon.usageLimit}
                                            </c:if>
                                            <c:if test="${empty coupon.usageLimit}">
                                                ∞
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="badge ${coupon.active ? 'bg-success' : 'bg-danger'}">
                                                ${coupon.active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/manage-coupon?action=edit&id=${coupon.couponId}" 
                                               class="action-btn edit" title="Edit">
                                                <iconify-icon icon="heroicons:pencil-square" width="16" height="16"></iconify-icon>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/manage-coupon?action=usage&id=${coupon.couponId}" 
                                               class="action-btn history" title="View usage history">
                                                <iconify-icon icon="heroicons:clock" width="16" height="16"></iconify-icon>
                                            </a>
                                            <a href="#" onclick="confirmDelete(${coupon.couponId})" 
                                               class="action-btn delete" title="Delete">
                                                <iconify-icon icon="heroicons:trash" width="16" height="16"></iconify-icon>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-24">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-coupon?action=list&page=${currentPage - 1}&status=${status}&discountType=${discountType}&search=${search}">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-coupon?action=list&page=${i}&status=${status}&discountType=${discountType}&search=${search}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-coupon?action=list&page=${currentPage + 1}&status=${status}&discountType=${discountType}&search=${search}">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm deletion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this coupon? This action cannot be undone.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Toast Container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="couponToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header" id="toast-header">
                    <strong class="me-auto" id="toast-title">Notification</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toast-body"></div>
            </div>
        </div>
        
        <script>
            // Function to confirm delete
            function confirmDelete(couponId) {
                document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/manage-coupon?action=delete&id=' + couponId;
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            }
            
            // Function to show toast
            function showToast(message, type) {
                const toastEl = document.getElementById('couponToast');
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
                <% 
                // Pre-remove the message to avoid processing issues
                String successMsg = (String)session.getAttribute("successMessage");
                session.removeAttribute("successMessage"); 
                %>
                document.addEventListener('DOMContentLoaded', function() {
                    showToast("<%= successMsg %>", "success");
                });
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <% 
                // Pre-remove the message to avoid processing issues
                String errorMsg = (String)session.getAttribute("errorMessage");
                session.removeAttribute("errorMessage"); 
                %>
                document.addEventListener('DOMContentLoaded', function() {
                    showToast("<%= errorMsg %>", "error");
                });
            </c:if>
        </script>
    </body>
</html>
