<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Change Password || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Change Password</h6>
            
        </div>

        <div class="row gy-4">
            <div class="col-lg-8">
                <div class="card h-100">
                    <div class="card-body p-24">
                        <form id="changePasswordForm" action="${pageContext.request.contextPath}/change-password" method="POST">
                            <input type="hidden" name="id" value="${user.id}">
                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-20">
                                        <label for="oldPassword" class="form-label fw-semibold text-primary-light text-sm mb-8">Old Password</label>
                                        <input type="password" class="form-control radius-8" id="oldPassword" name="oldPassword" required>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="mb-20">
                                        <label for="newPassword" class="form-label fw-semibold text-primary-light text-sm mb-8">New Password</label>
                                        <input type="password" class="form-control radius-8" id="newPassword" name="newPassword" required>
                                        <small class="text-muted">Password must be at least 8 characters, including 1 uppercase, 1 lowercase, and 1 number</small>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="mb-20">
                                        <label for="confirmPassword" class="form-label fw-semibold text-primary-light text-sm mb-8">Confirm New Password</label>
                                        <input type="password" class="form-control radius-8" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-center gap-3">
                                <button type="button" class="border border-danger-600 bg-hover-danger-200 text-danger-600 text-md px-56 py-11 radius-8"
                                        onclick="window.location.href = '${pageContext.request.contextPath}/profile'"> 
                                    Cancel
                                </button>
                                <button type="submit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8"> 
                                    Change Password
                                </button>
                            </div>
                            <div class="text-center mt-3">
                                <span style="color: #198754">${suc}</span>
                                <span style="color: #dc3545">${err}</span>
                                <span id="samePasswordError" style="color: #dc3545; display:none;">New password must be different from old password.</span>
                                <span id="passwordFormatError" style="color: #dc3545; display:none;">Password must be at least 8 characters, including 1 uppercase, 1 lowercase, and 1 number.</span>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 1000,
                    onClosing: function() {
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST'
                        });
                    }
                });
            }

            // Hide the password error on page load
            document.getElementById('samePasswordError').style.display = 'none';

            // Add client-side validation for password difference
            // Password validation function
            function validatePassword(password) {
                const minLength = 8;
                const hasUpperCase = /[A-Z]/.test(password);
                const hasLowerCase = /[a-z]/.test(password);
                const hasNumber = /[0-9]/.test(password);
                
                return password.length >= minLength && hasUpperCase && hasLowerCase && hasNumber;
            }

            // Form validation
            document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
                var oldPwd = document.getElementById('oldPassword').value;
                var newPwd = document.getElementById('newPassword').value;
                var samePwdError = document.getElementById('samePasswordError');
                var passwordFormatError = document.getElementById('passwordFormatError');
                
                // Reset error messages
                samePwdError.style.display = 'none';
                passwordFormatError.style.display = 'none';
                
                // Validate password format
                if (!validatePassword(newPwd)) {
                    passwordFormatError.style.display = 'inline';
                    e.preventDefault();
                    return;
                }
                
                // Check if old and new passwords are same
                if (oldPwd === newPwd) {
                    samePwdError.style.display = 'inline';
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>