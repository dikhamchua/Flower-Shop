<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<header>
    <div class="header-container">
        <div class="header-area header-sticky pt-30 pb-30">
            <div class="container">
                <div class="row">
                    <!--Header Logo Start-->
                    <div class="col-lg-3 col-md-3">
                        <div class="logo-area">
                            <a href="${pageContext.request.contextPath}/home">
                                <img src="${pageContext.request.contextPath}/img/logo/logo.png" alt="">
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
                                    <li><a href="${pageContext.request.contextPath}/home">Shop</a></li>
                                    <li><a href="portfolio.html">Portfolio</a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/manage-order">Blog</a></li>
                                    
                                    <!-- Hiển thị nút đăng nhập/đăng ký chỉ khi chưa đăng nhập -->
                                    <c:if test="${sessionScope.SESSION_ACCOUNT == null && sessionScope.account == null}">
                                        <li><a href="${pageContext.request.contextPath}/authen?action=login">Login</a></li>
                                        <li><a href="${pageContext.request.contextPath}/authen?action=sign-up">Register</a></li>
                                    </c:if>
                                    
                                    <!-- Hiển thị nút My Account và Logout khi đã đăng nhập -->
                                    <c:if test="${sessionScope.SESSION_ACCOUNT != null || sessionScope.account != null}">
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
                                    <a href="${pageContext.request.contextPath}/cart">
                                        <c:set var="cartTotal" value="0" />
                                        <c:forEach items="${sessionScope.cart.values()}" var="item">
                                            <c:set var="cartTotal" value="${cartTotal + (item.product.price * item.quantity)}" />
                                        </c:forEach>
                                        <span class="cart-title">Your cart <br></span> 
                                    </a>
                                </div>
                                <div class="header-search">
                                    <div class="search-box">
                                        <a href="#"><i class="fa fa-search"></i></a>
                                        <div class="search-dropdown">
                                            <form action="${pageContext.request.contextPath}/home" method="GET">
                                                <input name="search" id="search" placeholder="Search product..." value="${param.search}" type="text">
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
                                                <c:if test="${sessionScope.SESSION_ACCOUNT != null || sessionScope.account != null}">
                                                    <li><a href="${pageContext.request.contextPath}/user/profile">My Account</a></li>
                                                    <li><a href="wishlist.html">Wishlist</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/cart">Shopping cart</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/cart?action=checkout">Checkout</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/authen?action=logout">Logout</a></li>
                                                </c:if>
                                                <c:if test="${sessionScope.SESSION_ACCOUNT == null && sessionScope.account == null}">
                                                    <li><a href="${pageContext.request.contextPath}/cart">Shopping cart</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/cart?action=checkout">Checkout</a></li>
                                                    <li><a href="${pageContext.request.contextPath}/authen?action=login">Log In</a></li>
                                                </c:if>
                                            </ul>
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

<!-- Debug session - sẽ ẩn trong production -->
<div style="display: none;">
    SESSION_ACCOUNT: ${sessionScope.SESSION_ACCOUNT}<br>
    SESSION_ACCOUNT class: ${sessionScope.SESSION_ACCOUNT.getClass().getName()}<br>
    All session attributes: 
    <c:forEach items="${sessionScope}" var="attr">
        ${attr.key}: ${attr.value}<br>
    </c:forEach>
</div>