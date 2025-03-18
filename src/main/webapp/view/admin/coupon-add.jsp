<%-- 
    Document   : coupon-add
    Created on : Mar 14, 2025, 6:26:16 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Coupon - Flower Shop</title>
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
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

        <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Add New Coupon</h6>
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
                    <li class="fw-medium">Add New Coupon</li>
                </ul>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <!-- Error messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/admin/manage-coupon?action=insert" method="post">
                        <div class="row mb-3">
                            <label for="code" class="col-sm-3 col-form-label required-field">Coupon Code</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="code" name="code" required
                                       placeholder="Enter coupon code (e.g., SUMMER2023)" value="${param.code}">
                                <small class="text-muted">A unique code that customers will enter at checkout.</small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="description" class="col-sm-3 col-form-label">Description</label>
                            <div class="col-sm-9">
                                <textarea class="form-control" id="description" name="description" rows="2"
                                          placeholder="Enter a brief description of this coupon">${param.description}</textarea>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="discountType" class="col-sm-3 col-form-label required-field">Discount Type</label>
                            <div class="col-sm-9">
                                <select class="form-select" id="discountType" name="discountType" required onchange="toggleDiscountFields()">
                                    <option value="percentage" ${param.discountType eq 'percentage' ? 'selected' : ''}>Percentage (%)</option>
                                    <option value="fixed" ${param.discountType eq 'fixed' ? 'selected' : ''}>Fixed Amount ($)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="discountValue" class="col-sm-3 col-form-label required-field">Discount Value</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="discountValue" name="discountValue" 
                                           value="${param.discountValue}" required min="0" step="${discountType eq 'percentage' ? '0.01' : '1000'}">
                                    <span class="input-group-text" id="discountSymbol">%</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3" id="maxDiscountGroup">
                            <label for="maxDiscount" class="col-sm-3 col-form-label">Maximum Discount</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="maxDiscount" name="maxDiscount"
                                           value="${param.maxDiscount}" min="0" step="1000">
                                    <span class="input-group-text">₫</span>
                                </div>
                                <small class="text-muted">For percentage discounts, you can set a maximum discount amount in VND.</small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="minPurchase" class="col-sm-3 col-form-label">Minimum Purchase</label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="minPurchase" name="minPurchase"
                                           value="${param.minPurchase}" min="0" step="1000">
                                    <span class="input-group-text">₫</span>
                                </div>
                                <small class="text-muted">Minimum order amount required to use this coupon (in VND).</small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="startDate" class="col-sm-3 col-form-label required-field">Start Date</label>
                            <div class="col-sm-9">
                                <input type="date" class="form-control" id="startDate" name="startDate" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="endDate" class="col-sm-3 col-form-label required-field">End Date</label>
                            <div class="col-sm-9">
                                <input type="date" class="form-control" id="endDate" name="endDate" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label for="usageLimit" class="col-sm-3 col-form-label">Usage Limit</label>
                            <div class="col-sm-9">
                                <input type="number" class="form-control" id="usageLimit" name="usageLimit"
                                       value="${param.usageLimit}" min="0" step="1">
                                <small class="text-muted">Maximum number of times this coupon can be used. Leave empty for unlimited.</small>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label">Status</label>
                            <div class="col-sm-9">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="isActive" checked>
                                    <label class="form-check-label" for="isActive">
                                        Active
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-sm-9 offset-sm-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Save Coupon
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/manage-coupon" class="btn btn-cancel ms-2">
                                    <i class="fas fa-times me-1"></i>Cancel
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
            // Set default dates
            document.getElementById('startDate').valueAsDate = new Date();
            
            var tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 30); // Default 30 days
            document.getElementById('endDate').valueAsDate = tomorrow;
            
            // Toggle display of max_discount field based on discount type
            function toggleDiscountFields() {
                var discountType = document.getElementById('discountType').value;
                var maxDiscountGroup = document.getElementById('maxDiscountGroup');
                var discountSymbol = document.getElementById('discountSymbol');
                var discountValue = document.getElementById('discountValue');
                
                if (discountType === 'percentage') {
                    maxDiscountGroup.style.display = 'flex';
                    discountSymbol.textContent = '%';
                    discountValue.step = '0.01';
                } else {
                    maxDiscountGroup.style.display = 'none';
                    discountSymbol.textContent = '₫';
                    discountValue.step = '1000';
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
