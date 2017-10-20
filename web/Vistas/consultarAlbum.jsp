<%-- 
    Document   : consultarAlbum
    Created on : 15-sep-2017, 17:23:00
    Author     : usuario
--%>

<%@page import="webservices.DtListaPD"%>
<%@page import="webservices.DtAlbum"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <% 
    String nomgen = request.getParameter("nomgen");
    List<DtAlbum> albumes = (List<DtAlbum>) session.getAttribute("Album");
    List<DtListaPD> listas = (List<DtListaPD>) session.getAttribute("Listas");
    %>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
         <title>Espotify: Género</title>
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2">
                
                </div>
                <div class="col-sm-8 text-center">
                    <div class="row">
                        <img src="/EspotifyWeb/Imagenes/iconoGenero.jpg" alt="foto del genero" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
                        <h3 class="tituloGenero text-primary"><b><%= nomgen %></b></h3>
                        <h4 class="text-left">Álbumes: </h4>
                        <table class="table text-left">
                            <thead>
                                <tr>
                                    <th>Artista</th>
                                    <th>Álbum</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%for(DtAlbum album: albumes){ 
                                String nombreAlb = album.getNombre();
                                String nombreArt = album.getNombreArtista();
                                %>
                                <tr>
                                    <td><a class="link" href="ServletArtistas?verPerfilArt=<%= album.getNombreArtista() %>"><%= album.getNombreArtista() %></a></td>
                                    <td><a class="link" href="ServletArtistas?verAlbum=<%= nombreAlb+"&artista="+nombreArt %>"><%= nombreAlb %></a></td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                        <table class="table text-left">
                            <thead>
                                <tr>
                                    <th>Listas</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <%for(DtListaPD lista: listas){ 
                                String nombre = lista.getNombre();
                                byte[] bytes = nombre.getBytes(StandardCharsets.UTF_8);
                                // "normaliza" el texto
                                String nomCodificado = new String(bytes, StandardCharsets.ISO_8859_1);
                                %>
                                <tr>
                                    <td><a class="link" href="/EspotifyWeb/ServletClientes?Lista=<%= lista.getNombre() %>"><%= nombre%></a></td> 
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="btn-group-vertical col-sm-2">
                
                </div>
            </div> 
        </div>
                    
        <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
        <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
    </body>
</html>
