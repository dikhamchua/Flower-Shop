/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.swp391.controller.authen;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.dal.impl.AccountDAO;
import com.swp391.entity.Account;
import com.swp391.config.GlobalConfig;
import com.swp391.utils.MD5PasswordEncoderUtils;
import com.swp391.utils.EmailUtils;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

@WebServlet(name = "AuthenController", urlPatterns = { "/authen" })
public class AuthenController extends HttpServlet {

    // URL constants
    private static final String LOGIN_PAGE = "view/authen/login.jsp";
    private static final String REGISTER_PAGE = "view/authen/register.jsp";
    private static final String ENTER_EMAIL_PAGE = "view/authen/enterEmailForgotPassword.jsp";
    private static final String VERIFY_OTP_PAGE = "view/authen/verifyOTP.jsp";
    private static final String RESET_PASSWORD_PAGE = "view/authen/resetPassword.jsp";
    private static final String HOME_PAGE = "/home";

    private static final String PASSWORD_COMPLEXITY_REGEX = "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"; // 8+ chars, 1 uppercase, 1 lowercase, 1 number

    AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get ve action
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        // dua theo action set URL trang can chuyen den
        String url;
        switch (action) {
            case "login":
                url = LOGIN_PAGE;
//                 url = fakeLogin(request, response);
                break;
            case "logout":
                url = logOut(request, response);
                break;
            case "sign-up":
                url = REGISTER_PAGE;
                break;
            case "enter-email":
                url = ENTER_EMAIL_PAGE;
                break;
            default:
                url = LOGIN_PAGE;
        }

