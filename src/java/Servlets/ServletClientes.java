/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
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
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.FileItemFactory;
import java.util.List;
import java.util.Properties;
import javax.xml.namespace.QName;
import org.apache.commons.fileupload.FileUploadException;
import webservices.DtArtista;
import webservices.DtCliente;
import webservices.DtLista;
import webservices.DtListaP;
import webservices.DtListaPD;
import webservices.DtTipoSuscripcion;
import webservices.DtUsuario;
import webservices.WSArtistas;
import webservices.WSArtistasService;
import webservices.WSClientes;
import webservices.WSClientesService;

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
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();

        Properties propiedades = new Properties();
        String rutaConfWS = this.getClass().getClassLoader().getResource("").getPath();
        rutaConfWS = rutaConfWS.replace("build/web/WEB-INF/classes/", "webservices.properties");
        rutaConfWS = rutaConfWS.replace("%20", " ");
        InputStream entrada = new FileInputStream(rutaConfWS);
        propiedades.load(entrada);// cargamos el archivo de propiedades
        
        try{
            URL url = new URL("http://" + propiedades.getProperty("ipServidor") + ":" + propiedades.getProperty("puertoWSArt") + "/" + propiedades.getProperty("nombreWSArt"));
            WSArtistasService wsarts = new WSArtistasService(url,new QName("http://WebServices/", "WSArtistasService"));
            WSArtistas wsart = wsarts.getWSArtistasPort();

            url = new URL("http://" + propiedades.getProperty("ipServidor") + ":" + propiedades.getProperty("puertoWSCli") + "/" + propiedades.getProperty("nombreWSCli"));
            WSClientesService wsclis = new WSClientesService(url,new QName("http://WebServices/", "WSClientesService"));
            WSClientes wscli = wsclis.getWSClientesPort();

            request.getSession().setAttribute("WSArchivos", wsart);
            request.getSession().setAttribute("WSClientes", wscli);

            if (request.getParameter("verPerfilCli") != null) {
                String nickname = request.getParameter("verPerfilCli");
                DtCliente datosClientes = wscli.verPerfilCliente(nickname);
                sesion.setAttribute("PerfilCli", datosClientes);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilCliente.jsp");
                requestDispatcher.forward(request, response);

                response.getWriter().write("perfil del cliente cargado");
            }

            if (request.getParameter("AgregarTemaNombreTema") != null) {

                String tema = request.getParameter("AgregarTemaNombreTema");
                String album = request.getParameter("AgregarTemaNombreAlbum");
                String artista = request.getParameter("AgregarTemaNombreArtista");
                String listaelegida = request.getParameter("AgregarTemaListaElegida");
                DtCliente cliente = (DtCliente) request.getSession().getAttribute("PerfilCli");
                boolean x = wsart.agregarTemaListaWeb(tema, album, artista, listaelegida, cliente.getNickname());
                if (x == true) {
                    response.getWriter().write("si");
                } else {
                    response.getWriter().write("no");
                }
            }

            if (request.getParameter("dejarSeguir") != null) {
                String nickname = request.getParameter("dejarSeguir");
                byte[] bytes = nickname.getBytes(StandardCharsets.ISO_8859_1);
                nickname = new String(bytes, StandardCharsets.UTF_8);
                DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
                if (dt != null && dt instanceof DtCliente && wscli.suscripcionVigente(dt.getNickname())) {
                    wscli.dejarSeguir(dt.getNickname(), nickname);
                    sesion.setAttribute("Usuario", wscli.verPerfilCliente(dt.getNickname()));
                    response.sendRedirect("ServletClientes?verPerfilCli=" + dt.getNickname());
                    //response.getWriter().write("ok");
                } else {
                    if (dt == null) {
                        sesion.setAttribute("Mensaje", "Inicie sesión");
                    } else if (dt instanceof DtArtista) {
                        sesion.setAttribute("Mensaje", "Los artistas no pueden seguir usuarios");
                    } else {
                        sesion.setAttribute("Mensaje", "No tiene suscripción vigente");
                    }
                    response.sendRedirect("ServletArtistas?Inicio=true");
                    response.sendRedirect("ServletArtistas?Inicio=true");
                    //response.getWriter().write("ERROR : " + ex.getMessage());
                }
                //response.getWriter().write("ok");
            }

            if (request.getParameter("seguir") != null) {
                String nickname = request.getParameter("seguir");
                byte[] bytes = nickname.getBytes(StandardCharsets.ISO_8859_1);
                nickname = new String(bytes, StandardCharsets.UTF_8);
                DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
                if (dt != null && dt instanceof DtCliente && wscli.suscripcionVigente(dt.getNickname())) {
                    wscli.seguir(dt.getNickname(), nickname);
                    sesion.setAttribute("Usuario", wscli.verPerfilCliente(dt.getNickname()));
                    response.sendRedirect("ServletClientes?verPerfilCli=" + dt.getNickname());
                    //response.getWriter().write("ok");
                } else {
                    if (dt == null) {
                        sesion.setAttribute("Mensaje", "Inicie sesión");
                    } else if (dt instanceof DtArtista) {
                        sesion.setAttribute("Mensaje", "Los artistas no pueden seguir usuarios");
                    } else {
                        sesion.setAttribute("Mensaje", "No tiene suscripción vigente");
                    }
                    response.sendRedirect("ServletArtistas?Inicio=true");
                    //response.getWriter().write("ERROR : " + ex.getMessage());
                }
            }

            if (request.getParameter("Artista") != null && request.getParameter("album") != null && request.getParameter("tema") != null) {
                DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
                if (dt != null && dt instanceof DtCliente && wscli.suscripcionVigente(dt.getNickname())) {
                String art = request.getParameter("Artista");
                String alb = request.getParameter("album");
                String tem = request.getParameter("tema");
                DtCliente dc = (DtCliente) dt;
                wscli.agregarTemaFavorito(dc.getNickname(), art, alb, tem);
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("ServletArtistas?Inicio=true");
                requestDispatcher.forward(request, response);
            }
                if (dt == null) {
                        sesion.setAttribute("Mensaje", "Inicie sesión");
                    } else if (dt instanceof DtArtista) {
                        sesion.setAttribute("Mensaje", "Los artistas no pueden agregar a favoritos");
                    } else {
                        sesion.setAttribute("Mensaje", "No tiene suscripción vigente");
                    }
                response.sendRedirect("ServletArtistas?Inicio=true");
            }
            if (request.getParameter("art") != null && request.getParameter("alb") != null) {
                DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
                if (dt != null && dt instanceof DtCliente && wscli.suscripcionVigente(dt.getNickname())) {
                String arti = request.getParameter("art");
                String albu = request.getParameter("alb");

                DtCliente dc = (DtCliente)dt;
                wscli.agregarAlbumFavorito(dc.getNickname(), arti, albu);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("ServletArtistas?Inicio=true");
                requestDispatcher.forward(request, response);
                } else {
                    if (dt == null) {
                        sesion.setAttribute("Mensaje", "Inicie sesión");
                    } else if (dt instanceof DtArtista) {
                        sesion.setAttribute("Mensaje", "Los artistas no pueden agregar a favoritos");
                    } else {
                        sesion.setAttribute("Mensaje", "No tiene suscripción vigente");
                    }
                    response.sendRedirect("ServletArtistas?Inicio=true");
                    //response.getWriter().write("ERROR : " + ex.getMessage());
                }
            }

            if (request.getParameter("contratarSuscripcion") != null) {
                List<DtTipoSuscripcion> tiposSus = wscli.listarTipoDeSus().getTiposDeSus();
                sesion.setAttribute("TiposDeSus", tiposSus);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/ContratarSuscripcion.jsp");
                requestDispatcher.forward(request, response);
            }

            if (request.getParameter("nuevaSuscripcion") != null) {
                DtCliente dc = (DtCliente) request.getSession().getAttribute("Usuario");
                int idTipoSus = Integer.valueOf(request.getParameter("nuevaSuscripcion"));

                if (wscli.contratarSuscripcion(dc.getNickname(), idTipoSus)) {
                    response.getWriter().write("ok");
                } else {
                    response.getWriter().write("error: " + dc.getNickname() + " " + idTipoSus);
                }
            }

            if (request.getParameter("VerFavoritos") != null) {
                DtCliente dtCli = (DtCliente) request.getSession().getAttribute("Usuario");
                DtCliente datosClientes = wscli.verPerfilCliente(dtCli.getNickname());

                sesion.setAttribute("PerfilCli", datosClientes);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/Favoritos.jsp");
                requestDispatcher.forward(request, response);
            }

            if (request.getContentType() != null && request.getContentType().toLowerCase().contains("multipart/form-data")) {
                try {
                    String nLista = "", imagen = null;

                    /*FileItemFactory es una interfaz para crear FileItem*/
                    FileItemFactory file_factory = new DiskFileItemFactory();
                    /*ServletFileUpload esta clase convierte los input file a FileItem*/
                    ServletFileUpload servlet_up = new ServletFileUpload(file_factory);
                    /*sacando los FileItem del ServletFileUpload en una lista */
                    List items = servlet_up.parseRequest(request);
                    String path = this.getClass().getClassLoader().getResource("").getPath();
                    path = path.replace("build/web/WEB-INF/classes/", "temporales/");
                    path = path.replace("%20", " ");
                    for (int i = 0; i < items.size(); i++) {
                        /*FileItem representa un archivo en memoria que puede ser pasado al disco duro*/
                        FileItem item = (FileItem) items.get(i);

                        /*item.isFormField() false=input file; true=text field*/
                        //Con if(item.isFormField()) se distingue si input es un archivo o es un input comun(texto)
                        if (item.isFormField() == false && item.getName().isEmpty() == false) {
                            File archivo_server = new File(path + item.getName()), directorio = new File(path);
                            directorio.mkdirs();
                            item.write(archivo_server);
                            imagen = path.substring(1) + item.getName();
                        } else {
                            nLista = item.getString();
                        }
                    }

                    //se crea un array de bytes con la codificación que se envía en los parametros
                    byte[] bytes = nLista.getBytes(StandardCharsets.ISO_8859_1);
                    // "normaliza" el texto
                    nLista = new String(bytes, StandardCharsets.UTF_8);
                    sesion.removeAttribute("cLista");
                    DtCliente c = (DtCliente) sesion.getAttribute("Usuario");

                    byte[] imagenBytes = new byte[0];
                    if (imagen != null) {
                        File im = new File(imagen);
                        imagenBytes = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                        im.delete();
                    }

                    wscli.crearListaP(c.getNickname(), nLista, imagenBytes);
                    if (wscli.confirmar()) {
                        sesion.setAttribute("Mensaje", "Lista creada");
                    } else {
                        sesion.setAttribute("Mensaje", "La lista ya existe");
                    }
                    c = wscli.verPerfilCliente(c.getNickname());
                    sesion.setAttribute("Usuario", c);
                    if (imagen != null) {
                        File fichero = new File(imagen);
                        if (fichero.delete()) {
                            System.out.println("El fichero ha sido borrado satisfactoriamente");
                        } else {
                            System.out.println("El fichero no puede ser borrado");
                        }
                    }
                    response.sendRedirect("ServletArtistas?Inicio=true");

                } catch (FileUploadException ex) {
                    Logger.getLogger(ServletClientes.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (request.getParameter("Lista") != null) {
                String nLista = request.getParameter("Lista");
                nLista = nLista.trim();
                if (request.getParameter("Usuario") != null) {
                    String nick = request.getParameter("Usuario");
                    DtListaP aux = null;
                    List<DtLista> dt = wscli.listarListaP().getListas();
                    for (DtLista l : dt) {
                        DtListaP lp = (DtListaP) l;
                        if (lp.getNombre().equals(nLista) && lp.getUsuario().equals(nick)) {
                            aux = lp;
                        }
                    }
                    sesion.setAttribute("Lista", (DtLista) aux);
                    response.sendRedirect("/EspotifyWeb/Vistas/ConsultadeListadeReproduccion.jsp");
                } else {
                    DtListaPD aux = null;
                    for (DtLista l : wsart.listarListaPD().getListas()) {
                        DtListaPD pd = (DtListaPD) l;
                        if (pd.getNombre().equals(nLista)) {
                            aux = pd;
                        }
                    }
                    sesion.setAttribute("Lista", (DtLista) aux);
                    response.sendRedirect("/EspotifyWeb/Vistas/ConsultadeListadeReproduccion.jsp");
                }
            }
            if (request.getParameter("publicarLista") != null) {
                DtCliente dtCli = (DtCliente) request.getSession().getAttribute("Usuario");
                String nLista = request.getParameter("publicarLista");
                wscli.publicarLista(dtCli.getNickname(), nLista);
            }

            if (request.getParameter("favLista") != null) {
                DtUsuario dt = (DtUsuario) sesion.getAttribute("Usuario");
                if (dt != null && dt instanceof DtCliente && wscli.suscripcionVigente(dt.getNickname())) {
                DtCliente dtCli = (DtCliente) dt;
                String nLista = request.getParameter("favLista");
                byte[] bytes = nLista.getBytes(StandardCharsets.ISO_8859_1);
                nLista = new String(bytes, StandardCharsets.UTF_8);
                if (request.getParameter("cliente") != null) {
                    wscli.agregarListaPFavorito(dtCli.getNickname(), (String) request.getParameter("cliente"), nLista);
                } else {
                    wscli.agregarListaPDFavorito(dtCli.getNickname(), nLista);
                }
                response.sendRedirect("ServletArtistas?Inicio=true");
                } else {
                    if (dt == null) {
                        sesion.setAttribute("Mensaje", "Inicie sesión");
                    } else if (dt instanceof DtArtista) {
                        sesion.setAttribute("Mensaje", "Los artistas no pueden agregar a favoritos");
                    } else {
                        sesion.setAttribute("Mensaje", "No tiene suscripción vigente");
                    }
                    response.sendRedirect("ServletArtistas?Inicio=true");
                    //response.getWriter().write("ERROR : " + ex.getMessage());
                }

            }
        }catch(Exception ex){       
            
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/Error.html");
            requestDispatcher.forward(request, response);
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
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ServletClientes.class.getName()).log(Level.SEVERE, null, ex);
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
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ServletClientes.class.getName()).log(Level.SEVERE, null, ex);
        }
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
