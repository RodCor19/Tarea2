/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtArtista;
import Logica.Fabrica;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Kevin
 */
@WebServlet(name = "ServletArtistas", urlPatterns = {"/ServletArtistas"})
public class ServletArtistas extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
            /* TODO output your page here. You may use following sample code. */
            
//            if(request.getParameter("cargarDatos") != null){
//                //Para que solo carge los datos una vez
//                if(request.getSession().getAttribute("datosCargados") == null){
//                    Fabrica.getCliente();
//                    Fabrica.getArtista();
//                    Fabrica.SetControladores();
//                    Fabrica.cargarDatos();
//                    request.getSession().setAttribute("datosCargados", true);
//                    
//                    response.getWriter().write("datos cargados correctamente");
//                }else{
//                    response.getWriter().write("los datos ya estaban cargados");
//                }
//            }
            
            //Si se pasó el parametro "listarArtistas", entocnes reconoce que tiene que listarlos
            if(request.getParameter("listarArtistas") != null){
                Fabrica.getCliente();
                Fabrica.getArtista();
                Fabrica.SetControladores();
                Fabrica.cargarDatos();
                ArrayList<DtArtista> artistas =  Fabrica.getArtista().ListarArtistas();
                request.getSession().setAttribute("Artistas", artistas);
//                String retornar="{";
//                for (DtArtista artista : artistas) {
//                    retornar +=artista.getNombre()+" "+artista.getApellido()+","; 
//                }
//                retornar += "}";
//                
//                response.getWriter().write(retornar);
            }
            
        
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
        processRequest(request, response);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
