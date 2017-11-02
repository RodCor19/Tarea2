<%-- 
    Document   : AlbumIngresado
    Created on : 04/10/2017, 01:03:14 AM
    Author     : Admin
--%>

<%@page import="webservices.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Album Creado</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%  DtArtista artista = (DtArtista) session.getAttribute("PerfilArt"); %>
        
        <!-- Redirige despues de 5 segundos-->
        <meta http-equiv="refresh" content="5; URL=/EspotifyWeb/ServletArtistas?verPerfilArt=<%= artista.getNickname() %>">
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="alert alert-success" style="text-align: center;">
            <strong><h1 style="font-size: 30px;">Operación Exitosa</h1></strong><h4>¡ Album Ingresado !</h4>
        </div>
        <a href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= artista.getNickname() %>">Volver al perfil del artista</a>
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
    </body>
</html>
