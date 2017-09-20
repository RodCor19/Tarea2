<%-- 
    Document   : consultarAlbum
    Created on : 15-sep-2017, 17:23:00
    Author     : usuario
--%>

<%@page import="Logica.DtAlbum"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.DtGenero"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <% 
    String nomgen = request.getParameter("nomgen");
    ArrayList<DtAlbum> albumes = (ArrayList<DtAlbum>) session.getAttribute("Album");
    %>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
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
                                    <td><%= album.getNombreArtista() %></td>
                                    <td><a href="ServletArtistas?verAlbum=<%= nombreAlb+"&artista="+nombreArt %>"><%= nombreAlb %></a></td>
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
                    
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
    </body>
</html>
