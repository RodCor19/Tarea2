/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.namespace.QName;
import webservices.DtArtista;
import webservices.DtCliente;
import webservices.DtLista;
import webservices.DtTema;
import webservices.DtUsuario;
import webservices.IOException_Exception;
import webservices.WSArchivos;
import webservices.WSArchivosService;
import webservices.WSClientes;
import webservices.WSClientesService;

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

        Properties propiedades = new Properties();
        String rutaConfWS = this.getClass().getClassLoader().getResource("").getPath();
        rutaConfWS = rutaConfWS.replace("build/web/WEB-INF/classes/", "webservices.properties");
        rutaConfWS = rutaConfWS.replace("%20", " ");
        InputStream entrada = new FileInputStream(rutaConfWS);
        propiedades.load(entrada);// cargamos el archivo de propiedades

//        try {
            URL url = new URL("http://" + propiedades.getProperty("ipServidor") + ":" + propiedades.getProperty("puertoWSArch") + "/" + propiedades.getProperty("nombreWSArch"));
            WSArchivosService wsarchs = new WSArchivosService(url,new QName("http://WebServices/", "WSArchivosService"));
            WSArchivos wsarch = wsarchs.getWSArchivosPort();
            WSClientes wscli = (WSClientes) request.getSession().getAttribute("WSClientes");

            request.getSession().setAttribute("WSArchivos", wsarch);

            if (request.getParameter("cargarDatosPrueba") != null) {
                wsarch.cargadeDatos();
                request.getSession().removeAttribute("Usuario");
                request.getSession().removeAttribute("Album");
                request.getSession().removeAttribute("temasAReproducir");

                response.getWriter().write("se han cargado los datos de prueba");
            }

            String tipoArchivo = request.getParameter("tipo");

            if (tipoArchivo != null) {
                if (tipoArchivo.equals("audio")) {
                    try {
                        String ruta = request.getParameter("ruta");
                        response.setContentType("audio/mpeg");
                        response.addHeader("Content-Disposition", "attachment; filename=" + "NombreTema.mp3"); //indica que es un archivo para descargar

                        byte[] audio = wsarch.cargarArchivo(ruta);
                        System.out.println(audio.length);

                        response.setContentType("audio/mpeg");
                        response.setContentLength((int) audio.length);

                        OutputStream out = response.getOutputStream();
                        out.write(audio);
                        out.close();

                        /*
                        BufferedInputStream buf = wsarch.cargarTema(ruta);

                        OutputStream out = response.getOutputStream();
                        int readBytes = 0;
                        //read from the file; write to the ServletOutputStream
                        while ((readBytes = buf.read()) != -1)
                        out.write(readBytes);

                        out.close();
                        buf.close();
                         */
                    } catch (IOException_Exception ex) {
                        Logger.getLogger(ServletArchivos.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    try {
                        // tipo == "imagen"
                        String ruta = request.getParameter("ruta");

                        byte[] img = wsarch.cargarArchivo(ruta);
                        response.setContentType("image/jpg");
                        response.setContentLength((int) img.length);
                        OutputStream out = response.getOutputStream();
                        //ImageIO.write(img, "png", out);
                        out.write(img);
                        out.close();
                    } catch (IOException_Exception ex) {
                        Logger.getLogger(ServletArchivos.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }

            if (request.getParameter("reproducirAlbum") != null) {
                String album = request.getParameter("reproducirAlbum");
                String artista = request.getParameter("artista");
                String temaSeleccionado = request.getParameter("tema");
                //            response.getWriter().write(temaSeleccionado);
                List<DtTema> temas = wsarch.reproducirAlbum(artista, album).getTemas();
                request.getSession().setAttribute("temasAReproducir", temas);
                byte[] imagen = wsarch.getImagenAlbum(artista, album);
                if (imagen != null) {
                    try {
                        String path = this.getClass().getClassLoader().getResource("").getPath();
                        path = path.replace("build/web/WEB-INF/classes/", "temporales/");
                        path = path + album + "REPRODUCTOR.jpg";
                        path = path.replace("%20", " ");
                        File f = new File(path);
                        org.apache.commons.io.FileUtils.writeByteArrayToFile(f, imagen);
                        request.getSession().setAttribute("ImagenAlbumReproductor", path);
                    } catch (FileNotFoundException ex) {
                        ex.getMessage();
                    } catch (IOException ex) {
                        ex.getMessage();
                    }
                } else if (request.getSession().getAttribute("ImagenAlbumReproductor") != null) {
                    request.getSession().removeAttribute("ImagenAlbumReproductor");
                }

                //Si es el rquest que se envia al seleccionar un tema
                if (temaSeleccionado != null) {
                    //Setear ese atributo para que se repdoduzca por defecto el tema seleccionado
                    for (DtTema tema : temas) {
                        if (tema.getNombre().equals(temaSeleccionado)) {
                            request.getSession().setAttribute("reproducirTema", tema);
                            break;
                        }
                    }
                } else {
                    //Sino, si hay temas para reproducir, setear ese atributo para que se repdoduzca el primero por defecto
                    if (temas.isEmpty() == false) {
                        request.getSession().setAttribute("reproducirTema", temas.get(0));
                    }
                }
            }

            if (request.getParameter("reproducirLista") != null) {
                String lista = request.getParameter("reproducirLista");
                String creador = request.getParameter("creador");
                String genero = request.getParameter("genero");
                String temaSeleccionado = request.getParameter("tema");

                List<DtTema> temas;

                //Si tiene creador es una lista particular, sino por defecto
                if (creador != null) {
                    temas = wsarch.reproducirListaP(creador, lista).getTemas();
                } else {
                    temas = wsarch.reproducirListaPD(genero, lista).getTemas();
                }

                DtLista dt = (DtLista) request.getSession().getAttribute("Lista");
                if (dt.getRutaImagen() != null) {
                    request.getSession().setAttribute("ImagenAlbumReproductor", dt.getRutaImagen());
                } else if (request.getSession().getAttribute("ImagenAlbumReproductor") != null) {
                    request.getSession().removeAttribute("ImagenAlbumReproductor");
                }

                request.getSession().setAttribute("temasAReproducir", temas);

                //Si es el rquest que se envia al seleccionar un tema
                if (temaSeleccionado != null) {
                    //Setear ese atributo para que se repdoduzca por defecto el tema seleccionado
                    for (DtTema tema : temas) {
                        if (tema.getNombre().equals(temaSeleccionado)) {
                            request.getSession().setAttribute("reproducirTema", tema);
                            break;
                        }
                    }
                } else {
                    //Sino, si hay temas para reproducir, setear ese atributo para que se repdoduzca el primero por defecto
                    if (temas.isEmpty() == false) {
                        request.getSession().setAttribute("reproducirTema", temas.get(0));
                    }
                }
            }

            if (request.getParameter("cerrarReproductor") != null) {
                request.getSession().removeAttribute("temasAReproducir");
                request.getSession().removeAttribute("reproducirTema");
            }
            
            if (request.getParameter("descargar") != null) {
//                if (tipoArchivo.equals("audio")) {
                    try {
                        DtUsuario dt = (DtUsuario) request.getSession().getAttribute("Usuario");
                        if (dt != null && dt instanceof DtCliente && wscli.suscripcionVigente(dt.getNickname())) {
                            String ruta = request.getParameter("descargar");
                            response.setContentType("audio/mpeg");
                            response.addHeader("Content-Disposition", "attachment; filename=" + "NombreTema.mp3"); //indica que es un archivo para descargar

                            byte[] audio = wsarch.cargarArchivo(ruta);
                            System.out.println(audio.length);

                            response.setContentType("audio/mpeg");
                            response.setContentLength((int) audio.length);

                            OutputStream out = response.getOutputStream();
                            out.write(audio);
                            out.close();
                        } else {
                            if (dt == null) {
                                request.getSession().setAttribute("Mensaje", "Inicie sesión");
                            } else if (dt instanceof DtArtista) {
                                request.getSession().setAttribute("Mensaje", "Los artistas no pueden descargar temas");
                            } else {
                                request.getSession().setAttribute("Mensaje", "No tiene suscripción vigente");
                            }
                            response.sendRedirect("ServletArtistas?Inicio=true");
                            //response.getWriter().write("ERROR : " + ex.getMessage());
                        }
                    } catch (IOException_Exception ex) {
                        Logger.getLogger(ServletArchivos.class.getName()).log(Level.SEVERE, null, ex);
                    }
//                }
            }
//        } catch (Exception ex) {
//            response.sendRedirect("/EspotifyWeb/Vistas/Error.html");
//            /*
//            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/Error.html");
//            requestDispatcher.forward(request, response);
//            */
//        }
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
