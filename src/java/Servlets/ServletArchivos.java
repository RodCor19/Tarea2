/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtTema;
import Logica.Fabrica;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Kevin
 */
@WebServlet(name = "ServletArchivos", urlPatterns = {"/ServletArchivos"})
public class ServletArchivos extends HttpServlet {

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
        
        String tipoArchivo = request.getParameter("tipo");
        
        if(tipoArchivo != null){
            if (tipoArchivo.equals("audio")) {
                String ruta = request.getParameter("ruta");
                response.setContentType("audio/mpeg");
                response.addHeader("Content-Disposition", "attachment; filename=" + "NombreTema.mp3"); //indica que es un archivo para descargar

                BufferedInputStream buf = Fabrica.getArtista().cargarTema(ruta);

                OutputStream out = response.getOutputStream();     
                int readBytes = 0;
                //read from the file; write to the ServletOutputStream
                while ((readBytes = buf.read()) != -1)
                    out.write(readBytes);

                out.close();
                buf.close();
            } else {
                // tipo == "imagen"
                String img = request.getParameter("ruta");
                response.setContentType("image/jpeg");
                BufferedImage bi = Fabrica.getCliente().cargarImagen(img);
                OutputStream out = response.getOutputStream();
                ImageIO.write(bi, "png", out);
                out.close();
            }
        }
        
        if(request.getParameter("reproducirAlbum")!=null){
            String album = request.getParameter("reproducirAlbum");
            String artista = request.getParameter("artista");
            String temaSeleccionado = request.getParameter("tema");
//            response.getWriter().write(temaSeleccionado);
            ArrayList<DtTema> temas = Fabrica.getArtista().reproducirAlbum(artista, album);
            request.getSession().setAttribute("temasAReproducir", temas);
            
            //Si es el rquest que se envia al seleccionar un tema
            if(temaSeleccionado != null){
                //Setear ese atributo para que se repdoduzca por defecto el tema seleccionado
                for (DtTema tema : temas) {
                    if(tema.getNombre().equals(temaSeleccionado)){
                        request.getSession().setAttribute("reproducirTema", tema);
                        break;
                    }
                }
            }else{
                //Sino, si hay temas para reproducir, setear ese atributo para que se repdoduzca el primero por defecto
                if(temas.isEmpty() == false){
                    request.getSession().setAttribute("reproducirTema", temas.get(0));
                }
            }
        }
        
        if(request.getParameter("reproducirLista")!=null){
            String lista = request.getParameter("reproducirLista");
            String creador = request.getParameter("creador");
            String genero = request.getParameter("genero");
            String temaSeleccionado = request.getParameter("tema");
            
            ArrayList<DtTema> temas;
            
            //Si tiene creador es una lista particular, sino por defecto
            if(creador != null){
                temas = Fabrica.getCliente().reproducirListaP(creador, lista);
            }else{
                temas = Fabrica.getArtista().reproducirListaPD(genero, lista);
            }
            
            request.getSession().setAttribute("temasAReproducir", temas);
            
            //Si es el rquest que se envia al seleccionar un tema
            if(temaSeleccionado != null){
                //Setear ese atributo para que se repdoduzca por defecto el tema seleccionado
                for (DtTema tema : temas) {
                    if(tema.getNombre().equals(temaSeleccionado)){
                        request.getSession().setAttribute("reproducirTema", tema);
                        break;
                    }
                }
            }else{
                //Sino, si hay temas para reproducir, setear ese atributo para que se repdoduzca el primero por defecto
                if(temas.isEmpty() == false){
                    request.getSession().setAttribute("reproducirTema", temas.get(0));
                }
            }
        }
        
        if(request.getParameter("cerrarReproductor") != null){
            request.getSession().removeAttribute("temasAReproducir");
            request.getSession().removeAttribute("reproducirTema");
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
