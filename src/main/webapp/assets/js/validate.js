// Regular expression constants
const REGEX = {
    USERNAME: /^[a-zA-Z0-9_]{4,20}$/,        // 4-20 chars, alphanumeric + underscore
    NAME: /^[A-Za-z]+$/,                     // Letters only
    EMAIL: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,     // Standard email format
    MOBILE: /^[0-9]{10}$/,                   // Exactly 10 digits
    PASSWORD_COMPLEXITY: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}/ // 8+ chars, 1 uppercase, 1 lowercase, 1 number
};

// Validation messages
const MESSAGES = {
    REQUIRED: "Please fill out this field",
    USERNAME: "Username must be 4-20 characters and can only contain letters, numbers, and underscores",
    FIRST_NAME: "First Name should contain only letters",
    LAST_NAME: "Last Name should contain only letters",
    EMAIL: "Please enter a valid email address",
    MOBILE: "Mobile number must be exactly 10 digits",
    PASSWORD: "Password must contain 8+ characters, at least one uppercase letter, one lowercase letter, and one number",
    PASSWORD_MATCH: "Passwords do not match",
    GENDER: "Please select a valid gender"
};

// Category validation constants
const CATEGORY_REGEX = {
    NAME: /^.{1,100}$/  // 1-100 characters for category name
};

// Category validation messages
const CATEGORY_MESSAGES = {
    NAME_REQUIRED: "Category name is required",
    NAME_LENGTH: "Category name must be less than 100 characters",
    STATUS_REQUIRED: "Please select a status"
};

// Check if field is empty
function isEmpty(value) {
    return value.trim() === '';
}

// Helper function to show error message
function showError(inputElement, message) {
    const errorElement = inputElement.nextElementSibling;
    if (errorElement && errorElement.classList.contains('error-message')) {
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }
}

// Helper function to clear error
function clearError(inputElement) {
    const errorElement = inputElement.nextElementSibling;
    if (errorElement && errorElement.classList.contains('error-message')) {
        errorElement.textContent = '';
        errorElement.style.display = 'none';
    }
}

// Helper function to show error message for Bootstrap forms
function showBootstrapError(inputElement, message) {
    inputElement.classList.add('is-invalid');
    const feedback = inputElement.nextElementSibling;
    if (feedback && feedback.classList.contains('invalid-feedback')) {
        feedback.textContent = message;
        feedback.style.display = 'block';
    }
    return false;
}

// Helper function to clear error for Bootstrap forms
function clearBootstrapError(inputElement) {
    inputElement.classList.remove('is-invalid');
    const feedback = inputElement.nextElementSibling;
    if (feedback && feedback.classList.contains('invalid-feedback')) {
        feedback.textContent = '';
        feedback.style.display = 'none';
    }
    return true;
}

// Individual field validations
function validateUsername(usernameInput) {
    const value = usernameInput.value;
    if (isEmpty(value)) {
        showError(usernameInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.USERNAME.test(value)) {
        showError(usernameInput, MESSAGES.USERNAME);
        return false;
    }
    clearError(usernameInput);
    return true;
}

function validateName(nameInput, fieldName) {
    const value = nameInput.value;
    if (isEmpty(value)) {
        showError(nameInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.NAME.test(value)) {
        showError(nameInput, MESSAGES[fieldName]);
        return false;
    }
    clearError(nameInput);
    return true;
}

function validateEmail(emailInput) {
    const value = emailInput.value;
    if (isEmpty(value)) {
        showError(emailInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.EMAIL.test(value)) {
        showError(emailInput, MESSAGES.EMAIL);
        return false;
    }
    clearError(emailInput);
    return true;
}

function validateMobile(mobileInput) {
    const value = mobileInput.value;
    if (isEmpty(value)) {
        showError(mobileInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.MOBILE.test(value)) {
        showError(mobileInput, MESSAGES.MOBILE);
        return false;
    }
    clearError(mobileInput);
    return true;
}

function validatePassword(passwordInput) {
    const value = passwordInput.value;
    if (isEmpty(value)) {
        showError(passwordInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.PASSWORD_COMPLEXITY.test(value)) {
        showError(passwordInput, MESSAGES.PASSWORD);
        return false;
    }
    clearError(passwordInput);
    return true;
}

function validateConfirmPassword(passwordInput, confirmPasswordInput) {
    const value = confirmPasswordInput.value;
    const passwordValue = passwordInput.value;
    if (isEmpty(value)) {
        showError(confirmPasswordInput, MESSAGES.REQUIRED);
        return false;
    }
    if (value !== passwordValue) {
        showError(confirmPasswordInput, MESSAGES.PASSWORD_MATCH);
        return false;
    }
    clearError(confirmPasswordInput);
    return true;
}

function validateGenderRadios(radios) {
    let isSelected = false;
    for (let i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            isSelected = true;
            break;
        }
    }
    
    if (!isSelected) {
        // Find the error message span after the last radio button
        const errorElement = radios[radios.length - 1].nextElementSibling;
        if (errorElement && errorElement.classList.contains('error-message')) {
            errorElement.textContent = MESSAGES.GENDER;
            errorElement.style.display = 'block';
        }
        return false;
    }
    
    // Clear any error message
    const errorElement = radios[radios.length - 1].nextElementSibling;
    if (errorElement && errorElement.classList.contains('error-message')) {
        errorElement.textContent = '';
        errorElement.style.display = 'none';
    }
    return true;
}

// Main validation function
function validateForm() {
    const fields = {
        username: document.querySelector('input[name="username"]'),
        firstName: document.querySelector('input[name="firstName"]'),
        lastName: document.querySelector('input[name="lastName"]'),
        email: document.querySelector('input[name="email"]'),
        mobile: document.querySelector('input[name="mobile"]'),
        password: document.querySelector('input[name="password"]'),
        confirmPassword: document.querySelector('input[name="confirmPassword"]')
    };
    
    // Get gender radio buttons
    const genderRadios = document.querySelectorAll('input[name="gender"]');
    
    // Validate each field
    const isValid = [
        validateUsername(fields.username),
        validateName(fields.firstName, 'FIRST_NAME'),
        validateName(fields.lastName, 'LAST_NAME'),
        validateEmail(fields.email),
        validateMobile(fields.mobile),
        validatePassword(fields.password),
        validateConfirmPassword(fields.password, fields.confirmPassword),
        validateGenderRadios(genderRadios)
    ].every(result => result);
    
    // If not valid, prevent form submission
    if (!isValid) {
        return false;
    }
    
    return true;
}

// Validate category name
function validateCategoryName(nameInput) {
    const value = nameInput.value;
    if (isEmpty(value)) {
        return showBootstrapError(nameInput, CATEGORY_MESSAGES.NAME_REQUIRED);
    }
    if (!CATEGORY_REGEX.NAME.test(value)) {
        return showBootstrapError(nameInput, CATEGORY_MESSAGES.NAME_LENGTH);
    }
    return clearBootstrapError(nameInput);
}

// Validate category status
function validateCategoryStatus(statusSelect) {
    const value = statusSelect.value;
    if (value === "" || value === null) {
        return showBootstrapError(statusSelect, CATEGORY_MESSAGES.STATUS_REQUIRED);
    }
    return clearBootstrapError(statusSelect);
}

// Validate category form
function validateCategoryForm() {
    const fields = {
        name: document.querySelector('input[name="name"]'),
        status: document.querySelector('select[name="status"]')
    };
    
    // Validate each field
    const isNameValid = validateCategoryName(fields.name);
    const isStatusValid = validateCategoryStatus(fields.status);
    
    // Return overall validation result
    return isNameValid && isStatusValid;
}


