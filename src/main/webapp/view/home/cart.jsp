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
        <title>Cart || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow" />
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>
        
        <style>
            /* Custom CSS for quantity input */
            .cart-plus-minus {
                position: relative;
                display: inline-flex;
                border: 1px solid #ddd;
            }
            .cart-plus-minus-box {
                width: 40px;
                height: 40px;
                border: none;
                text-align: center;
                padding: 0;
                background: #fff;
            }
            .qtybutton-container {
                display: flex;
                flex-direction: column;
                border-left: 1px solid #ddd;
            }
            .qtybutton {
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                background: #f9f9f9;
                user-select: none;
            }
            .inc.qtybutton {
                border-bottom: 1px solid #ddd;
            }
            .qtybutton:hover {
                background: #e9e9e9;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            
            <!--Breadcrumb One Start-->
            <div class="breadcrumb-one mb-120">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="breadcrumb-img">
                                <img src="${pageContext.request.contextPath}/img/page-banner/cart-banner.jpg" alt="">
                            </div>
                            <div class="breadcrumb-content">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                    <li class="active">Shopping Cart</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb One End-->
            
            <!--Shopping Cart Area Start-->
            <div class="Shopping-cart-area mb-110">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <form action="${pageContext.request.contextPath}/cart" method="post" id="cartForm">
                                <input type="hidden" name="action" value="update">
                                <div class="table-content table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th class="plantmore-product-remove">Remove</th>
                                                <th class="plantmore-product-thumbnail">Images</th>
                                                <th class="cart-product-name">Product</th>
                                                <th class="plantmore-product-price">Unit Price</th>
                                                <th class="plantmore-product-quantity">Quantity</th>
                                                <th class="plantmore-product-subtotal">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty cartItems}">
                                                <tr>
                                                    <td colspan="6" class="text-center">Your cart is empty</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${cartItems}" var="item">
                                                <tr>
                                                    <td class="plantmore-product-remove">
                                                        <a href="${pageContext.request.contextPath}/cart?action=remove&productId=${item.product.productId}"><i class="fa fa-times"></i></a>
                                                    </td>
                                                    <td class="plantmore-product-thumbnail">
                                                        <a href="${pageContext.request.contextPath}/home?action=product-details&id=${item.product.productId}">
                                                            <img src="${item.product.image}" alt="${item.product.productName}" style="max-width: 80px;">
                                                        </a>
                                                    </td>
                                                    <td class="plantmore-product-name">
                                                        <a href="${pageContext.request.contextPath}/home?action=product-details&id=${item.product.productId}">${item.product.productName}</a>
                                                    </td>
                                                    <td class="plantmore-product-price">
                                                        <span class="amount">
                                                            <fmt:formatNumber value="${item.product.price}" pattern="#,##0" /> VND
                                                        </span>
                                                    </td>
                                                    <td class="plantmore-product-quantity">
                                                        <input type="hidden" name="productId" value="${item.product.productId}">
                                                        <div class="cart-plus-minus">
                                                            <input class="cart-plus-minus-box" type="text" name="quantity" value="${item.quantity}" min="1">
                                                            <div class="qtybutton-container">
                                                                <div class="inc qtybutton">▲</div>
                                                                <div class="dec qtybutton">▼</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="product-subtotal">
                                                        <span class="amount">
                                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> VND
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </form>
                            <div class="row">
                                <div class="col-12">
                                    <div class="coupon-all">
                                        <!-- Hiển thị thông báo từ việc áp dụng coupon -->
                                        <c:if test="${not empty sessionScope.couponMessage}">
                                            <div class="alert ${sessionScope.couponMessage.contains('thành công') ? 'alert-success' : 'alert-warning'}" style="margin-bottom: 15px; padding: 10px 15px; border-radius: 4px;">
                                                ${sessionScope.couponMessage}
                                                <% session.removeAttribute("couponMessage"); %>
                                            </div>
                                        </c:if>
                                        
                                        <c:choose>
                                            <c:when test="${empty sessionScope.appliedCoupon}">
                                                <!-- Form nhập mã giảm giá - Tách riêng ra khỏi form cập nhật giỏ hàng -->
                                                <div class="coupon">
                                                    <form action="${pageContext.request.contextPath}/cart" method="post" id="couponForm">
                                                        <input type="hidden" name="action" value="apply-coupon">
                                                        <input id="couponCode" class="input-text" name="couponCode" value="" placeholder="Coupon code" type="text" required>
                                                        <button type="submit" class="button" name="apply_coupon">Apply coupon</button>
                                                    </form>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Hiển thị coupon đã áp dụng -->
                                                <div class="applied-coupon" style="display: flex; align-items: center; background: #f9f9f9; padding: 10px 15px; border-radius: 4px; margin-bottom: 15px; border: 1px dashed #ddd;">
                                                    <div style="flex-grow: 1;">
                                                        <strong>Applied coupon: ${sessionScope.appliedCoupon.code}</strong>
                                                        <div class="text-success" style="color: #28a745; margin-top: 5px;">
                                                            Discount: <fmt:formatNumber value="${sessionScope.couponDiscount}" pattern="#,##0" /> ₫
                                                        </div>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/cart?action=remove-coupon" class="button" style="background: #dc3545; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none;">
                                                        Remove
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <div class="coupon2">
                                            <input class="button" name="update_cart" value="Update cart" type="submit" form="cartForm">
                                            <a href="${pageContext.request.contextPath}/cart?action=proceed-to-checkout" class="button checkout-btn" style="background: linear-gradient(to right, #80b82d, #8cc640); color: white; padding: 10px 20px; font-weight: bold; box-shadow: 0 2px 5px rgba(0,0,0,0.1); border-radius: 4px; transition: all 0.3s ease; text-decoration: none; display: inline-block;">
                                                <i class="fa fa-check-circle" style="margin-right: 8px;"></i> Proceed to checkout
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-5 ml-auto">
                                    <div class="cart-page-total" style="margin-top: 30px;">
                                        <h2>Cart totals</h2>
                                        <ul style="padding: 0; list-style: none;">
                                            <li style="padding: 10px 0; display: flex; justify-content: space-between; border-bottom: 1px solid #eee;">
                                                <span>Subtotal</span>
                                                <span><fmt:formatNumber value="${cartTotal}" pattern="#,##0" /> ₫</span>
                                            </li>
                                            
                                            <c:if test="${not empty sessionScope.couponDiscount}">
                                                <li style="padding: 10px 0; display: flex; justify-content: space-between; border-bottom: 1px solid #eee; color: #28a745;">
                                                    <span>Discount</span>
                                                    <span>-<fmt:formatNumber value="${sessionScope.couponDiscount}" pattern="#,##0" /> ₫</span>
                                                </li>
                                            </c:if>
                                            
                                            <li style="padding: 15px 0; display: flex; justify-content: space-between; font-weight: bold; font-size: 1.1em;">
                                                <span>Total</span>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.couponDiscount}">
                                                            <fmt:formatNumber value="${cartTotal - sessionScope.couponDiscount}" pattern="#,##0" /> ₫
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${cartTotal}" pattern="#,##0" /> ₫
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Shopping Cart Area End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        <script>
            $(document).ready(function() {
                // Xử lý nút tăng giảm số lượng
                $('.qtybutton').on('click', function() {
                    var $button = $(this);
                    var oldValue = $button.parent().parent().find('input').val();
                    
                    if ($button.hasClass('inc')) {
                        var newVal = parseFloat(oldValue) + 1;
                    } else {
                        // Không cho phép giảm xuống dưới 1
                        if (oldValue > 1) {
                            var newVal = parseFloat(oldValue) - 1;
                        } else {
                            newVal = 1;
                        }
                    }
                    
                    $button.parent().parent().find('input').val(newVal);
                });
                
                // Kiểm tra giá trị nhập vào
                $('.cart-plus-minus-box').on('change', function() {
                    var value = parseInt($(this).val());
                    if (isNaN(value) || value < 1) {
                        $(this).val(1);
                    }
                });
                
                // Ngăn chặn nhập giá trị âm hoặc 0
                $('.cart-plus-minus-box').on('keypress', function(e) {
                    var key = String.fromCharCode(e.which);
                    if (!/[1-9]/.test(key) && !(e.which === 8 || e.which === 0)) {
                        e.preventDefault();
                    }
                });
                
                // Hiển thị toast nếu có thông báo từ server
                <c:if test="${not empty sessionScope.cartMessage}">
                    const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                    const message = `${sessionScope.cartMessage}`;
                    $('#cartToast .toast-body').text(message);
                    
                    // Thay đổi màu header của toast dựa vào loại thông báo
                    if (message.includes("exceed available stock")) {
                        $('#cartToast .toast-header').addClass('bg-danger text-white');
                    } else {
                        $('#cartToast .toast-header').addClass('bg-success text-white');
                    }
                    
                    toast.show();
                    
                    // Auto hide toast after 5 seconds for stock error messages, 3 seconds for others
                    setTimeout(function() {
                        toast.hide();
                    }, message.includes("exceed available stock") ? 5000 : 3000);
                    
                    <% session.removeAttribute("cartMessage"); %>
                </c:if>
            });
        </script>

        <!-- Toast container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <strong class="me-auto">Thông báo</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" style="white-space: pre-line">
                    <!-- white-space: pre-line để hiển thị đúng định dạng xuống dòng -->
                </div>
            </div>
        </div>
    </body>
</html>

