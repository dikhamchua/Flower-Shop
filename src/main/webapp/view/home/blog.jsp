<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Blog || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow">
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <style>
            .iziToast-wrapper {
                z-index: 99999 !important;
            }
            .iziToast {
                min-width: 300px;
            }
            /* Slider styling for blog page */
            .slider-carousel {
                margin-bottom: 30px;
            }

            #blogSliderCarousel {
                border-radius: 8px;
                overflow: hidden; /* Prevents slider image overflow */
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            #blogSliderCarousel .carousel-inner {
                height: 300px; /* Fixed height for slider */
            }

            #blogSliderCarousel .carousel-item {
                height: 100%;
            }

            #blogSliderCarousel .carousel-item img {
                width: 100%;
                height: 100%;
                object-fit: contain; /* Shows the entire image without cropping */
                object-position: center; /* Centers the image */
            }

            /* Improve slider controls visibility */
            #blogSliderCarousel .carousel-control-prev,
            #blogSliderCarousel .carousel-control-next {
                width: 40px;
                height: 40px;
                background-color: rgba(0,0,0,0.3);
                border-radius: 50%;
                top: 50%;
                transform: translateY(-50%);
                margin: 0 15px;
            }

            #blogSliderCarousel .carousel-control-prev-icon,
            #blogSliderCarousel .carousel-control-next-icon {
                width: 20px;
                height: 20px;
            }

            /* Improved blog layout styling */
            .blog_area {
                padding: 0 15px;
            }

            .blog_single {
                margin-bottom: 40px;
                border-bottom: 1px solid #eee;
                padding-bottom: 30px;
                text-align: left;
            }

            .blog_single:last-child {
                border-bottom: none;
            }

            .entry-header {
                margin-bottom: 20px;
                text-align: left;
            }

            .entry-title {
                font-size: 24px;
                margin-bottom: 15px;
                font-weight: 600;
                text-align: left;
            }

            .entry-title a {
                color: #333;
                transition: color 0.3s;
            }

            .entry-title a:hover {
                color: #80b435;
            }

            .post-author, .blog-post-date {
                font-size: 14px;
                color: #777;
            }

            .post-separator {
                margin: 0 8px;
                color: #ccc;
            }

            .postinfo-wrapper {
                text-align: left;
            }

            .entry-summary {
                margin-bottom: 20px;
                line-height: 1.6;
            }

            .form-button {
                display: inline-block;
                padding: 8px 20px;
                background-color: #80b435;
                color: white;
                border-radius: 4px;
                text-decoration: none;
                transition: background-color 0.3s;
                margin-bottom: 15px;
            }

            .form-button:hover {
                background-color: #6a9a2d;
                color: white;
            }

            /* Blog sidebar styling */
            .blog_sidebar {
                background-color: #f9f9f9;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .product-filter h5 {
                font-size: 18px;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
                text-align: left;
            }

            .blog_Archives__sidbar ul {
                list-style: none;
                padding-left: 0;
                text-align: left;
            }

            .blog_Archives__sidbar ul li {
                padding: 8px 0;
                border-bottom: 1px dashed #eee;
            }

            .blog_Archives__sidbar ul li:last-child {
                border-bottom: none;
            }

            .blog_Archives__sidbar ul li a {
                color: #555;
                transition: color 0.3s;
            }

            .blog_Archives__sidbar ul li a:hover {
                color: #80b435;
            }

            /* Blog search styling */
            .blog-search {
                margin-bottom: 30px;
            }

            .blog-search .form-control {
                border-radius: 4px 0 0 4px;
                height: 45px;
            }

            .blog-search .btn {
                border-radius: 0 4px 4px 0;
                background-color: #80b435;
                color: white;
                border-color: #80b435;
            }

            .blog-search .btn:hover {
                background-color: #6a9a2d;
                border-color: #6a9a2d;
            }

            /* Pagination styling */
            .pagination-wrapper {
                margin-top: 30px;
            }

            .pagination .page-item.active .page-link {
                background-color: #007bff; /* Blue color instead of green */
                border-color: #007bff;
                color: white;
            }

            .pagination .page-item .page-link:hover {
                background-color: #0056b3;
                border-color: #0056b3;
                color: white;
            }

            /* Social sharing styling */
            .social-sharing {
                margin-top: 20px;
                text-align: left;
            }

            .widget-title {
                font-size: 16px;
                margin-bottom: 10px;
            }

            .blog-social-icons {
                list-style: none;
                padding-left: 0;
                display: flex;
                gap: 10px;
            }

            .blog-social-icons li a {
                display: inline-block;
                width: 36px;
                height: 36px;
                line-height: 36px;
                text-align: center;
                background-color: #f5f5f5;
                border-radius: 50%;
                color: #555;
                transition: all 0.3s;
            }

            .blog-social-icons li a:hover {
                background-color: #80b435;
                color: white;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .entry-title {
                    font-size: 20px;
                }
                
                .blog_sidebar {
                    margin-top: 40px;
                }
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
                                <h1>Blog</h1>
                            </div>
                            <div class="breadcrumb-content breadcrumb-content-tow">
                                <ul>
                                    <li><a href="home">Home</a></li>
                                    <li class="active">Blog</li>
                                </ul>
                            </div>
                            <!-- Slider Carousel -->
                            <div class="slider-carousel mt-4">
                                <div id="blogSliderCarousel" class="carousel slide" data-bs-ride="carousel">
                                    <div class="carousel-inner">
                                        <c:set var="count" value="0" />
                                        <c:forEach var="slider" items="${sliders}">
                                            <div class="carousel-item ${count == 0 ? 'active' : ''}">
                                                <a href="#">
                                                    <img src="${slider.imageUrl}" alt="${slider.caption}" class="d-block w-100">
                                                </a>
                                            </div>
                                            <c:set var="count" value="${count + 1}" />
                                        </c:forEach>
                                        
                                        <!-- If no sliders are available, show default image -->
                                        <c:if test="${empty sliders}">
                                            <div class="carousel-item active">
                                                <img src="${pageContext.request.contextPath}/assets/img/page-banner/blog-banner.jpg" alt="Blog Banner" class="d-block w-100">
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Only show controls if there are multiple sliders -->
                                    <c:if test="${fn:length(sliders) > 1}">
                                        <button class="carousel-control-prev" type="button" data-bs-target="#blogSliderCarousel" data-bs-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Previous</span>
                                        </button>
                                        <button class="carousel-control-next" type="button" data-bs-target="#blogSliderCarousel" data-bs-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Next</span>
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb Tow End-->
            <!--Blog Area Start-->
            <div class="blog-area white-bg pt-0 pb-0 mb-70">
                <div class="container">
                    <div class="row">
                        <!--Blog Post Start-->
                        <div class="col-lg-9">
                            <div class="blog_area">
                                <!-- Search form -->
                                <div class="blog-search mb-50">
                                    <form action="blog" method="get">
                                        <div class="input-group">
                                            <input type="text" class="form-control" name="search" value="${searchTitle}" placeholder="Search blogs...">
                                            <div class="input-group-append">
                                                <button class="btn btn-outline-secondary" type="submit">Search</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                
                                <c:if test="${empty blogs}">
                                    <div class="alert alert-info">No blogs found.</div>
                                </c:if>
                                
                                <c:forEach var="blog" items="${blogs}">
                                    <article class="blog_single">
                                        <header class="entry-header">
                                            <h2 class="entry-title">
                                                <a href="blog?action=detail&id=${blog.id}">${blog.title}</a>
                                            </h2>
                                            <span class="post-author">
                                                <span class="post-by"> Posted by: </span> Admin </span>
                                            <span class="post-separator">|</span>
                                            <span class="blog-post-date">
                                                <i class="fas fa-calendar-alt"></i>
                                                <fmt:formatDate value="${blog.createdAt}" pattern="MMMM dd, yyyy" />
                                            </span>
                                        </header>
                                        
                                        <div class="postinfo-wrapper">
                                            <div class="post-info">
                                                <div class="entry-summary">
<!--                                                    <p>${blog.content.length() > 200 ? blog.content.substring(0, 200).concat("...") : blog.content}</p>-->
                                                    <a href="blog?action=detail&id=${blog.id}" class="form-button">Read More</a>
<!--                                                    <div class="social-sharing">
                                                        <div class="widget widget_socialsharing_widget">
                                                            <h3 class="widget-title">Share this post</h3>
                                                            <ul class="blog-social-icons">
                                                                <li>
                                                                    <a target="_blank" title="Facebook" href="#" class="facebook social-icon">
                                                                        <i class="fa fa-facebook"></i>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a target="_blank" title="twitter" href="#" class="twitter social-icon">
                                                                        <i class="fa fa-twitter"></i>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a target="_blank" title="pinterest" href="#" class="pinterest social-icon">
                                                                        <i class="fa fa-pinterest"></i>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a target="_blank" title="linkedin" href="#" class="linkedin social-icon">
                                                                        <i class="fa fa-linkedin"></i>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </div>-->
                                                </div>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                                
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="pagination-wrapper">
                                                <ul class="pagination">
                                                    <c:if test="${currentPage > 1}">
                                                        <li class="page-item">
                                                            <a class="page-link" href="blog?page=${currentPage - 1}${searchTitle != null ? '&search='.concat(searchTitle) : ''}">
                                                                <i class="fa fa-angle-left"></i> Previous
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                    
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                            <a class="page-link" href="blog?page=${i}${searchTitle != null ? '&search='.concat(searchTitle) : ''}">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    
                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="page-item">
                                                            <a class="page-link" href="blog?page=${currentPage + 1}${searchTitle != null ? '&search='.concat(searchTitle) : ''}">
                                                                Next <i class="fa fa-angle-right"></i>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <!--Blog Post End-->
                        <!--Blog Sidebar Start-->
                        <div class="col-lg-3">
                            <div class="blog_sidebar">
                                <div class="row_products_side">
                                    <div class="product_left_sidbar">
<!--                                        <div class="product-filter mb-35">
                                            <h5>Search </h5>
                                            <div class="search__sidbar">
                                                <div class="input_form">
                                                    <form action="blog" method="get">
                                                        <input id="search_input" name="search" value="${searchTitle}" placeholder="Search..." class="input_text" type="text">
                                                        <button id="blogsearchsubmit" type="submit" class="button">
                                                            <i class="fa fa-search"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>-->
                                        <div class="product-filter mb-35">
                                            <h5>Recent Posts</h5>
                                            <div class="blog_Archives__sidbar">
                                                <ul>
                                                    <c:forEach var="blog" items="${blogs}" end="4">
                                                        <li>
                                                            <a href="blog?action=detail&id=${blog.id}">${blog.title}</a>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="product-filter  mb-35">
                                            <div class="sidebar-banner single-banner">
                                                <div class="banner-img">
                                                    <a href="#"><img src="img/banner/shop-sidebar.jpg" alt=""></a>
                                                </div>
                                            </div>
                                        </div>

<!--                                        <div class="product-filter mb-35">
                                            <h5>tags</h5>
                                            <div class="product-tag blog-tag">
                                                <ul>
                                                    <li><a href="#">brand</a></li>
                                                    <li><a href="#">black</a></li>
                                                    <li><a href="#">white</a></li>
                                                    <li><a href="#">chire</a></li>
                                                    <li><a href="#">table</a></li>
                                                    <li><a href="#">Lorem</a></li>
                                                    <li><a href="#">ipsum</a></li>
                                                    <li><a href="#">dolor</a></li>
                                                    <li><a href="#">sit</a></li>
                                                    <li><a href="#">amet</a></li>
                                                </ul>
                                            </div>
                                        </div>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--Blog Sidebar End-->
                    </div>
                </div>
            </div>
            <!--Blog Area End-->
            <!--Brand Area Start-->
<!--                <div class="brand-area mb-105">
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="brand-active">
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand1.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand2.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand3.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand4.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand5.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand3.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand4.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                    Single Brand Start
                                    <div class="single-brand img-full">
                                        <a href="#"><img src="img/brand/brand5.png" alt=""></a>
                                    </div>
                                    Single Brand End
                                </div>
                            </div>
                        </div>
                    </div>
                </div>-->
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
                                            <h1>Sit voluptatem</h1>
                                            <div class="modal-product-price">
                                                <span class="old-price">$74.00</span>
                                                <span class="new-price">$69.00</span>
                                            </div>
                                            <a href="single-product.html" class="see-all">See all features</a>
                                            <div class="add-to-cart quantity">
                                                <form class="add-quantity" action="#">
                                                    <div class="modal-quantity">
                                                        <input type="number" value="1">
                                                    </div>
                                                    <div class="add-to-link">
                                                        <button class="form-button" data-text="add to cart">add to cart</button>
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

            <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
        <script>
            // Toast message display
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000
                });
                
                // Remove toast attributes from session
                fetch('${pageContext.request.contextPath}/remove-toast', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    }
                }).catch(error => {
                    console.error('Error:', error);
                });
            }
        </script>
    </body>
</html>
