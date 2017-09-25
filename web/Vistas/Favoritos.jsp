<%-- 
    Document   : Favoritos
    Created on : 22/09/2017, 11:30:30 AM
    Author     : Kevin
--%>

<%@page import="Logica.Fabrica"%>
<%@page import="Logica.DtListaPD"%>
<%@page import="Logica.DtListaP"%>
<%@page import="Logica.DtLista"%>
<%@page import="Logica.DtTema"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="Logica.DtCliente"%>
<%@page import="Logica.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%if(session.getAttribute("Usuario") == null || session.getAttribute("Usuario") instanceof DtArtista ){ %>
    <script>alert("No es un cliente, no puede acceder a esta página");</script>
    <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}else{
    DtCliente cliente = (DtCliente) session.getAttribute("PerfilCli");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Favoritos</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2">

                </div>
                <div class="col-sm-8 text-center">
                    <div class="row">
                        <h3 class="lineaAbajo"><b>Favoritos de <%= cliente.getNombre()+" "+cliente.getApellido() %></b></h3>
                        <ul class="nav nav-tabs" style="padding-top: 0px;">
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Álbumes</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu1"><h4><b>Temas</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu2"><h4><b>Listas</b></h4></a></li>
                        </ul>

                        <div class="tab-content text-left">
                            <div id="home" class="tab-pane fade in active">
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Álbum</b></h4></th>
                                            <th><h4><b>Artista</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtAlbum album : cliente.getFavAlbumes()) {%>
                                        <tr>
                                            <td><h4><%= album.getNombre()%></h4></td>
                                            <td><h4><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= album.getNombreArtista()%>"><%= album.getNombreArtista()%></h4></a></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                            </div>
                            <div id="menu1" class="tab-pane fade">
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Tema</b></h4></th>
                                            <th><h4><b>Álbum</b></h4></th>
                                            <th><h4><b>Artista</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtTema tema : cliente.getFavTemas()) {%>
                                        <tr>
                                            <td><a class="link" href="#"><h4><%= tema.getNombre()%></h4></a></td>
                                            <td><a class="link" href="#"><h4><%= tema.getAlbum()%></h4></a></td>
                                            <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= tema.getArtista()%>"><h4><%= tema.getArtista()%></h4></a></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Lista</b></h4></th>
                                            <th><h4><b>Creador/Género</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (DtLista lista : cliente.getFavListas()) { %>
                                        <tr>
                                            <% if (lista instanceof DtListaP) {
                                                    DtListaP listaP = (DtListaP) lista;%>
                                            <td><a class="link" href="#"><h4><%= listaP.getNombre()%></h4></a></td>
                                            <td><a class="link" href="/EspotifyWeb/ServletClientes?verPerfilCli=<%= listaP.getUsuario()%>"><h4><%= listaP.getUsuario()%></h4></a></td>
                                                        <%} else {
                                                DtListaPD listaPD = (DtListaPD) lista;%>
                                            <td><a class="link" href="#"><h4><%= listaPD.getNombre()%></h4></a></td>
                                            <td><a class="link" href="/EspotifyWeb/ServletClientes?verPerfilCli=<%= listaPD.getGenero()%>"><h4><%= listaPD.getGenero()%></h4></a></td>
                                                        <%}%>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <br>
                    </div>                        
                </div>
                <div class="btn-group-vertical col-sm-2">

                </div>
            </div>
        </div>
        
        <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
                                    
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
    </body>
</html>
<%}%>
