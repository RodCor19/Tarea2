<%-- 
    Document   : Favoritos
    Created on : 22/09/2017, 11:30:30 AM
    Author     : Kevin
--%>

<%@page import="webservices.WSClientes"%>
<%@page import="webservices.DtArtista"%>
<%@page import="webservices.DtCliente"%>
<%@page import="webservices.DtListaPD"%>
<%@page import="webservices.DtListaP"%>
<%@page import="webservices.DtLista"%>
<%@page import="webservices.DtTema"%>
<%@page import="webservices.DtAlbum"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%if(session.getAttribute("Usuario") == null || session.getAttribute("Usuario") instanceof DtArtista ){ %>
    <script>alert("No es un cliente, no puede acceder a esta página");</script>
    <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}else{
    DtCliente cliente = (DtCliente) session.getAttribute("PerfilCli");
    WSClientes wscli = (WSClientes) session.getAttribute("WSClientes");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Favoritos</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2">

                </div>
                <div class="col-sm-8 text-center">
                    <div class="row">
                        <h3 class="titulo lineaAbajo"><b>Mis Favoritos</b></h3>
                        <ul class="nav nav-tabs" style="padding-top: 0px;">
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Álbumes</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu1"><h4><b>Temas</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu2"><h4><b>Listas</b></h4></a></li>
                        </ul>

                        <div class="tab-content text-left">
                            <div id="home" class="tab-pane fade in active">
                                <% if(cliente.getFavAlbumes().isEmpty()){ %>
                                <h4 class="lineaAbajo"><i>No tiene álbumes favoritos</i></h4>
                                <%}else{%>
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
                                            <td><h4><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= album.getNombre() + "&artista=" + album.getNombreArtista()%>"><%= album.getNombre()%></a></h4></td>
                                            <td><h4><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= album.getNombreArtista()%>"><%= album.getNombreArtista()%></h4></a></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                            </div>
                            <div id="menu1" class="tab-pane fade">
                                <% if(cliente.getFavTemas().isEmpty()){ %>
                                <h4 class="lineaAbajo"><i>No tiene temas favoritos</i></h4>
                                <%}else{%>
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
                                            <td><h4><%= tema.getNombre()%></h4></td>
                                            <td><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= tema.getNomalbum()+ "&artista=" + tema.getNomartista() %>"><h4><%= tema.getNomalbum() %></h4></a></td>
                                            <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= tema.getNomartista()%>"><h4><%= tema.getNomartista()%></h4></a></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <% if(cliente.getFavListas().isEmpty()){ %>
                                <h4 class="lineaAbajo"><i>No tiene listas favoritas</i></h4>
                                <%}else{%>
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th onclick="ordenarTabla(0, this)" class="tituloFila"><h4><b>Lista</b></h4></th>
                                            <th onclick="ordenarTabla(1, this)" class="tituloFila"><h4><b>Creador/Género</b></h4></th>
                                            <th id="FechaC" onclick="ordenarTabla(2, this)" class="tituloFila"><h4><b>Fecha de Creacion</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (DtLista lista : cliente.getFavListas()) {
                                        String nombre = lista.getNombre();
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
                                        <tr>
                                            <% if (lista instanceof DtListaP) {
                                                DtListaP listaP = (DtListaP) lista;
                                                DtCliente cli= wscli.verPerfilCliente(listaP.getUsuario());
                                            %>
                                                
                                            <td><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre %>&Usuario=<%= listaP.getUsuario()%>"><h4><%= listaP.getNombre()%></h4></a></td>
                                            <td><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?verPerfilCli=<%= listaP.getUsuario()%>"><h4><%= cli.getNombre()+" "+cli.getApellido() %></h4></a></td>
                                            <td class="fechalista"><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre %>&Usuario=<%= listaP.getNombre() %>"><h4><%= listaP.getFechacreacion() %></h4></a></td>
                                            
                                            <%} else {
                                                DtListaPD listaPD = (DtListaPD) lista;%>
                                            <td><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre %>"><h4><%= listaPD.getNombre()%></h4></a></td>
                                            <% String generoCodificado = URLEncoder.encode(listaPD.getGenero(), "UTF-8"); %>
                                            <td><a class="link textoAcomparar" href="ServletArtistas?consultarAlbum=<%= generoCodificado %>"><h4><%= listaPD.getGenero() %></h4></a></td>
                                            <td class="fechalista"><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre %>"><h4><%= listaPD.getFechacreacion() %></h4></a></td>
                                            <%}%>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                            </div>
                        </div>
                        <br>
                    </div>                        
                </div>
                <div class="btn-group-vertical col-sm-2">

                </div>
            </div>
        </div>
        
        <script src="/EspotifyWeb/Javascript/fecha.js"></script>                    
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script src="/EspotifyWeb/Javascript/ordenarTabEnviarPorAjax.js"></script>
    </body>
</html>
<%}%>
