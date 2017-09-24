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
            <div class="col-md-4">
                <a href="/EspotifyWeb/ServletArtistas?Inicio=true">
                    <img src="/EspotifyWeb/Imagenes/Espotify.png" alt="imagen de header" width="250"  style="margin-top: 17px;">
                </a>
            </div>
            <div class="col-md-4">
                <form id="formBuscar" action="http://www.google.com" method="GET" class="navbar-form navbar-left" style="margin-top: 40px;">
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
                <div class="col-md-8 text-right" style="padding-right: 0px; padding-bottom: 5px; opacity: 0;">
                    <img src="/EspotifyWeb/Imagenes/iconoUsuario.jpg" alt="foto del usuario" class="img-responsive imgPerfil" title="Usuario">
                </div>
                <div class="col-md-4 text-right" style="padding-left: 0px;">
                    <h5 style="color:white"><a class="linkCabecera" href="/EspotifyWeb/Vistas/Registrarse.jsp">Registrarse</a> o</h5>
                    <h5 style="color:white"><a class="iniciarCerrarSesion" href="/EspotifyWeb/Vistas/Iniciarsesion.jsp">Iniciar Sesión</a></h5>
                </div>
                <%} else {
                    DtUsuario dt = (DtUsuario)sesion.getAttribute("Usuario");
                    String servlet;
                    if (dt instanceof DtCliente) {
                        servlet = "/EspotifyWeb/ServletClientes?verPerfilCli=";
                    } else {
                        servlet = "/EspotifyWeb/ServletArtistas?verPerfilArt=";
                    }
                %>
                <div class="col-md-8 text-right" style="padding-right: 0px; padding-bottom: 5px;">
                    <img src="/EspotifyWeb/Imagenes/iconoUsuario.jpg" alt="foto del usuario" class="img-responsive imgPerfil" title="Usuario">
                </div>
                <div class="col-md-4 text-right" style="padding-left: 0px;">
                    <h5 style="color:white"><a class="linkCabecera" href="<%= servlet + dt.getNickname() %>"><%= dt.getNickname() %></a></h5>
                    <h5 style="color:white"><a class="linkCabecera" href="/EspotifyWeb/Vistas/Favoritos.jsp">Ver Favoritos</a></h5>
                    <h5 style="color:white"><a class="iniciarCerrarSesion" href="ServletArtistas?CerrarSesion=true">Cerrar Sesión</a></h5>
                <%}%>
                </div>
            </div>
        </div>
    </div>
</nav>
