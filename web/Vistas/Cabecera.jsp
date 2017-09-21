<%-- 
    Document   : Cabecera
    Created on : 11/09/2017, 11:47:33 AM
    Author     : Kevin
--%>

<%@page import="Logica.DtCliente"%>
<%@page import="Logica.DtUsuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%-- navegador, cabecera - color #1ED760 --%>
<nav class="navbar navbar-custom">
    <div class="container-fluid">
        <div class="row">
            <%-- se divide la pantalla en 3 partes de tamaño 4(columnas) (El total de columnas de la pantalla es 12) --%>
            <div class="col-md-4" >
                <a href="/EspotifyWeb/ServletArtistas?Inicio=true">
                    <img src="/EspotifyWeb/Imagenes/Espotify.png" alt="imagen de header" width="200" onclick="">
                </a>
            </div>
            <div class="col-md-4">
                <form id="formBuscar" action="http://www.google.com" method="GET" class="navbar-form navbar-left">
                    <input id="buscar" name="busqueda" placeholder="Buscar Tema, Lista, Álbum..." type="text" class="form-control">
                    <button class="btn" type="submit">
                        <i class="glyphicon glyphicon-search"></i> <%-- Icono de buscar, lupa--%>
                    </button>
                </form> 
            </div>
            <div class="col-md-4 text-right" >
               <%
                    HttpSession sesion = request.getSession();
                    if (sesion.getAttribute("Usuario") == null) {
                %>
                <h5 style="color:white"><a id="registrarse" href="/EspotifyWeb/Vistas/Registrarse.jsp">Registrarse</a> o</h5>
                <h5 style="color:white"><a id="iniciarSesion" href="/EspotifyWeb/Vistas/Iniciarsesion.jsp">Iniciar Sesión</a></h5>
                <%} else {
                    DtUsuario dt = (DtUsuario)sesion.getAttribute("Usuario");
                    String servlet;
                    if (dt instanceof DtCliente) {
                        servlet = "ServletClientes?verPerfilCli=";
                    } else {
                        servlet = "ServletArtistas?verPerfilArt=";
                    }
                %>
                <h5 style="color:white"><a id="registrarse" href="<%= servlet + dt.getNickname() %>"><%= dt.getNickname() %></a></h5>
                <h5 style="color:white"><a id="iniciarSesion" href="http://www.google.com">Cerrar Sesión</a></h5>
                <%}%>
 
            </div>
        </div>
    </div>
</nav>
