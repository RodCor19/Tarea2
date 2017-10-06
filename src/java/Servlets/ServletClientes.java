/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtCliente;
import Logica.DtListaP;
import Logica.DtListaPD;
import Logica.DtTipoSuscripcion;
import Logica.DtUsuario;
import Logica.Fabrica;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
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
@WebServlet(name = "ServletClientes", urlPatterns = {"/ServletClientes"})
public class ServletClientes extends HttpServlet {

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
        HttpSession sesion = request.getSession();

        if (request.getParameter("verPerfilCli") != null) {
            String nickname = request.getParameter("verPerfilCli");
            DtCliente datosClientes = Fabrica.getCliente().verPerfilCliente(nickname);
            sesion.setAttribute("PerfilCli", datosClientes);
            
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilCliente.jsp");
            requestDispatcher.forward(request, response);

            response.getWriter().write("perfil del cliente cargado");
        }
        
          if(request.getParameter("Registrarse") != null){
            try{
            String nickname=request.getParameter("nickname");
            String contrasenia=request.getParameter("contrasenia");
            String nombre=request.getParameter("nombre");
            String apellido=request.getParameter("apellido");
            String fechanac= request.getParameter("fechanac");
            String correo=request.getParameter("correo");
  
            SimpleDateFormat formato= new SimpleDateFormat("dd-MM-yyyy");

            DtCliente cli=new DtCliente(nickname,contrasenia,nombre,apellido,formato.parse(fechanac),correo,null,null,null,null,null,null, null, null);
            boolean x = Fabrica.getCliente().IngresarCliente(cli);
            if (!x) 
                response.getWriter().write("si");
            else
                response.getWriter().write("no");
                          
            } catch (ParseException ex) {
                Logger.getLogger(ServletArtistas.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (request.getParameter("dejarSeguir") != null) {
            String nickname = request.getParameter("dejarSeguir");
            byte[] bytes = nickname.getBytes(StandardCharsets.ISO_8859_1);
            nickname = new String(bytes, StandardCharsets.UTF_8);
            DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
            Fabrica.getCliente().DejarSeguir(dt.getNickname(), nickname);
            response.sendRedirect("ServletClientes?verPerfilCli=" + dt.getNickname());
            //response.getWriter().write("ok");
        }

        if (request.getParameter("seguir") != null) {
            String nickname = request.getParameter("seguir");
            byte[] bytes = nickname.getBytes(StandardCharsets.ISO_8859_1);
            nickname = new String(bytes, StandardCharsets.UTF_8);
            DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
            try {
                Fabrica.getCliente().seguir(dt.getNickname(), nickname);
                sesion.setAttribute("Usuario", Fabrica.getCliente().verPerfilCliente(dt.getNickname()));
                response.sendRedirect("ServletClientes?verPerfilCli=" + dt.getNickname());
                //response.getWriter().write("ok");
            } catch (Exception ex) {
                sesion.setAttribute("Mensaje", "Hubo error al seguir al usuario " + nickname);
                response.sendRedirect("ServletArtistas?Inicio=true");
                //response.getWriter().write("ERROR : " + ex.getMessage());
            }
        }

        if (request.getParameter("Artista") != null && request.getParameter("album") != null && request.getParameter("tema") != null) {
            String art = request.getParameter("Artista");
            String alb = request.getParameter("album");
            String tem = request.getParameter("tema");
            DtCliente dc = (DtCliente) request.getSession().getAttribute("Usuario");
            Fabrica.getCliente().agregarTemaFavorito(dc.getNickname(), art, alb, tem);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("ServletArtistas?Inicio=true");
            requestDispatcher.forward(request, response);
        }
        if (request.getParameter("art") != null && request.getParameter("alb") != null) {
            String arti = request.getParameter("art");
            String albu = request.getParameter("alb");
           
            DtCliente dc = (DtCliente) request.getSession().getAttribute("Usuario");
            Fabrica.getCliente().agregarAlbumFavorito(dc.getNickname(), arti, albu);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("ServletArtistas?Inicio=true");
            requestDispatcher.forward(request, response);
        }
        
        

        if (request.getParameter("contratarSuscripcion") != null) {
            ArrayList<DtTipoSuscripcion> tiposSus = Fabrica.getCliente().listarTipoDeSus();
            sesion.setAttribute("TiposDeSus", tiposSus);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/ContratarSuscripcion.jsp");
            requestDispatcher.forward(request, response);
        }

        if (request.getParameter("nuevaSuscripcion") != null) {
            DtCliente dc = (DtCliente) request.getSession().getAttribute("Usuario");
            int idTipoSus = Integer.valueOf(request.getParameter("nuevaSuscripcion"));

            if (Fabrica.getCliente().contratarSuscripcion(dc.getNickname(), idTipoSus)) {
                response.getWriter().write("ok");
            } else {
                response.getWriter().write("error: " + dc.getNickname() + " " + idTipoSus);
            }
        }

        if (request.getParameter("cargarDatosPrueba") != null) {
            Fabrica.getCliente().CargadeDatos();
            
            if(sesion.getAttribute("Usuario") != null && sesion.getAttribute("Usuario") instanceof DtCliente){
                DtCliente dtCli = (DtCliente) sesion.getAttribute("Usuario");
                Fabrica.getCliente().actualizarVigenciaSuscripciones(dtCli.getNickname());
            }
            
            response.getWriter().write("se han cargado los datos de prueba");
        }
        
        if(request.getParameter("VerFavoritos") != null){
            DtCliente dtCli = (DtCliente)request.getSession().getAttribute("Usuario");
            DtCliente datosClientes = Fabrica.getCliente().verPerfilCliente(dtCli.getNickname());
            
            sesion.setAttribute("PerfilCli", datosClientes);
            
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/Favoritos.jsp");
            requestDispatcher.forward(request, response);
        }
         

        if (request.getParameter("nomLista") != null) {
            String nLista = request.getParameter("nomLista");
            //se crea un array de bytes con la codificación que se envía en los parametros
            byte[] bytes = nLista.getBytes(StandardCharsets.ISO_8859_1);
            // "normaliza" el texto
            nLista = new String(bytes, StandardCharsets.UTF_8);
            DtCliente c = (DtCliente) sesion.getAttribute("Usuario");
            c = Fabrica.getCliente().verPerfilCliente(c.getNickname());
            for (DtListaP l : c.getListas()) {
                if (l.getNombre().equals(nLista)) {
                    response.getWriter().write("Lista en uso");
                } else {
                    response.getWriter().write("ok");
                }
            }
        }

        if (request.getParameter("cLista") != null) {
            String nLista = request.getParameter("cLista");
            //se crea un array de bytes con la codificación que se envía en los parametros
            byte[] bytes = nLista.getBytes(StandardCharsets.ISO_8859_1);
            // "normaliza" el texto
            nLista = new String(bytes, StandardCharsets.UTF_8);
            DtCliente c = (DtCliente) sesion.getAttribute("Usuario");
            Fabrica.getCliente().crearListaP(c.getNickname(), nLista, null);
            try {
                Fabrica.getCliente().confirmar();
                c = Fabrica.getCliente().verPerfilCliente(c.getNickname());
                sesion.setAttribute("Usuario", c);
                sesion.setAttribute("Mensaje", "Lista Creada");
                response.sendRedirect("/EspotifyWeb/Vistas/index.jsp");
            } catch (Exception ex) {
                sesion.setAttribute("Mensaje", "Hubo un error al crear la lista \n"+ ex.getMessage());
                response.sendRedirect("/EspotifyWeb/Vistas/index.jsp");
            }

        }
        
        if(request.getParameter("Lista")!=null){
            String nLista = request.getParameter("Lista");
            //se crea un array de bytes con la codificación que se envía en los parametros
            byte[] bytes = nLista.getBytes(StandardCharsets.ISO_8859_1);
            // "normaliza" el texto
            nLista = new String(bytes, StandardCharsets.UTF_8);
            if(request.getParameter("Usuario")!=null){
                String nick = request.getParameter("Usuario");
                DtListaP aux = null;
                ArrayList<DtListaP> dt = Fabrica.getCliente().ListarListaP();
                for(DtListaP p : dt)
                    if(p.getNombre().equals(nLista) && p.getUsuario().equals(nick))
                        aux=p;
                sesion.setAttribute("Lista", aux);
                response.sendRedirect("/EspotifyWeb/Vistas/ConsultadeListadeReproduccion.jsp");
            }else{
                DtListaPD aux = null;
                for(DtListaPD pd : Fabrica.getArtista().ListarListaPD())
                    if(pd.getNombre().equals(nLista))
                        aux=pd;
                sesion.setAttribute("Lista", aux);
                response.sendRedirect("/EspotifyWeb/Vistas/ConsultadeListadeReproduccion.jsp");
            }
        }
        if(request.getParameter("publicarLista") != null){
                DtCliente dtCli = (DtCliente)request.getSession().getAttribute("Usuario");
                String nLista = request.getParameter("publicarLista");
                Fabrica.getCliente().publicarLista(dtCli.getNickname(), nLista);
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
