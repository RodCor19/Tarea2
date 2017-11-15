<%-- 
    Document   : listaArtistas
    Created on : 12/09/2017, 10:01:57 PM
    Author     : Kevin
--%>
<%@page import="webservices.DtArtista"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  List<DtArtista> artistas = (List<DtArtista>) session.getAttribute("Artistas"); %>

<div class="row">
    <%for(DtArtista art: artistas){ %>
    <div class="col-xs-4" style="padding: 2px;">
        <a href="ServletArtistas?verPerfilArt=<%= art.getNickname() %>">
            <% if(art.getRutaImagen() == null){ %>
            <img src="/EspotifyWeb/Imagenes/iconoArtista.png" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista"><!--Cambiar por imagen del usuario-->
            <%}else{%>
            <img src="/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=<%= art.getRutaImagen() %>" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista">
            <%}%>
            
            <!--<img src="/EspotifyWeb/Imagenes/iconoArtista.png" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista">Cambiar por imagen del usuario-->
            <h4 class="img-text" onmouseover="artSeleccionado(this, true)" onmouseout="artSeleccionado(this, false)"><%=art.getNombre()+" "+art.getApellido() %></h4>
        </a>  
    </div>
    <%}%>
</div>
