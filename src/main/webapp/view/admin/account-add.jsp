<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Add New Account || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <style>
        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545;
            background-image: none;
        }
        .invalid-feedback {
            display: block;
            color: #dc3545;
            margin-top: 5px;
        }
    </style>
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Add New Account</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Add Account</li>
            </ul>
        </div>

        <!-- Add Account Form -->
        <div class="card">
            <div class="card-body p-24">
                <form id="accountForm" action="${pageContext.request.contextPath}/admin/manage-account?action=add" method="POST">
                    <div class="row g-3">
                        <!-- Basic Information -->
                        <div class="col-md-6">
                            <label class="form-label">First Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty sessionScope.errors.firstName ? 'is-invalid' : ''}" 
                                   name="firstName" value="${sessionScope.formData.firstName[0]}">
                            <c:if test="${not empty sessionScope.errors.firstName}">
                                <div class="invalid-feedback">${sessionScope.errors.firstName}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty sessionScope.errors.lastName ? 'is-invalid' : ''}" 
                                   name="lastName" value="${sessionScope.formData.lastName[0]}">
                            <c:if test="${not empty sessionScope.errors.lastName}">
                                <div class="invalid-feedback">${sessionScope.errors.lastName}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control ${not empty sessionScope.errors.email ? 'is-invalid' : ''}" 
                                   name="email" value="${sessionScope.formData.email[0]}">
                            <c:if test="${not empty sessionScope.errors.email}">
                                <div class="invalid-feedback">${sessionScope.errors.email}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control ${not empty sessionScope.errors.phone ? 'is-invalid' : ''}" 
                                   name="phone" value="${sessionScope.formData.phone[0]}">
                            <c:if test="${not empty sessionScope.errors.phone}">
                                <div class="invalid-feedback">${sessionScope.errors.phone}</div>
                            </c:if>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" 
                                   value="${sessionScope.formData.address[0]}">
                        </div>

                        <!-- Account Information -->
                        <div class="col-md-6">
                            <label class="form-label">Username <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty sessionScope.errors.username ? 'is-invalid' : ''}" 
                                   name="username" value="${sessionScope.formData.username[0]}">
                            <c:if test="${not empty sessionScope.errors.username}">
                                <div class="invalid-feedback">${sessionScope.errors.username}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control ${not empty sessionScope.errors.password ? 'is-invalid' : ''}" 
                                   name="password">
                            <c:if test="${not empty sessionScope.errors.password}">
                                <div class="invalid-feedback">${sessionScope.errors.password}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Role <span class="text-danger">*</span></label>
                            <select class="form-select ${not empty sessionScope.errors.role ? 'is-invalid' : ''}" name="role">
                                <option value="" selected disabled>Select Role</option>
                                <option value="user" ${sessionScope.formData.role[0] == 'user' ? 'selected' : ''}>User</option>
                                <option value="staff" ${sessionScope.formData.role[0] == 'staff' ? 'selected' : ''}>Staff</option>
                                <option value="admin" ${sessionScope.formData.role[0] == 'admin' ? 'selected' : ''}>Admin</option>
                            </select>
                            <c:if test="${not empty sessionScope.errors.role}">
                                <div class="invalid-feedback">${sessionScope.errors.role}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select class="form-select ${not empty sessionScope.errors.status ? 'is-invalid' : ''}" name="status">
                                <option value="" selected disabled>Select Status</option>
                                <option value="true" ${sessionScope.formData.status[0] == 'true' ? 'selected' : ''}>Active</option>
                                <option value="false" ${sessionScope.formData.status[0] == 'false' ? 'selected' : ''}>Inactive</option>
                            </select>
                            <c:if test="${not empty sessionScope.errors.status}">
                                <div class="invalid-feedback">${sessionScope.errors.status}</div>
                            </c:if>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-md-12 mt-4">
                            <button type="submit" class="btn btn-primary">Add Account</button>
                            <a href="${pageContext.request.contextPath}/admin/manage-account" 
                               class="btn btn-secondary">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toast message handling
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000,
                    onClosing: function() {
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST'
                        });
                    }
                });
            }
            
            // Form validation
            const form = document.getElementById('accountForm');
            
            // Validate on input change
            const inputs = form.querySelectorAll('input, select');
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    validateField(this);
                });
                
                input.addEventListener('blur', function() {
                    validateField(this);
                });
            });
            
            // Validate on form submit
            form.addEventListener('submit', function(event) {
                let isValid = true;
                
                // Validate all fields
                inputs.forEach(input => {
                    if (!validateField(input)) {
                        isValid = false;
                    }
                });
                
                if (!isValid) {
                    event.preventDefault();
                    // Scroll to first error
                    const firstError = form.querySelector('.is-invalid');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstError.focus();
                    }
                    
                    // Show error message
                    iziToast.error({
                        title: 'Error',
                        message: 'Please correct the errors before submitting the form',
                        position: 'topRight',
                        timeout: 5000
                    });
                }
            });
            
            function validateField(field) {
                const name = field.getAttribute('name');
                let isValid = true;
                
                // Required fields validation
                if (['firstName', 'lastName', 'email', 'phone', 'username', 'password', 'role', 'status'].includes(name)) {
                    if (!field.value.trim()) {
                        setInvalid(field, `${field.previousElementSibling.textContent.replace('*', '').trim()} is required`);
                        isValid = false;
                    } else {
                        setValid(field);
                    }
                }
                
                // Specific field validations
                if (isValid) {
                    switch(name) {
                        case 'email':
                            const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
                            if (!emailRegex.test(field.value.trim())) {
                                setInvalid(field, 'Please enter a valid email address');
                                isValid = false;
                            }
                            break;
                            
                        case 'phone':
                            const phoneRegex = /^[0-9]{10,15}$/;
                            if (!phoneRegex.test(field.value.trim())) {
                                setInvalid(field, 'Phone number must be between 10 and 15 digits');
                                isValid = false;
                            }
                            break;
                            
                        case 'username':
                            if (field.value.trim().length < 3 || field.value.trim().length > 50) {
                                setInvalid(field, 'Username must be between 3 and 50 characters');
                                isValid = false;
                            } else if (!/^[a-zA-Z0-9_]+$/.test(field.value.trim())) {
                                setInvalid(field, 'Username can only contain letters, numbers, and underscores');
                                isValid = false;
                            }
                            break;
                            
                        case 'password':
                            const password = field.value.trim();
                            if (password.length < 8) {
                                setInvalid(field, 'Password must be at least 8 characters');
                                isValid = false;
                            } else if (!/[a-z]/.test(password) || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
                                setInvalid(field, 'Password must contain at least one uppercase letter, one lowercase letter, and one number');
                                isValid = false;
                            }
                            break;
                            
                        case 'role':
                        case 'status':
                            if (field.value === "" || field.value === null) {
                                setInvalid(field, `Please select a ${name}`);
                                isValid = false;
                            }
                            break;
                    }
                }
                
                return isValid;
            }
            
            function setInvalid(element, message) {
                element.classList.add('is-invalid');
                let feedback = element.nextElementSibling;
                if (!feedback || !feedback.classList.contains('invalid-feedback')) {
                    feedback = document.createElement('div');
                    feedback.className = 'invalid-feedback';
                    element.parentNode.insertBefore(feedback, element.nextSibling);
                }
                feedback.textContent = message;
                return false;
            }
            
            function setValid(element) {
                element.classList.remove('is-invalid');
                let feedback = element.nextElementSibling;
                if (feedback && feedback.classList.contains('invalid-feedback')) {
                    feedback.textContent = '';
                }
                return true;
            }
            
            // Clear session attributes after page load
            <% session.removeAttribute("errors"); %>
            <% session.removeAttribute("formData"); %>
        });
    </script>
</body>
</html> 