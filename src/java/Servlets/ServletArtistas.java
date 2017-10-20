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
import Logica.DtGenero;
import Logica.DtListaP;
import Logica.DtListaPD;
import Logica.DtTema;
import Logica.DtUsuario;
import Logica.Fabrica;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Kevin
 */

@WebServlet(name = "ServletArtistas", urlPatterns = {"/ServletArtistas"})
@MultipartConfig
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
        HttpSession sesion = request.getSession();
        
        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                String  rutaArchivo = null, nickname = null, contrasenia = null, nombre = null, apellido = null, fechanac = null, correo = null, 
                        tipoUsuario = null, biografia = null, paginaweb = null;
                
                /*FileItemFactory es una interfaz para crear FileItem*/
                FileItemFactory file_factory = new DiskFileItemFactory();
                /*ServletFileUpload esta clase convierte los input file a FileItem*/
                ServletFileUpload servlet_up = new ServletFileUpload(file_factory);
                /*sacando los FileItem del ServletFileUpload en una lista */
                List items = servlet_up.parseRequest(request);
                String path = this.getClass().getClassLoader().getResource("").getPath();
                path = path.replace("build/web/WEB-INF/classes/","temporales/");
                path = path.replace( "%20", " ");
                for(int i=0;i<items.size();i++){
                    /*FileItem es un input enviado dentro del form multipart, puede ser un archivo o un parametro nomrnal(string)*/
                    FileItem item = (FileItem) items.get(i);
                    
                    /*item.isFormField() false=input file; true=text field*/
                    //Con if(item.isFormField()) se distingue si input es un archivo o es un input comun(texto)
                    if (item.isFormField() == false && item.getName().isEmpty() == false){
                        File archivo_server = new File(path + item.getName());
                        item.write(archivo_server);
                        rutaArchivo = path+ item.getName();
                    }else{
                        String nombreInput = item.getFieldName();
                        
                        switch(nombreInput){
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
                
                //SI la contrasenia es != null entonces el request fue enviado desde la pagina de registrarse
                if(contrasenia != null){
                    SimpleDateFormat formato= new SimpleDateFormat("dd-MM-yyyy");
                    byte[] imagen = null;
                    if (rutaArchivo != null){
                        File im = new File(rutaArchivo);
                        imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                        im.delete();
                    }
                    if(tipoUsuario != null && tipoUsuario.equals("Artista")){
                        DtArtista art=new DtArtista(nickname,contrasenia,nombre,apellido,correo,formato.parse(fechanac),biografia,paginaweb,0,null,null,null);
                        boolean x = Fabrica.getArtista().IngresarArtista(art,imagen);
                        if (x){
                            DtUsuario dt = Fabrica.getArtista().verificarLoginArtista(nickname, contrasenia);
                            sesion.setAttribute("Usuario", dt);
                            sesion.removeAttribute("error");
                            sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());
                            response.sendRedirect("ServletArtistas?Inicio=true");
                        }else{
                           response.getWriter().write("Error al llamar la funcion de la logica");
                        }
                    }else{
                        DtCliente cli = new DtCliente(nickname, contrasenia, nombre, apellido, formato.parse(fechanac), correo, null, null, null, null, null, null, null);
                        boolean x = Fabrica.getCliente().IngresarCliente(cli,imagen);
                        if (x){
                            DtUsuario dt = Fabrica.getArtista().verificarLoginArtista(nickname, contrasenia);
                            sesion.setAttribute("Usuario", dt);
                            sesion.removeAttribute("error");
                            sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());
                            
                            response.sendRedirect("ServletArtistas?Inicio=true");
                        } else{
                            response.getWriter().write("Error al llamar la funcion de la logica");
                        }
                    }
                }else{ // Crear Album
                    response.getWriter().write("Entró a crear album"+"<br>");
                    DtArtista artista = (DtArtista) sesion.getAttribute("Usuario");
                    String nomAlbum = (String) sesion.getAttribute("nombreAlb");
                    HashMap<String,DtTema> temasAlbum = (HashMap<String,DtTema>) sesion.getAttribute("temasAlbum");
                    HashMap<String,DtGenero> generosAlbum = new HashMap<>();
                    generosAlbum = (HashMap<String,DtGenero>) sesion.getAttribute("generosAlbum");
                    String anioAlbum = (String) sesion.getAttribute("anioAlb");
                    
                    response.getWriter().write("Artista: "+artista.getNickname()+"<br>");
                    response.getWriter().write("Album: "+nomAlbum+"<br>");
                    response.getWriter().write("Año: "+anioAlbum+"<br>");
                    
                    response.getWriter().write("Temas: size="+temasAlbum.size()+"<br>");
                    for (DtTema tema : temasAlbum.values()) {
                        response.getWriter().write("->"+tema.getNombre()+"<br>");
                    }
                    
                    response.getWriter().write("<br>");
                    for (DtGenero gen : generosAlbum.values()) {
                        response.getWriter().write(gen.getNombre()+"<br>");
                    }
                    
                    byte[] imagen = null;
                    if (rutaArchivo != null){
                        response.getWriter().write("Ruta archivo != null"+"<br>");
                        File im = new File(rutaArchivo);
                        imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                        im.delete();
                    }
                    
                    Fabrica.getArtista().IngresarAlbumWeb(artista.getNickname(),anioAlbum,nomAlbum,imagen,temasAlbum,generosAlbum);
                    response.getWriter().write("FIN crear album"+"<br>");
                    
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

        if(request.getParameter("listarGeneros") != null){    
            ArrayList<String> generos =  Fabrica.getArtista().BuscarGenero("");
            request.getSession().setAttribute("Generos", generos);
            ArrayList<DtTema> temas = Fabrica.getArtista().listarTodosTemas();
            request.getSession().setAttribute("temas", temas);
        }    
        
        /* TODO output your page here. You may use following sample code. */

        if (request.getParameter("Inicio") != null) {
            ArrayList<DtArtista> artistas = Fabrica.getArtista().ListarArtistas();
            request.getSession().removeAttribute("temasAReproducir");
            request.getSession().setAttribute("Artistas", artistas);
            
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
        
        if(request.getParameter("NombreAlbum") != null){
            String nom = request.getParameter("NombreAlbum");
            String anio = request.getParameter("anioalbum");
            nom = ConvertirString(nom);
            DtArtista artista = (DtArtista) request.getSession().getAttribute("PerfilArt");
            boolean x = Fabrica.getArtista().estaAlbum(artista.getNickname(),nom);
            if (x == true)
                response.getWriter().write("nomRepetido");
            else{
                sesion.setAttribute("nombreAlb", nom);
                sesion.setAttribute("anioAlb", anio);
                response.getWriter().write("ok");
                String JSON_data = request.getParameter("json");
                JSON_data = "{" + "  \"temas\": "+ JSON_data + "}";
                String[] generos = request.getParameterValues("generos[]");
                try{
                JSONObject obj = new JSONObject(JSON_data);
                JSONArray temas = obj.getJSONArray("temas");
                int n = temas.length();
                String path = this.getClass().getClassLoader().getResource("").getPath();
                path = path.replace("build/web/WEB-INF/classes/","temporales/");
                path = path.replace( "%20", " ");
                path= path.substring(1);
                HashMap<String,DtTema> temasAlbum = new HashMap();
                for (int i = 0; i < n; ++i) {
                    JSONObject person = temas.getJSONObject(i);
                    int orden = person.getInt("orden");
                    String nomtema = person.getString("nombre");
                    String duracion = person.getString("duracion");
                    String arch_url = person.getString("Archivo_Url");
                    int cantDescarga = person.getInt("cantDescarga");
                    int cantReproduccion = person.getInt("cantReproduccion");
                    
                    DtTema dtt;
                    if (arch_url.contains(".mp3")){
                        arch_url = (path + arch_url);
                        File audio =new File(arch_url);
                        byte[] arch = org.apache.commons.io.FileUtils.readFileToByteArray(audio);
                        dtt = new DtTema(nomtema,duracion,orden,null,null,arch,cantDescarga,cantReproduccion);
                        audio.delete();    
                    }else{
                        dtt = new DtTema(nomtema,duracion,orden,arch_url,null,null,cantDescarga,cantReproduccion);
                    }
                    temasAlbum.put(dtt.getNombre(), dtt);
                }
                
                response.getWriter().write("<br>Temas:<br>");
                for (DtTema tema : temasAlbum.values()) {
                    response.getWriter().write("->"+tema.getNombre()+"<br>");
                    if(tema.getArchivobyte() != null){
                        response.getWriter().write("-> Tiene archivo en bytes"+"<br>");
                    }
                }
                sesion.setAttribute("temasAlbum", temasAlbum);
                
                Map<String,DtGenero> gen = Fabrica.getArtista().GetDataGeneros();
                HashMap<String,DtGenero> generosAlbum = new HashMap();
                for (String genero : generos) {
                    if (genero.contains("Rock") && genero.contains("Roll"))
                        genero = genero.substring(0, 6) + genero.substring(10);
                    DtGenero dt = gen.get(genero);
                    generosAlbum.put(dt.getNombre(), dt);
                }
                sesion.setAttribute("generosAlbum", generosAlbum);
                }
                catch (Exception e){e.getMessage();}
            }
//            
        }
        if(request.getParameter("verPerfilArt") != null){
            String nickname = request.getParameter("verPerfilArt");
            DtArtista datosArtista = Fabrica.getArtista().ElegirArtista(nickname);
            request.getSession().setAttribute("PerfilArt", datosArtista);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilArtista.jsp");
            requestDispatcher.forward(request, response);

            response.getWriter().write("perfil del artista cargado");
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
            ArrayList<DtListaPD> listas = Fabrica.getArtista().getListasGenero(nombre);
            request.getSession().setAttribute("Album", albumnes);
            request.getSession().setAttribute("Listas", listas);
            if (nombre.contains("&"))
                nombre = java.net.URLEncoder.encode(nombre, "UTF-8");
            //Redirecciona a la pagina indicada 
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/consultarAlbum.jsp?nomgen=" + nombre);
            requestDispatcher.forward(request, response);
        }

        if (request.getParameter("verAlbum") != null && request.getParameter("artista") != null) {
            String nombreArt = request.getParameter("artista");
            String nombreAlb = request.getParameter("verAlbum");
            DtAlbum album = Fabrica.getArtista().ElegirAlbum(nombreArt, nombreAlb);
            request.getSession().setAttribute("Album", album);
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
            
           Fabrica.getArtista().nuevaDescargaTema(artista, album, tema);
            //Redirecciona a la pagina indicada 
            
        }
        
        if (request.getParameter("listarGeneros") != null) {
            ArrayList<String> generos = Fabrica.getArtista().BuscarGenero("");
            request.getSession().setAttribute("Generos", generos);
        }
        
        if (request.getParameter("nickenuso") != null) {
            String nick = request.getParameter("nickenuso");
            if (((Fabrica.getArtista().verificarDatos(nick, null))==false) || (Fabrica.getCliente().verificarDatos(nick, null))==false){
                response.getWriter().write("si");
            }
            else
                response.getWriter().write("no");
        }
        if (request.getParameter("correoenuso") != null) {
            String mail = request.getParameter("correoenuso");
            if (((Fabrica.getArtista().verificarDatos(null, mail))==false) || (Fabrica.getCliente().verificarDatos(null, mail))==false){
                response.getWriter().write("si");
            }
            else
                response.getWriter().write("no");
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

            SimpleDateFormat formato= new SimpleDateFormat("dd-MM-yyyy");
            String path = this.getClass().getClassLoader().getResource("").getPath();
            path = path.replace("build/web/WEB-INF/classes/","temporales/");
            path = path.replace( "%20", " ");
            path= path.substring(1);
            byte[] imagen = null;
            if (request.getParameter("foto")!=""){
                String img = request.getParameter("foto");
                img = (path + img);
                File im = new File(img);
                imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                im.delete();
                }
             DtArtista art=new DtArtista(nickname,contrasenia,nombre,apellido,correo,formato.parse(fechanac),biografia,paginaweb,0,null,null,null);
             boolean x = Fabrica.getArtista().IngresarArtista(art,imagen);
             if (!x)
                response.getWriter().write("si");
             else
                response.getWriter().write("no");

           }catch (ParseException ex) {
                  Logger.getLogger(ServletArtistas.class.getName()).log(Level.SEVERE, null, ex); 
                }
        }
        
        if (request.getParameter("TipoAgregarTema")!=null){
            String tipo = (String) request.getParameter("TipoAgregarTema");
            if (tipo.equals("0")){
                String nomalbum = (String) request.getParameter("NombreElementoAgregarTema");
                String nomartista = (String) request.getParameter("NombreCreadorAgregarTema");
                ArrayList<DtAlbum> albumes = (ArrayList<DtAlbum>)request.getSession().getAttribute("todosalbumes");
                DtAlbum al = null;
                for (int i=0;i<albumes.size();i++){
                    if (albumes.get(i).getNombre().equals(nomalbum) && albumes.get(i).getNombreArtista().equals(nomartista))
                        al = albumes.get(i);
                }
                request.getSession().setAttribute("ColeccionTemas", al);
                request.getSession().setAttribute("TipoAgregarTema", tipo);
                }
            if (tipo.equals("1")){
                String nomlista = (String) request.getParameter("NombreElementoAgregarTema");
                String nomcreador = (String) request.getParameter("NombreCreadorAgregarTema");
                ArrayList<DtListaP> listasp = (ArrayList<DtListaP>)request.getSession().getAttribute("todaslistasp");
                DtListaP lp = null;
                for (int i=0;i<listasp.size();i++){
                    if (listasp.get(i).getNombre().equals(nomlista) && listasp.get(i).getUsuario().equals(nomcreador))
                        lp = listasp.get(i);
                }
                request.getSession().setAttribute("ColeccionTemas", lp);
                request.getSession().setAttribute("TipoAgregarTema", tipo);
            }
            if (tipo.equals("2")){
                String nomlista = (String) request.getParameter("NombreElementoAgregarTema");
                ArrayList<DtListaPD> listaspd = (ArrayList<DtListaPD>) request.getSession().getAttribute("todaslistaspd");
                DtListaPD lpd = null;
                for (int i=0;i<listaspd.size();i++){
                    if (listaspd.get(i).getNombre().equals(nomlista))
                        lpd = listaspd.get(i);
                }
                request.getSession().setAttribute("ColeccionTemas", lpd);
                request.getSession().setAttribute("TipoAgregarTema", tipo);
            }
        }
        
        if (request.getParameter("agregartemalista") != null) {
            ArrayList<DtAlbum> todosalbumes = Fabrica.getArtista().listarTodosAlbumes();
            ArrayList<DtListaPD> todaslistaspd = Fabrica.getArtista().ListarListaPD();
            ArrayList<DtListaP> auxiliar = Fabrica.getCliente().ListarListaP();
            ArrayList<DtListaP> todaslistasp = new ArrayList();
            for (int i=0;i<auxiliar.size();i++){
                if (!(auxiliar.get(i).isPrivada()))
                    todaslistasp.add(auxiliar.get(i));
            }
            request.getSession().setAttribute("todosalbumes", todosalbumes);
            request.getSession().setAttribute("todaslistaspd", todaslistaspd);
            request.getSession().setAttribute("todaslistasp", todaslistasp);
            
            response.sendRedirect("/EspotifyWeb/Vistas/AgregarTema.jsp");
        }

        if (request.getParameter("Join") != null) {
            String nickname = request.getParameter("Join");
            String contrasenia = request.getParameter("Contrasenia");
            DtUsuario dt = Fabrica.getArtista().verificarLoginArtista(nickname, contrasenia);
            if (dt != null) {
                sesion.setAttribute("Usuario", dt);
                sesion.removeAttribute("error");
                sesion.setAttribute("Mensaje", "Bienvenido/a " + dt.getNombre() + " " + dt.getApellido());
                
                if(dt instanceof DtCliente){
                    //Verificar y actualizar si las suscripciones del cliente que estaban vigentes se vencieron
                    Fabrica.getCliente().actualizarVigenciaSuscripciones(dt.getNickname());
                }
                
                response.sendRedirect("ServletArtistas?Inicio=true");
            } else {
                if (!(Fabrica.getCliente().verificarDatos(nickname, nickname) && Fabrica.getArtista().verificarDatos(nickname, nickname))) {
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
    
    String ConvertirString(String cad){
        cad = cad.toLowerCase();
        String[] palabras = cad.split("\\s+");
        cad = "";
        for (int i=0;i<palabras.length;i++){
            palabras[i].toLowerCase();
            palabras[i] = palabras[i].substring(0, 1).toUpperCase() + palabras[i].substring(1);
            if (i==0)
                cad = cad + palabras[i];           
            else
                cad = cad + " " + palabras[i];
        }
        return cad;
    }
    
    void registrarse(){
        
    }
    
}
