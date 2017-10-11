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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
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
                   
            

        if(request.getParameter("listarGeneros") != null){    
            ArrayList<String> generos =  Fabrica.getArtista().BuscarGenero("");
            request.getSession().setAttribute("Generos", generos);
            ArrayList<DtTema> temas = Fabrica.getArtista().listarTodosTemas();
            request.getSession().setAttribute("temas", temas);
        }    
        
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
        
        if(request.getParameter("NombreAlbum") != null){
            String nom = request.getParameter("NombreAlbum");
            String anio = request.getParameter("anioalbum");
            nom = ConvertirString(nom);
            DtArtista artista = (DtArtista) request.getSession().getAttribute("PerfilArt");
            boolean x = Fabrica.getArtista().estaAlbum(artista.getNickname(),nom);
            if (x == true)
                response.getWriter().write("si");
            else{
                response.getWriter().write("no");
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
                byte[] imagen = null;
                if (request.getParameter("foto")!=""){
                    String img = request.getParameter("foto");
                    img = (path + img);
                    File im = new File(img);
                    imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                    im.delete();
                    }
                //org.apache.commons.io.FileUtils.writeByteArrayToFile(new File(path +"hola.jpg"), bs);
                HashMap<String,DtTema> temasenviar = new HashMap();
                for (int i = 0; i < n; ++i) {
                    JSONObject person = temas.getJSONObject(i);
                    int orden = person.getInt("orden");
                    String nomtema = person.getString("nombre");
                    String duracion = person.getString("duracion");
                    String arch_url = person.getString("Archivo_Url");
                    
                    DtTema dtt;
                    if (arch_url.contains(".mp3")){
                        arch_url = (path + arch_url);
                        File audio =new File(arch_url);
                        byte[] arch = org.apache.commons.io.FileUtils.readFileToByteArray(audio);
                        dtt = new DtTema(nomtema,duracion,orden,null,null,arch);
                        audio.delete();
                        
                    }
                    else
                        dtt = new DtTema(nomtema,duracion,orden,arch_url,null);
                    temasenviar.put(dtt.getNombre(), dtt);
                    }
                Map<String,DtGenero> gen = new HashMap();
                HashMap<String,DtGenero> generosenviar = new HashMap();
                gen = Fabrica.getArtista().GetDataGeneros();
                for (String genero : generos) {
                    if (genero.contains("Rock") && genero.contains("Roll"))
                        genero = genero.substring(0, 6) + genero.substring(10);
                    DtGenero dt = gen.get(genero);
                    generosenviar.put(dt.getNombre(), dt);
                    }
                Fabrica.getArtista().IngresarAlbumWeb(artista.getNickname(),anio,nom,imagen,temasenviar,generosenviar);
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
            path= path.substring(1);
            byte[] imagen = null;
            if (request.getParameter("foto")!=""){
                String img = request.getParameter("foto");
                img = (path + img);
                File im = new File(img);
                imagen = org.apache.commons.io.FileUtils.readFileToByteArray(im);
                im.delete();
                }
             DtArtista art=new DtArtista(nickname,contrasenia,nombre,apellido,correo,formato.parse(fechanac),null,biografia,paginaweb,0,null,null,null);
             boolean x = Fabrica.getArtista().IngresarArtista(art,imagen);
             if (!x)
                response.getWriter().write("si");
             else
                response.getWriter().write("no");

           }catch (ParseException ex) {
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
    
}
