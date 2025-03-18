<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Reset Password || Plantmore</title>
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
            .reset-password-page {
                min-height: 100vh;
                display: flex;
                align-items: center;
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                padding: 2rem;
            }
            
            .reset-password-card {
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                max-width: 500px;
                width: 100%;
                margin: auto;
                overflow: hidden;
            }
            
            .reset-password-header {
                background: #fff;
                padding: 2.5rem;
                text-align: center;
                border-bottom: 1px solid #e9ecef;
            }
            
            .reset-password-header h2 {
                font-size: 1.8rem;
                font-weight: 600;
                color: #343a40;
                margin-bottom: 0.5rem;
            }
            
            .reset-password-header p {
                color: #6c757d;
                font-size: 0.95rem;
            }
            
            .reset-password-body {
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
            
            .btn-reset {
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
            
            .btn-reset:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
            }
            
            .back-to-login {
                text-align: center;
                margin-top: 1.5rem;
                padding-top: 1.5rem;
                border-top: 1px solid #e9ecef;
            }
            
            .back-to-login a {
                color: #28a745;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }
            
            .back-to-login a:hover {
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
            
            <!--Reset Password Page Start-->
            <div class="reset-password-page">
                <div class="reset-password-card">
                    <div class="reset-password-header">
                        <h2>Reset Your Password</h2>
                        <p>Create a new password for your account</p>
                    </div>
                    <div class="reset-password-body">
                        <form action="${pageContext.request.contextPath}/authen?action=reset-password" method="POST" onsubmit="return validateForm()">
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Enter new password">
                                <i class="fas fa-lock form-icon"></i>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
                                <i class="fas fa-lock form-icon"></i>
                            </div>
                            <button type="submit" class="btn-reset">Reset Password</button>
                        </form>
                        <div class="back-to-login">
                            <p>Remember your password? <a href="${pageContext.request.contextPath}/authen?action=login">Sign In</a></p>
                        </div>
                    </div>
                </div>
            </div>
            <!--Reset Password Page End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        
        <script>
            function validateForm() {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
                
                // Reset error messages
                document.querySelectorAll('.error-message').forEach(el => el.remove());
                
                if (!passwordPattern.test(newPassword)) {
                    showError('newPassword', 'Password must contain 8+ characters, at least one uppercase letter, one lowercase letter, and one number.');
                    return false;
                }
                
                if (newPassword !== confirmPassword) {
                    showError('confirmPassword', 'Passwords do not match.');
                    return false;
                }
                
                return true;
            }
            
            function showError(fieldId, message) {
                const field = document.getElementById(fieldId);
                const error = document.createElement('div');
                error.className = 'error-message';
                error.style.color = '#dc3545';
                error.style.fontSize = '0.8rem';
                error.style.marginTop = '0.25rem';
                error.textContent = message;
                field.parentNode.insertBefore(error, field.nextSibling);
            }
        </script>
    </body>
</html>
