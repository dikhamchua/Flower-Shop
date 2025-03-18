
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${empty sessionScope.account}">
    <c:redirect url="/authen?action=login">
        <c:param name="message" value="Vui lÃ²ng ÄÄng nháº­p Äá» xem ÄÃ¡nh giÃ¡ cá»§a báº¡n" />
    </c:redirect>
</c:if>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Reviews</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            .product-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
            }
            
            .star-rating {
                color: #ffc107;
                font-size: 18px;
            }
            
            .review-card {
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
                margin-bottom: 20px;
            }
            
            .review-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            }
            
            .review-date {
                font-size: 0.85rem;
                color: #6c757d;
            }
            
            .review-content {
                line-height: 1.6;
            }
            
            .action-buttons a {
                margin-right: 8px;
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
                <h6 class="fw-semibold mb-0">My Reviews</h6>
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
                        <a href="javascript:void(0)" class="hover-text-primary">My Reviews</a>
                    </li>
                </ul>
            </div>

            <!-- Reviews List -->
            <div class="card">
                <div class="card-body p-24">
                    <c:if test="${empty feedbacks}">
                        <div class="text-center py-5">
                            <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                            <h5>No reviews yet</h5>
                            <p class="text-muted">You haven't written any reviews yet.</p>
                            <a href="${pageContext.request.contextPath}/orderControll" class="btn btn-primary mt-2">
                                <i class="fas fa-store me-2"></i>View Your Orders
                            </a>
                        </div>
                    </c:if>
                    
                    <c:forEach var="feedback" items="${feedbacks}">
                        <div class="card review-card">
                            <div class="card-body p-4">
                                <div class="d-flex">
                                    <div class="me-3">
                                        <img src="${pageContext.request.contextPath}/uploads/products/${feedback.productImage}" 
                                             alt="${feedback.productName}" class="product-image">
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="mb-0">${feedback.productName}</h5>
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= feedback.rating ? '' : 'text-muted'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p class="review-date">
                                            <i class="far fa-calendar-alt me-1"></i>
                                            <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </p>
                                        <p class="review-content">${feedback.content}</p>
                                        <div class="action-buttons mt-3">
                                            <a href="${pageContext.request.contextPath}/feedbackControl?action=edit&id=${feedback.feedbackId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-edit me-1"></i>Edit
                                            </a>
                                            <a href="#" onclick="confirmDelete(${feedback.feedbackId})" 
                                               class="btn btn-sm btn-outline-danger">
                                                <i class="fas fa-trash-alt me-1"></i>Delete
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this review? This action cannot be undone.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
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
                    <strong class="me-auto" id="toast-title">ThÃ´ng bÃ¡o</strong>
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
            
            // Function to show delete confirmation
            function confirmDelete(feedbackId) {
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                
                confirmDeleteBtn.href = "${pageContext.request.contextPath}/feedbackControl?action=delete&id=" + feedbackId;
                deleteModal.show();
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