        // chuyen trang
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get ve action
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        // dựa theo action để xử lí request
        String url;
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "sign-up":
                url = signUp(request, response);
                break;
            case "verify-otp":
                url = verifyOTP(request, response);
                break;
            case "forgot-password":
                url = forgotPassword(request, response);
                break;
            case "reset-password":
                url = resetPassword(request, response);
                break;
            default:
                url = HOME_PAGE;
        }
        
        // Kiểm tra nếu url bắt đầu bằng "/" thì redirect, ngược lại thì forward
        if (url != null && url.startsWith("/")) {
            response.sendRedirect(request.getContextPath() + url);
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private String logOut(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute(GlobalConfig.SESSION_ACCOUNT);
        return HOME_PAGE;
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) {
        String url = null;
        HttpSession session = request.getSession();
        
        // get về các thong tin người dufg nhập
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        // kiểm tra thông tin có tồn tại trong DB ko
        Account account = Account.builder()
                .username(usernameOrEmail)
                .email(usernameOrEmail)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .build();
        Account accFoundByUsernamePass = accountDAO.findByEmailOrUsernameAndPass(account);
        // true => trang home ( set account vao trong session )
        if (accFoundByUsernamePass != null) {
            // Lưu thông tin người dùng vào session
            session.setAttribute(GlobalConfig.SESSION_ACCOUNT, accFoundByUsernamePass);
            
            url = HOME_PAGE;
        } else {
            session.setAttribute("toastMessage", "Username or password incorrect!!");
            session.setAttribute("toastType", "error");
            url = LOGIN_PAGE;
        }
        return url;
    }

    private String signUp(HttpServletRequest request, HttpServletResponse response) {
        String url;
        HttpSession session = request.getSession();
        
        // Lấy thông tin người dùng nhập
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String genderParam = request.getParameter("gender");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Store form data in request to preserve it in case of validation failure
        request.setAttribute("formData", Map.of(
            "username", username != null ? username : "",
            "firstName", firstName != null ? firstName : "",
            "lastName", lastName != null ? lastName : "",
            "gender", genderParam != null ? genderParam : "",
            "email", email != null ? email : "",
            "mobile", mobile != null ? mobile : ""
        ));

        // Server-side validation
        if (username == null || username.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            genderParam == null || genderParam.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            mobile == null || mobile.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            session.setAttribute("toastMessage", "All fields are required");
            session.setAttribute("toastType", "error");
            return REGISTER_PAGE;
        }

        boolean gender = Boolean.parseBoolean(genderParam);

        // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
        if (!password.equals(confirmPassword)) {
            session.setAttribute("toastMessage", "Password and confirm password do not match");
            session.setAttribute("toastType", "error");
            return REGISTER_PAGE;
        }

        // Kiểm tra xem email đã tồn tại trong db chưa
        Account account = Account.builder()
                .username(username)
                .firstName(firstName)
                .lastName(lastName)
                .phone(mobile)
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .role(GlobalConfig.ROLE_USER)
                // .stat(false)
                .status(false)
                .build();
        Account accountFoundByEmail = accountDAO.findByEmail(account);

        if (accountFoundByEmail != null) {
            if (accountFoundByEmail.getUsername().equalsIgnoreCase(username)) {
                session.setAttribute("toastMessage", "Username already exists!");
                session.setAttribute("toastType", "error");
            } else {
                session.setAttribute("toastMessage", "Email already exists!");
                session.setAttribute("toastType", "error");
            }
            url = REGISTER_PAGE;
        } else {
            // Lưu tài khoản vào database
            int accountId = accountDAO.insert(account);
            if (accountId > 0) {
                // Tạo session cho việc kích hoạt tài khoản sau này
                account.setUserId(accountId);
                session.setAttribute(GlobalConfig.SESSION_ACCOUNT, account);
                session.setAttribute("email", email);
                session.setMaxInactiveInterval(300);

                // Gửi OTP
                String otp = EmailUtils.sendOTPMail(email);
                session.setAttribute("otp", otp);
                session.setAttribute("otp_purpose", "activation"); // Thêm mục đích OTP

                url = VERIFY_OTP_PAGE;
            } else {
                session.setAttribute("toastMessage", "Failed to create account. Please try again.");
                session.setAttribute("toastType", "error");
                url = REGISTER_PAGE;
            }
        }
        return url;
    }

    private String verifyOTP(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("email");
        String enteredOTP = request.getParameter("otp");
        String purpose = (String) session.getAttribute("otp_purpose");

        System.out.println("Verifying OTP: entered=" + enteredOTP + ", stored=" + storedOTP);
        System.out.println("Purpose: " + purpose + ", Email: " + email);

        if (storedOTP == null || email == null) {
            session.setAttribute("toastMessage", "Session expired. Please try again.");
            session.setAttribute("toastType", "error");
            return ENTER_EMAIL_PAGE;
        }

        if (storedOTP.equals(enteredOTP)) {
            System.out.println("OTP verified successfully!");
            session.setAttribute("toastMessage", "OTP verified successfully!");
            session.setAttribute("toastType", "success");
            // OTP is correct
            session.removeAttribute("otp");

            if ("activation".equals(purpose)) {
                System.out.println("Handling account activation");
                return handleAccountActivation(request, session);
            } else if ("password_reset".equals(purpose)) {
                System.out.println("Handling password reset");
                return handlePasswordReset(request, session);
            } else {
                System.out.println("Invalid purpose: " + purpose);
                request.setAttribute("error", "Invalid OTP purpose.");
                return VERIFY_OTP_PAGE;
            }
        } else {
            session.setAttribute("toastMessage", "Incorrect OTP. Please try again.");
            session.setAttribute("toastType", "error");
            return VERIFY_OTP_PAGE;
        }
    }

    private String forgotPassword(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String url;
        String email = request.getParameter("email");

        // Kiểm tra xem email có tồn tại trong cơ sở dữ liệu không
        Account account = Account.builder().email(email).build();
        Account foundAccount = accountDAO.findByEmail(account);

        if (foundAccount == null) {
            session.setAttribute("toastMessage", "No account found with this email address.");
            session.setAttribute("toastType", "error");
            url = ENTER_EMAIL_PAGE;
            return url;
        }

        // Gửi OTP
        String otp = EmailUtils.sendOTPMail(email);

        // Lưu thông tin vào session
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setAttribute("otp_purpose", "password_reset");
        session.setAttribute("account_id", foundAccount.getUserId());

        // Đặt thời gian hết hạn cho session (ví dụ: 15 phút)
        session.setMaxInactiveInterval(15 * 60);

        url = VERIFY_OTP_PAGE;
        return url;
    }

    private String handleAccountActivation(HttpServletRequest request, HttpSession session) {
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account != null) {
            account.setStatus(true);
            accountDAO.activateAccount(account.getUserId());
            request.setAttribute("message", "Your account has been successfully activated!");
            return HOME_PAGE;
        } else {
            request.setAttribute("error", "Session expired. Please sign up again.");
            return REGISTER_PAGE;
        }
    }

    private String handlePasswordReset(HttpServletRequest request, HttpSession session) {
        // Redirect to password reset page
        return RESET_PASSWORD_PAGE;
    }

    private String resetPassword(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        if (email == null) {
            session.setAttribute("toastMessage", "Session expired. Please start the password reset process again.");
            session.setAttribute("toastType", "error");
            return ENTER_EMAIL_PAGE;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra xem mật khẩu mới và xác nhận mật khẩu có khớp không
        if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            session.setAttribute("toastMessage", "New password and confirm password are required.");
            session.setAttribute("toastType", "error");
            return RESET_PASSWORD_PAGE;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("toastMessage", "Passwords do not match.");
            session.setAttribute("toastType", "error");
            return RESET_PASSWORD_PAGE;
        }

        if (!isValidPassword(newPassword)) {
            session.setAttribute("toastMessage", "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.");
            session.setAttribute("toastType", "error");
            return RESET_PASSWORD_PAGE;
        }

        Account account = Account.builder()
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(newPassword))
                .build();

        boolean updated = accountDAO.updatePassword(account);
        if (updated) {
            session.setAttribute("toastMessage", "Your password has been successfully reset.");
            session.setAttribute("toastType", "success");
            return LOGIN_PAGE;
        } else {
            session.setAttribute("toastMessage", "Failed to reset password. Please try again.");
            session.setAttribute("toastType", "error");
            return RESET_PASSWORD_PAGE;
        }
    }

    private boolean isValidPassword(String password) {
        return password.matches(PASSWORD_COMPLEXITY_REGEX); // Kiểm tra mật khẩu theo regex
    }

    private String fakeLogin(HttpServletRequest request, HttpServletResponse response) {
        String url = null;
        // get về các thong tin người dufg nhập
        String email = "long10";
        String password = "Edison@28";
        // kiểm tra thông tin có tồn tại trong DB ko
        Account account = Account.builder()
                .username(email)
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .build();
        Account accFoundByUsernamePass = accountDAO.findByEmailOrUsernameAndPass(account);
        // true => trang home ( set account vao trong session )
        if (accFoundByUsernamePass != null) {
            request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT,
                    accFoundByUsernamePass);
            
            url = HOME_PAGE;
            // false => quay tro lai trang login ( set them thong bao loi )
        } else {
            request.setAttribute("error", "Username or password incorrect!!");
            url = LOGIN_PAGE;
        }
        return url;
    }

}