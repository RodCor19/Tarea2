/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.net.Socket;
import org.json.JSONArray;
import org.json.JSONObject;
import webservices.DataGeneros;
import webservices.DataTemas;
import webservices.DataUsuarios;
import webservices.DtAlbum;
import webservices.DtArtista;
import webservices.DtCliente;
import webservices.DtGenero;
import webservices.DtLista;
import webservices.DtListaP;
import webservices.DtListaPD;
import webservices.DtTema;
import webservices.DtUsuario;
import webservices.WSArtistas;
import webservices.WSArtistasService;
import webservices.WSClientes;
import webservices.WSClientesService;

/**
 *
 * @author Kevin
 */
@WebServlet(name = "ServletArtistas", urlPatterns = {"/ServletArtistas"})
@MultipartConfig
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
        

        Properties propiedades = new Properties();
        String rutaConfWS = this.getClass().getClassLoader().getResource("").getPath();
        rutaConfWS = rutaConfWS.replace("build/web/WEB-INF/classes/", "webservices.properties");
        rutaConfWS = rutaConfWS.replace("%20", " ");
        InputStream entrada = new FileInputStream(rutaConfWS);
        propiedades.load(entrada);// cargamos el archivo de propiedades
        
        try{
            //URL url = new URL("http://" + propiedades.getProperty("ipServidor") + ":" + propiedades.getProperty("puertoWSArt") + "/" + propiedades.getProperty("nombreWSArt"));
            WSArtistasService wsarts = new WSArtistasService(/*url*/);
            WSArtistas wsart = wsarts.getWSArtistasPort();

    //        url = new URL("http://"+ propiedades.getProperty("ipServidor") +":"+ propiedades.getProperty("puertoWSCli")+"/"+propiedades.getProperty("nombreWSCli"));
            WSClientesService wsclis = new WSClientesService();
            WSClientes wscli = wsclis.getWSClientesPort();
            HttpSession sesion = request.getSession();
            request.getSession().setAttribute("WSArtistas", wsart);
            request.getSession().setAttribute("WSClientes", wscli);


            //Aca se hacen los cu alta perfil(cliente y artista) y alta album(una parte) 
            if (ServletFileUpload.isMultipartContent(request)) {
                try {
                    String rutaArchivo = null, nickname = null, contrasenia = null, nombre = null, apellido = null, fechanac = null, correo = null,
                            tipoUsuario = null, biografia = null, paginaweb = null;

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
                        /*FileItem es un input enviado dentro del form multipart, puede ser un archivo o un parametro nomrnal(string)*/
                        FileItem item = (FileItem) items.get(i);

                        /*item.isFormField() false=input file; true=text field*/
                        //Con if(item.isFormField()) se distingue si input es un archivo o es un input comun(texto)
                        if (item.isFormField() == false && item.getName().isEmpty() == false) {
                            File archivo_server = new File(path + item.getName());
                            item.write(archivo_server);
                            rutaArchivo = path + item.getName();
                        } else {
                            String nombreInput = item.getFieldName();

                            switch (nombreInput) {
                                case "nickname":
                                    nickname = item.getString("UTF-8");
                                    break;
                                case "contrasenia":
                                    contrasenia = item.getString("UTF-8");
                                    break;
                                case "nombre":
                                    nombre = item.getString("UTF-8");
                                    break;
                                case "apellido":
                                    apellido = item.getString("UTF-8");
                                    break;
                                case "fechanac":
                                    fechanac = item.getString("UTF-8");
                                    break;
                                case "correo":
                                    correo = item.getString("UTF-8");
                                    break;
                                case "tipoUsr":
                                    tipoUsuario = item.getString("UTF-8");
                                    break;
                                case "biografia":
                                    biografia = item.getString("UTF-8");
                                    break;
                                case "paginaweb":
                                    paginaweb = item.getString("UTF-8");
                                    break;
                            }
                        }
                    }

                    if (fechanac != null) {
                        fechanac = fechanac.replace("-", "/"); //cambiar el formato a dd/mm/yyyy
                    }

                    //SI la contrasenia es != null entonces el request fue enviado desde la pagina de registrarse
                    if (contrasenia != null) {
                        byte[] imagen = new byte[0];
                        if(imagen.length == 0){
                            response.getWriter().write("lenght 0 == null");
                        }
                        if (rutaArchivo != null){
                            File im = new File(rutaArchivo);
                            imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                            im.delete();
                        }
                        if (tipoUsuario != null && tipoUsuario.equals("Artista")) {
    //                        DtArtista art=new DtArtista(nickname,contrasenia,nombre,apellido,correo,fechanac,biografia,paginaweb,0,null,null,null);
                            DtArtista art = new DtArtista();
                            art.setNickname(nickname);
                            art.setContrasenia(contrasenia);
                            art.setNombre(nombre);
                            art.setApellido(apellido);
                            art.setCorreo(correo);
                            art.setFechaNac(fechanac);
                            art.setBiografia(biografia);
                            art.setPagWeb(paginaweb);
                            art.setCantSeguidores(0);
                            boolean x = wsart.ingresarArtista(art, imagen);
                            if (x) {
                                DataUsuarios data = wsart.verificarLoginArtista(nickname, contrasenia);
                                DtUsuario dt = null;
                                if (!data.getUsuarios().isEmpty()) {
                                    dt = data.getUsuarios().get(0);
                                }
                                sesion.setAttribute("Usuario", dt);
                                sesion.removeAttribute("error");
                                sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());
                                response.sendRedirect("ServletArtistas?Inicio=true");
                            } else {
                                response.getWriter().write("Error al llamar la funcion de la logica");
                            }
                        } else {
    //                        DtCliente cli = new DtCliente(nickname, contrasenia, nombre, apellido, fechanac, correo, null, null, null, null, null, null, null, null);
                            DtCliente cli = new DtCliente();
                            cli.setNickname(nickname);
                            cli.setContrasenia(contrasenia);
                            cli.setNombre(nombre);
                            cli.setApellido(apellido);
                            cli.setCorreo(correo);
                            cli.setFechaNac(fechanac);
                            cli.setRutaImagen(null);
                            boolean x = wscli.ingresarCliente(cli, imagen);
                            if (x) {
                                DataUsuarios data = wsart.verificarLoginArtista(nickname, contrasenia);
                                DtUsuario dt = null;
                                if (!data.getUsuarios().isEmpty()) {
                                    dt = data.getUsuarios().get(0);
                                }
                                sesion.setAttribute("Usuario", dt);
                                sesion.removeAttribute("error");
                                sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());

                                response.sendRedirect("ServletArtistas?Inicio=true");
                            } else {
                                response.getWriter().write("Error al llamar la funcion de la logica");
                            }
                        }
                    } else { // Crear Album
                        response.getWriter().write("Entró a crear album" + "<br>");
                        DtArtista artista = (DtArtista) sesion.getAttribute("Usuario");
                        String nomAlbum = (String) sesion.getAttribute("nombreAlb");
                        DataTemas temasAlbum = (DataTemas) sesion.getAttribute("temasAlbum");
                        DataGeneros generosAlbum = (DataGeneros) sesion.getAttribute("generosAlbum");
                        String anioAlbum = (String) sesion.getAttribute("anioAlb");

                        response.getWriter().write("Artista: " + artista.getNickname() + "<br>");
                        response.getWriter().write("Album: " + nomAlbum + "<br>");
                        response.getWriter().write("Año: " + anioAlbum + "<br>");

                        response.getWriter().write("Temas: size=" + temasAlbum.getTemas().size() + "<br>");
                        for (DtTema tema : temasAlbum.getTemas()) {
                            response.getWriter().write("->" + tema.getNombre() + "<br>");
                        }

                        response.getWriter().write("<br>");
                        for (DtGenero gen : generosAlbum.getGeneros()) {
                            response.getWriter().write(gen.getNombre() + "<br>");
                        }

                        byte[] imagen = new byte[0]; //se interpreta como null en el servidor
                        if (rutaArchivo != null) {
                            response.getWriter().write("Ruta archivo != null" + "<br>");
                            File im = new File(rutaArchivo);
                            imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                            im.delete();
                        }

    //                    DataTemas temasA = new DataTemas();
                        wsart.ingresarAlbumWeb(artista.getNickname(),anioAlbum,nomAlbum,imagen,temasAlbum,generosAlbum);
                        response.getWriter().write("FIN crear album" + "<br>");

                        //Borar atributos de sesion usados durante la creacion del nuevo album
                        sesion.removeAttribute("nombreAlb");
                        sesion.removeAttribute("anioAlb");
                        sesion.removeAttribute("temasAlbum");
                        sesion.removeAttribute("generosAlbum");
                    }

                } catch (FileUploadException ex) {
                    Logger.getLogger(ServletClientes.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ServletArtistas.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (request.getParameter("listarGeneros") != null) {
                DataGeneros datag = wsart.buscarGenero("");
                List<DtGenero> generos = wsart.buscarGenero("").getGeneros();
                request.getSession().setAttribute("Generos", generos);
                List<DtTema> temas = wsart.listarTodosTemas().getTemas();
                request.getSession().setAttribute("temas", temas);
            }

            /* TODO output your page here. You may use following sample code. */
            if (request.getParameter("Inicio") != null) {
                List<DtUsuario> artistas = wsart.listarArtistas().getUsuarios();
                request.getSession().removeAttribute("temasAReproducir");
                request.getSession().setAttribute("Artistas", artistas);

                //Redirecciona a la pagina indicada 
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/index.jsp");
                requestDispatcher.forward(request, response);
            }

            //Si se pasó el parametro "listarArtistas", entocnes reconoce que tiene que listarlos
            if (request.getParameter("listarArtistas") != null) {
                List<DtUsuario> artistas = wsart.listarArtistas().getUsuarios();
                request.getSession().setAttribute("Artistas", artistas);
    //          
                response.getWriter().write("artistas listados correctamente");// es para que mostrar un mensaje en la consola del navegador, es opcional
            }

            if (request.getParameter("NombreAlbum") != null) {
                String nom = request.getParameter("NombreAlbum");
                String anio = request.getParameter("anioalbum");
                nom = ConvertirString(nom);
                DtArtista artista = (DtArtista) request.getSession().getAttribute("PerfilArt");
                boolean x = wsart.estaAlbum(artista.getNickname(), nom);
                if (x == true) {
                    response.getWriter().write("nomRepetido");
                } else {
                    sesion.setAttribute("nombreAlb", nom);
                    sesion.setAttribute("anioAlb", anio);
                    response.getWriter().write("ok");
                    String JSON_data = request.getParameter("json");
                    JSON_data = "{" + "  \"temas\": " + JSON_data + "}";
                    String[] generos = request.getParameterValues("generos[]");
    //<<<<<<< HEAD
                    try{
                    JSONObject obj = new JSONObject(JSON_data);
                    JSONArray temas = obj.getJSONArray("temas");
                    int n = temas.length();
                    String path = this.getClass().getClassLoader().getResource("").getPath();
                    path = path.replace("build/web/WEB-INF/classes/","temporales/");
                    path = path.replace( "%20", " ");
                    path= path.substring(1);

    //                List<DtTema> temasAlbum = new ArrayList();
                    DataTemas temasA = new DataTemas();
                    for (int i = 0; i < n; ++i) {
                        JSONObject person = temas.getJSONObject(i);
                        int orden = person.getInt("orden");
                        String nomtema = person.getString("nombre");
                        String duracion = person.getString("duracion");
                        String arch_url = person.getString("Archivo_Url");
                        int cantDescarga = person.getInt("cantDescarga");
                        int cantReproduccion = person.getInt("cantReproduccion");

                        DtTema dtt = new DtTema();
                        dtt.setNombre(nomtema);
                        dtt.setDuracion(duracion);
                        dtt.setOrden(orden);
                        dtt.setArchivo(null);
                        if (arch_url.contains(".mp3")){
                            arch_url = (path + arch_url);
                            File audio =new File(arch_url);
                            byte[] arch = org.apache.commons.io.FileUtils.readFileToByteArray(audio);
                                dtt.setDireccion(null);
                                dtt.setArchivobyte(arch);
                                audio.delete();
                            } else {
    //                        dtt = new DtTema(nomtema,duracion,orden,arch_url, null, null);
                                dtt.setDireccion(arch_url);
                                dtt.setArchivobyte(null);
                            }
                            temasA.getTemas().add(dtt);
                        }

                        response.getWriter().write("<br>Temas:<br>");
                        for (DtTema tema : temasA.getTemas()) {
                            response.getWriter().write("->" + tema.getNombre() + "<br>");
                            if (tema.getArchivobyte() != null) {
                                response.getWriter().write("-> Tiene archivo en bytes" + "<br>");
                            }
                        }
                        sesion.setAttribute("temasAlbum", temasA);

                        List<DtGenero> gen = wsart.getDataGeneros().getGeneros();
                        DataGeneros generosA = new DataGeneros();
    //                    List<DtGenero> generosAlbum = new ArrayList();
                        for (String genero : generos) {
                            if (genero.contains("Rock") && genero.contains("Roll")) {
                                genero = genero.substring(0, 6) + genero.substring(10);
                            }

                            for (DtGenero dtG : gen) {
                                if (dtG.getNombre().equals(genero)) {
    //                                generosAlbum.add(dtG);
                                    generosA.getGeneros().add(dtG);
                                    break;
                                }
                            }
                        }
                        sesion.setAttribute("generosAlbum", generosA);
                    } catch (Exception e) {
                        e.getMessage();
                    }
                }
    //            
            }
            if (request.getParameter("verPerfilArt") != null) {
                String nickname = request.getParameter("verPerfilArt");
                DtArtista datosArtista = wsart.elegirArtista(nickname);
                request.getSession().setAttribute("PerfilArt", datosArtista);
                List<DtUsuario> seguidores = wsart.listarSeguidores(nickname).getUsuarios();
                request.getSession().setAttribute("SeguidoresArt", seguidores);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilArtista.jsp");
                requestDispatcher.forward(request, response);

                response.getWriter().write("perfil del artista cargado");
            }
            if (request.getParameter("consultarAlbum") != null) {
                String nombre = request.getParameter("consultarAlbum");
                List<DtAlbum> albumnes = wsart.listarAlbumGenero(nombre).getAlbumes();
                List<DtLista> listas = wsart.getListasGenero(nombre).getListas();
                request.getSession().setAttribute("Album", albumnes);
                request.getSession().setAttribute("Listas", listas);
                if (nombre.contains("&")) {
                    nombre = java.net.URLEncoder.encode(nombre, "UTF-8");
                }
                //Redirecciona a la pagina indicada 
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/consultarAlbum.jsp?nomgen=" + nombre);
                requestDispatcher.forward(request, response);
            }

            if (request.getParameter("verAlbum") != null && request.getParameter("artista") != null) {
                String nombreArt = request.getParameter("artista");
                String nombreAlb = request.getParameter("verAlbum");

                DtAlbum album = wsart.elegirAlbum(nombreArt, nombreAlb);
                request.getSession().setAttribute("Album", album);

                DtArtista artista = wsart.elegirArtista(album.getNombreArtista());
                request.getSession().setAttribute("ArtistaAlbum", artista);

                request.getSession().removeAttribute("temasAReproducir");

                //Redirecciona a la pagina indicada 
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/listarTema.jsp");
                //"ServletArtistas?verAlbum=<%= nombreAlb+"&artista="+nombreArt %>"
                requestDispatcher.forward(request, response);

                response.getWriter().write("temas cargados");
            }

            if (request.getParameter("nuevadescarga") != null) {
    //            response.getWriter().write("nuevadescarga");
                String artista = request.getParameter("artista");
                String album = request.getParameter("album");
                String tema = request.getParameter("tema");

                //Poner la funcion en webservice aertistas
    //           Fabrica.getArtista().nuevaDescargaTema(artista, album, tema);
                //Redirecciona a la pagina indicada 
            }

            if (request.getParameter("listarGeneros") != null) {
                List<DtGenero> generos = wsart.buscarGenero("").getGeneros();
                request.getSession().setAttribute("Generos", generos);
            }

            if (request.getParameter("nickenuso") != null) {
                String nick = request.getParameter("nickenuso");
                if (((wsart.verificarDatosArt(nick, "")) == false) || (wscli.verificarDatosCli(nick, "")) == false) {
                    response.getWriter().write("si");
                } else {
                    response.getWriter().write("no");
                }
            }
            if (request.getParameter("correoenuso") != null) {
                String mail = request.getParameter("correoenuso");
                if (((wsart.verificarDatosArt("", mail)) == false) || (wsart.verificarDatosArt("", mail)) == false) {
                    response.getWriter().write("si");
                } else {
                    response.getWriter().write("no");
                }
            }
            if (request.getParameter("TipoAgregarTema") != null) {
                String tipo = (String) request.getParameter("TipoAgregarTema");
                if (tipo.equals("0")) {
                    String nomalbum = (String) request.getParameter("NombreElementoAgregarTema");
                    String nomartista = (String) request.getParameter("NombreCreadorAgregarTema");
                    ArrayList<DtAlbum> albumes = (ArrayList<DtAlbum>) request.getSession().getAttribute("todosalbumes");
                    DtAlbum al = null;
                    for (int i = 0; i < albumes.size(); i++) {
                        if (albumes.get(i).getNombre().equals(nomalbum) && albumes.get(i).getNombreArtista().equals(nomartista)) {
                            al = albumes.get(i);
                        }
                    }
                    request.getSession().setAttribute("ColeccionTemas", al);
                    request.getSession().setAttribute("TipoAgregarTema", tipo);
                }
                if (tipo.equals("1")) {
                    String nomlista = (String) request.getParameter("NombreElementoAgregarTema");
                    String nomcreador = (String) request.getParameter("NombreCreadorAgregarTema");
                    ArrayList<DtListaP> listasp = (ArrayList<DtListaP>) request.getSession().getAttribute("todaslistasp");
                    DtListaP lp = null;
                    for (int i = 0; i < listasp.size(); i++) {
                        if (listasp.get(i).getNombre().equals(nomlista) && listasp.get(i).getUsuario().equals(nomcreador)) {
                            lp = listasp.get(i);
                        }
                    }
                    request.getSession().setAttribute("ColeccionTemas", lp);
                    request.getSession().setAttribute("TipoAgregarTema", tipo);
                }
                if (tipo.equals("2")) {
                    String nomlista = (String) request.getParameter("NombreElementoAgregarTema");
                    ArrayList<DtListaPD> listaspd = (ArrayList<DtListaPD>) request.getSession().getAttribute("todaslistaspd");
                    DtListaPD lpd = null;
                    for (int i = 0; i < listaspd.size(); i++) {
                        if (listaspd.get(i).getNombre().equals(nomlista)) {
                            lpd = listaspd.get(i);
                        }
                    }
                    request.getSession().setAttribute("ColeccionTemas", lpd);
                    request.getSession().setAttribute("TipoAgregarTema", tipo);
                }
            }

            if (request.getParameter("agregartemalista") != null) {
                List<DtAlbum> todosalbumes = wsart.listarTodosAlbumes().getAlbumes();
                List<DtLista> todaslistaspd = wsart.listarListaPD().getListas();
                List<DtLista> auxiliar = wscli.listarListaP().getListas();
                List<DtLista> todaslistasp = new ArrayList();
                for (DtLista listaAux : auxiliar) {
                    DtListaP listapd = (DtListaP) listaAux;
                    if (!listapd.isPrivada()) {
                        todaslistasp.add(listapd);
                    }
                }
                request.getSession().setAttribute("todosalbumes", todosalbumes);
                request.getSession().setAttribute("todaslistaspd", todaslistaspd);
                request.getSession().setAttribute("todaslistasp", todaslistasp);

                response.sendRedirect("/EspotifyWeb/Vistas/AgregarTema.jsp");
            }

            if (request.getParameter("Join") != null) {
                String nickname = request.getParameter("Join");
                String contrasenia = request.getParameter("Contrasenia");
                DataUsuarios data = wsart.verificarLoginArtista(nickname, contrasenia);
                DtUsuario dt = null;
                if (!data.getUsuarios().isEmpty()) {
                    dt = data.getUsuarios().get(0);
                }

                if (dt != null) {
                    sesion.setAttribute("Usuario", dt);
                    sesion.removeAttribute("error");
                    sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());

                    if (dt instanceof DtCliente) {
                        //Verificar y actualizar si las suscripciones del cliente que estaban vigentes se vencieron
                        wscli.actualizarVigenciaSuscripciones(dt.getNickname());
                    }

                    response.sendRedirect("ServletArtistas?Inicio=true");
                } else {
                    if (!(wscli.verificarDatosCli(nickname, nickname) && wsart.verificarDatosArt(nickname, nickname))) {
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
            
            if (request.getParameter("VerRanking") != null) {
                List<DtUsuario> usr = wsart.rankingDesendente().getUsuarios();
                request.getSession().setAttribute("RankingUsuarios", usr);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/listaRanking.jsp");
                requestDispatcher.forward(request, response);
            }
                    
        }catch(Exception ex){
//            response.sendRedirect("/EspotifyWeb/Vistas/Error.html");
            //Redirecciona a la pagina indicada 
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/Error.html");
            requestDispatcher.forward(request, response);
        }
        
        
        
//            response.getWriter().write("hola wolrd");
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

    String ConvertirString(String cad) {
        cad = cad.toLowerCase();
        String[] palabras = cad.split("\\s+");
        cad = "";
        for (int i = 0; i < palabras.length; i++) {
            palabras[i].toLowerCase();
            palabras[i] = palabras[i].substring(0, 1).toUpperCase() + palabras[i].substring(1);
            if (i == 0) {
                cad = cad + palabras[i];
            } else {
                cad = cad + " " + palabras[i];
            }
        }
        return cad;
    }

}
