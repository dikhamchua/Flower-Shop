<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Shop || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow" />
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>
       

    </head>
    <body>

        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            <!--Shop Area Start-->
            <div class="shop-area mb-70">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-3 order-2 order-lg-1">
                        <jsp:include page="/view/common/home/sidebar.jsp"></jsp:include>
                        </div>
                        <div class="col-lg-9 order-1 order-lg-2">
                            <div class="shop-layout">
                                <!--Breadcrumb One Start-->
                                <div class="breadcrumb-one mb-120">
                                    <div class="breadcrumb-img">
                                        <img src="${pageContext.request.contextPath}/assets/img/page-banner/shop-banner-1.jpg" alt="">
                                    </div>
                                    <div class="breadcrumb-content">
                                        <ul>
                                            <li><a href="index.html">Home</a></li>
                                            <li class="active">Shop</li>
                                        </ul>
                                    </div>
                                </div>
                                <!--Breadcrumb One End-->
                                <!--Grid & List View Start-->
                                <div class="shop-topbar-wrapper d-md-flex justify-content-md-between align-items-center">
                                    <div class="grid-list-option">
                                        <ul class="nav">
                                            <li>
                                                <a class="active" data-bs-toggle="tab" href="#grid"><i class="fa fa-th-large"></i></a>
                                            </li>
                                            <li>
                                                <a data-bs-toggle="tab" href="#list"><i class="fa fa-th-list"></i></a>
                                            </li>
                                        </ul>
                                    </div>
                                    <!--Toolbar Short Area Start-->
                                    <div class="toolbar-short-area d-md-flex align-items-center">
                                        <div class="toolbar-shorter ">
                                            <label>Sort By:</label>
                                            <select class="wide">
                                                <option data-display="Select">Nothing</option>
                                                <option value="Relevance">Relevance</option>
                                                <option value="Name, A to Z">Name, A to Z</option>
                                                <option value="Name, Z to A">Name, Z to A</option>
                                                <option value="Price, low to high">Price, low to high</option>
                                                <option value="Price, high to low">Price, high to low</option>
                                            </select>
                                        </div>
                                        <p class="show-product">Showing 1–9 of 42 results</p>
                                    </div>
                                    <!--Toolbar Short Area End-->
                                </div>
                                <!--Grid & List View End-->
                                <!--Shop Product Start-->
                                <div class="shop-product">
                                    <div id="myTabContent-2" class="tab-content">
                                        <div id="grid" class="tab-pane fade show active">
                                            <div class="product-grid-view">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product1.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product2.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Aliquam lobortis</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$148.00</span>
                                                                        <span class="regular-price">$145.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product24.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Aliquam sit amet</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$110.00</span>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product23.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Aliquet auctor sem</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$80.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product22.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Aliquet auctor sem</a></h2>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product1.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product23.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Condimentum posuere</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$120.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product20.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Convallis furniture</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$75.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product19.jpg" alt="">
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
                                                                        <span class="regular-price">$95.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product18.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Curabitur a purus</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$82.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product17.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Diam vel neque</a></h2>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product16.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Dignissim furniture</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$80.00</span>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single Product End-->
                                                    </div>
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product15.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Dignissim venenatis</a></h2>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product14.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Auctor sem</a></h2>
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
                                                    <div class="col-md-4">
                                                        <!--Single Product Start-->
                                                        <div class="single-product mb-25">
                                                            <div class="product-img img-full">
                                                                <a href="single-product.html">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/product/product1.jpg" alt="">
                                                                </a>
                                                                <span class="onsale">Sale!</span>
                                                                <div class="product-action">
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="product-content">
                                                                <h2><a href="single-product.html">Convallis quam sit</a></h2>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$130.00</span>
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
                                        <div id="list" class="tab-pane fade">
                                            <div class="product-list-view">
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product9.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Aliquam furniture</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$125.00</span>
                                                                        <span class="regular-price">$115.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product14.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Aliquam sit amet</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$100.00</span>
                                                                        <span class="regular-price">$90.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product15.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Aliquam sit amet</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$90.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product10.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Aliquet auctor sem</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$75.00</span>
                                                                        <span class="regular-price">$50.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product16.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Auctor gravida enim</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$85.00</span>
                                                                        <span class="regular-price">$60.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product7.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Auctor sem</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$100.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product2.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Commodo dolor</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$80.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product18.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Condimentum furniture</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$115.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product19.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Condimentum posuere</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$125.00</span>
                                                                        <span class="regular-price">$115.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product3.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Convallis furniture</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$75.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product20.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Convallis quam sit</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$95.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product21.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Curabitur a purus</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$115.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product11.jpg" alt="">
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Diam vel neque</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="regular-price">$40.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                                <div class="product-list-item mb-40">
                                                    <div class="row">
                                                        <!--Single List Product Start-->
                                                        <div class="col-md-4">
                                                            <div class="single-product">
                                                                <div class="product-img img-full">
                                                                    <a href="single-product.html">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/product/product23.jpg" alt="">
                                                                    </a>
                                                                    <span class="onsale">Sale!</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <div class="product-content shop-list">
                                                                <h2><a href="single-product.html">Dignissim furniture</a></h2>
                                                                <div class="product-reviews">
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star"></i>
                                                                    <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <div class="product-description">
                                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere metus vitae arcu imperdiet, id aliquet ante scelerisque. Sed sit amet sem vitae urna fringilla tempus.</p>
                                                                </div>
                                                                <div class="product-price">
                                                                    <div class="price-box">
                                                                        <span class="price">$175.00</span>
                                                                        <span class="regular-price">$150.00</span>
                                                                    </div>
                                                                </div>
                                                                <div class="product-list-action">
                                                                    <div class="add-btn">
                                                                        <a href="#">Add To Cart</a>
                                                                    </div>
                                                                    <ul>
                                                                        <li><a href="#open-modal" data-bs-toggle="modal" title="Quick view"><i class="fa fa-search"></i></a></li>
                                                                        <li><a href="#" title="Whishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                        <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--Single List Product End-->
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--Pagination Start-->
                                        <div class="product-pagination">
                                            <ul>
                                                <li class="active"><a href="#">1</a></li>
                                                <li><a href="#">2</a></li>
                                                <li><a href="#">3</a></li>
                                                <li><a href="#">4</a></li>
                                                <li><a href="#">5</a></li>
                                                <li><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
                                            </ul>
                                        </div>
                                        <!--Pagination End-->
                                    </div>
                                </div>
                                <!--Shop Product End-->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Shop Area End-->
            <!--Brand Area Start-->
            <jsp:include page="/view/common/home/brand.jsp"></jsp:include>
            <!--Brand Area End-->
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
            <!-- Modal Area Strat -->
            <jsp:include page="/view/common/home/modalProductDetails.jsp"></jsp:include>
            <!-- Modal Area End -->
        </div>





        <!--All Js Here-->
    <jsp:include page="../common/home/common-js.jsp"></jsp:include>
    </body>
</html>
