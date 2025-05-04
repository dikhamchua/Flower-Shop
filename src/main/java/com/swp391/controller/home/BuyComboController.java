package com.swp391.controller.home;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.ComboDAO; // Giả sử bạn có ComboDAO
import com.swp391.dal.impl.ComboProductDAO; // Giả sử bạn có ComboProductDAO
import com.swp391.dal.impl.OrderComboDAO;
import com.swp391.dal.impl.OrderComboProductDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Combo;
import com.swp391.entity.ComboProduct;
import com.swp391.entity.Order;
import com.swp391.entity.OrderCombo;
import com.swp391.entity.OrderComboProduct;
import com.swp391.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "BuyComboController", urlPatterns = {"/buy-combo", "/process-vnpay"})
public class BuyComboController extends HttpServlet {

    private ProductDAO productDAO;
    private ComboDAO comboDAO; // Khởi tạo DAO
    private ComboProductDAO comboProductDAO; // Khởi tạo DAO
    private OrderDAO orderDAO; // Khởi tạo DAO
    private OrderComboDAO orderComboDAO;
    private OrderComboProductDAO orderComboProductDAO;

    private static final String COMBO_SERVLET_URL = "combo";

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        comboDAO = new ComboDAO(); // Khởi tạo
        comboProductDAO = new ComboProductDAO(); // Khởi tạo
        orderDAO = new OrderDAO(); // Khởi tạo
        orderComboDAO = new OrderComboDAO();
        orderComboProductDAO = new OrderComboProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //get part
        String path = request.getServletPath();

        switch (path) {
            case "/buy-combo":
                processBuyCombo(request, response);
                break;
            case "/process-vnpay":
                processVnpay(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * Xử lý thông tin khi VNPAY trả về
     * @param request
     * @param response
     * @throws IOException 
     */
    private void processVnpay(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //get combo info
        HttpSession session = request.getSession();
        try {
            Combo combo = (Combo) session.getAttribute("combo");
            int quantity = (int) session.getAttribute("quantity");
            List<ComboProduct> comboProducts = (List<ComboProduct>) session.getAttribute("comboProducts");
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);


            //get VNPAY info
            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");

            //kiểm tra trạng thái thanh toán
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                // Thanh toán thành công
                //STEP 1:  insert order
                Order order = new Order();
                order.setUserId(account.getUserId());
                order.setStatus(GlobalConfig.ORDER_STATUS_PENDING);
                order.setShippingAddress(account.getAddress());
                order.setTotal(BigDecimal.valueOf(combo.getDiscountPrice()));
                order.setPaymentMethod(GlobalConfig.PAYMENT_METHOD_VNPAY);
                order.setType(GlobalConfig.ORDER_TYPE_WHOLE_SALE);

                int orderIdAfterInsrt = orderDAO.insert(order);

                //STEP2: insert order combo
                OrderCombo orderCombo = OrderCombo
                                            .builder()
                                            .orderId(orderIdAfterInsrt)
                                            .comboId(combo.getComboId())
                                            .comboName(combo.getName())
                                            .comboDiscountPrice(BigDecimal.valueOf(combo.getDiscountPrice()))
                                            .quantity(quantity)
                                            .totalPrice(BigDecimal.valueOf(combo.getOriginalPrice()))
                                            .build();

                int orderComboIdAfterInsert = orderComboDAO.insert(orderCombo);

                //STEP3 : insert order combo product
                for (ComboProduct cp : comboProducts) {
                    Product product = productDAO.findById(cp.getProductId());
                    OrderComboProduct orderComboProduct = OrderComboProduct
                                                             .builder()
                                                            .orderComboId(orderComboIdAfterInsert)
                                                            .productId(product.getProductId())
                                                            .productName(product.getProductName())
                                                            .productPrice(product.getPrice())
                                                            .quantityInCombo(cp.getQuantityInCombo())
                                                            .totalQuantity(cp.getQuantityInCombo() * quantity)
                                                            .build();

                    orderComboProductDAO.insert(orderComboProduct);
                    int newStock = product.getStock() - cp.getQuantityInCombo() * quantity;
                    product.setStock(newStock);
                    productDAO.update(product);
                }
                //Xóa session
                session.removeAttribute("combo");
                session.removeAttribute("quantity");
                session.removeAttribute("comboProducts");

                setToastMessage(request, "Order Successful !!", "success");
                response.sendRedirect(COMBO_SERVLET_URL);
            }else {
                // Thanh toán không thành công hoặc lỗi
                // Xử lý lỗi hoặc chuyển hướng đến trang thông báo lỗi
                setToastMessage(request, "Order failed. Something Wrong!!", "error");
                response.sendRedirect(COMBO_SERVLET_URL);
            }            


        } catch (Exception e) {
            setToastMessage(request, "Order failed. Something Wrong!! " + e.getMessage(), "error");
            response.sendRedirect(COMBO_SERVLET_URL);
        }
        

    }

