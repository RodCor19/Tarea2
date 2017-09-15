<%-- 
    Document   : listaArtistas
    Created on : 12/09/2017, 10:01:57 PM
    Author     : Kevin
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  ArrayList<DtArtista> artistas = (ArrayList<DtArtista>) session.getAttribute("Artistas"); %>

<div class="row">
    <%for(DtArtista art: artistas){ %>
    <div class="col-md-4" style="padding: 2px;">
        <a href="ServletArtistas?verPerfilArt=<%= art.getNickname() %>">
            <img src="/EspotifyWeb/Imagenes/iconoArtista.png" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista"><!--Cambiar por imagen del usuario-->
            <h4 class="img-text" onmouseover="artSeleccionado(this, true)" onmouseout="artSeleccionado(this, false)"><%=art.getNombre()+" "+art.getApellido() %></h4>
        </a>  
    </div>
    <%}%>
</div>
