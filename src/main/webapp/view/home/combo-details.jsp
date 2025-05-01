<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${combo.name} - Flower Shop</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow" />
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>

            <style>
                /* Enhanced styling for combo details */
                .combo-details-container {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                    padding: 30px;
                    margin-bottom: 40px;
                    border: 2px dashed #80b435;
                }

                .combo-image {
                    width: 100%;
                    height: 400px;
                    overflow: hidden;
                    border-radius: 8px;
                    margin-bottom: 15px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background-color: #fff;
                    padding: 20px;
                }

                .combo-image img {
                    max-width: 100%;
                    max-height: 100%;
                    object-fit: contain;
                }

                .combo-title {
                    font-size: 28px;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 15px;
                }

                .combo-description {
                    font-size: 16px;
                    color: #666;
                    margin-bottom: 20px;
                    line-height: 1.6;
                }

                .combo-price-container {
                    background: #f8f9fa;
                    border-radius: 6px;
                    padding: 15px;
                    margin-bottom: 20px;
                }

                .combo-original-price {
                    font-size: 18px;
                    color: #999;
                    text-decoration: line-through;
                    margin-bottom: 5px;
                }

                .combo-discount-price {
                    font-size: 24px;
                    color: #80b435;
                    font-weight: 700;
                }

                .combo-savings {
                    font-size: 16px;
                    color: #e74c3c;
                    font-weight: 500;
                    margin-top: 5px;
                }

                .combo-products-title {
                    font-size: 20px;
                    font-weight: 600;
                    color: #333;
                    margin: 30px 0 15px;
                    padding-bottom: 10px;
                    border-bottom: 1px solid #eee;
                }

                .combo-product-item {
                    display: flex;
                    align-items: center;
                    padding: 15px;
                    border: 1px solid #eee;
                    border-radius: 6px;
                    margin-bottom: 15px;
                    transition: all 0.3s ease;
                }

                .combo-product-item:hover {
                    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                }

                .combo-product-image {
                    width: 80px;
                    height: 80px;
                    border-radius: 4px;
                    overflow: hidden;
                    margin-right: 15px;
                }

                .combo-product-image img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .combo-product-info {
                    flex: 1;
                }

                .combo-product-name {
                    font-size: 16px;
                    font-weight: 500;
                    color: #333;
                    margin-bottom: 5px;
                }

                .combo-product-price {
                    font-size: 14px;
                    color: #666;
                }

                .combo-product-quantity {
                    font-size: 14px;
                    color: #80b435;
                    font-weight: 500;
                }

                .combo-add-to-cart {
                    display: flex;
                    align-items: center;
                    margin-top: 30px;
                }

                .combo-quantity {
                    display: flex;
                    align-items: center;
                    margin-right: 15px;
                }

                .combo-quantity-input {
                    width: 60px;
                    height: 40px;
                    text-align: center;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    margin: 0 10px;
                }

                .combo-quantity-btn {
                    width: 30px;
                    height: 30px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: #f8f9fa;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .combo-quantity-btn:hover {
                    background: #e9ecef;
                }

                .combo-add-to-cart-btn {
                    padding: 10px 25px;
                    background-color: #80b435;
                    color: #fff;
                    border: none;
                    border-radius: 4px;
                    font-size: 16px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .combo-add-to-cart-btn:hover {
                    background-color: #6a9c2a;
                }

                .combo-badge {
                    display: inline-block;
                    padding: 5px 10px;
                    background-color: #e74c3c;
                    color: white;
                    border-radius: 3px;
                    font-size: 14px;
                    font-weight: bold;
                    margin-bottom: 15px;
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
                <!--Breadcrumb One Start-->
                <div class="breadcrumb-tow mb-120">
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="breadcrumb-title">
                                    <h1>Combo Detail</h1>
                                </div>
                                <div class="breadcrumb-content breadcrumb-content-tow">
                                    <ul>
                                        <li><a href="home">Home</a></li>
                                        <li class="active">Combo Detail</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Breadcrumb One End-->

                <!--Combo Details Area Start-->
                <div class="combo-details-area mb-115">
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="combo-details-container">
                                    <div class="row">
                                        <!-- Combo Image -->
                                        <div class="col-md-5">
                                            <div class="tab-content single-product-img">
                                                <div class="tab-pane fade show active" id="product1">
                                                    <div class="product-large-thumb img-full">
                                                        <div class="easyzoom easyzoom--overlay">
                                                            <a href="${combo.image}">
                                                                <img src="${combo.image}" alt="${combo.name}">
                                                            </a>
                                                            <a href="${combo.image}" class="popup-img venobox" data-gall="myGallery"><i class="fa fa-search"></i></a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Combo Info -->
                                        <div class="col-md-7">
                                            <span class="combo-badge">Tiết kiệm <fmt:formatNumber value="${combo.originalPrice - combo.discountPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            <h1 class="combo-title">${combo.name}</h1>
                                            <p class="combo-description">${combo.description}</p>

                                            <div class="combo-price-container">
                                                <div class="combo-original-price">Giá gốc: <fmt:formatNumber value="${combo.originalPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                                                <div class="combo-discount-price">Giá ưu đãi: <fmt:formatNumber value="${combo.discountPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                                                <div class="combo-savings">Tiết kiệm: <fmt:formatNumber value="${combo.originalPrice - combo.discountPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                                            </div>

                                            <div class="combo-add-to-cart">
                                                <div class="combo-quantity">
                                                    <span>Số lượng:</span>
                                                    <button type="button" class="combo-quantity-btn decrease-quantity">-</button>
                                                    <input type="number" class="combo-quantity-input" value="1" min="1" id="combo-quantity">
                                                    <button type="button" class="combo-quantity-btn increase-quantity">+</button>
                                                </div>
                                                <button type="button" class="combo-add-to-cart-btn" onclick="addComboToCart(${combo.comboId})">Thêm vào giỏ hàng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Combo Products -->
                                <h3 class="mt-4">Danh sách sản phẩm trong combo:</h3>
                                <div class="row">
                                    <c:forEach var="product" items="${comboProducts}">
                                        <div class="col-md-4 mb-4">
                                            <div class="card">
                                                <img src="${pageContext.request.contextPath}/${product.image}" class="card-img-top" alt="${product.productName}">
                                                <div class="card-body">
                                                    <h5 class="card-title">${product.productName}</h5>
                                                    <p class="card-text">Giá: <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" /></p>
                                                    <p class="card-text">Số lượng trong combo: ${product.quantity}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Combo Details Area End-->

            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
                <!--Footer Area End-->
            </div>

            <!--All Js Here-->
        <jsp:include page="/view/common/home/common-js.jsp"></jsp:include>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Xử lý tăng giảm số lượng
                    const quantityInput = document.getElementById('combo-quantity');
                    const decreaseBtn = document.querySelector('.decrease-quantity');
                    const increaseBtn = document.querySelector('.increase-quantity');

                    decreaseBtn.addEventListener('click', function () {
                        let currentValue = parseInt(quantityInput.value);
                        if (currentValue > 1) {
                            quantityInput.value = currentValue - 1;
                        }
                    });

                    increaseBtn.addEventListener('click', function () {
                        let currentValue = parseInt(quantityInput.value);
                        quantityInput.value = currentValue + 1;
                    });
                });

                // Hàm thêm combo vào giỏ hàng
                function addComboToCart(comboId) {
                    const quantity = document.getElementById('combo-quantity').value;
                    window.location.href = '${pageContext.request.contextPath}/cart?action=add&comboId=' + comboId + '&quantity=' + quantity;
                }
        </script>
    </body>
</html>