    /**
     * Xử lý khi bấm nút mua combo
     * 
     * @param request
     * @param response
     * @throws UnsupportedEncodingException
     * @throws IOException
     */
    private void processBuyCombo(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, IOException {
        // Chuyển hướng về trang chủ hoặc trang combo nếu truy cập GET
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        // Kiểm tra đăng nhập
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login&message=Vui lòng đăng nhập để mua hàng");
            return;
        }

        String comboIdStr = request.getParameter("comboId");
        String quantityStr = request.getParameter("quantity");
        String errorMessage = null;

        int comboId = 0;
        int quantity = 0;

        try {
            comboId = Integer.parseInt(comboIdStr);
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                throw new NumberFormatException("Số lượng phải lớn hơn 0");
            }
        } catch (NumberFormatException e) {
            errorMessage = "ID combo hoặc số lượng không hợp lệ.";
            System.out.println("Hàm processBuyCombo: " + errorMessage);
            setToastMessage(request, "Order failed. Something Wrong!!", "error");
            response.sendRedirect(COMBO_SERVLET_URL);
            return;
        }

        // Lấy thông tin combo
        Combo combo = comboDAO.findById(comboId);
        if (combo == null) {
            errorMessage = "Không tìm thấy combo.";
            System.out.println("Hàm processBuyCombo: " + errorMessage);
            setToastMessage(request, "Order failed. Something Wrong!!", "error");
            response.sendRedirect(COMBO_SERVLET_URL);
            return;
        }

        // Lấy danh sách sản phẩm trong combo
        List<ComboProduct> comboProducts = comboProductDAO.getProductsByComboId(comboId); // Giả sử có hàm này

        // Kiểm tra tồn kho cho từng sản phẩm trong combo
        boolean stockAvailable = true;
        StringBuilder stockErrorMessage = new StringBuilder("Không đủ số lượng cho sản phẩm: ");
        for (ComboProduct cp : comboProducts) {
            Product product = productDAO.findById(cp.getProductId()); // Lấy thông tin sản phẩm mới nhất
            if (product == null) {
                 errorMessage = "Lỗi: Không tìm thấy sản phẩm có ID " + cp.getProductId() + " trong combo.";
                 stockAvailable = false;
                 break; // Thoát nếu sản phẩm không tồn tại
            }
            int requiredStock = cp.getQuantityInCombo() * quantity; // Số lượng sản phẩm cần cho combo * số lượng combo muốn mua
            if (product.getStock() < requiredStock) {
                stockAvailable = false;
                stockErrorMessage.append(product.getProductName()).append(" (cần ").append(requiredStock).append(", còn ").append(product.getStock()).append("), ");
            }
        }

        // Xóa dấu phẩy cuối cùng nếu có lỗi
         if (!stockAvailable && stockErrorMessage.length() > "Không đủ số lượng cho sản phẩm: ".length()) {
             stockErrorMessage.setLength(stockErrorMessage.length() - 2); // Xóa ", "
             errorMessage = stockErrorMessage.toString();
         } else if (!stockAvailable && errorMessage == null) { // Trường hợp lỗi không tìm thấy sản phẩm
            errorMessage = "Không tìm thấy san phẩm trong combo.";
         }


        if (stockAvailable) {
            // Lưu thông tin combo và số lượng vào session
            session.setAttribute("combo", combo);
            session.setAttribute("quantity", quantity);
            session.setAttribute("comboProducts", comboProducts);
            
            //chuyen toi trang VNPAY
            String url = request.getContextPath() + 
                            "/ajaxServlet?amount=" + combo.getDiscountPrice() +
                            "&action=wholesale";
            response.sendRedirect(url);
            
        } else {
            // Xử lý khi không đủ số lượng
            System.out.println("Hàm processBuyCombo: " + errorMessage);
            setToastMessage(request, "Order failed. Something Wrong!!", "error");
            response.sendRedirect(COMBO_SERVLET_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    /**
     * Sets toast message attributes in the session.
     *
     * @param request The HttpServletRequest object.
     * @param message The message to display.
     * @param type    The type of toast (e.g., "success", "error").
     */
    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    @Override
    public String getServletInfo() {
        return "Handles buying combos and checking stock";
    }
}
