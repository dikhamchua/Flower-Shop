package com.swp391.controller.home;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.dal.impl.CartItemDAO;
import com.swp391.dal.impl.CouponDAO;
import com.swp391.dal.impl.CouponUsageDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.dal.impl.OrderItemDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.CartItem;
import com.swp391.entity.Coupon;
import com.swp391.entity.CouponUsage;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import com.swp391.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final String CART_PAGE = "/view/home/cart.jsp";
    private final String CHECKOUT_PAGE = "/view/home/checkout.jsp";
    private final String LOGIN_PAGE = "/view/home/login.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Kiểm tra đăng nhập trước khi cho phép xem giỏ hàng
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            if (account == null) {
                // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
                session.setAttribute("loginMessage", "Please log in to view your cart");
                response.sendRedirect(request.getContextPath() + "/authen?action=login");
                return;
            }
            
            String action = request.getParameter("action");
            
            if (action != null) {
                switch (action) {
                    case "remove":
                        handleRemoveFromCart(request, response);
                        break;
                    case "get-count":
                        handleGetCartCount(request, response);
                        break;
                    case "clear":
                        handleClearCart(request, response);
                        break;
                    case "proceed-to-checkout":
                        handleProceedToCheckout(request, response);
                        break;
                    case "remove-coupon":
                        handleRemoveCoupon(request, response);
                        break;
                    default:
                        handleShowCart(request, response);
                        break;
                }
            } else {
                handleShowCart(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Thay vì chuyển hướng đến trang lỗi, đặt thông báo lỗi vào session và quay lại trang giỏ hàng
            HttpSession session = request.getSession();
            session.setAttribute("cartMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            if (account == null) {
                // Nếu là AJAX request
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("Please log in to perform this operation");
                    return;
                }
                
                // Nếu không phải AJAX request
                session.setAttribute("loginMessage", "Please log in to perform operations with your cart");
                response.sendRedirect(request.getContextPath() + "/authen?action=login");
                return;
            }
            
            String action = request.getParameter("action");

            if (action != null) {
                switch (action) {
                    case "add":
                        handleAddToCart(request, response);
                        break;
                    case "update":
                        handleUpdateCart(request, response);
                        break;
                    case "checkout":
                        handleProcessCheckout(request, response);
                        break;
                    case "apply-coupon":
                        handleApplyCoupon(request, response);
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/cart");
                        break;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Thay vì chuyển hướng đến trang lỗi, đặt thông báo lỗi vào session và quay lại trang giỏ hàng
            HttpSession session = request.getSession();
            session.setAttribute("cartMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    // GET handlers
    private void handleShowCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Lấy giỏ hàng từ database
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        
        if (cartId == 0) {
            // Nếu người dùng chưa có giỏ hàng, tạo giỏ hàng mới
            cartId = cartDAO.createCart(account.getUserId());
        }
        
        // Lấy danh sách sản phẩm trong giỏ hàng
        CartItemDAO cartItemDAO = new CartItemDAO();
        List<CartItem> cartItems = cartItemDAO.getCartItemsByCartId(cartId);
        
        // Tính tổng giá trị giỏ hàng
        double cartTotal = calculateCartTotal(cartItems);
        
        // Áp dụng giảm giá nếu có
        BigDecimal couponDiscount = (BigDecimal) session.getAttribute("couponDiscount");
        double finalTotal = cartTotal;
        if (couponDiscount != null) {
            // Đảm bảo finalTotal không âm
            finalTotal = Math.max(0, cartTotal - couponDiscount.doubleValue());
        }
        
        // Đặt thuộc tính cho request
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("finalTotal", finalTotal);
        
        // Forward đến trang giỏ hàng
        request.getRequestDispatcher(CART_PAGE).forward(request, response);
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Lấy cart_id từ user_id
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        
        if (cartId > 0) {
            // Xóa sản phẩm khỏi giỏ hàng
            CartItemDAO cartItemDAO = new CartItemDAO();
            cartItemDAO.deleteCartItem(cartId, productId);
        }
        
        // Chuyển hướng về trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleGetCartCount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Lấy số lượng sản phẩm từ database
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        
        int cartCount = 0;
        if (cartId > 0) {
            CartItemDAO cartItemDAO = new CartItemDAO();
            cartCount = cartItemDAO.countCartItems(cartId);
        }
        
        // Trả về số lượng sản phẩm trong giỏ hàng
        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(cartCount));
    }

    private void handleClearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        // Lấy cart_id từ user_id
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        
        if (cartId > 0) {
            // Xóa tất cả sản phẩm khỏi giỏ hàng
            CartItemDAO cartItemDAO = new CartItemDAO();
            cartItemDAO.deleteAllCartItems(cartId);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    // POST handlers
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        // Lấy thông tin sản phẩm
        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.findById(productId);
        
        if (product != null) {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            // Kiểm tra số lượng tồn kho
            if (quantity > product.getStock()) {
                // Nếu là AJAX request
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("text/plain");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Only " + product.getStock() + " items of " + product.getProductName() + " are available.");
                    return;
                }
                
                // Nếu không phải AJAX request
                session.setAttribute("cartMessage", product.getProductName() + " is only available in " + product.getStock() + " items.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            // Lấy hoặc tạo giỏ hàng
            CartDAO cartDAO = new CartDAO();
            int cartId = cartDAO.getCartIdByUserId(account.getUserId());
            
            if (cartId > 0) {
                // Thêm sản phẩm vào giỏ hàng
                CartItemDAO cartItemDAO = new CartItemDAO();
                
                // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
                CartItem existingItem = cartItemDAO.findCartItem(cartId, productId);
                boolean success;
                
                if (existingItem != null) {
                    // Nếu sản phẩm đã có trong giỏ hàng, kiểm tra tổng số lượng
                    int newQuantity = existingItem.getQuantity() + quantity;
                    if (newQuantity > product.getStock()) {
                        // Nếu là AJAX request
                        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                            response.setContentType("text/plain");
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            response.getWriter().write("Only " + product.getStock() + " items of " + product.getProductName() + " are available.");
                            return;
                        }
                        
                        // Nếu không phải AJAX request
                        session.setAttribute("cartMessage", product.getProductName() + " is only available in " + product.getStock() + " items.");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                    
                    // Cập nhật số lượng
                    success = cartItemDAO.updateCartItemQuantity(existingItem.getCartItemId(), newQuantity);
                } else {
                    // Thêm mới sản phẩm vào giỏ hàng
                    success = cartItemDAO.addCartItem(cartId, productId, quantity);
                }
                
                // Nếu là AJAX request, trả về số lượng sản phẩm trong giỏ hàng
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("text/plain");
                    if (success) {
                        int cartCount = cartDAO.getCartItemCount(account.getUserId());
                        response.getWriter().write(String.valueOf(cartCount));
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().write("Failed to add product to cart");
                    }
                    return;
                }
                
                // Nếu không phải AJAX, chuyển hướng về trang giỏ hàng
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                // Xử lý khi không thể tạo giỏ hàng
                session.setAttribute("cartMessage", "Unable to create cart. Please try again later.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
            // Xử lý khi không tìm thấy sản phẩm
            HttpSession session = request.getSession();
            session.setAttribute("cartMessage", "Product not found. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        
        if (productIds != null && quantities != null && productIds.length == quantities.length) {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            // Lấy cart_id từ user_id
            CartDAO cartDAO = new CartDAO();
            int cartId = cartDAO.getCartIdByUserId(account.getUserId());
            
            if (cartId > 0) {
                CartItemDAO cartItemDAO = new CartItemDAO();
                ProductDAO productDAO = new ProductDAO();
                StringBuilder errorMessage = new StringBuilder();
                boolean hasStockError = false;
                boolean hasInputError = false;
                
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity;
                    
                    try {
                        // Kiểm tra và giới hạn giá trị số lượng
                        String quantityStr = quantities[i];
                        if (quantityStr.length() > 9) { // Giới hạn độ dài chuỗi để tránh lỗi số quá lớn
                            quantityStr = "9999"; // Giới hạn số lượng tối đa
                            hasInputError = true;
                        }
                        quantity = Integer.parseInt(quantityStr);
                        
                        // Giới hạn số lượng tối đa là 9999 để tránh lỗi
                        if (quantity > 9999) {
                            quantity = 9999;
                            hasInputError = true;
                        }
                    } catch (NumberFormatException e) {
                        // Nếu không thể chuyển đổi thành số, đặt số lượng là 1
                        quantity = 1;
                        hasInputError = true;
                    }
                    
                    // Lấy thông tin sản phẩm
                    Product product = productDAO.findById(productId);
                    
                    if (product != null) {
                        // Kiểm tra số lượng tồn kho
                        if (quantity > product.getStock()) {
                            hasStockError = true;
                            errorMessage.append("- ").append(product.getProductName())
                                       .append(": We only have ").append(product.getStock())
                                       .append(" items in stock (you requested ").append(quantity)
                                       .append(" items)\n");
                            
                            // Cập nhật số lượng về giới hạn tồn kho
                            CartItem cartItem = cartItemDAO.findCartItem(cartId, productId);
                            if (cartItem != null) {
                                cartItemDAO.updateCartItemQuantity(cartItem.getCartItemId(), product.getStock());
                            }
                        } else if (quantity > 0) {
                            // Cập nhật số lượng nếu hợp lệ
                            CartItem cartItem = cartItemDAO.findCartItem(cartId, productId);
                            if (cartItem != null) {
                                cartItemDAO.updateCartItemQuantity(cartItem.getCartItemId(), quantity);
                            }
                        } else {
                            // Nếu số lượng <= 0, xóa sản phẩm khỏi giỏ hàng
                            cartItemDAO.deleteCartItem(cartId, productId);
                        }
                    }
                }
                
                if (hasInputError && !hasStockError) {
                    session.setAttribute("cartMessage", "The product quantity was too large and has been adjusted to a valid value.");
                }
                
                if (hasStockError) {
                    session.setAttribute("cartMessage", "Some products in your cart exceed our available stock:\n" 
                            + errorMessage.toString() + "\nWe apologize for the inconvenience.");
                }
            }
        }
        
        // Chuyển hướng về trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleProceedToCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Lấy cart_id từ user_id
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        
        if (cartId == 0) {
            session.setAttribute("cartMessage", "Your cart is empty");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Lấy danh sách sản phẩm trong giỏ hàng
        CartItemDAO cartItemDAO = new CartItemDAO();
        List<CartItem> cartItems = cartItemDAO.getCartItemsByCartId(cartId);
        
        if (cartItems.isEmpty()) {
            session.setAttribute("cartMessage", "Your cart is empty. Please add items before checkout.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra số lượng tồn kho
        ProductDAO productDAO = new ProductDAO();
        StringBuilder errorMessage = new StringBuilder();
        boolean hasStockError = false;
        
        for (CartItem item : cartItems) {
            Product product = productDAO.findById(item.getProduct().getProductId());
            if (product != null && item.getQuantity() > product.getStock()) {
                hasStockError = true;
                errorMessage.append("- ").append(product.getProductName())
                           .append(": Only ").append(product.getStock())
                           .append(" items available (you requested ").append(item.getQuantity())
                           .append(")\n");
            }
        }
        
        if (hasStockError) {
            session.setAttribute("cartMessage", "Some items in your cart exceed available stock:\n" + errorMessage.toString());
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Nếu mọi thứ OK, tiếp tục với checkout
        double cartTotal = calculateCartTotal(cartItems);
        
        // Áp dụng giảm giá nếu có
        double finalTotal = cartTotal;
        BigDecimal couponDiscount = (BigDecimal) session.getAttribute("couponDiscount");
        if (couponDiscount != null) {
            // Đảm bảo finalTotal không âm
            finalTotal = Math.max(0, cartTotal - couponDiscount.doubleValue());
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("couponDiscount", couponDiscount);
        request.setAttribute("appliedCoupon", session.getAttribute("appliedCoupon"));
        request.setAttribute("account", account);
        
        request.getRequestDispatcher(CHECKOUT_PAGE).forward(request, response);
    }

    private void handleProcessCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Lấy thông tin từ form checkout
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Lấy giỏ hàng
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        
        if (cartId == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Lấy sản phẩm trong giỏ hàng
        CartItemDAO cartItemDAO = new CartItemDAO();
        List<CartItem> cartItems = cartItemDAO.getCartItemsByCartId(cartId);
        
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Tính tổng giá trị
        double cartTotal = calculateCartTotal(cartItems);
        
        // Áp dụng giảm giá nếu có
        BigDecimal couponDiscount = (BigDecimal) session.getAttribute("couponDiscount");
        Coupon appliedCoupon = (Coupon) session.getAttribute("appliedCoupon");
        double finalTotal = cartTotal;
        if (couponDiscount != null) {
            // Đảm bảo finalTotal không âm
            finalTotal = Math.max(0, cartTotal - couponDiscount.doubleValue());
        }
        
        // Tạo đơn hàng trong database với finalTotal thay vì cartTotal
        OrderDAO orderDAO = new OrderDAO();
        Order order = new Order();
        order.setUserId(account.getUserId());
        order.setStatus("pending");  // Trạng thái mặc định là "pending"
        order.setTotal(new BigDecimal(finalTotal)); // Sử dụng finalTotal thay vì total
        order.setShippingAddress(address);
        order.setPaymentMethod(paymentMethod);
        
        int orderId = orderDAO.insert(order);
        
        if (orderId > 0) {
            // Tạo chi tiết đơn hàng
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            boolean allItemsInserted = true;
            
            for (CartItem item : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setProductId(item.getProduct().getProductId());
                orderItem.setQuantity(item.getQuantity());
                
                // Sửa lại dòng này để tránh tạo BigDecimal từ BigDecimal
                // Tùy vào kiểu dữ liệu của item.getProduct().getPrice()
                if (item.getProduct().getPrice() instanceof BigDecimal) {
                    orderItem.setPrice((BigDecimal) item.getProduct().getPrice());
                } else {
                    // Nếu là double
                    orderItem.setPrice(new BigDecimal(item.getProduct().getPrice().toString()));
                }
                
                if (!orderItemDAO.insert(orderItem)) {
                    allItemsInserted = false;
                    break;
                }
            }
            
            // Lưu thông tin sử dụng coupon nếu có
            if (appliedCoupon != null) {
                CouponUsageDAO couponUsageDAO = new CouponUsageDAO();
                CouponUsage couponUsage = new CouponUsage();
                couponUsage.setCouponId(appliedCoupon.getCouponId());
                couponUsage.setUserId(account.getUserId());
                couponUsage.setOrderId(orderId);
                couponUsageDAO.insertCouponUsage(couponUsage);
                
                // Xóa coupon khỏi session sau khi sử dụng
                session.removeAttribute("appliedCoupon");
                session.removeAttribute("couponDiscount");
            }
            
            if (allItemsInserted) {
                // Sau khi đặt hàng thành công, xóa giỏ hàng
                cartItemDAO.deleteAllCartItems(cartId);
                
                // Thông báo thành công
                session.setAttribute("orderSuccessMessage", "Your order has been placed successfully!");
                
                // Chuyển hướng đến trang danh sách đơn hàng
                response.sendRedirect(request.getContextPath() + "/orderControll");
                return;
            }
        }
        
        // Nếu có lỗi xảy ra
        session.setAttribute("errorMessage", "Failed to place your order. Please try again.");
        response.sendRedirect(request.getContextPath() + "/cart?action=proceed-to-checkout");
    }

    // GET handler for removing coupon
    private void handleRemoveCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Xóa coupon khỏi session
        session.removeAttribute("appliedCoupon");
        session.removeAttribute("couponDiscount");
        session.setAttribute("couponMessage", "Coupon removed");
        
        // Chuyển hướng về trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    // POST handler for applying coupon
    private void handleApplyCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String couponCode = request.getParameter("couponCode");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (couponCode == null || couponCode.trim().isEmpty()) {
            session.setAttribute("couponMessage", "Please enter a coupon code");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra coupon trong database
        CouponDAO couponDAO = new CouponDAO();
        Coupon coupon = couponDAO.getCouponByCode(couponCode.trim());
        
        if (coupon == null) {
            session.setAttribute("couponMessage", "Coupon does not exist");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra xem coupon có đang hoạt động không
        if (!coupon.isActive()) {
            session.setAttribute("couponMessage", "This coupon is no longer valid");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra thời hạn
        Date now = new Date();
        if (now.before(coupon.getStartDate()) || now.after(coupon.getEndDate())) {
            session.setAttribute("couponMessage", "This coupon has expired or is not yet valid");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra giới hạn sử dụng
        if (coupon.getUsageLimit() != null && coupon.getUsageCount() >= coupon.getUsageLimit()) {
            session.setAttribute("couponMessage", "This coupon has reached its usage limit");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Kiểm tra xem người dùng đã sử dụng coupon này chưa
        CouponUsageDAO couponUsageDAO = new CouponUsageDAO();
        if (couponUsageDAO.hasCouponBeenUsedByUser(coupon.getCouponId(), account.getUserId())) {
            session.setAttribute("couponMessage", "You have already used this coupon");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Lấy giỏ hàng và tính tổng giá trị
        CartDAO cartDAO = new CartDAO();
        int cartId = cartDAO.getCartIdByUserId(account.getUserId());
        CartItemDAO cartItemDAO = new CartItemDAO();
        List<CartItem> cartItems = cartItemDAO.getCartItemsByCartId(cartId);
        double cartTotal = calculateCartTotal(cartItems);
        
        // Kiểm tra giá trị tối thiểu
        if (coupon.getMinPurchase() != null && new BigDecimal(cartTotal).compareTo(coupon.getMinPurchase()) < 0) {
            session.setAttribute("couponMessage", "Order total is below the minimum required to use this coupon (" 
                    + formatCurrency(coupon.getMinPurchase()) + ")");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Tính toán giá trị giảm giá
        BigDecimal discount;
        if ("percentage".equals(coupon.getDiscountType())) {
            // Giảm giá theo phần trăm
            discount = new BigDecimal(cartTotal).multiply(coupon.getDiscountValue().divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
            
            // Kiểm tra giới hạn giảm giá tối đa
            if (coupon.getMaxDiscount() != null && discount.compareTo(coupon.getMaxDiscount()) > 0) {
                discount = coupon.getMaxDiscount();
            }
        } else {
            // Giảm giá cố định
            discount = coupon.getDiscountValue();
        }
        
        // Đảm bảo giảm giá không vượt quá tổng giá trị đơn hàng
        if (discount.compareTo(new BigDecimal(cartTotal)) > 0) {
            discount = new BigDecimal(cartTotal);
        }
        
        // Lưu coupon và giá trị giảm giá vào session
        session.setAttribute("appliedCoupon", coupon);
        session.setAttribute("couponDiscount", discount);
        session.setAttribute("couponMessage", "Coupon applied successfully! Discount " 
                + formatCurrency(discount) + " from order total.");
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    // Helper methods
    private double calculateCartTotal(List<CartItem> cartItems) {
        double total = 0;
        
        for (CartItem item : cartItems) {
            total += item.getSubtotal();
        }
        
        return total;
    }

    // Helper method để định dạng tiền tệ
    private String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0₫";
        return String.format("%,.0f", amount) + "₫";
    }
}
