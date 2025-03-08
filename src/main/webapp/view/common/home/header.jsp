<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<header>
    <div class="header-container">
        <div class="header-area header-sticky pt-30 pb-30">
            <div class="container">
                <div class="row">
                    <!--Header Logo Start-->
                    <div class="col-lg-3 col-md-3">
                        <div class="logo-area">
                            <a href="index.html">
                                <img src="img/logo/logo.png" alt="">
                            </a>
                        </div>
                    </div>
                    <!--Header Logo End-->
                    <!--Header Menu And Mini Cart Start-->
                    <div class="col-lg-9 col-md-9 text-lg-right">
                        <!--Main Menu Area Start-->
                        <div class="header-menu">
                            <nav>
                                <ul class="main-menu">
                                    <li><a href="${pageContext.request.contextPath}/home">home</a>
                                    </li>
                                    <li><a href="shop.html">Shop</a></li>
                                    <li><a href="portfolio.html">Portfolio</a></li>
                                    <li><a href="blog.html">Blog</a></li>
                                    
                                    <!-- Hiển thị nút đăng nhập/đăng ký chỉ khi chưa đăng nhập -->
                                    <c:if test="${isLoggedIn == null || isLoggedIn == false}">
                                        <li><a href="${pageContext.request.contextPath}/authen?action=login">Login</a></li>
                                        <li><a href="${pageContext.request.contextPath}/authen?action=sign-up">Register</a></li>
                                    </c:if>
                                    
                                    <!-- Hiển thị nút My Account và Logout khi đã đăng nhập -->
                                    <c:if test="${isLoggedIn == true}">
                                        <li><a href="${pageContext.request.contextPath}/profile">My Account</a></li>
                                        <li><a href="${pageContext.request.contextPath}/authen?action=logout">Logout</a></li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                        <!--Main Menu Area End-->
                        <!--Header Option Start--> 
                        <div class="header-option">
                            <div class="mini-cart-search">
                                <div class="mini-cart">
                                    <a href="#">
                                        <span class="cart-icon">
                                            <span class="cart-quantity">2</span>
                                        </span>
                                        <span class="cart-title">Your cart <br><strong>$190.00</strong></span> 
                                    </a>
                                    <!--Cart Dropdown Start-->
                                    <div class="cart-dropdown">
                                        <ul>
                                            <li class="single-cart-item">
                                                <div class="cart-img">
                                                    <a href="single-product.html"><img src="img/cart/cart1.jpg" alt=""></a>
                                                </div>
                                                <div class="cart-content">
                                                    <h5 class="product-name"><a href="single-product.html">Odio tortor consequat</a></h5>
                                                    <span class="cart-price">1 × $90.00</span>
                                                </div>
                                                <div class="cart-remove">
                                                    <a title="Remove" href="#"><i class="fa fa-times"></i></a>
                                                </div>
                                            </li>
                                            <li class="single-cart-item">
                                                <div class="cart-img">
                                                    <a href="single-product.html"><img src="img/cart/cart2.jpg" alt=""></a>
                                                </div>
                                                <div class="cart-content">
                                                    <h5 class="product-name"><a href="single-product.html">Auctor sem</a></h5>
                                                    <span class="cart-price">1 × $100.00</span>
                                                </div>
                                                <div class="cart-remove">
                                                    <a title="Remove" href="#"><i class="fa fa-times"></i></a>
                                                </div>
                                            </li>
                                        </ul> 
                                        <p class="cart-subtotal"><strong>Subtotal:</strong> <span class="float-right">$190.00</span></p> 
                                        <p class="cart-btn">
                                            <a href="cart.html">View cart</a>
                                            <a href="checkout.html">Checkout</a>
                                        </p>
                                    </div>
                                    <!--Cart Dropdown End--> 
                                </div>
                                <div class="header-search">
                                    <div class="search-box">
                                        <a href="#"><i class="fa fa-search"></i></a>
                                        <div class="search-dropdown">
                                            <form action="#">
                                                <input name="search" id="search" placeholder="" value="Search product..." onblur="if (this.value == '') {
                                                            this.value = 'Search product...'
                                                        }" onfocus="if (this.value == 'Search product...') {
                                                                    this.value = ''
                                                                }" type="text">
                                                <button type="submit"><i class="fa fa-search"></i></button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <div class="currency">
                                    <div class="currency-box">
                                        <a href="#"><i class="fa fa-th"></i></a>
                                        <div class="currency-dropdown">
                                            <ul class="menu-top-menu">
                                                <!-- Điều chỉnh menu dropdown dựa trên trạng thái đăng nhập -->
                                                <c:if test="${isLoggedIn == true}">
                                                    <li><a href="${pageContext.request.contextPath}/user/profile">My Account</a></li>
                                                    <li><a href="wishlist.html">Wishlist</a></li>
                                                    <li><a href="cart.html">Shopping cart</a></li>
                                                    <li><a href="checkout.html">Checkout</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/authen?action=logout">Logout</a></li>
                                                </c:if>
                                                <c:if test="${isLoggedIn == null || isLoggedIn == false}">
                                                    <li><a href="cart.html">Shopping cart</a></li>
                                                    <li><a href="checkout.html">Checkout</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/authen?action=login">Log In</a></li>
                                                </c:if>
                                            </ul>
                                            <div class="switcher">
                                                <div class="language">
                                                    <span class="switcher-title">Language: </span>
                                                    <div class="switcher-menu">
                                                        <ul>
                                                            <li><a href="#">English</a>
                                                                <ul class="switcher-dropdown">
                                                                    <li><a href="#">German</a></li>
                                                                    <li><a href="#">French</a></li>
                                                                </ul>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div class="currency">
                                                    <span class="switcher-title">Currency: </span>
                                                    <div class="switcher-menu">
                                                        <ul>
                                                            <li><a href="#">$ USD</a>
                                                                <ul class="switcher-dropdown">
                                                                    <li><a href="#">€ EUR</a></li>
                                                                </ul>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--Header Option End--> 
                    </div>
                    <!--Header Menu And Mini Cart End-->
                </div>
                <div class="row">
                    <div class="col-12"> 
                        <!--Mobile Menu Area Start-->
                        <div class="mobile-menu d-lg-none"></div>
                        <!--Mobile Menu Area End-->
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>