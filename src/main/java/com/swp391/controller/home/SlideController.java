/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.home;

import com.swp391.dal.impl.SliderDAO;
import com.swp391.entity.Slider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "SlideController", urlPatterns = {"/slide"})
public class SlideController extends HttpServlet {

    private SliderDAO sliderDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        sliderDAO = new SliderDAO();
    }

  
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
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listActiveSliders(request, response);
                break;
            case "detail":
                getSliderDetail(request, response);
                break;
            default:
                listActiveSliders(request, response);
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
        // POST methods can be implemented for admin operations like adding/updating sliders
        doGet(request, response);
    }

    private void listActiveSliders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Slider> activeSliders = sliderDAO.findActiveSliders();
        request.setAttribute("sliders", activeSliders);
        request.getRequestDispatcher("/view/home/sliders.jsp").forward(request, response);
    }
    
    private void getSliderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int sliderId = Integer.parseInt(request.getParameter("id"));
            Slider slider = sliderDAO.findById(sliderId);
            
            if (slider != null) {
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("/view/home/slider-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/slide?error=not_found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/slide?error=invalid_id");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Slider Controller for displaying and managing sliders";
    }// </editor-fold>

}
