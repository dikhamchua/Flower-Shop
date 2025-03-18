<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Verify OTP || Plantmore</title>
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
            .verify-otp-page {
                min-height: 100vh;
                display: flex;
                align-items: center;
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                padding: 2rem;
            }
            
            .verify-otp-card {
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                max-width: 500px;
                width: 100%;
                margin: auto;
                overflow: hidden;
            }
            
            .verify-otp-header {
                background: #fff;
                padding: 2.5rem;
                text-align: center;
                border-bottom: 1px solid #e9ecef;
            }
            
            .verify-otp-header h2 {
                font-size: 1.8rem;
                font-weight: 600;
                color: #343a40;
                margin-bottom: 0.5rem;
            }
            
            .verify-otp-header p {
                color: #6c757d;
                font-size: 0.95rem;
            }
            
            .verify-otp-body {
                padding: 2.5rem;
            }
            
            .form-group {
                margin-bottom: 1.5rem;
                position: relative;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: #495057;
                font-size: 0.9rem;
            }
            
            .form-control {
                width: 100%;
                padding: 0.8rem 1rem;
                border: 1px solid #e1e5eb;
                border-radius: 8px;
                font-size: 0.9rem;
                transition: all 0.3s;
                background-color: #f8f9fa;
            }
            
            .form-control:focus {
                border-color: #28a745;
                box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.15);
                background-color: #fff;
            }
            
            .form-icon {
                position: absolute;
                right: 1rem;
                top: 2.6rem;
                color: #adb5bd;
                font-size: 1rem;
            }
            
            .btn-verify {
                width: 100%;
                padding: 0.8rem;
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                border: none;
                border-radius: 8px;
                color: #fff;
                font-size: 1rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 1rem;
            }
            
            .btn-verify:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
            }
            
            .resend-otp {
                text-align: center;
                margin-top: 1.5rem;
                padding-top: 1.5rem;
                border-top: 1px solid #e9ecef;
            }
            
            .resend-otp a {
                color: #28a745;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }
            
            .resend-otp a:hover {
                color: #218838;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            
            <!--Verify OTP Page Start-->
            <div class="verify-otp-page">
                <div class="verify-otp-card">
                    <div class="verify-otp-header">
                        <h2>Verify OTP</h2>
                        <p>Enter the OTP sent to your email</p>
                    </div>
                    <div class="verify-otp-body">
                        <form action="${pageContext.request.contextPath}/authen?action=verify-otp" method="POST">
                            <div class="form-group">
                                <label for="otp">OTP Code</label>
                                <input type="text" class="form-control" id="otp" name="otp" placeholder="Enter OTP Code">
                                <i class="fas fa-shield-alt form-icon"></i>
                            </div>
                            <button type="submit" class="btn-verify">Verify</button>
                        </form>
                        <div class="resend-otp">
                            <p>Didn't receive the code? <a href="${pageContext.request.contextPath}/authen?action=enter-email">Resend OTP</a></p>
                        </div>
                    </div>
                </div>
            </div>
            <!--Verify OTP Page End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
    </body>
</html>
