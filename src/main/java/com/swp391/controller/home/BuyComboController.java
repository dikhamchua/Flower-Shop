package com.swp391.controller.home;

import com.swp391.dal.impl.ComboDAO; // Giả sử bạn có ComboDAO
import com.swp391.dal.impl.ComboProductDAO; // Giả sử bạn có ComboProductDAO
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart; // Giả sử bạn có entity Cart
import com.swp391.entity.Combo;
import com.swp391.entity.ComboProduct;
import com.swp391.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map; // Import Map nếu Cart dùng Map

@WebServlet(name = "BuyComboController", urlPatterns = {"/buy-combo"})
public class BuyComboController extends HttpServlet {

    private ProductDAO productDAO;
    private ComboDAO comboDAO; // Khởi tạo DAO
    private ComboProductDAO comboProductDAO; // Khởi tạo DAO

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        comboDAO = new ComboDAO(); // Khởi tạo
        comboProductDAO = new ComboProductDAO(); // Khởi tạo
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang chủ hoặc trang combo nếu truy cập GET
        response.sendRedirect(request.getContextPath() + "/combo");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        // Kiểm tra đăng nhập
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login&message=Vui lòng đăng nhập để mua hàng");
            return;
        }

        String comboIdStr = request.getParameter("comboId");
        String quantityStr = request.getParameter("quantity");
        String errorMessage = null;
        String successMessage = null;

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
            // Chuyển hướng lại trang chi tiết combo với thông báo lỗi
            response.sendRedirect(request.getContextPath() + "/combo-details?id=" + comboIdStr + "&error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
            return;
        }

        // Lấy thông tin combo
        Combo combo = comboDAO.findById(comboId);
        if (combo == null) {
            errorMessage = "Không tìm thấy combo.";
            response.sendRedirect(request.getContextPath() + "/combo?error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
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
             // errorMessage đã được set ở trên
         }


        if (stockAvailable) {
            // Thêm vào giỏ hàng (Logic thêm vào giỏ hàng cần được điều chỉnh theo cấu trúc Cart của bạn)
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart(); // Tạo giỏ hàng mới nếu chưa có
                session.setAttribute("cart", cart);
            }

            // Logic thêm combo vào giỏ hàng (có thể bạn cần phương thức riêng)
            // Ví dụ: cart.addCombo(combo, quantity);
            // Hoặc thêm từng sản phẩm riêng lẻ nếu giỏ hàng chỉ chứa sản phẩm
             for (ComboProduct cp : comboProducts) {
                 Product productToAdd = productDAO.findById(cp.getProductId());
                 int quantityToAdd = cp.getQuantityInCombo() * quantity;
                 // Giả sử cart có phương thức addItem(Product p, int quantity)
                 // cart.addItem(productToAdd, quantityToAdd); // Cần triển khai logic này trong Cart
             }
             // **Lưu ý:** Cần có logic cụ thể để thêm combo hoặc sản phẩm vào giỏ hàng trong lớp Cart.java

            successMessage = "Đã thêm combo '" + combo.getName() + "' vào giỏ hàng thành công!";
            // Chuyển hướng đến trang giỏ hàng với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/cart?success=" + java.net.URLEncoder.encode(successMessage, "UTF-8"));
        } else {
            // Chuyển hướng lại trang chi tiết combo với thông báo lỗi tồn kho
            response.sendRedirect(request.getContextPath() + "/combo-details?id=" + comboId + "&error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles buying combos and checking stock";
    }
}
