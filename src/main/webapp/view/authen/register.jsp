<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Login-Register || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, follow" />
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>

            <style>
                #padding-form {
                    padding-left:  20%;
                    padding-right: 20%;
                }

            </style>

        </head>
        <body>

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
                                    <h1>Login - Register</h1>
                                </div>
                                <div class="breadcrumb-content breadcrumb-content-tow">
                                    <ul>
                                        <li><a href="index.html">Home</a></li>
                                        <li class="active">Login-Register</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Breadcrumb Tow End-->
                <!--Login Register Area Strat-->
                <div class="login-register-area mb-80">
                    <div class="container" id="padding-form">
                        <!--Register Form Start-->
                        <div class="customer-login-register register-pt-0">
                            <div class="form-register-title">
                                <h2>Register</h2>
                            </div>
                            <div class="register-form">
                                <form action="authen?action=sign-up" method="POST" id="registerForm" onsubmit="return validateForm()">
                                    <div class="form-fild">
                                        <p><label>Username <span class="required">*</span></label></p>
                                        <input name="username" type="text"  value="${param.username}">
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p><label>First Name <span class="required">*</span></label></p>
                                    <input name="firstName" type="text"  value="${param.firstName}">
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p><label>Last Name <span class="required">*</span></label></p>
                                    <input name="lastName" type="text" value="${param.lastName}">
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p style="display: inline;"><label>Gender <span class="required">*</span></label></p>
                                    <input type="radio" name="gender" value="true"  style="width: auto; height: auto;" ${param.gender == 'true' ? 'checked' : ''}> Male
                                    <input type="radio" name="gender" value="false"  style="width: auto; height: auto;" ${param.gender == 'false' ? 'checked' : ''}> Female
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p><label>Email <span class="required">*</span></label></p>
                                    <input name="email" type="email"  value="${param.email}">
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p><label>Mobile <span class="required">*</span></label></p>
                                    <input name="mobile" type="tel"  value="${param.mobile}">
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p><label>Password <span class="required">*</span></label></p>
                                    <input name="password" type="password" >
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="form-fild">
                                    <p><label>Confirm Password <span class="required">*</span></label></p>
                                    <input name="confirmPassword" type="password" >
                                    <span class="error-message" style="color: red; display: none;"></span>
                                </div>
                                <div class="register-submit">
                                    <button type="submit" class="form-button">Register</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!--Register Form End-->
                </div>
            </div>
            <!--Login Register Area End-->
            <!--Brand Area Start-->
            <jsp:include page="/view/common/home/brand.jsp"></jsp:include>
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
        <script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>
    </body>
</html>
