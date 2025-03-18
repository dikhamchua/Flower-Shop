/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.SupplierDAO;
import com.swp391.entity.Supplier;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ManageSupplier", urlPatterns = {"/admin/manage-supplier", "/admin/remove-toast"})
public class ManageSupplier extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final SupplierDAO supplierDAO = new SupplierDAO();

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        if ("/admin/remove-toast".equals(servletPath)) {
            removeToast(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listSuppliers(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "activate":
                activateSupplier(request, response);
                break;
            case "deactivate":
                deactivateSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        if ("/admin/remove-toast".equals(servletPath)) {
            removeToast(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                addSupplier(request, response);
                break;
            case "update":
                updateSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Supplier Management Servlet";
    }// </editor-fold>

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        
        // Get current page
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get suppliers with pagination and filters
        List<Supplier> suppliers = supplierDAO.getSuppliersByPage(page, PAGE_SIZE, searchFilter, statusFilter);
        int totalSuppliers = supplierDAO.getTotalSuppliers(searchFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalSuppliers / PAGE_SIZE);
        
        // Set attributes for JSP
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchFilter", searchFilter);
        request.setAttribute("statusFilter", statusFilter);
        
        // Forward to supplier list page
        request.getRequestDispatcher("/view/admin/supplier-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/supplier-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierDAO.getSupplierById(supplierId);
        
        if (supplier != null) {
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/view/admin/supplier-edit.jsp").forward(request, response);
        } else {
            setToastMessage(request, "Supplier not found", "error");
            response.sendRedirect(request.getContextPath() + "/admin/manage-supplier");
        }
    }

    private void addSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));
        
        // Create supplier object
        Supplier supplier = new Supplier();
        supplier.setName(name);
        supplier.setEmail(email);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setDescription(description);
        supplier.setStatus(status);
        
        // Add supplier to database - gọi trực tiếp insert() thay vì addSupplier()
        int newSupplierId = supplierDAO.insert(supplier);
        
        if (newSupplierId > 0) {
            setToastMessage(request, "Supplier added successfully", "success");
        } else {
            setToastMessage(request, "Failed to add supplier", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-supplier");
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));
        
        // Create supplier object
        Supplier supplier = new Supplier();
        supplier.setSupplierId(supplierId);
        supplier.setName(name);
        supplier.setEmail(email);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setDescription(description);
        supplier.setStatus(status);
        
        // Update supplier in database - gọi trực tiếp update() thay vì updateSupplier()
        boolean success = supplierDAO.update(supplier);
        
        if (success) {
            setToastMessage(request, "Supplier updated successfully", "success");
        } else {
            setToastMessage(request, "Failed to update supplier", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-supplier");
    }

    private void activateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        boolean success = supplierDAO.changeSupplierStatus(supplierId, 1);
        
        if (success) {
            setToastMessage(request, "Supplier activated successfully", "success");
        } else {
            setToastMessage(request, "Failed to activate supplier", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-supplier");
    }

    private void deactivateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        boolean success = supplierDAO.changeSupplierStatus(supplierId, 0);
        
        if (success) {
            setToastMessage(request, "Supplier deactivated successfully", "success");
        } else {
            setToastMessage(request, "Failed to deactivate supplier", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-supplier");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    private void removeToast(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("toastMessage");
        session.removeAttribute("toastType");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
