<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Login || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!-- Font Awesome CDN -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f5f7fa;
            }
            
            .login-page-wrapper {
                padding: 80px 0;
                background-color: #f5f7fa;
            }
            
            .login-card {
                background: #fff;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 15px 30px rgba(0,0,0,0.05);
                margin-bottom: 50px;
            }
            
            .login-card-header {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                padding: 40px;
                text-align: center;
                color: white;
            }
            
            .login-card-header h2 {
                font-size: 32px;
                font-weight: 600;
                margin-bottom: 10px;
            }
            
            .login-card-header p {
                font-size: 16px;
                opacity: 0.9;
            }
            
            .login-card-body {
                padding: 40px;
            }
            
            .form-group {
                margin-bottom: 25px;
                position: relative;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 10px;
                font-weight: 500;
                color: #333;
                font-size: 15px;
            }
            
            .form-control {
                width: 100%;
                padding: 15px 20px;
                border: 1px solid #e1e5eb;
                border-radius: 8px;
                font-size: 15px;
                transition: all 0.3s;
                background-color: #f9fafb;
            }
            
            .form-control:focus {
                border-color: #28a745;
                background-color: #fff;
                box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.15);
                outline: none;
            }
            
            .form-icon {
                position: absolute;
                top: 45px;
                right: 15px;
                color: #adb5bd;
            }
            
            .login-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }
            
            .remember-me {
                display: flex;
                align-items: center;
            }
            
            .remember-me input {
                margin-right: 8px;
                width: 18px;
                height: 18px;
            }
            
            .remember-me label {
                font-size: 14px;
                color: #495057;
                cursor: pointer;
            }
            
            .forgot-password {
                font-size: 14px;
                color: #28a745;
                text-decoration: none;
                transition: color 0.3s;
            }
            
            .forgot-password:hover {
                color: #218838;
                text-decoration: underline;
            }
            
            .btn-login {
                display: block;
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-align: center;
                margin-bottom: 25px;
            }
            
            .btn-login:hover {
                background: linear-gradient(135deg, #218838 0%, #1ba87e 100%);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
            }
            
            .divider {
                display: flex;
                align-items: center;
                margin: 25px 0;
                color: #adb5bd;
            }
            
            .divider::before, .divider::after {
                content: "";
                flex: 1;
                height: 1px;
                background-color: #e1e5eb;
            }
            
            .divider span {
                padding: 0 15px;
                font-size: 14px;
            }
            
            .btn-google {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                padding: 15px;
                background-color: #fff;
                color: #5f6368;
                border: 1px solid #e1e5eb;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                margin-bottom: 25px;
            }
            
            .btn-google:hover {
                background-color: #f8f9fa;
                border-color: #dadce0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            }
            
            .btn-google i {
                font-size: 18px;
                margin-right: 10px;
                color: #4285F4;
            }
            
            .register-prompt {
                text-align: center;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #e1e5eb;
            }
            
            .register-prompt p {
                margin-bottom: 15px;
                color: #6c757d;
                font-size: 15px;
            }
            
            .btn-register {
                display: inline-block;
                padding: 12px 25px;
                background-color: #f8f9fa;
                color: #495057;
                border: 1px solid #e1e5eb;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
            }
            
            .btn-register:hover {
                background-color: #e9ecef;
                color: #212529;
                border-color: #dae0e5;
                transform: translateY(-2px);
                box-shadow: 0 3px 6px rgba(0,0,0,0.08);
            }
            
            .breadcrumb-area {
                background-color: #f8f9fa;
                padding: 30px 0;
                border-bottom: 1px solid #e1e5eb;
            }
            
            .breadcrumb-title h2 {
                font-size: 28px;
                font-weight: 600;
                color: #343a40;
                margin-bottom: 10px;
            }
            
            .breadcrumb-list {
                display: flex;
                align-items: center;
            }
            
            .breadcrumb-list li {
                font-size: 14px;
                color: #6c757d;
            }
            
            .breadcrumb-list li a {
                color: #28a745;
                text-decoration: none;
            }
            
            .breadcrumb-list li a:hover {
                color: #218838;
                text-decoration: underline;
            }
            
            .breadcrumb-list li.active {
                color: #343a40;
            }
            
            .breadcrumb-list li + li:before {
                content: "/";
                padding: 0 10px;
                color: #adb5bd;
            }
            
            /* Responsive adjustments */
            @media (max-width: 767px) {
                .login-card-header, .login-card-body {
                    padding: 30px 20px;
                }
                
                .login-options {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }
                
                .forgot-password {
                    margin-top: 10px;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            
            <!--Breadcrumb Area Start-->
            <div class="breadcrumb-area" style="background-color: #f9f9f9; padding: 20px 0;">
                <div class="container">
                    <div class="row">
                        <div class="col-12 text-center">
                            <div class="breadcrumb-title">
                                <h2 style="font-size: 28px; margin-bottom: 15px; color: #333;">Account Login</h2>
                            </div>
                            <div class="breadcrumb-list" style="display: flex; justify-content: center;">
                                <ul style="display: inline-flex; padding-left: 0; margin-bottom: 0; list-style: none;">
                                    <li style="display: flex; align-items: center;">
                                        <span style="color: #28a745; margin-right: 5px;">•</span>
                                        <a href="${pageContext.request.contextPath}/home" style="color: #28a745; text-decoration: none;">Home</a>
                                    </li>
<!--                                    <li style="display: flex; align-items: center; margin: 0 10px;">
                                        <span style="color: #ccc;">/</span>
                                    </li>-->
<!--                                    <li style="display: flex; align-items: center; margin: 0 10px;">
                                        <span style="color: #ccc;">/</span>
                                    </li>-->
                                    <li style="display: flex; align-items: center;">
                                        <span style="color: #777;">Login</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb Area End-->
            
            <!--Login Page Start-->
            <div class="login-page-wrapper">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-6 col-md-8">
                            <div class="login-card">
                                <div class="login-card-header">
                                    <h2>Welcome Back</h2>
                                    <p>Sign in to continue to your account</p>
                                </div>
                                <div class="login-card-body">
                                    <form action="${pageContext.request.contextPath}/authen?action=login" method="POST">
                                        <div class="form-group">
                                            <label for="username">Username or Email</label>
                                            <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username or email">
                                            <i class="fas fa-user form-icon"></i>
                                        </div>
                                        <div class="form-group">
                                            <label for="password">Password</label>
                                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password">
                                            <i class="fas fa-lock form-icon"></i>
                                        </div>
                                        
                                        <div class="login-options">
                                            <a href="${pageContext.request.contextPath}/authen?action=enter-email" class="forgot-password">Forgot password?</a>
                                        </div>
                                        
                                        <button type="submit" class="btn-login">Sign In</button>
                                        
                                        <div class="divider">
                                            <span>OR</span>
                                        </div>
                                        
                                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9999/SWP391-FlowerShop/LoginGoogleHandler&response_type=code&client_id=688320491984-inlcglainoimtek5cid4akn0evqqjju1.apps.googleusercontent.com&approval_prompt=force" class="btn-google">
                                            <i class="fab fa-google"></i>
                                            <span>Sign in with Google</span>
                                        </a>
                                        
                                        <div class="register-prompt">
                                            <p>Don't have an account?</p>
                                            <a href="${pageContext.request.contextPath}/authen?action=sign-up" class="btn-register">Create Account</a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Login Page End-->
            
            <!--Brand Area Start-->
            <jsp:include page="/view/common/home/brand.jsp"></jsp:include>
            <!--Brand Area End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
    </body>
</html>
