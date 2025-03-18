<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Coupon - Flower Shop</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <style>
            .required-field::after {
                content: "*";
                color: #e74a3b;
                margin-left: 4px;
            }
            
            .form-control:focus {
                border-color: #4e73df;
                box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
            }
            
            .btn-cancel {
                color: #858796;
                background-color: #f8f9fc;
                border-color: #ddd;
            }
            
            .btn-cancel:hover {
                color: #2e2f37;
                background-color: #eaecf4;
            }
            
            .badge-success {
                background-color: #1cc88a;
                color: white;
            }
            
            .badge-danger {
                background-color: #e74a3b;
                color: white;
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
                <h6 class="fw-semibold mb-0">Edit Coupon</h6>
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
                    <li class="fw-medium">Edit Coupon</li>
                </ul>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center bg-white py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-edit me-1"></i>Coupon #${coupon.couponId} 
                        <span class="badge ${coupon.active ? 'badge-success' : 'badge-danger'} ms-2">
                            ${coupon.active ? 'Active' : 'Inactive'}
                        </span>
                    </h6>
                    <div>
                        <span class="text-muted small">Used: <strong>${coupon.usageCount}/${coupon.usageLimit > 0 ? coupon.usageLimit : '∞'}</strong></span>
                    </div>
                </div>
                <div class="card-body p-4">
                    <!-- Error messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <fmt:setLocale value="en_US"/>
                    
                    <form action="${pageContext.request.contextPath}/admin/manage-coupon?action=update" method="post">
                        <input type="hidden" name="couponId" value="${coupon.couponId}">

                        <div class="row mb-3">
                            <label for="code" class="col-sm-3 col-form-label required-field">Coupon Code</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="code" name="code" value="${coupon.code}" required>
                                <small class="text-muted">Coupon code must be unique</small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="description" class="col-sm-3 col-form-label">Description</label>
                            <div class="col-sm-9">
                                <textarea class="form-control" id="description" name="description" rows="3">${coupon.description}</textarea>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="discountType" class="col-sm-3 col-form-label required-field">Discount Type</label>
                            <div class="col-sm-9">
                                <select class="form-select" id="discountType" name="discountType" required onchange="toggleDiscountFields()">
                                    <option value="percentage" ${coupon.discountType eq 'percentage' ? 'selected' : ''}>Percentage (%)</option>
                                    <option value="fixed" ${coupon.discountType eq 'fixed' ? 'selected' : ''}>Fixed Amount ($)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="discountValue" class="col-sm-3 col-form-label required-field">Discount Value</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="discountValue" name="discountValue" 
                                           value="${coupon.discountValue}" required min="0" step="${coupon.discountType eq 'percentage' ? '0.01' : '1000'}">
                                    <span class="input-group-text" id="discountSymbol">
                                        ${coupon.discountType eq 'percentage' ? '%' : '₫'}
                                    </span>
                                </div>
                                <small class="text-muted" id="discountHint">
                                    ${coupon.discountType eq 'percentage' ? 'Enter percentage value (e.g., 10 for 10%)' : 'Enter amount in VND'}
                                </small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="minPurchase" class="col-sm-3 col-form-label">Minimum Purchase</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="minPurchase" name="minPurchase"
                                           value="${coupon.minPurchase}" min="0" step="1000">
                                    <span class="input-group-text">₫</span>
                                </div>
                                <small class="text-muted">
                                    <c:if test="${not empty coupon.minPurchase}">
                                        <fmt:formatNumber value="${coupon.minPurchase}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </c:if>
                                </small>
                            </div>
                        </div>
                        
                        <div class="row mb-3" id="maxDiscountGroup" 
                             style="${coupon.discountType eq 'percentage' ? '' : 'display: none;'}">
                            <label for="maxDiscount" class="col-sm-3 col-form-label">Maximum Discount</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="maxDiscount" name="maxDiscount"
                                           value="${coupon.maxDiscount}" min="0" step="1000">
                                    <span class="input-group-text">₫</span>
                                </div>
                                <small class="text-muted">
                                    <c:if test="${not empty coupon.maxDiscount}">
                                        <fmt:formatNumber value="${coupon.maxDiscount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </c:if>
                                    <br>Only applies to percentage discounts
                                </small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="startDate" class="col-sm-3 col-form-label required-field">Start Date</label>
                            <div class="col-sm-9">
                                <fmt:formatDate value="${coupon.startDate}" pattern="yyyy-MM-dd" var="formattedStartDate" />
                                <input type="date" class="form-control" id="startDate" name="startDate" 
                                       value="${formattedStartDate}" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="endDate" class="col-sm-3 col-form-label required-field">End Date</label>
                            <div class="col-sm-9">
                                <fmt:formatDate value="${coupon.endDate}" pattern="yyyy-MM-dd" var="formattedEndDate" />
                                <input type="date" class="form-control" id="endDate" name="endDate" 
                                       value="${formattedEndDate}" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="usageLimit" class="col-sm-3 col-form-label">Usage Limit</label>
                            <div class="col-sm-9">
                                <input type="number" class="form-control" id="usageLimit" name="usageLimit"
                                       value="${coupon.usageLimit}" min="1" step="1"
                                       placeholder="Maximum number of uses (leave empty for unlimited)">
                                <small class="text-muted">
                                    Used: ${coupon.usageCount} times
                                </small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label">Status</label>
                            <div class="col-sm-9">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                           ${coupon.active ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActive">Activate this coupon</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label">Created At</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <fmt:formatDate value="${coupon.createdAt}" pattern="MM/dd/yyyy HH:mm:ss" var="formattedCreatedAt" />
                                    <input type="text" class="form-control" value="${formattedCreatedAt}" disabled>
                                    <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mt-4">
                            <div class="col-sm-9 offset-sm-3 d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Save Changes
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/manage-coupon" class="btn btn-cancel">
                                    <i class="fas fa-arrow-left me-1"></i>Go Back
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/manage-coupon?action=usage&id=${coupon.couponId}" 
                                   class="btn btn-info ms-2">
                                    <i class="fas fa-history me-1"></i>View Usage History
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        
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
            // Toggle display of max_discount field based on discount type
            function toggleDiscountFields() {
                var discountType = document.getElementById('discountType').value;
                var maxDiscountGroup = document.getElementById('maxDiscountGroup');
                var discountSymbol = document.getElementById('discountSymbol');
                var discountValue = document.getElementById('discountValue');
                var discountHint = document.getElementById('discountHint');
                
                if (discountType === 'percentage') {
                    maxDiscountGroup.style.display = 'flex';
                    discountSymbol.textContent = '%';
                    discountValue.step = '0.01';
                    discountHint.textContent = 'Enter percentage value (e.g., 10 for 10%)';
                } else {
                    maxDiscountGroup.style.display = 'none';
                    discountSymbol.textContent = '₫';
                    discountValue.step = '1000';
                    discountHint.textContent = 'Enter amount in VND';
                }
            }
            
            // Run function on load to set initial state
            toggleDiscountFields();
            
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