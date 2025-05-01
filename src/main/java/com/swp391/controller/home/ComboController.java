package com.swp391.controller.home;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.ComboDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Combo;
import com.swp391.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller để xử lý các yêu cầu liên quan đến combo sản phẩm
 */
@WebServlet(name = "ComboController", urlPatterns = {"/combo"})
public class ComboController extends HttpServlet {

    private final String COMBO_LIST_PAGE = "/view/home/combo-list.jsp";
    private final String COMBO_DETAILS_PAGE = "/view/home/combo-details.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy action từ request
            String action = request.getParameter("action");
            
            // Kiểm tra trạng thái đăng nhập và lưu vào request attribute
            HttpSession session = request.getSession();
            boolean isLoggedIn = session.getAttribute(GlobalConfig.SESSION_ACCOUNT) != null;
            request.setAttribute("isLoggedIn", isLoggedIn);
            
            // Nếu action là "details", xử lý hiển thị chi tiết combo
            if ("details".equals(action)) {
                showComboDetails(request, response);
                return;
            }
            
            // Mặc định hiển thị danh sách combo
            showComboList(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in ComboController: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * Hiển thị danh sách combo
     */
    private void showComboList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ComboDAO comboDAO = new ComboDAO();
        
        // Get search parameter
        String searchTerm = request.getParameter("search");
        
        // Xử lý phân trang
        int pageSize = 9; // Số combo trên mỗi trang
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1; // Reset về trang 1 nếu số trang không hợp lệ
            }
        }
        
        List<Combo> combos;
        int totalCombos;
        
        // If search term exists, use search functionality
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            // Get total count for pagination
            totalCombos = comboDAO.countSearchResults(searchTerm, "active");
            
            // Get combos for current page
            combos = comboDAO.searchCombos(searchTerm, "active", currentPage, pageSize);
        } else {
            // Get all active combos if no search term
            List<Combo> allCombos = comboDAO.findAllActive();
            totalCombos = allCombos.size();
            
            // Calculate pagination
            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalCombos);
            
            combos = fromIndex < totalCombos ? allCombos.subList(fromIndex, toIndex) : new ArrayList<>();
        }
        
        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalCombos / pageSize);
        
        // Validate currentPage
        if (currentPage < 1) {
            currentPage = 1;
        } else if (currentPage > totalPages) {
            currentPage = totalPages > 0 ? totalPages : 1;
        }
        
        // Tính toán phân trang
        int maxVisiblePages = 5;
        int halfVisible = (maxVisiblePages - 1) / 2;
        
        // Tính startPage và endPage
        int startPage;
        int endPage;
        
        if (totalPages <= maxVisiblePages) {
            startPage = 1;
            endPage = totalPages;
        } else {
            startPage = Math.max(1, currentPage - halfVisible);
            endPage = Math.min(currentPage + halfVisible, totalPages);
            
            // Điều chỉnh nếu khoảng trang hiển thị không đủ
            if (endPage - startPage < maxVisiblePages - 1) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }
        }
        
        // Create search query string for pagination links
        String searchQueryString = "";
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            searchQueryString = "&search=" + searchTerm;
        }
        
        // Đặt các thuộc tính vào request
        request.setAttribute("combos", combos);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("searchQueryString", searchQueryString);
        request.setAttribute("searchTerm", searchTerm);
        
        // Forward đến trang danh sách combo
        request.getRequestDispatcher(COMBO_LIST_PAGE).forward(request, response);
    }

    /**
     * Hiển thị chi tiết combo
     */
    private void showComboDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy ID combo từ request
        String comboIdStr = request.getParameter("id");
        if (comboIdStr == null || comboIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/combo");
            return;
        }
        
        try {
            int comboId = Integer.parseInt(comboIdStr);
            ComboDAO comboDAO = new ComboDAO();
            ProductDAO productDAO = new ProductDAO();
            
            // Lấy thông tin combo
            Combo combo = comboDAO.findById(comboId);
            if (combo == null || !"active".equals(combo.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/combo");
                return;
            }
            
            // Lấy danh sách sản phẩm trong combo
            List<Map<String, Object>> comboProducts = comboDAO.getComboProducts(comboId);
            List<Product> products = new ArrayList<>();
            
            // Chuyển đổi dữ liệu để hiển thị
            for (Map<String, Object> comboProduct : comboProducts) {
                int productId = (int) comboProduct.get("product_id");
                int quantity = (int) comboProduct.get("quantity");
                
                Product product = productDAO.findById(productId);
                if (product != null) {
                    product.setQuantity(quantity); // Đặt số lượng sản phẩm trong combo
                    products.add(product);
                }
            }
            
            // Đặt các thuộc tính vào request
            request.setAttribute("combo", combo);
            request.setAttribute("comboProducts", products);
            
            // Forward đến trang chi tiết combo
            request.getRequestDispatcher(COMBO_DETAILS_PAGE).forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/combo");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý các yêu cầu POST nếu cần
        doGet(request, response);
    }
}