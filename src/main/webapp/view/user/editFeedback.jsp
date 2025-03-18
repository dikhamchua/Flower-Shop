<%-- 
    Document   : editFeedback
    Created on : Mar 15, 2025, 12:00:00 AM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Kiểm tra đăng nhập --%>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="/authen?action=login">
        <c:param name="message" value="Vui lòng đăng nhập để chỉnh sửa đánh giá" />
    </c:redirect>
</c:if>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Review</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            .product-image {
                max-width: 120px;
                border-radius: 10px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            }
            
            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                font-size: 1.5em;
                justify-content: flex-end;
                padding: 0 0.2em;
                text-align: center;
                width: 5em;
            }

            .star-rating input {
                display: none;
            }

            .star-rating label {
                color: #ccc;
                cursor: pointer;
                padding: 0 0.1em;
                transition: color 0.3s ease;
            }

            .star-rating :checked ~ label {
                color: #f90;
            }

            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #fc0;
            }
            
            .review-card {
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
            }
            
            .review-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
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
                <h6 class="fw-semibold mb-0">Edit Review</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/home" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Home
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/feedbackControl" class="d-flex align-items-center gap-1 hover-text-primary">
                            My Reviews
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">
                        <a href="javascript:void(0)" class="hover-text-primary">Edit Review</a>
                    </li>
                </ul>
            </div>

            <!-- Product Review Form -->
            <div class="card mb-24 review-card">
                <div class="card-body p-24">
                    <div class="row mb-4">
                        <div class="col-md-3 text-center">
                            <img src="${pageContext.request.contextPath}/uploads/products/${orderItem.productImage}" 
                                 alt="${orderItem.productName}" class="product-image mb-3">
                            <h5 class="mb-1">${orderItem.productName}</h5>
                            <p class="text-muted small">
                                <fmt:formatNumber value="${orderItem.price}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                            </p>
                        </div>
                        <div class="col-md-9">
                            <h4 class="mb-4">Edit Your Review</h4>
                            <form action="${pageContext.request.contextPath}/feedbackControl" method="POST">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
                                
                                <div class="mb-4">
                                    <label class="form-label">Rating</label>
                                    <div class="star-rating">
                                        <input type="radio" id="star5" name="rating" value="5" ${feedback.rating == 5 ? 'checked' : ''} required />
                                        <label for="star5" title="5 stars"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star4" name="rating" value="4" ${feedback.rating == 4 ? 'checked' : ''} />
                                        <label for="star4" title="4 stars"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star3" name="rating" value="3" ${feedback.rating == 3 ? 'checked' : ''} />
                                        <label for="star3" title="3 stars"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star2" name="rating" value="2" ${feedback.rating == 2 ? 'checked' : ''} />
                                        <label for="star2" title="2 stars"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star1" name="rating" value="1" ${feedback.rating == 1 ? 'checked' : ''} />
                                        <label for="star1" title="1 star"><i class="fas fa-star"></i></label>
                                    </div>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="content" class="form-label">Your Comments</label>
                                    <textarea class="form-control" id="content" name="content" rows="5" 
                                              placeholder="Share your thoughts about this product..." required>${feedback.content}</textarea>
                                </div>
                                
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i> Update Review
                                    </button>
                                    <a href="${pageContext.request.contextPath}/feedbackControl" class="btn btn-outline-secondary">
                                        <i class="fas fa-times me-2"></i> Cancel
                                    </a>
                                </div>
                            </form>
                        </div>
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