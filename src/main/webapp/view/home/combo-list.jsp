<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Combo Sản Phẩm || Flower Shop</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>

            <style>
                .pagination li.disabled a {
                    pointer-events: none;
                    opacity: 0.5;
                    cursor: not-allowed;
                }

                /* Combo card styling */
                .combo-product {
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                    margin-bottom: 30px;
                    overflow: hidden;
                }

                .combo-product:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                }

                .combo-product .product-img {
                    width: 100%;
                    height: 280px;
                    position: relative;
                    overflow: hidden;
                    padding: 20px;
                    background: #fff;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .combo-product .product-img img {
                    max-width: 100%;
                    max-height: 100%;
                    object-fit: contain;
                    transition: transform 0.5s ease;
                }

                .combo-product:hover .product-img img {
                    transform: scale(1.08);
                }

                .combo-product .product-content {
                    padding: 15px;
                    text-align: center;
                    background: #fff;
                }

                .combo-product .product-content h2 {
                    font-size: 16px;
                    margin-bottom: 10px;
                    font-weight: 500;
                    height: 40px;
                    overflow: hidden;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                }

                .combo-product .product-content h2 a {
                    color: #333;
                    text-decoration: none;
                }

                .combo-product .product-price {
                    margin: 10px 0;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                }

                .combo-product .original-price {
                    font-size: 16px;
                    color: #999;
                    text-decoration: line-through;
                    margin-bottom: 5px;
                }

                .combo-product .discount-price {
                    font-size: 18px;
                    color: #80b435;
                    font-weight: 600;
                }

                .combo-product .savings {
                    font-size: 14px;
                    color: #e74c3c;
                    font-weight: 500;
                    margin-top: 5px;
                }

                .combo-product .add-to-cart-btn {
                    display: inline-block;
                    padding: 8px 20px;
                    background-color: #80b435;
                    color: #fff;
                    border-radius: 4px;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    border: none;
                    cursor: pointer;
                    margin-top: 10px;
                    text-decoration: none;
                }

                .combo-product .add-to-cart-btn:hover {
                    background-color: #6a9c2a;
                }

                .combo-product .view-details-btn {
                    display: inline-block;
                    padding: 8px 20px;
                    background-color: #f8f9fa;
                    color: #333;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    cursor: pointer;
                    margin-top: 10px;
                    margin-right: 5px;
                    text-decoration: none;
                }

                .combo-product .view-details-btn:hover {
                    background-color: #e9ecef;
                }

                .combo-badge {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                    background-color: #e74c3c;
                    color: white;
                    padding: 5px 10px;
                    border-radius: 3px;
                    font-size: 12px;
                    font-weight: bold;
                    z-index: 1;
                }

                .page-title {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .page-title h1 {
                    font-size: 32px;
                    color: #333;
                    margin-bottom: 10px;
                }

                .page-title p {
                    font-size: 16px;
                    color: #666;
                }
            </style>

            <style>
                /* Remove old combo styles and add new coupon-like styles */
                .combo-product {
                    border: 2px dashed #80b435;
                    padding: 20px;
                    margin-bottom: 30px;
                    border-radius: 8px;
                    background-color: #fff;
                    transition: all 0.3s ease;
                }

                .combo-product:hover {
                    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                    transform: translateY(-2px);
                }

                .combo-header {
                    border-bottom: 1px solid #eee;
                    padding-bottom: 15px;
                    margin-bottom: 15px;
                    text-align: center;
                }

                .combo-price {
                    display: flex;
                    justify-content: space-between;
                    margin-top: 15px;
                    font-size: 14px;
                    color: #888;
                }

                .combo-badge {
                    background-color: #e74c3c;
                    color: white;
                    padding: 5px 10px;
                    border-radius: 3px;
                    font-size: 12px;
                    font-weight: bold;
                }

                /* Update product image styling */
                .product-img {
                    width: 100%;
                    height: 200px;
                    position: relative;
                    overflow: hidden;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 15px;
                }

                /* Modify buttons to match coupon style */
                .add-to-cart-btn {
                    background-color: #80b435 !important;
                    border: none !important;
                    width: 100%;
                    text-align: center;
                }

                .view-details-btn {
                    background-color: #f8f9fa !important;
                    border: 1px solid #ddd !important;
                    color: #333 !important;
                    width: 100%;
                    margin-top: 10px !important;
                }
            </style>

            <style>
                /* Add these pagination styles */
                .pagination-area {
                    display: flex;
                    justify-content: center;
                    margin-top: 40px;
                }

                .pagination-content {
                    display: flex;
                    list-style: none;
                    padding: 0;
                    margin: 0;
                    gap: 5px;
                }

                .pagination-content li {
                    display: inline-block;
                }

                .pagination-content li a {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    width: 40px;
                    height: 40px;
                    border: 1px solid #ddd;
                    color: #666;
                    border-radius: 4px;
                    text-decoration: none;
                    transition: all 0.3s ease;
                }

                .pagination-content li.active a {
                    background-color: #80b435;
                    border-color: #80b435;
                    color: #fff;
                }

                .pagination-content li a:hover:not(.active) {
                    background-color: #f8f9fa;
                    border-color: #80b435;
                    color: #80b435;
                }

                .pagination-content li a i {
                    font-size: 18px;
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
                                <h1>Combo</h1>
                            </div>
                            <div class="breadcrumb-content breadcrumb-content-tow">
                                <ul>
                                    <li><a href="home">Home</a></li>
                                    <li class="active">Combo</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                <!--Breadcrumb One End-->
                <!--Shop Area Start-->
                <div class="shop-area mb-70">
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title">
                                    <h1>Combo Sản Phẩm</h1>
                                    <p>Tiết kiệm hơn với các combo sản phẩm đặc biệt của chúng tôi</p>
                                </div>
                                
                                <!-- Add search form similar to coupons -->
                                <div class="coupon-search mb-5">
                                    <form action="${pageContext.request.contextPath}/combo" method="get">
                                        <div class="input-group">
                                            <input type="text" class="form-control" name="search" value="${searchTerm}" placeholder="Tìm kiếm combo...">
                                            <div class="input-group-append">
                                                <button class="btn btn-outline-secondary" type="submit">Tìm kiếm</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <div class="row">
                                    <c:forEach items="${combos}" var="combo">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="combo-product">
                                                <div class="combo-header">
                                                    <span class="combo-badge">Tiết kiệm <fmt:formatNumber value="${combo.originalPrice - combo.discountPrice}"/>đ</span>
                                                    <h2 style="margin-top: 15px;">
                                                        <a href="${pageContext.request.contextPath}/combo?action=details&id=${combo.comboId}">${combo.name}</a>
                                                    </h2>
                                                </div>
                                                
                                                <div class="product-img">
                                                    <img src="${pageContext.request.contextPath}/${combo.image}" alt="${combo.name}" class="product-image">
                                                </div>

                                                <div class="combo-price">
                                                    <div>
                                                        <del><fmt:formatNumber value="${combo.originalPrice}"/>đ</del>
                                                        <div class="text-success" style="font-size: 1.2em; font-weight: bold;">
                                                            <fmt:formatNumber value="${combo.discountPrice}"/>đ
                                                        </div>
                                                    </div>
                                                    <div class="product-action">
                                                        <a href="${pageContext.request.contextPath}/combo?action=details&id=${combo.comboId}" class="view-details-btn">Xem chi tiết</a>
                                                        <a href="${pageContext.request.contextPath}/cart?action=add&comboId=${combo.comboId}&quantity=1" class="add-to-cart-btn">Thêm vào giỏ</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    
                                    <c:if test="${empty combos}">
                                        <div class="col-12 text-center">
                                            <p>Không có combo nào được tìm thấy.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Replace the pagination HTML structure -->
                            ## 3. Let's also update the pagination links to maintain the search parameter:
                            ```html
                            <c:if test="${totalPages > 1}">
                                <div class="col-12">
                                    <div class="pagination-area">
                                        <ul class="pagination-content">
                                            <c:if test="${currentPage > 1}">
                                                <li>
                                                    <a href="${pageContext.request.contextPath}/combo?page=${currentPage - 1}${searchQueryString}">
                                                        <i class="fa fa-angle-left"></i>
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                <li class="${currentPage == i ? 'active' : ''}">
                                                    <a href="${pageContext.request.contextPath}/combo?page=${i}${searchQueryString}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li>
                                                    <a href="${pageContext.request.contextPath}/combo?page=${currentPage + 1}${searchQueryString}">
                                                        <i class="fa fa-angle-right"></i>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </div>
                            </c:if>
                            ```
                        </div>
                    </div>
                </div>
                <!--Shop Area End-->
                <!--Footer Area Start-->
                <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
                <!--Footer Area End-->
            </div>

            <!--All Js Here-->
            <jsp:include page="/view/common/home/common-js.jsp"></jsp:include>
        </body>
    </html>