<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Register || Plantmore</title>
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
            
            .register-page-wrapper {
                padding: 80px 0;
                background-color: #f5f7fa;
            }
            
            .register-card {
                background: #fff;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 15px 30px rgba(0,0,0,0.05);
                margin-bottom: 50px;
            }
            
            .register-card-header {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                padding: 40px;
                text-align: center;
                color: white;
            }
            
            .register-card-header h2 {
                font-size: 32px;
                font-weight: 600;
                margin-bottom: 10px;
            }
            
            .register-card-header p {
                font-size: 16px;
                opacity: 0.9;
            }
            
            .register-card-body {
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
            
            .gender-options {
                display: flex;
                gap: 20px;
                margin-top: 10px;
            }
            
            .gender-option {
                display: flex;
                align-items: center;
                cursor: pointer;
            }
            
            .gender-option input {
                margin-right: 8px;
                width: 18px;
                height: 18px;
            }
            
            .btn-register {
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
            
            .btn-register:hover {
                background: linear-gradient(135deg, #218838 0%, #1ba87e 100%);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
            }
            
            .login-prompt {
                text-align: center;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #e1e5eb;
            }
            
            .login-prompt p {
                margin-bottom: 15px;
                color: #6c757d;
                font-size: 15px;
            }
            
            .btn-login {
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
            
            .btn-login:hover {
                background-color: #e9ecef;
                color: #212529;
                border-color: #dae0e5;
                transform: translateY(-2px);
                box-shadow: 0 3px 6px rgba(0,0,0,0.08);
            }
            
            .error-message {
                color: #dc3545;
                font-size: 13px;
                margin-top: 5px;
                display: block;
            }
            
            /* Responsive adjustments */
            @media (max-width: 767px) {
                .register-card-header, .register-card-body {
                    padding: 30px 20px;
                }
                
                .gender-options {
                    flex-direction: column;
                    gap: 10px;
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
<!--                            <div class="breadcrumb-title">
                                <h2 style="font-size: 28px; margin-bottom: 15px; color: #333;">Account Register</h2>
                            </div>-->
<!--                            <div class="breadcrumb-list" style="display: flex; justify-content: center;">
                                <ul style="display: inline-flex; padding-left: 0; margin-bottom: 0; list-style: none;">
                                    <li style="display: flex; align-items: center;">
                                        <span style="color: #28a745; margin-right: 5px;">•</span>
                                        <a href="${pageContext.request.contextPath}/home" style="color: #28a745; text-decoration: none;">Home</a>
                                    </li>
                                    <li style="display: flex; align-items: center; margin: 0 10px;">
                                        <span style="color: #ccc;">/</span>
                                    </li>
                                    <li style="display: flex; align-items: center;">
                                        <span style="color: #777;">Register</span>
                                    </li>
                                </ul>
                            </div>-->
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb Area End-->
            
            <!--Register Page Start-->
            <div class="register-page-wrapper">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-8 col-md-10">
                            <div class="register-card">
                                <div class="register-card-header">
                                    <h2>Create Account</h2>
                                    <p>Fill in the form below to create your account</p>
                                </div>
                                <div class="register-card-body">
                                    <form action="${pageContext.request.contextPath}/authen?action=sign-up" method="POST" id="registerForm" onsubmit="return validateForm()">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="username">Username <span class="required">*</span></label>
                                                    <input type="text" class="form-control" id="username" name="username" value="${param.username}" placeholder="Choose a username">
                                                    <i class="fas fa-user form-icon"></i>
                                                    <span class="error-message"></span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="email">Email <span class="required">*</span></label>
                                                    <input type="email" class="form-control" id="email" name="email" value="${param.email}" placeholder="Enter your email">
                                                    <i class="fas fa-envelope form-icon"></i>
                                                    <span class="error-message"></span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="firstName">First Name <span class="required">*</span></label>
                                                    <input type="text" class="form-control" id="firstName" name="firstName" value="${param.firstName}" placeholder="Enter your first name">
                                                    <span class="error-message"></span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="lastName">Last Name <span class="required">*</span></label>
                                                    <input type="text" class="form-control" id="lastName" name="lastName" value="${param.lastName}" placeholder="Enter your last name">
                                                    <span class="error-message"></span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label>Gender <span class="required">*</span></label>
                                            <div class="gender-options">
                                                <label class="gender-option">
                                                    <input type="radio" name="gender" value="true" ${param.gender == 'true' ? 'checked' : ''}>
                                                    <span>Male</span>
                                                </label>
                                                <label class="gender-option">
                                                    <input type="radio" name="gender" value="false" ${param.gender == 'false' ? 'checked' : ''}>
                                                    <span>Female</span>
                                                </label>
                                            </div>
                                            <span class="error-message"></span>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="mobile">Mobile <span class="required">*</span></label>
                                            <input type="tel" class="form-control" id="mobile" name="mobile" value="${param.mobile}" placeholder="Enter your mobile number">
                                            <i class="fas fa-phone form-icon"></i>
                                            <span class="error-message"></span>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="password">Password <span class="required">*</span></label>
                                                    <input type="password" class="form-control" id="password" name="password" placeholder="Create a password">
                                                    <i class="fas fa-lock form-icon"></i>
                                                    <span class="error-message"></span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password">
                                                    <i class="fas fa-lock form-icon"></i>
                                                    <span class="error-message"></span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="btn-register">Create Account</button>
                                        
                                        <div class="login-prompt">
                                            <p>Already have an account?</p>
                                            <a href="${pageContext.request.contextPath}/authen?action=login" class="btn-login">Sign In</a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Register Page End-->
            
            <!--Brand Area Start-->
            <jsp:include page="/view/common/home/brand.jsp"></jsp:include>
            <!--Brand Area End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        <script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>
    </body>
</html>
