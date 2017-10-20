<%-- 
    Document   : ConsultadeListadeReproducción
    Created on : 02/10/2017, 01:25:29 AM
    Author     : ninoh
--%>
<%@page import="webservices.WSArtistas"%>
<%@page import="webservices.WSArtistasService"%>
<%@page import="webservices.DtTema"%>
<%@page import="webservices.WSClientes"%>
<%@page import="webservices.WSClientesService"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="webservices.DtArtista"%>
<%@page import="webservices.DtCliente"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="webservices.DtLista"%>
<%@page import="webservices.DtListaP"%>
<%@page import="webservices.DtListaPD"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        DtLista dt = (DtLista) session.getAttribute("Lista");
        session.removeAttribute("temasAReproducir");
        
        WSClientes wscli = (WSClientes) session.getAttribute("WSClientes");
        WSArtistas wsart = (WSArtistas) session.getAttribute("WSArtistas");
    %>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <title>Espotify: Lista de Reproduccion</title>
        <%if (dt == null) {
        %>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}
            DtUsuario aux2 = (DtUsuario) session.getAttribute("Usuario");
            boolean cliente = false;
            DtCliente dtcontrol = null;
            if (dt instanceof DtListaP) {
                DtListaP aux = (DtListaP) dt;
        if (aux.isPrivada() && ((aux2==null) || (aux2 != null && aux2 instanceof DtArtista))) {%>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%} else {
            if (aux2 instanceof DtCliente) {
                DtCliente dtc = (DtCliente) aux2;
                if (!dtc.getNickname().equals(aux.getUsuario()) && aux.isPrivada()) {
        %>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}
                        if (aux2 != null && wscli.suscripcionVigente(aux2.getNickname())) {
                            cliente = true;
                            dtcontrol=wscli.verPerfilCliente(aux2.getNickname());
                        }
                    }
                }
            }%>
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" />
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical">

                </div>
                <div class="col-sm-10 text-center">
                    <div class="row">
                        <%if ( dt.getRutaImagen() != null) {%>
                        <img src="/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=<%= dt.getRutaImagen()%>" alt="Foto de la Lista" class="img-responsive imgAlbum" title="Listas"><!--Cambiar por imagen del usuario-->
                        <%} else {%>
                        <img src="/EspotifyWeb/Imagenes/IconoLista.png" alt="Foto de la Lista" class="img-responsive imgAlbum" title="Listas"><!--Cambiar por imagen del usuario-->
                        <%}
                            if (dt instanceof DtListaPD) {%>
                        <h3 class="tituloLista text-primary"><b><%= dt.getNombre()%></b></h3>
                        <h4 class="text-center">Lista Por Defecto</h4>
                        <%} else {%>
                        <h3 class="tituloLista text-primary"><b><%= dt.getNombre()%></b></h3>
                        <h4 class="text-center">Lista Particular</h4>
                        <%}%>
                        <br>
                        <div class="tab-pane">
                            <% if (dt instanceof DtListaPD) {
                                    DtListaPD dtpd = (DtListaPD) dt;
                                    String gen = dtpd.getGenero();
                                    if (gen.contains("&")) {
                                        gen = java.net.URLEncoder.encode(gen, "UTF-8");
                                    }
                            %>
                            <h4 class="lineaAbajo"><b>Género:</b> <a href="/EspotifyWeb/ServletArtistas?consultarAlbum=<%= gen %>"><%= dtpd.getGenero()%></a></h4>
                                <%} else {
                                    DtListaP dtp = (DtListaP) dt;
                                    String tipo = "Privada";
                                %>
                            <h4 class="lineaAbajo"><b>Cliente:</b> <a href="/EspotifyWeb/ServletClientes?verPerfilCli=<%= dtp.getUsuario()%>"><%= dtp.getUsuario()%></a></h4>
                            <%if (!dtp.isPrivada()) {
                                    tipo = "Pública";
                            %>
                            <h4 class="lineaAbajo"><b>Tipo: </b><%= tipo%></h4>
                            <%}else{%>
                            <h4 class="lineaAbajo"><b>Tipo: </b><%= tipo%> <button style="font-size: 15px; margin-left: 5px;" id="btnPublicar" class="btn boton" onclick="publicarLista('<%= dtp.getNombre()%>')">Publicar</button></h4>
                            <%}}%>
                        </div>
                        <br>
                        <div class="tab-pane">
                            <% if (dt.getTemas() == null || dt.getTemas().isEmpty()) { %>
                            <h4 class="lineaAbajo"><i>No tiene temas</i></h4>
                            <%} else {%>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th><h4><b>Tema</b></h4></th>
                                        <th><h4><b>Album</b></h4></th>
                                        <th><h4><b>Artista</b></h4></th>
                                        <th><h4><b>Duración</b></h4></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%for (DtTema tem : dt.getTemas()) {
                                            String nombre = tem.getNombre();
                                            String durac = tem.getDuracion();
                                            DtArtista a = wsart.elegirArtista(tem.getNomartista());
                                            boolean control2 = true;
                                            if (dtcontrol != null) {
                                                for (DtTema t : dtcontrol.getFavTemas()) {
                                                    if (t.getNombre().equals(nombre) && t.getNomartista().equals(tem.getNomartista()) && t.getNomalbum().equals(tem.getNomalbum())) {
                                                        control2 = false;
                                                    }
                                                }
                                            }
                                            if (dt instanceof DtListaP) {
                                                DtListaP aux = (DtListaP) dt;
                                    %>
                                    <tr class="filaTema" onclick="reproducirTemaLista('<%= tem.getNombre()%>','<%= aux.getNombre() %>','<%= aux.getUsuario() %>',null)">
                                    <%      }else{
                                            DtListaPD aux = (DtListaPD) dt;%>
                                    <tr class="filaTema" onclick="reproducirTemaLista('<%= tem.getNombre()%>','<%= aux.getNombre() %>',null,'<%= aux.getGenero()%>')">
                                    <%      }%>
                                        <%if (cliente && control2) {%>
                                        <td>
                                            <div class="row">
                                                <div class="span">
                                                    <a style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?Artista=<%=tem.getNomartista() + "&album=" + tem.getNomalbum() + "&tema=" + nombre%>">
                                                        <img onmouseover="hover(this, true)" onmouseout="hover(this, false)" src="/EspotifyWeb/Imagenes/guardar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                                    </a>
                                                    <div class="span" ><%= nombre%></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%} else {%>
                                        <td><%= nombre%></td>
                                        <%}%>
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= tem.getNomalbum() + "&artista=" + tem.getNomartista()%>"><%= tem.getNomalbum()%></a></td>
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= tem.getNomartista()%>"><%= a.getNombre() + " " + a.getApellido()%></td>
                                        <%if (cliente) {%>
                                        <%if (tem.getArchivo() != null) {%>
                                        <td><%= durac%> <a id="Descargar" href="/EspotifyWeb/ServletArchivos?tipo=audio&ruta=<%= tem.getArchivo()%>">Descargar</a></td>
                                        <%} else {%>
                                        <td><%= durac%> <a id="Link" href="http://<%= tem.getDireccion()%>">Escuchar online</a></td>
                                        <%}%>
                                        <%} else {%>
                                        <%if (tem.getDireccion() != null) {%>
                                        <td><%= durac%><br> <a id="Link" href="http://<%= tem.getDireccion()%>">Escuchar online</a></td>
                                            <%} else {%>
                                        <td><%= durac%></td>
                                        <%}%>
                                        <%}%>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </table>
                            <%}%>

                        </div>
                    </div>
                </div>
                <div class="btn-group-vertical col-sm-2">
                    <div id="divReproductor">
                    <% if(session.getAttribute("temasAReproducir") != null){ %>
                        <jsp:include page="reproductor.jsp" /> <%-- Importar codigo desde otro archivo .jsp --%>
                    <%}%>
                    </div>
                </div>
            </div> 
        </div>
                    
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script src="/EspotifyWeb/Javascript/ListaReproduccion.js"></script>        
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
        <script src="/EspotifyWeb/Javascript/reproductor.js"></script>
    </body>
</html>
