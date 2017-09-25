/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtArtista;
import Logica.DtCliente;
import Logica.DtAlbum;
import Logica.DtArtista;
import Logica.DtTema;
import Logica.DtUsuario;
import Logica.Fabrica;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
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

        if (request.getParameter("Inicio") != null) {
            ArrayList<DtArtista> artistas = Fabrica.getArtista().ListarArtistas();
            request.getSession().setAttribute("Artistas", artistas);
//          
            //Redirecciona a la pagina indicada 
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/index.jsp");
            requestDispatcher.forward(request, response);
        }

        //Si se pasó el parametro "listarArtistas", entocnes reconoce que tiene que listarlos
        if (request.getParameter("listarArtistas") != null) {
            ArrayList<DtArtista> artistas = Fabrica.getArtista().ListarArtistas();
            request.getSession().setAttribute("Artistas", artistas);
//          
            response.getWriter().write("artistas listados correctamente");// es para que mostrar un mensaje en la consola del navegador, es opcional
        }

        if (request.getParameter("verPerfilArt") != null) {
            String nickname = request.getParameter("verPerfilArt");
            DtArtista datosArtista = Fabrica.getArtista().ElegirArtista(nickname);
            request.getSession().setAttribute("PerfilArt", datosArtista);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilArtista.jsp");
            requestDispatcher.forward(request, response);

            response.getWriter().write("perfil del artista cargado");
        }
        if (request.getParameter("consultarAlbum") != null) {
            String nombre = request.getParameter("consultarAlbum");
            ArrayList<DtAlbum> albumnes = Fabrica.getArtista().listarAlbumGenero(nombre);
            request.getSession().setAttribute("Album", albumnes);

            //Redirecciona a la pagina indicada 
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/consultarAlbum.jsp?nomgen=" + nombre);
            requestDispatcher.forward(request, response);

            response.getWriter().write("albumnes cargados");
        }

        if (request.getParameter("verAlbum") != null && request.getParameter("artista") != null) {
            String nombreArt = request.getParameter("artista");
            String nombreAlb = request.getParameter("verAlbum");
            ArrayList<DtTema> albumes = Fabrica.getArtista().obtenerTema(nombreArt, nombreAlb);
            DtAlbum album = Fabrica.getArtista().ElegirAlbum(nombreArt, nombreAlb);
            request.getSession().setAttribute("Album", album);

            //Redirecciona a la pagina indicada 
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/listarTema.jsp");
            //"ServletArtistas?verAlbum=<%= nombreAlb+"&artista="+nombreArt %>"
            requestDispatcher.forward(request, response);

            response.getWriter().write("temas cargados");
        }

        if (request.getParameter("listarGeneros") != null) {
            ArrayList<String> generos = Fabrica.getArtista().BuscarGenero("");
            request.getSession().setAttribute("Generos", generos);
        }

        if (request.getParameter("Registrarse") != null) {
            try {
                String nickname = request.getParameter("nickname");
                String contrasenia = request.getParameter("contrasenia");
                String nombre = request.getParameter("nombre");
                String apellido = request.getParameter("apellido");
                String fechanac = request.getParameter("fechanac");
                String correo = request.getParameter("correo");
                String biografia = request.getParameter("biografia");
                String paginaweb = request.getParameter("paginaweb");

                SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
                if (nickname.equals("") && contrasenia.equals("") && nombre.equals("") && apellido.equals("") && fechanac.equals("") && correo.equals("") && biografia.equals("") && paginaweb.equals("")) {
                    PrintWriter out = response.getWriter();
                    out.println("No debe haber campos vacios");

                } else {

                    DtArtista art = new DtArtista(nickname, contrasenia, nombre, apellido, correo, formato.parse(fechanac), null, biografia, paginaweb, 0, null, null);
                    boolean ok = Fabrica.getArtista().IngresarArtista(art);
                    if (ok) {
                        // request.getRequestDispatcher("iniciarsesion").forward(request, response);
                        PrintWriter out = response.getWriter();
                        out.println("ta todo bien");
                    } else {
                        PrintWriter out = response.getWriter();
                        out.println("Algo salio mal, no se pudo completar tu solicitud.");
                    }
                }
            } catch (ParseException ex) {
                Logger.getLogger(ServletArtistas.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (request.getParameter("Join") != null) {
            HttpSession sesion = request.getSession();
            String nickname = request.getParameter("Join");
            String contrasenia = request.getParameter("Contrasenia");
            DtUsuario dt = Fabrica.getArtista().verificarLoginArtista(nickname, contrasenia);
            if (dt != null) {
                sesion.setAttribute("Usuario", dt);
                sesion.removeAttribute("error");
                sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());
                response.sendRedirect("ServletArtistas?Inicio=true");
            } else {
                if (!(Fabrica.getCliente().verificarDatos(nickname, nickname) || Fabrica.getArtista().verificarDatos(nickname, nickname))) {
                    sesion.setAttribute("error", "Contraseña incorrecta");
                } else {
                    sesion.setAttribute("error", "Usuario y contraseña incorrectos");
                }
                response.sendRedirect("/EspotifyWeb/Vistas/Iniciarsesion.jsp");
            }
        }
        
        if (request.getParameter("CerrarSesion") != null) {
            request.getSession().removeAttribute("Usuario");
            request.getSession().setAttribute("Mensaje", "Vuelva pronto");
            response.sendRedirect("ServletArtistas?Inicio=true");

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
