<%-- 
    Document   : listaGeneros
    Created on : 13-sep-2017, 21:30:09
    Author     : usuario
--%>

<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<%  ArrayList<String> generos = (ArrayList<String>) session.getAttribute("Generos"); %>

<div class="row">
    <%for(String gen: generos){
        
    %>
    <div class="col-md-4" style="padding: 2px;">
        <% String generoCodificado = URLEncoder.encode(gen, "UTF-8"); %>
        <a href="ServletArtistas?consultarAlbum=<%= generoCodificado %>">
            <img src="/EspotifyWeb/Imagenes/iconoGenero.jpg" alt="foto del genero" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
            <h4 class="img-text" onmouseover="artSeleccionado(this, true)" onmouseout="artSeleccionado(this, false)"><%=gen%></h4>
        </a>  
    </div>
    <%}%>
</div>
