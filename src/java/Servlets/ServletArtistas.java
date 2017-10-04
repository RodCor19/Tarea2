/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtAlbum;
import Logica.DtArtista;
import Logica.DtGenero;
import Logica.DtTema;
import Logica.DtUsuario;
import Logica.Fabrica;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
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
        }    
        
        //Si se pasó el parametro "listarArtistas", entocnes reconoce que tiene que listarlos
        if(request.getParameter("listarArtistas") != null){
            ArrayList<DtArtista> artistas =  Fabrica.getArtista().ListarArtistas();
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
                byte[] imagen = null;
                if (request.getParameter("foto")!=null){
                    String img = request.getParameter("foto");
                    img = (path + img);
                    imagen = org.apache.commons.io.FileUtils.readFileToByteArray(new File(img));
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
                        byte[] arch = org.apache.commons.io.FileUtils.readFileToByteArray(new File(arch_url));
                        dtt = new DtTema(nomtema,duracion,orden,null,null,arch);
                    }
                    else
                        dtt = new DtTema(nomtema,duracion,orden,null,arch_url);
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
//            byte[] data = Base64.decodeBase64(nom);
//            int i=0;
//            String ruta = "D:\\hol" + i + ".mp3";
//            try (OutputStream stream = new FileOutputStream(ruta)) {
//                stream.write(data);
//            }
            /*File file = new File("D:\\newfile.txt");
            String content = "This is the text content";
            try (FileOutputStream fop = new FileOutputStream(file)) {
                if (!file.exists()) {
                    file.createNewFile();
                    }
                byte[] contentInBytes = nom.getBytes();
                fop.write(contentInBytes);
                fop.flush();
                fop.close();
            }*/
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
       
        if(request.getParameter("Join")!=null){
            HttpSession sesion = request.getSession();
            String nickname = request.getParameter("Join");
            String contrasenia = request.getParameter("Contraseña");
            DtUsuario dt=Fabrica.getArtista().verificarLoginArtista(nickname, contrasenia);
            if(dt==null){
                sesion.setAttribute("Usuario", dt);
                 response.sendRedirect("/EspotifyWeb/Vistas/Cabecera.jsp");
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
