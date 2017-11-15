<%-- 
    Document   : listaGeneros
    Created on : 13-sep-2017, 21:30:09
    Author     : usuario
--%>

<%@page import="webservices.DtGenero"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<%  List<DtGenero> generos = (List<DtGenero>) session.getAttribute("Generos"); %>

<div class="row">
    <%for (DtGenero gen : generos) {
    %>
    <div class="col-xs-4" style="padding: 2px;">
        <% String generoCodificado = URLEncoder.encode(gen.getNombre(), "UTF-8"); %>
        <a href="ServletArtistas?consultarAlbum=<%= generoCodificado %>">
            <%String nomgen = gen.getNombre();
            if (nomgen.equals("Rock") || nomgen.equals("Pop") || nomgen.equals("Clásica") || nomgen.equals("Balada") || nomgen.equals("Disco") || nomgen.equals("Rock Clásico") || nomgen.equals("Electropop")){%>
            <img src="/EspotifyWeb/Imagenes/<%=nomgen%>.jpg" alt="foto del genero" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
            <%}else{%>
            <img src="/EspotifyWeb/Imagenes/iconoGenero.jpg" alt="foto del genero" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
            <%}%>
            <h4 class="img-text" onmouseover="artSeleccionado(this, true)" onmouseout="artSeleccionado(this, false)"><%=gen.getNombre() %></h4>
        </a>  
    </div>
    <%}%>
</div>
