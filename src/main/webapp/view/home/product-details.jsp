<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${product.productName} - Flower Shop</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow" />
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>

        <style>
            /* Override any existing price styling */
            .single-product-price .price {
                text-decoration: none !important;  /* Ngăn chặn gạch ngang */
                font-size: 24px;
                font-weight: 600;
                color: #333;
            }
            
            /* Ẩn các class có thể gây gạch ngang */
            .old-price,
            .new-price {
                text-decoration: none !important;
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
                <div class="breadcrumb-one mb-120">
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="breadcrumb-img">
                                    <img src="${pageContext.request.contextPath}/img/page-banner/product-banner.jpg" alt="">
                                </div>
                                <div class="breadcrumb-content">
                                    <ul>
                                        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                                        <li><a href="${pageContext.request.contextPath}/home">Shop</a></li>
                                        <li><a href="${pageContext.request.contextPath}/home?categories=${product.categoryId}">${categoryName}</a></li>
                                        <li class="active">${product.productName}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Breadcrumb One End-->
                <!--Single Product Area Start-->
                <div class="single-product-area mb-115">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-12 col-lg-5">
                                <div class="product-details-img-tab">
                                    <!--Product Tab Content Start-->
                                    <div class="tab-content single-product-img">
                                        <div class="tab-pane fade show active" id="product1">
                                            <div class="product-large-thumb img-full">
                                                <div class="easyzoom easyzoom--overlay">
                                                    <a href="${product.image}">
                                                        <img src="${product.image}" alt="${product.productName}">
                                                    </a>
                                                    <a href="${product.image}" class="popup-img venobox" data-gall="myGallery"><i class="fa fa-search"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Product Tab Content End-->
                                    <!--Product Tab Menu Start-->
                                    <div class="product-menu">
                                        <div class="nav product-tab-menu">
                                            <div class="product-details-img">
                                                <a class="active" data-bs-toggle="tab" href="#product1"><img src="${product.image}" alt="${product.productName}"></a>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Product Tab Menu End-->
                                </div>
                            </div>
                            <div class="col-md-12 col-lg-7">
                                <!--Product Details Content Start-->
                                <div class="product-details-content">
                                    <!--Product Nav Start-->
                                    <div class="product-nav">
                                        <a href="#"><i class="fa fa-angle-left"></i></a>
                                        <a href="#"><i class="fa fa-angle-right"></i></a>
                                    </div>
                                    <!--Product Nav End-->
                                    <h2>${product.productName}</h2>
                                    <div class="single-product-reviews">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star-o"></i>
                                        <a class="review-link" href="#">(1 customer review)</a>
                                    </div>
                                    <div class="single-product-price">
                                        <span class="price">
                                            <fmt:formatNumber value="${product.price}" pattern="#,##0"/> VND
                                        </span>
                                    </div>
                                    <div class="single-product-quantity">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.account}">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" id="addToCartForm">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <div class="product-quantity">
                                                        <div class="cart-plus-minus">
                                                            <input class="cart-plus-minus-box" type="text" name="quantity" value="1" min="1">
                                                            <div class="qtybutton-container">
                                                                <div class="inc qtybutton">▲</div>
                                                                <div class="dec qtybutton">▼</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="add-to-link">
                                                        <button class="product-btn" type="submit">Add to cart</button>
                                                    </div>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-quantity">
                                                    <div class="cart-plus-minus">
                                                        <input class="cart-plus-minus-box" type="text" value="1" disabled>
                                                        <div class="qtybutton-container">
                                                            <div class="inc qtybutton">▲</div>
                                                            <div class="dec qtybutton">▼</div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="add-to-link">
                                                    <button class="product-btn login-required">Add to cart</button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="wishlist-compare-btn">
                                        <a href="#" class="wishlist-btn">Add to Wishlist</a>
                                        <a href="#" class="add-compare">Compare</a>
                                    </div>
                                    <div class="product-meta">
                                        <span class="posted-in">
                                            Category: 
                                            <a href="${pageContext.request.contextPath}/home?categories=${product.categoryId}">${categoryName}</a>
                                        </span>
                                    </div>
                                    <div class="single-product-sharing">
                                        <h3>Share this product</h3>
                                        <ul>
                                            <li><a href="#"><i class="fa fa-facebook"></i></a></li>
                                            <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                                            <li><a href="#"><i class="fa fa-pinterest"></i></a></li>
                                            <li><a href="#"><i class="fa fa-google-plus"></i></a></li>
                                            <li><a href="#"><i class="fa fa-instagram"></i></a></li>
                                        </ul>
                                    </div>
                                </div>
                                <!--Product Details Content End-->
                            </div>
                        </div>
                    </div>
                </div>
                <!--Single Product Area End-->
                <!--Product Description Review Area Start-->
                <div class="product-description-review-area mb-100">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="product-review-tab">
                                    <!--Review And Description Tab Menu Start-->
                                    <ul class="nav dec-and-review-menu">
                                        <li>
                                            <a class="active" data-bs-toggle="tab" href="#description">Description</a>
                                        </li>
                                        <li>
                                            <a data-bs-toggle="tab" href="#reviews">Reviews</a>
                                        </li>
                                    </ul>
                                    <!--Review And Description Tab Menu End-->
                                    <!--Review And Description Tab Content Start-->
                                    <div class="tab-content product-review-content-tab" id="myTabContent-4">
                                        <div class="tab-pane fade active show" id="description">
                                            <div class="single-product-description">
                                                <p>${product.description}</p>
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="reviews">
                                            <div class="review-page-comment">
                                                <c:choose>
                                                    <c:when test="${not empty productFeedbacks}">
                                                        <h2>${productFeedbacks.size()} review(s) for ${product.productName}</h2>
                                                        <ul>
                                                            <c:forEach items="${productFeedbacks}" var="feedback">
                                                                <li>
                                                                    <div class="product-comment">
                                                                        <img src="${pageContext.request.contextPath}/img/icon/author.png" alt="">
                                                                        <div class="product-comment-content">
                                                                            <div class="product-reviews">
                                                                                <c:forEach begin="1" end="5" var="i">
                                                                                    <c:choose>
                                                                                        <c:when test="${i <= feedback.rating}">
                                                                                            <i class="fa fa-star"></i>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <i class="fa fa-star-o"></i>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:forEach>
                                                                            </div>
                                                                            <p class="meta">
                                                                                <strong>${feedback.userName}</strong> - 
                                                                                <span><fmt:formatDate value="${feedback.createdAt}" pattern="MMMM dd, yyyy" /></span>
                                                                            </p>
                                                                            <div class="description">
                                                                                <p>${feedback.content}</p>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <h2>No reviews yet for ${product.productName}</h2>
                                                        <p>Be the first to review this product!</p>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <div class="review-form-wrapper">
                                                    <div class="review-form">
                                                        <span class="comment-reply-title">Add a review </span>
                                                        <c:choose>
                                                            <c:when test="${not empty sessionScope.account}">
                                                                <c:choose>
                                                                    <c:when test="${canReview}">
                                                                        <form action="${pageContext.request.contextPath}/feedbackControl" method="post">
                                                                            <input type="hidden" name="action" value="submit-product-review">
                                                                            <input type="hidden" name="productId" value="${product.productId}">
                                                                            
                                                                            <div class="comment-form-rating">
                                                                                <label>Your rating</label>
                                                                                <div class="rating-stars">
                                                                                    <input type="radio" id="star5" name="rating" value="5" required />
                                                                                    <label for="star5" title="5 stars"><i class="fa fa-star"></i></label>
                                                                                    
                                                                                    <input type="radio" id="star4" name="rating" value="4" />
                                                                                    <label for="star4" title="4 stars"><i class="fa fa-star"></i></label>
                                                                                    
                                                                                    <input type="radio" id="star3" name="rating" value="3" />
                                                                                    <label for="star3" title="3 stars"><i class="fa fa-star"></i></label>
                                                                                    
                                                                                    <input type="radio" id="star2" name="rating" value="2" />
                                                                                    <label for="star2" title="2 stars"><i class="fa fa-star"></i></label>
                                                                                    
                                                                                    <input type="radio" id="star1" name="rating" value="1" />
                                                                                    <label for="star1" title="1 star"><i class="fa fa-star"></i></label>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                            <div class="input-element">
                                                                                <div class="comment-form-comment">
                                                                                    <label>Your review</label>
                                                                                    <textarea name="content" required></textarea>
                                                                                </div>
                                                                                <div class="form-submit">
                                                                                    <input type="submit" value="Submit" class="comment-submit">
                                                                                </div>
                                                                            </div>
                                                                        </form>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p class="review-notice">You can only review products you've purchased.</p>
                                                                        <p>Please purchase this product to leave a review.</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <p class="review-notice">Please <a href="${pageContext.request.contextPath}/authen?action=login">log in</a> to leave a review.</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Review And Description Tab Content End-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Product Description Review Area Start-->
                <!--Also Like Product Start-->
                <div class="also-like-product">
                    <div class="container">
                        <div class="row">
                            <!--Section Title Start-->
                            <div class="col-12">
                                <div class="section-title text-center mb-35">
                                    <h3>You may also like…</h3>
                                </div>
                            </div>
                            <!--Section Title End-->
                        </div>
                        <div class="row">
                            <div class="product-slider-active p-0">
                                <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                    <!--Single Product Start-->
                                    <div class="single-product mb-25">
                                        <div class="product-img img-full">
                                            <a href="single-product.html">
                                                <img src="img/product/product1.jpg" alt="">
                                            </a>
                                            <div class="product-action">
                                                <ul>
                                                    <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                    <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                    <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-content">
                                            <h2><a href="single-product.html">Eleifend quam</a></h2>
                                            <div class="product-price">
                                                <div class="price-box">
                                                    <span class="regular-price">$115.00</span>
                                                </div>
                                                <div class="add-to-cart">
                                                    <a href="#">Add To Cart</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Single Product End-->
                                </div>
                                <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                    <!--Single Product Start-->
                                    <div class="single-product mb-25">
                                        <div class="product-img img-full">
                                            <a href="single-product.html">
                                                <img src="img/product/product3.jpg" alt="">
                                            </a>
                                            <div class="product-action">
                                                <ul>
                                                    <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                    <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                    <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-content">
                                            <h2><a href="single-product.html">Nulla sed stg</a></h2>
                                            <div class="product-price">
                                                <div class="price-box">
                                                    <span class="regular-price">$40.00</span>
                                                </div>
                                                <div class="add-to-cart">
                                                    <a href="#">Add To Cart</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Single Product End-->
                                </div>
                                <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                    <!--Single Product Start-->
                                    <div class="single-product mb-25">
                                        <div class="product-img img-full">
                                            <a href="single-product.html">
                                                <img src="img/product/product5.jpg" alt="">
                                            </a>
                                            <div class="product-action">
                                                <ul>
                                                    <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                    <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                    <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-content">
                                            <h2><a href="single-product.html">Odio tortor consequat</a></h2>
                                            <div class="product-price">
                                                <div class="price-box">
                                                    <span class="regular-price">$90.00</span>
                                                </div>
                                                <div class="add-to-cart">
                                                    <a href="#">Add To Cart</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Single Product End-->
                                </div>
                                <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                    <!--Single Product Start-->
                                    <div class="single-product mb-25">
                                        <div class="product-img img-full">
                                            <a href="single-product.html">
                                                <img src="img/product/product7.jpg" alt="">
                                            </a>
                                            <div class="product-action">
                                                <ul>
                                                    <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                    <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                    <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-content">
                                            <h2><a href="single-product.html">Vulputate justo</a></h2>
                                            <div class="product-price">
                                                <div class="price-box">
                                                    <span class="regular-price">$70.00</span>
                                                </div>
                                                <div class="add-to-cart">
                                                    <a href="#">Add To Cart</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Single Product End-->
                                </div>
                                <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                    <!--Single Product Start-->
                                    <div class="single-product mb-25">
                                        <div class="product-img img-full">
                                            <a href="single-product.html">
                                                <img src="img/product/product9.jpg" alt="">
                                            </a>
                                            <div class="product-action">
                                                <ul>
                                                    <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                    <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                    <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-content">
                                            <h2><a href="single-product.html">Ipsum imperdie</a></h2>
                                            <div class="product-price">
                                                <div class="price-box">
                                                    <span class="regular-price">$100.00</span>
                                                </div>
                                                <div class="add-to-cart">
                                                    <a href="#">Add To Cart</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Single Product End-->
                                </div>
                                <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                    <!--Single Product Start-->
                                    <div class="single-product mb-25">
                                        <div class="product-img img-full">
                                            <a href="single-product.html">
                                                <img src="img/product/product11.jpg" alt="">
                                            </a>
                                            <div class="product-action">
                                                <ul>
                                                    <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                    <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                    <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-content">
                                            <h2><a href="single-product.html">Pellentesque position</a></h2>
                                            <div class="product-price">
                                                <div class="price-box">
                                                    <span class="regular-price">$90.00</span>
                                                </div>
                                                <div class="add-to-cart">
                                                    <a href="#">Add To Cart</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Single Product End-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Also Like Product End-->
                <!--Related Product Start-->
                <div class="Related-product mt-105 mb-100">
                    <div class="container">
                        <div class="row">
                            <!--Section Title Start-->
                            <div class="col-12">
                                <div class="section-title text-center mb-35">
                                    <h3>Related Products</h3>
                                </div>
                            </div>
                            <!--Section Title End-->
                        </div>
                        <div class="row">
                            <div class="product-slider-active p-0">
                                <c:forEach items="${relatedProducts}" var="relatedProduct">
                                    <div class="col-md-3 col-lg-3 col-sm-4 col-xs-12">
                                        <!--Single Product Start-->
                                        <div class="single-product mb-25">
                                            <div class="product-img img-full">
                                                <a href="${pageContext.request.contextPath}/home?action=product-details&id=${relatedProduct.productId}">
                                                    <img src="${relatedProduct.image}" alt="${relatedProduct.productName}">
                                                </a>
                                                <div class="product-action">
                                                    <ul>
                                                        <li><a href="${pageContext.request.contextPath}/home?action=product-details&id=${relatedProduct.productId}" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                        <li><a href="#" title="Wishlist"><i class="fa fa-heart-o"></i></a></li>
                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="product-content">
                                                <h2><a href="${pageContext.request.contextPath}/home?action=product-details&id=${relatedProduct.productId}">${relatedProduct.productName}</a></h2>
                                                <div class="product-price">
                                                    <div class="price-box">
                                                        <span class="regular-price">${relatedProduct.price} VND</span>
                                                    </div>
                                                    <div class="add-to-cart">
                                                        <a href="${pageContext.request.contextPath}/cart?action=add&productId=${relatedProduct.productId}&quantity=1">Add To Cart</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--Single Product End-->
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Related Product End-->
                <!--Brand Area Start-->
                <div class="brand-area mb-105">
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="brand-active">
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand1.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand2.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand3.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand4.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand5.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand3.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand4.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                    <!--Single Brand Start-->
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand5.png" alt=""></a>
                                    </div>
                                    <!--Single Brand End-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Brand Area End-->
                <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
                <!--Footer Area End-->
                <!-- Modal Area Strat -->
                <div class="modal fade" id="open-modal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close"><i class="fa fa-close"></i></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <!--Modal Img-->
                                    <div class="col-md-5">
                                        <!--Modal Tab Content Start-->
                                        <div class="tab-content product-details-large" id="myTabContent">
                                            <div class="tab-pane fade show active" id="single-slide1" role="tabpanel" aria-labelledby="single-slide-tab-1">
                                                <!--Single Product Image Start-->
                                                <div class="single-product-img img-full">
                                                    <img src="img/single-product/large/single-product1.jpg" alt="">
                                                </div>
                                                <!--Single Product Image End-->
                                            </div>
                                            <div class="tab-pane fade" id="single-slide2" role="tabpanel" aria-labelledby="single-slide-tab-2">
                                                <!--Single Product Image Start-->
                                                <div class="single-product-img img-full">
                                                    <img src="img/single-product/large/single-product2.jpg" alt="">
                                                </div>
                                                <!--Single Product Image End-->
                                            </div>
                                            <div class="tab-pane fade" id="single-slide3" role="tabpanel" aria-labelledby="single-slide-tab-3">
                                                <!--Single Product Image Start-->
                                                <div class="single-product-img img-full">
                                                    <img src="img/single-product/large/single-product3.jpg" alt="">
                                                </div>
                                                <!--Single Product Image End-->
                                            </div>
                                            <div class="tab-pane fade" id="single-slide4" role="tabpanel" aria-labelledby="single-slide-tab-4">
                                                <!--Single Product Image Start-->
                                                <div class="single-product-img img-full">
                                                    <img src="img/single-product/large/single-product4.jpg" alt="">
                                                </div>
                                                <!--Single Product Image End-->
                                            </div>
                                            <div class="tab-pane fade" id="single-slide5" role="tabpanel" aria-labelledby="single-slide-tab-4">
                                                <!--Single Product Image Start-->
                                                <div class="single-product-img img-full">
                                                    <img src="img/single-product/large/single-product5.jpg" alt="">
                                                </div>
                                                <!--Single Product Image End-->
                                            </div>
                                            <div class="tab-pane fade" id="single-slide6" role="tabpanel" aria-labelledby="single-slide-tab-4">
                                                <!--Single Product Image Start-->
                                                <div class="single-product-img img-full">
                                                    <img src="img/single-product/large/single-product6.jpg" alt="">
                                                </div>
                                                <!--Single Product Image End-->
                                            </div>
                                        </div>
                                        <!--Modal Content End-->
                                        <!--Modal Tab Menu Start-->
                                        <div class="single-product-menu">
                                            <div class="nav single-slide-menu owl-carousel" role="tablist">
                                                <div class="single-tab-menu img-full">
                                                    <a class="active" data-bs-toggle="tab" id="single-slide-tab-1" href="#single-slide1"><img src="img/single-product/small/single-product1.jpg" alt=""></a>
                                                </div>
                                                <div class="single-tab-menu img-full">
                                                    <a data-bs-toggle="tab" id="single-slide-tab-2" href="#single-slide2"><img src="img/single-product/small/single-product2.jpg" alt=""></a>
                                                </div>
                                                <div class="single-tab-menu img-full">
                                                    <a data-bs-toggle="tab" id="single-slide-tab-3" href="#single-slide3"><img src="img/single-product/small/single-product3.jpg" alt=""></a>
                                                </div>
                                                <div class="single-tab-menu img-full">
                                                    <a data-bs-toggle="tab" id="single-slide-tab-4" href="#single-slide4"><img src="img/single-product/small/single-product4.jpg" alt=""></a>
                                                </div>
                                                <div class="single-tab-menu img-full">
                                                    <a data-bs-toggle="tab" id="single-slide-tab-5" href="#single-slide5"><img src="img/single-product/small/single-product5.jpg" alt=""></a>
                                                </div>
                                                <div class="single-tab-menu img-full">
                                                    <a data-bs-toggle="tab" id="single-slide-tab-6" href="#single-slide6"><img src="img/single-product/small/single-product6.jpg" alt=""></a>
                                                </div>
                                            </div>
                                        </div>
                                        <!--Modal Tab Menu End-->
                                    </div>
                                    <!--Modal Img-->
                                    <!--Modal Content-->
                                    <div class="col-md-7">
                                        <div class="modal-product-info">
                                            <h1>${product.productName}</h1>
                                            <div class="modal-product-price">
                                                <span class="old-price">$74.00</span>
                                                <span class="new-price">$69.00</span>
                                            </div>
                                            <a href="single-product.html" class="see-all">See all features</a>
                                            <div class="add-to-cart quantity">
                                                <form class="add-quantity" action="${pageContext.request.contextPath}/cart" method="post">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <div class="modal-quantity">
                                                        <div class="cart-plus-minus">
                                                            <input class="cart-plus-minus-box" type="text" name="quantity" value="1">
                                                            <div class="qtybutton-container">
                                                                <div class="inc qtybutton">▲</div>
                                                                <div class="dec qtybutton">▼</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="add-to-link">
                                                        <button class="form-button" type="submit">Add to cart</button>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="cart-description">
                                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco,Proin lectus ipsum, gravida et mattis vulputate, tristique ut lectus.</p>
                                            </div>
                                            <div class="social-share">
                                                <h3>Share this product</h3>
                                                <ul class="socil-icon2">
                                                    <li><a href=""><i class="fa fa-facebook"></i></a></li>
                                                    <li><a href=""><i class="fa fa-twitter"></i></a></li>
                                                    <li><a href=""><i class="fa fa-pinterest"></i></a></li>
                                                    <li><a href=""><i class="fa fa-google-plus"></i></a></li>
                                                    <li><a href=""><i class="fa fa-linkedin"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <!--Modal Content-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal Area End -->
            </div>

            <!-- Toast Container -->
            <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
                <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-warning text-white">
                        <strong class="me-auto">Thông báo</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body"></div>
                </div>
            </div>

            <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        <script>
            $(document).ready(function() {
                // Xử lý nút thêm vào giỏ hàng
                $('.add-quantity').on('submit', function(e) {
                    e.preventDefault();
                    
                    const formData = $(this).serialize();
                    
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cart',
                        type: 'POST',
                        data: formData,
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        success: function(response) {
                            // Cập nhật số lượng sản phẩm trong giỏ hàng
                            $('.cart-count').text(response);
                            
                            // Hiển thị toast thông báo thành công
                            const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                            $('#cartToast').removeClass('bg-danger').addClass('bg-success');
                            $('#cartToast .toast-body').text('Sản phẩm đã được thêm vào giỏ hàng');
                            toast.show();
                            
                            // Auto hide toast after 3 seconds
                            setTimeout(function() {
                                toast.hide();
                            }, 3000);
                        },
                        error: function(xhr) {
                            // Hiển thị toast thông báo lỗi
                            const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                            $('#cartToast').removeClass('bg-success').addClass('bg-danger');
                            $('#cartToast .toast-body').text('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng');
                            toast.show();
                            
                            // Auto hide toast after 3 seconds
                            setTimeout(function() {
                                toast.hide();
                            }, 3000);
                        }
                    });
                });
                
                // Xử lý nút thêm vào giỏ hàng cho sản phẩm liên quan
                $('.add-to-cart').on('click', function(e) {
                    e.preventDefault();
                    
                    const productId = $(this).data('product-id');
                    
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cart',
                        type: 'POST',
                        data: { action: 'add', productId: productId, quantity: 1 },
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        success: function(response) {
                            // Cập nhật số lượng sản phẩm trong giỏ hàng
                            $('.cart-count').text(response);
                            
                            // Hiển thị toast thông báo thành công
                            const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                            $('#cartToast').removeClass('bg-danger').addClass('bg-success');
                            $('#cartToast .toast-body').text('Sản phẩm đã được thêm vào giỏ hàng');
                            toast.show();
                            
                            // Auto hide toast after 3 seconds
                            setTimeout(function() {
                                toast.hide();
                            }, 3000);
                        },
                        error: function(xhr) {
                            // Hiển thị toast thông báo lỗi
                            const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                            $('#cartToast').removeClass('bg-success').addClass('bg-danger');
                            $('#cartToast .toast-body').text('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng');
                            toast.show();
                            
                            // Auto hide toast after 3 seconds
                            setTimeout(function() {
                                toast.hide();
                            }, 3000);
                        }
                    });
                });
                
                // Xử lý nút "Add to cart" khi chưa đăng nhập
                $('.login-required').on('click', function(e) {
                    e.preventDefault();
                    
                    // Hiển thị thông báo
                    const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                    $('#cartToast .toast-body').text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng');
                    toast.show();
                    
                    // Chuyển hướng sau 2 giây
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/authen?action=login';
                    }, 2000);
                });
                
                // Tương tự cho nút "Add to Wishlist"
                $('.wishlist-btn').on('click', function(e) {
                    e.preventDefault();
                    
                    <c:if test="${empty sessionScope.account}">
                        alert('Vui lòng đăng nhập để thêm sản phẩm vào danh sách yêu thích');
                        setTimeout(function() {
                            window.location.href = '${pageContext.request.contextPath}/authen?action=login';
                        }, 1000);
                        return;
                    </c:if>
                    
                    // Xử lý thêm vào wishlist nếu đã đăng nhập
                    // ... existing code ...
                });
                
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
            });
        </script>

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

    </body>
</html>
