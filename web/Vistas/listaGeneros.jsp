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
            String nombre = gen.getNombre();
            nombre = nombre.replace("á", "&aacute;");
            nombre = nombre.replace("é", "&eacute;");
            nombre = nombre.replace("í", "&iacute;");
            nombre = nombre.replace("ó", "&oacute;");
            nombre = nombre.replace("ú", "&uacute;");
            nombre = nombre.replace("Á", "&Aacute;");
            nombre = nombre.replace("É", "&Eacute;");
            nombre = nombre.replace("Í", "&Iacute;");
            nombre = nombre.replace("Ó", "&Oacute;");
            nombre = nombre.replace("Ú", "&Uacute;");
            nombre = nombre.replace("ñ", "&ntilde;");
            nombre = nombre.replace("Ñ", "&Ntilde;");
    %>
    <div class="col-md-4" style="padding: 2px;">
        <a href="ServletGeneral?consultarAlbum=<%= nombre%>">
            <img src="/EspotifyWeb/Imagenes/iconoGenero.jpg" alt="foto del genero" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
            <h4 class="img-text"><%=nombre%></h4>
        </a>  
    </div>
    <%}%>
</div>
