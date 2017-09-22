/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Logica.DtCliente;
import Logica.DtUsuario;
import Logica.Fabrica;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
        
        if(request.getParameter("verPerfilCli") != null){
            String nickname = request.getParameter("verPerfilCli");
            DtCliente datosClientes = Fabrica.getCliente().verPerfilCliente(nickname);
            request.getSession().setAttribute("PerfilCli", datosClientes);
            
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("Vistas/VerPerfilCliente.jsp");
            requestDispatcher.forward(request, response);
            
            response.getWriter().write("perfil del cliente cargado");
        }
        
         if(request.getParameter("Registrarse") != null){
             response.getWriter().write("entro al if");
            try{
            String nickname=request.getParameter("nickname");
            String contrasenia=request.getParameter("contrasenia");
            String nombre=request.getParameter("nombre");
            String apellido=request.getParameter("apellido");
            String fechanac= request.getParameter("fechanac");
            String correo=request.getParameter("correo");
  
            SimpleDateFormat formato= new SimpleDateFormat("dd-MM-yyyy");
            if(nickname.equals("") && contrasenia.equals("") && nombre.equals("") && apellido.equals("") && fechanac.equals("") && correo.equals("") ){
                PrintWriter out=response.getWriter();
                  out.println("No debe haber campos vacios");
    
              }else{
                
                
             DtCliente cli=new DtCliente(nickname,contrasenia,nombre,apellido,formato.parse(fechanac),correo,null,null,null,null,null,null, null);
             boolean ok= Fabrica.getCliente().IngresarCliente(cli);
             if(ok){
             // request.getRequestDispatcher("/iniciarsesion").forward(request, response);
             PrintWriter out=response.getWriter();
                out.println("ta todo bien");
             }else{
                  PrintWriter out=response.getWriter();
                  out.println("Algo salio mal, no se pudo completar tu solicitud.");
                }
            }
           }catch (ParseException ex) {
                  Logger.getLogger(ServletArtistas.class.getName()).log(Level.SEVERE, null, ex); 
                }
    }
         if(request.getParameter("dejarSeguir") != null){
             String nickname = request.getParameter("dejarSeguir");
             DtUsuario dt = (DtUsuario)sesion.getAttribute("Usuario");
             Fabrica.getCliente().DejarSeguir(dt.getNickname(), nickname);
             sesion.setAttribute("Usuario", Fabrica.getCliente().verPerfilCliente(dt.getNickname()));
             response.sendRedirect("ServletClientes?verPerfilCli="+dt.getNickname());
         }
         
         
         if(request.getParameter("seguir") != null){
             String nickname = request.getParameter("seguir");
             DtUsuario dt = (DtUsuario)sesion.getAttribute("Usuario");
            try {
                Fabrica.getCliente().seguir(dt.getNickname(), nickname);
                sesion.setAttribute("Usuario", Fabrica.getCliente().verPerfilCliente(dt.getNickname()));
                response.sendRedirect("ServletClientes?verPerfilCli="+dt.getNickname());
            } catch (Exception ex) {
                sesion.setAttribute("Mensaje", "Hubo error al seguir al usuario "+ nickname);
                response.sendRedirect("ServletArtistas?Inicio=true");
            }
         }
         
         if (request.getParameter("Artista") != null && request.getParameter("album") != null && request.getParameter("tema") != null){
             String art = request.getParameter("Artista");
             String alb = request.getParameter("album");
             String tem = request.getParameter("tema");
             DtCliente dc = (DtCliente)request.getSession().getAttribute("Usuario");
            Fabrica.getCliente().agregarTemaFavorito(dc.getNickname(), art, alb, tem); 
            
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("ServletArtistas?Inicio=true");
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
