/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.swp391.controller.home;

import com.swp391.config.GlobalConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.swp391.dal.impl.CategoryDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.dal.impl.FeedbacksDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import com.swp391.entity.CartItem;
import com.swp391.entity.Account;
import com.swp391.entity.Feedbacks;


@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final String HOME_PAGE = "view/home/shop.jsp";
    private final int TOP_RATE = 5;
    private final String PRODUCT_DETAILS_PAGE = "/view/home/product-details.jsp";
    private final int RELATED_PRODUCTS_COUNT = 4;

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
            
            // Nếu action là "product-details", xử lý hiển thị chi tiết sản phẩm
            if ("product-details".equals(action)) {
                showProductDetails(request, response);
                return;
            }
            
            // Debug session
            Object account = session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            System.out.println("SESSION_ACCOUNT in HomeController: " + account);
            
            // Kiểm tra tất cả các thuộc tính trong session
            System.out.println("All session attributes:");
            java.util.Enumeration<String> attributeNames = session.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                System.out.println(name + " = " + session.getAttribute(name));
            }
            
            // Khởi tạo các DAO cần thiết
            CategoryDAO categoryDAO = new CategoryDAO();
            ProductDAO productDAO = new ProductDAO();

            // Xử lý phân trang
            int pageSize = 9; // Số sản phẩm trên mỗi trang
            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                currentPage = Integer.parseInt(pageStr);
            }

            // Xử lý các tham số lọc
            String searchKeyword = request.getParameter("search");
            String categoriesParam = request.getParameter("categories");
            String minPriceParam = request.getParameter("minPrice");
            String maxPriceParam = request.getParameter("maxPrice");
            String sortParam = request.getParameter("sort");

            // Xử lý lọc theo danh mục
            List<Integer> selectedCategoryIds = new ArrayList<>();
            if (categoriesParam != null && !categoriesParam.isEmpty()) {
                selectedCategoryIds = Arrays.stream(categoriesParam.split(","))
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());
            }

            // Xử lý lọc theo giá
            Double minPrice = null;
            Double maxPrice = null;
            if (minPriceParam != null && !minPriceParam.isEmpty()) {
                minPrice = Double.parseDouble(minPriceParam);
            }
            if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceParam);
            }

            // Lấy giá trị min/max của tất cả sản phẩm cho price slider
            double globalMinPrice = productDAO.getMinPrice();
            double globalMaxPrice = productDAO.getMaxPrice();

            // Nếu không có giá trị lọc, sử dụng giá trị mặc định
            if (minPrice == null) minPrice = globalMinPrice;
            if (maxPrice == null) maxPrice = globalMaxPrice;

            // Lấy danh sách sản phẩm với bộ lọc
            List<Product> products = productDAO.findProductsWithFilters(
                searchKeyword, selectedCategoryIds, minPrice, maxPrice,
                sortParam, currentPage, pageSize
            );
            
            // Đếm tổng số sản phẩm thỏa mãn điều kiện lọc
            int totalProducts = productDAO.countProductsWithFilters(
                searchKeyword, selectedCategoryIds, minPrice, maxPrice
            );

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

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

            // Lấy danh mục và số lượng sản phẩm cho sidebar
            List<Category> allCategories = categoryDAO.findAllActive();
            Map<Integer, Integer> categoryProductCounts = categoryDAO.getAllCategoryProductCounts();

            // Lấy top 5 sản phẩm đánh giá cao nhất
            List<Product> topRatedProducts = productDAO.findTopRatedProducts(TOP_RATE);

            // Lấy tham số sort từ request
            String sortType = request.getParameter("sort");
            if (sortType == null || sortType.isEmpty()) {
                sortType = "default"; // Giá trị mặc định
            }

            // Sắp xếp danh sách sản phẩm dựa trên sortType
            sortProducts(products, sortType);

            // Lưu tham số sort vào request để hiển thị selected option
            request.setAttribute("currentSort", sortType);

            // Đặt các thuộc tính cho request
            request.setAttribute("products", products);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("productsPerPage", pageSize);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("maxVisiblePages", maxVisiblePages);

            // Thuộc tính cho sidebar và bộ lọc
            request.setAttribute("selectedCategories", new HashSet<>(selectedCategoryIds));
            request.setAttribute("minPrice", globalMinPrice);
            request.setAttribute("maxPrice", globalMaxPrice);
            request.setAttribute("selectedMinPrice", minPrice);
            request.setAttribute("selectedMaxPrice", maxPrice);
            request.setAttribute("topRatedProducts", topRatedProducts);
            request.setAttribute("allCategories", allCategories);
            request.setAttribute("categoryProductCounts", categoryProductCounts);

            // Forward đến trang shop
            request.getRequestDispatcher("/view/home/shop.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(HOME_PAGE);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // // Kiểm tra trạng thái đăng nhập của người dùng
        // HttpSession session = request.getSession();
        // Object loggedInUser = session.getAttribute("account");

        // // Truyền trạng thái đăng nhập đến trang JSP
        // request.setAttribute("isLoggedIn", loggedInUser != null);

        // request.getRequestDispatcher(HOME_PAGE).forward(request, response);
    }

    private void sortProducts(List<Product> products, String sortType) {
        switch (sortType) {
            case "name_asc":
                Collections.sort(products, (a, b) -> a.getProductName().compareTo(b.getProductName()));
                break;
            case "name_desc":
                Collections.sort(products, (a, b) -> b.getProductName().compareTo(a.getProductName()));
                break;
            case "price_asc":
                Collections.sort(products, (a, b) -> a.getPrice().compareTo(b.getPrice()));
                break;
            case "price_desc":
                Collections.sort(products, (a, b) -> b.getPrice().compareTo(a.getPrice()));
                break;
            case "newest":
                Collections.sort(products, (a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
                break;
        }
    }

    /**
     * Xử lý hiển thị chi tiết sản phẩm
     */
    private void showProductDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy ID sản phẩm từ request
            String productIdStr = request.getParameter("id");
            
            if (productIdStr == null || productIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            int productId = Integer.parseInt(productIdStr);
            
            // Khởi tạo DAO
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            FeedbacksDAO feedbacksDAO = new FeedbacksDAO();
            OrderDAO orderDAO = new OrderDAO();
            
            // Lấy thông tin chi tiết sản phẩm
            Product product = productDAO.findById(productId);
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Lấy danh sách sản phẩm liên quan (cùng danh mục)
            List<Product> relatedProducts = productDAO.findRelatedProducts(product.getCategoryId(), productId, RELATED_PRODUCTS_COUNT);
            
            // Kiểm tra trạng thái đăng nhập và lưu vào request attribute
            HttpSession session = request.getSession();
            boolean isLoggedIn = session.getAttribute(GlobalConfig.SESSION_ACCOUNT) != null;
            request.setAttribute("isLoggedIn", isLoggedIn);
            
            // Lấy danh sách đánh giá của sản phẩm
            List<Feedbacks> productFeedbacks = feedbacksDAO.getFeedbacksByProductId(productId);
            request.setAttribute("productFeedbacks", productFeedbacks);
            
            // Kiểm tra xem người dùng đã đăng nhập có thể đánh giá sản phẩm này không
            boolean canReview = false;
            if (isLoggedIn) {
                Account loggedInUser = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
                // Kiểm tra xem người dùng đã mua sản phẩm này chưa
                canReview = orderDAO.hasUserPurchasedProduct(loggedInUser.getUserId(), productId);
                // Kiểm tra xem người dùng đã đánh giá sản phẩm này chưa
                if (canReview) {
                    canReview = !feedbacksDAO.hasUserReviewedProduct(loggedInUser.getUserId(), productId);
                }
            }
            request.setAttribute("canReview", canReview);
            
            // Đặt thuộc tính cho request
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            
            // Lấy tên danh mục
            String categoryName = categoryDAO.findById(product.getCategoryId()).getName();
            request.setAttribute("categoryName", categoryName);
            
            // Kiểm tra thông báo từ session và xóa sau khi sử dụng
            String cartMessage = (String) session.getAttribute("cartMessage");
            if (cartMessage != null) {
                request.setAttribute("cartMessage", cartMessage);
                session.removeAttribute("cartMessage"); // Xóa thông báo sau khi sử dụng
            }
            
            // Forward đến trang chi tiết sản phẩm
            request.getRequestDispatcher(PRODUCT_DETAILS_PAGE).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            }
        }
    }

}
