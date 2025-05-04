<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Edit Account || Clothing</title>
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
            <h6 class="fw-semibold mb-0">Edit Account</h6>
            
        </div>

        <!-- Edit Account Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="accountEditForm" action="${pageContext.request.contextPath}/admin/manage-account?action=update" method="POST">
                    <input type="hidden" name="id" value="${account.userId}">
                    <input type="hidden" name="page" value="${param.page}">
                    <div class="row g-3">
                        <!-- Basic Information -->
                        <div class="col-md-6">
                            <label class="form-label">First Name</label>
                            <input type="text" class="form-control" name="firstName" 
                                   value="${account.firstName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name</label>
                            <input type="text" class="form-control" name="lastName" 
                                   value="${account.lastName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" 
                                   value="${account.email}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" class="form-control ${not empty sessionScope.errors.phone ? 'is-invalid' : ''}" 
                                   name="phone" value="${account.phone}" required id="phoneInput">
                            <div class="invalid-feedback" id="phoneError" style="display:none;">Phone number must start with 0 and have exactly 10 digits.</div>
                            <c:if test="${not empty sessionScope.errors.phone}">
                                <div class="invalid-feedback">${sessionScope.errors.phone}</div>
                            </c:if>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" 
                                   value="${account.address}">
                        </div>

                        <!-- Account Information -->
                        <div class="col-md-6">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" name="username" 
                                   value="${account.username}" readonly>
                        </div>
                        <!-- Update the password input field -->
                        <div class="col-md-6">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control ${not empty sessionScope.errors.password ? 'is-invalid' : ''}" 
                                   name="password" id="passwordInput"
                                   placeholder="Leave blank to keep current password">
                            <div class="invalid-feedback" id="passwordError" style="display:none;">
                                Password must be at least 8 characters long and contain at least one number, one uppercase letter, and one lowercase letter.
                            </div>
                            <c:if test="${not empty sessionScope.errors.password}">
                                <div class="invalid-feedback" style="display:block;">${sessionScope.errors.password}</div>
                            </c:if>
                        </div>
                        
                        <!-- Update the JavaScript validation -->
                        <script>
                            document.addEventListener('DOMContentLoaded', function() {
                                // ... existing code ...
                        // Add password validation
                        const passwordInput = document.getElementById('passwordInput');
                        const passwordError = document.getElementById('passwordError');
                        
                        document.getElementById('accountEditForm').addEventListener('submit', function(e) {
                            let valid = true;
                        
                            // Existing validations...
                        
                            // Password validation (only if password field is not empty)
                            const passwordValue = passwordInput.value.trim();
                            if (passwordValue !== '') {
                                const passwordPattern = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$/;
                                if (!passwordPattern.test(passwordValue)) {
                                    passwordInput.classList.add('is-invalid');
                                    passwordError.style.display = 'block';
                                    valid = false;
                                } else {
                                    passwordInput.classList.remove('is-invalid');
                                    passwordError.style.display = 'none';
                                }
                            }
                        
                            // Prevent form submission if not valid
                            if (!valid) {
                                e.preventDefault();
                            }
                        });
                    });
                </script>
                        <div class="col-md-6">
                            <label class="form-label">Role</label>
                            <select class="form-select" name="role" required>
                                <option value="user" ${account.role == 'user' ? 'selected' : ''}>User</option>
                                <option value="staff" ${account.role == 'staff' ? 'selected' : ''}>Staff</option>
                                <option value="admin" ${account.role == 'admin' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status" required 
                                    ${account.role eq 'admin' ? 'disabled' : ''}>
                                <option value="true" ${account.status ? 'selected' : ''}>Active</option>
                                <option value="false" ${!account.status ? 'selected' : ''}>Inactive</option>
                            </select>
                            <c:if test="${account.role eq 'admin'}">
                                <input type="hidden" name="status" value="true">
                                <small class="text-muted">Admin accounts cannot be deactivated</small>
                            </c:if>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-md-12 mt-4">
                            <button type="submit" class="btn btn-primary">Update Account</button>
                            <a href="${pageContext.request.contextPath}/admin/manage-account?page=${param.page}" 
                               class="btn btn-secondary">Back</a>
                        </div>
                    </div>
                </form>
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
                    timeout: 1500,
                    onClosing: function() {
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST'
                        });
                    }
                });
            }

            // Client-side validation for all fields
            document.getElementById('accountEditForm').addEventListener('submit', function(e) {
                let valid = true;

                // Validate phone number
                const phoneInput = document.getElementById('phoneInput');
                const phoneError = document.getElementById('phoneError');
                const phoneValue = phoneInput.value.trim();
                const phonePattern = /^0\d{9}$/;

                if (!phonePattern.test(phoneValue)) {
                    phoneInput.classList.add('is-invalid');
                    phoneError.style.display = 'block';
                    valid = false;
                } else {
                    phoneInput.classList.remove('is-invalid');
                    phoneError.style.display = 'none';
                }

                // Validate first name
                const firstName = this.elements['firstName'].value.trim();
                if (firstName === '') {
                    this.elements['firstName'].classList.add('is-invalid');
                    valid = false;
                } else {
                    this.elements['firstName'].classList.remove('is-invalid');
                }

                // Validate last name
                const lastName = this.elements['lastName'].value.trim();
                if (lastName === '') {
                    this.elements['lastName'].classList.add('is-invalid');
                    valid = false;
                } else {
                    this.elements['lastName'].classList.remove('is-invalid');
                }

                // Validate address (optional, but you can require if needed)
                // const address = this.elements['address'].value.trim();
                // if (address === '') {
                //     this.elements['address'].classList.add('is-invalid');
                //     valid = false;
                // } else {
                //     this.elements['address'].classList.remove('is-invalid');
                // }

                // Prevent form submission if not valid
                if (!valid) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>