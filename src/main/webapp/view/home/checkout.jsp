<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Kiểm tra đăng nhập --%>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="/authen?action=login">
        <c:param name="message" value="Vui lòng đăng nhập để xem giỏ hàng" />
    </c:redirect>
</c:if>

<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Checkout || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow" />
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>
        <style>
            .payment-method-section {
                background-color: #f9f9f9;
                border-radius: 10px;
                padding: 20px;
                margin-top: 20px;
            }

            .payment-option {
                background: white;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
            }

            .payment-option:hover {
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            .payment-option.active {
                border-color: #80b82d;
                box-shadow: 0 5px 15px rgba(128,184,45,0.1);
            }

            .payment-label {
                display: flex;
                align-items: center;
                cursor: pointer;
            }

            .payment-icon {
                width: 40px;
                height: 40px;
                background: #f0f8eb;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
            }

            .payment-details {
                padding: 10px 0 0 55px;
                font-size: 14px;
                color: #666;
                display: none;
            }

            .payment-option.active .payment-details {
                display: block;
            }

            .checkout-btn {
                background: linear-gradient(to right, #80b82d, #8cc640);
                color: white;
                border: none;
                padding: 15px 25px;
                font-size: 16px;
                border-radius: 50px;
                width: 100%;
                margin-top: 20px;
                transition: all 0.3s ease;
            }

            .checkout-btn:hover {
                background: linear-gradient(to right, #729d27, #7eb536);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(128,184,45,0.2);
            }

            .your-order {
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 25px rgba(0,0,0,0.05);
                padding: 25px;
            }

            .order-table {
                width: 100%;
            }

            .order-table th, .order-table td {
                padding: 12px 0;
                border-bottom: 1px solid #eee;
            }

            .order-total {
                font-weight: bold;
                font-size: 18px;
                color: #80b82d;
            }
            
            .readonly-field {
                background-color: #f9f9f9;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <!--[if lt IE 8]>
        <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            <!--Breadcrumb Tow Start-->
            <div class="breadcrumb-tow mb-120">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="breadcrumb-title">
                                <h1>Checkout</h1>
                            </div>
                            <div class="breadcrumb-content breadcrumb-content-tow">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                    <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                                    <li class="active">Checkout</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb Tow End-->

            <!--Checkout Area Start-->
            <div class="checkout-area mb-80">
                <div class="container">
                    <form action="${pageContext.request.contextPath}/cart?action=checkout" method="post">
                        <div class="row">
                            <!-- Billing Details - Left Column -->
                            <div class="col-lg-6 col-md-12 mb-4 mb-lg-0">
                                <div class="billing-details p-4 bg-white rounded shadow-sm">
                                    <h3 class="mb-4">Billing Details</h3>

                                    <div class="row">
                                        <!-- Thay đổi từ fullName sang firstName và lastName -->
                                        <div class="col-md-6">
                                            <div class="form-group mb-4">
                                                <label>First Name</label>
                                                <input type="text" class="form-control readonly-field" value="${account.firstName}" readonly>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group mb-4">
                                                <label>Last Name</label>
                                                <input type="text" class="form-control readonly-field" value="${account.lastName}" readonly>
                                            </div>
                                        </div>
                                        
                                        <!-- Email -->
                                        <div class="col-md-6">
                                            <div class="form-group mb-4">
                                                <label>Email</label>
                                                <input type="email" class="form-control readonly-field" value="${account.email}" readonly>
                                            </div>
                                        </div>
                                        
                                        <!-- Phone -->
                                        <div class="col-md-6">
                                            <div class="form-group mb-4">
                                                <label>Phone</label>
                                                <input type="tel" class="form-control readonly-field" value="${account.phone}" readonly>
                                            </div>
                                        </div>
                                        
                                        <!-- Address - Có thể chỉnh sửa, lấy giá trị mặc định từ account -->
                                        <div class="col-md-12">
                                            <div class="form-group mb-4">
                                                <label>Shipping Address</label>
                                                <input type="text" name="address" class="form-control" value="${account.address}" required 
                                                       placeholder="Enter your shipping address">
                                                <small class="text-muted">You can modify the shipping address if needed</small>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Payment Method Section -->
                                    <div class="payment-method-section">
                                        <h4 class="mb-3">Payment Method</h4>
                                        
                                        <!-- Cash on Delivery -->
                                        <div class="payment-option">
                                            <div class="payment-label">
                                                <input type="radio" id="cash-on-delivery" name="paymentMethod" value="cash on delivery" checked>
                                                <div class="payment-icon">
                                                    <iconify-icon icon="uil:money-bill" width="24" height="24" style="color: #80b82d;"></iconify-icon>
                                                </div>
                                                <label for="cash-on-delivery">Cash On Delivery</label>
                                            </div>
                                            <div class="payment-details">
                                                Pay with cash upon delivery. Please have the exact amount ready for our delivery personnel.
                                            </div>
                                        </div>
                                        
                                        <!-- Digital Wallet -->
                                        <div class="payment-option">
                                            <div class="payment-label">
                                                <input type="radio" id="digital-wallet" name="paymentMethod" value="digital wallet" >
                                                <div class="payment-icon">
                                                    <iconify-icon icon="uil:wallet" width="24" height="24" style="color: #80b82d;"></iconify-icon>
                                                </div>
                                                <label for="digital-wallet">Digital Wallet</label>
                                            </div>
                                            <div class="payment-details">
                                                Pay via digital wallet services. Your payment will be processed securely through our verified payment gateway.
                                            </div>
                                        </div>
                                        
                                        <!-- Bank Transfer -->
                                        <div class="payment-option">
                                            <div class="payment-label">
                                                <input type="radio" name="paymentMethod" id="bank-transfer" value="bank transfer">
                                                <div class="payment-icon">
                                                    <iconify-icon icon="mdi:bank-outline" width="24" height="24" style="color: #80b82d;"></iconify-icon>
                                                </div>
                                                <label for="bank-transfer">Bank Transfer</label>
                                            </div>
                                            <div class="payment-details">
                                                Make your payment directly into our bank account. Please use your Order ID as the payment reference. Your order won't be processed until the funds have cleared in our account.
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Order Summary - Right Column -->
                            <div class="col-lg-6 col-md-12">
                                <div class="your-order">
                                    <h3 class="mb-4">Your Order</h3>
                                    <table class="order-table">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th style="text-align: right;">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${cartItems}" var="item">
                                                <tr>
                                                    <td>${item.product.productName} × ${item.quantity}</td>
                                                    <td style="text-align: right;"><fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Subtotal</th>
                                                <td style="text-align: right;"><fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                            </tr>
                                            <c:if test="${not empty couponDiscount}">
                                                <tr>
                                                    <th>Discount <c:if test="${not empty appliedCoupon}"><small>(${appliedCoupon.code})</small></c:if></th>
                                                    <td style="text-align: right; color: #e83e8c;">-<fmt:formatNumber value="${couponDiscount}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <th>Shipping</th>
                                                <td style="text-align: right;">Free</td>
                                            </tr>
                                            <tr class="order-total">
                                                <th>Total</th>
                                                <td style="text-align: right;"><fmt:formatNumber value="${finalTotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                            </tr>
                                        </tfoot>
                                    </table>

                                    <button type="submit" class="checkout-btn">
                                        <iconify-icon icon="uil:check-circle" width="20" height="20" style="margin-right: 8px;"></iconify-icon>
                                        Place Order
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <!--Checkout Area End-->

            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <script>
            $(document).ready(function () {
                // Handle payment method selection
                $('input[name="paymentMethod"]').change(function () {
                    $('.payment-option').removeClass('active');
                    $(this).closest('.payment-option').addClass('active');
                });

                // Initially show the selected payment method details
                $('.payment-option input:checked').closest('.payment-option').addClass('active');
                
                // Form submission
                $('form').on('submit', function() {
                    // Disable the submit button to prevent multiple submissions
                    $('.checkout-btn').prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...');
                    
                    // Show a loading message
                    showToast('Processing your order...', 'info');
                    
                    // Allow the form to submit
                    return true;
                });
            });
            
            // Function to show toast messages
            function showToast(message, type) {
                // Create toast element if it doesn't exist
                if (!$('#orderToast').length) {
                    $('body').append(`
                        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
                            <div id="orderToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                                <div class="toast-header bg-\${type === 'success' ? 'success' : 'info'} text-white">
                                    <strong class="me-auto">Thông báo</strong>
                                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                                </div>
                                <div class="toast-body">\${message}</div>
                            </div>
                        </div>
                    `);
                } else {
                    // Update existing toast
                    $('#orderToast .toast-header').removeClass('bg-success bg-info').addClass('bg-' + (type === 'success' ? 'success' : 'info'));
                    $('#orderToast .toast-body').text(message);
                }
                
                // Show the toast
                const toast = new bootstrap.Toast(document.getElementById('orderToast'));
                toast.show();
            }
            
            // Check for success message from session and show toast
            <c:if test="${not empty sessionScope.orderSuccessMessage}">
                $(document).ready(function() {
                    showToast("${sessionScope.orderSuccessMessage}", "success");
                    
                    // Remove the message from session
                    <% session.removeAttribute("orderSuccessMessage"); %>
                });
            </c:if>
        </script>
    </body>
</html>
