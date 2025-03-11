/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.swp391.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.swp391.dal.impl.AccountDAO;
import com.swp391.entity.Account;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@WebServlet(name="ManageAccountController", urlPatterns={"/admin/manage-account"})
public class ManageAccountController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "deactivate":
                deactivateAccount(request, response);
                break;
            case "activate":
                activateAccount(request, response);
                break;
            case "list":
            default:
                listAccounts(request, response);
                break;
        }
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "add":
                addAccount(request, response);
                break;
            case "update":
                updateAccount(request, response);
                break;
            default:
                listAccounts(request, response);
                break;
        }
    }

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DashboardController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DashboardController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.findById(accountId);
            if (account != null) {
                request.setAttribute("account", account);
                request.getRequestDispatcher("/view/admin/account-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-account");
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Get filter parameters
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String roleFilter = request.getParameter("role");
        String genderFilter = request.getParameter("gender");

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.findAccountsWithFilters(
            roleFilter, statusFilter, searchFilter, page, pageSize);
        
        int totalAccounts = accountDAO.getTotalFilteredAccounts(
            roleFilter, statusFilter, searchFilter);
        
        int totalPages = (int) Math.ceil((double) totalAccounts / pageSize);

        // Set attributes for JSP
        request.setAttribute("accounts", accounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalAccounts", totalAccounts);

        // Set filter values for maintaining state
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("genderFilter", genderFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("../view/admin/account-list.jsp").forward(request, response);
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            int accountId = Integer.parseInt(request.getParameter("id"));
            String password = request.getParameter("password");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            // Lấy account từ database
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.findById(accountId);

            if (account != null) {
                // Validate input data (chỉ kiểm tra phone và password nếu có thay đổi)
                Map<String, String> errors = validateAccountData(null, null, phone, 
                    password.isEmpty() ? null : password, accountId);
                
                if (!errors.isEmpty()) {
                    // Nếu có lỗi, lưu thông tin lỗi và dữ liệu đã nhập vào session
                    request.getSession().setAttribute("errors", errors);
                    request.getSession().setAttribute("formData", request.getParameterMap());
                    
                    // Chuyển hướng về form chỉnh sửa tài khoản
                    response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=edit&id=" + accountId);
                    return;
                }
                
                // Cập nhật các trường có thể thay đổi
                account.setFirstName(firstName);
                account.setLastName(lastName);
                account.setPhone(phone);
                account.setAddress(address);
                account.setStatus(status);
                
                // Cập nhật password nếu có
                if (password != null && !password.isEmpty()) {
                    account.setPassword(password);
                }
                
                // Cập nhật thời gian chỉnh sửa
                account.setUpdatedAt(LocalDateTime.now());
                
                // Thực hiện update
                boolean isSuccess = accountDAO.update(account);
                
                // Xử lý kết quả
                if (isSuccess) {
                    request.getSession().setAttribute("toastMessage", "Account updated successfully!");
                    request.getSession().setAttribute("toastType", "success");
                } else {
                    request.getSession().setAttribute("toastMessage", "Failed to update account!");
                    request.getSession().setAttribute("toastType", "error");
                }
            } else {
                request.getSession().setAttribute("toastMessage", "Account not found!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Chuyển hướng về trang list
        response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=list");
    }

    private void deactivateAccount(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            boolean deactivated = accountDAO.deactivateAccount(accountId);
            
            if (deactivated) {
                setToastMessage(request, "Account deactivated successfully", "success");
            } else {
                setToastMessage(request, "Failed to deactivate account", "error");
            }
        } else {
            setToastMessage(request, "Invalid account ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-account");
    }

    private void activateAccount(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            boolean activated = accountDAO.activateAccount(accountId);
            
            if (activated) {
                setToastMessage(request, "Account activated successfully", "success");
            } else {
                setToastMessage(request, "Failed to activate account", "error");
            }
        } else {
            setToastMessage(request, "Invalid account ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-account");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/account-add.jsp");
        dispatcher.forward(request, response);
    }

    private void addAccount(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            
            // Validate input data
            Map<String, String> errors = validateAccountData(username, email, phone, password, null);
            
            if (!errors.isEmpty()) {
                // Nếu có lỗi, lưu thông tin lỗi và dữ liệu đã nhập vào session
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());
                
                // Chuyển hướng về form thêm tài khoản
                response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=add");
                return;
            }

            // Tạo đối tượng Account mới
            Account newAccount = Account.builder()
                .username(username)
                .email(email)
                .password(password)
                .firstName(firstName)
                .lastName(lastName)
                .phone(phone)
                .address(address)
                .role(role)
                .status(status)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

            // Thêm account vào database
            AccountDAO accountDAO = new AccountDAO();
            boolean isSuccess = accountDAO.insert(newAccount) > 0;

            // Xử lý kết quả
            if (isSuccess) {
                request.getSession().setAttribute("toastMessage", "Account added successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to add account!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Chuyển hướng về trang list
        response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=list");
    }
    
    /**
     * Validate account data
     * @param username Username to validate (null if not validating)
     * @param email Email to validate (null if not validating)
     * @param phone Phone to validate (null if not validating)
     * @param password Password to validate (null if not validating)
     * @param accountId Account ID (null for new accounts)
     * @return Map of field names to error messages
     */
    private Map<String, String> validateAccountData(String username, String email, String phone, 
            String password, Integer accountId) {
        Map<String, String> errors = new HashMap<>();
        AccountDAO accountDAO = new AccountDAO();
        
        // Validate username
        if (username != null && !username.isEmpty()) {
            if (username.length() < 3 || username.length() > 50) {
                errors.put("username", "Username must be between 3 and 50 characters");
            } else if (!Pattern.matches("^[a-zA-Z0-9_]+$", username)) {
                errors.put("username", "Username can only contain letters, numbers, and underscores");
            } else if (accountDAO.isUsernameExists(username)) {
                errors.put("username", "Username already exists");
            }
        }
        
        // Validate email
        if (email != null && !email.isEmpty()) {
            String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
            if (!Pattern.matches(emailRegex, email)) {
                errors.put("email", "Invalid email format");
            } else if (accountDAO.isEmailExists(email, accountId)) {
                errors.put("email", "Email already exists");
            }
        }
        
        // Validate phone
        if (phone != null && !phone.isEmpty()) {
            if (!Pattern.matches("^[0-9]{10,15}$", phone)) {
                errors.put("phone", "Phone number must be between 10 and 15 digits");
            } else if (accountDAO.isPhoneExists(phone, accountId)) {
                errors.put("phone", "Phone number already exists");
            }
        }
        
        // Validate password
        if (password != null && !password.isEmpty()) {
            if (password.length() < 8) {
                errors.put("password", "Password must be at least 8 characters");
            } else if (!Pattern.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$", password)) {
                errors.put("password", "Password must contain at least one uppercase letter, one lowercase letter, and one number");
            }
        }
        
        return errors;
    }
}
