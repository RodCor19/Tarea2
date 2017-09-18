/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtAlbum;
import Logica.DtArtista;
import Logica.DtUsuario;
import Logica.Fabrica;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Kevin
 */
@WebServlet(name = "ServletArtistas", urlPatterns = {"/ServletArtistas"})
public class ServletArtistas extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        Fabrica.getInstance(); //crea los controladores y carga los datos de la bd
    }
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
           
        //Si se pasó el parametro "listarArtistas", entocnes reconoce que tiene que listarlos
        if(request.getParameter("listarArtistas") != null){
            ArrayList<DtArtista> artistas =  Fabrica.getArtista().ListarArtistas();
            request.getSession().setAttribute("Artistas", artistas);
//          
            response.getWriter().write("artistas listados correctamente");// es para que mostrar un mensaje en la consola del navegador, es opcional
        }
        
        if(request.getParameter("verPerfilArt") != null){
            String nickname = request.getParameter("verPerfilArt");
            DtArtista datosArtista = Fabrica.getArtista().ElegirArtista(nickname);
            request.getSession().setAttribute("PerfilArt", datosArtista);
            
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilArtista.jsp");
            requestDispatcher.forward(request, response);
            
            response.getWriter().write("perfil del artista cargado");
        }
        if(request.getParameter("consultarAlbum") != null){
            String nombre = request.getParameter("consultarAlbum");
            ArrayList<DtAlbum> albumnes = Fabrica.getArtista().listarAlbumGenero(nombre); 
            request.getSession().setAttribute("Album", albumnes);
            
            //Redirecciona a la pagina indicada 
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/consultarAlbum.jsp?nomgen="+nombre);
            requestDispatcher.forward(request, response);
            
            response.getWriter().write("albumnes cargados");
        }
            
        if(request.getParameter("listarGeneros") != null){    
            ArrayList<String> generos =  Fabrica.getArtista().BuscarGenero("");
            request.getSession().setAttribute("Generos", generos);
        }
        
        if(request.getParameter("Join")!=null){
            HttpSession sesion = request.getSession();
            String nickname = request.getParameter("Join");
            String contrasenia = request.getParameter("Contraseña");
            DtUsuario dt=Fabrica.getArtista().verificarLoginArtista(nickname, contrasenia);
            if(dt!=null){
                sesion.setAttribute("Usuario", dt);
            }else{
                sesion.setAttribute("error", true);
                response.sendRedirect("/EspotifyWeb/Vistas/Iniciarsesion.jsp");
            }
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
