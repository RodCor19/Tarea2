<%-- 
    Document   : VerPerfilArtista
    Created on : 14/09/2017, 08:02:51 PM
    Author     : Kevin
--%>

<%@page import="Logica.DtUsuario"%>
<%@page import="Logica.DtCliente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.Fabrica"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="Logica.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%  DtArtista artista = (DtArtista) session.getAttribute("PerfilArt"); %>   
    <% ArrayList<DtCliente> seguidores = Fabrica.getArtista().listarSeguidores(artista.getNickname());
        DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
        DtCliente dt = null;
        boolean controlSeguir = false;
        if (perfilUsr != null && perfilUsr instanceof DtCliente) {
            if (Fabrica.getCliente().SuscripcionVigente(perfilUsr.getNickname())) {
                controlSeguir = true;
                dt = Fabrica.getCliente().verPerfilCliente(perfilUsr.getNickname());
                session.setAttribute("Usuario", dt);
            }
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Artista</title>
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
                        <% if (artista.getRutaImagen() == null) { %>
                        <img src="/EspotifyWeb/Imagenes/iconoArtista.png" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista"><!--Cambiar por imagen del usuario-->
                        <%} else {%>
                        <img src="/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=<%= artista.getRutaImagen()%>" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista">
                        <%}%>
                        <h3 class="tituloPerfil text-primary"><b><%= artista.getNombre() + " " + artista.getApellido()%></b></h3>
                        <br>
                        <%
                            if (controlSeguir) {
                                boolean control = false;
                                for (int i = 0; i < dt.getUsuariosSeguidos().size(); i++) {
                                    if (dt.getUsuariosSeguidos().get(i).getNickname().equals(artista.getNickname())) {
                                        control = true;
                                    }
                                }
                                if (control) {
                        %>
                        <a class="text-primary btn btn-danger glyphicon glyphicon-remove" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= artista.getNickname()%>"></a>
                        <%} else {%>
                        <a class="text-primary btn btn-success glyphicon glyphicon-ok" href="/EspotifyWeb/ServletClientes?seguir=<%= artista.getNickname()%>"></a>
                        <%}
                            }%>
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Información</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu1"><h4><b>Álbumes</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu2"><h4><b>Seguidores(<%= seguidores.size()%>)</b></h4></a></li>
                        </ul>

                        <div class="tab-content text-left">
                            <div id="home" class="tab-pane fade in active">
                                <h4 class="lineaAbajo"><b>Nickname:</b> <%= artista.getNickname()%></h4>
                                <h4 class="lineaAbajo"><b>Nombre:</b> <%= artista.getNombre()%></h4>
                                <h4 class="lineaAbajo"><b>Apellido:</b> <%= artista.getApellido()%></h4>                        
                                <h4 class="lineaAbajo"><b>Fecha de Nacimiento:</b> <%= artista.getFechaNac()%></h4>
                                <h4 class="lineaAbajo"><b>Correo:</b> <%= artista.getCorreo()%></h4>

                                <%String biografia = artista.getBiografia();
                                    if (biografia == null) {
                                        biografia = "";
                                    }%>
                                <h4 class="lineaAbajo"><b>Biografia:</b> <%= biografia%></h4>

                                <%String pagina = artista.getPagWeb();
                                    if (pagina == null) {
                                        pagina = "";
                                    }%>
                                <h4 class="lineaAbajo"><b>Página web:</b> <a class="link" href="http://<%= pagina%>"><%= pagina%></a></h4>
                                <br>
                            </div>
                            <div id="menu1" class="tab-pane fade">
                                <% if (request.getSession().getAttribute("Usuario") != null) {
                                        DtUsuario dtu = (DtUsuario) request.getSession().getAttribute("Usuario");
                                        if (artista.getNickname().equals(dtu.getNickname())) {%>
                                <a  href="/EspotifyWeb/Vistas/AltaAlbum.jsp" class="btn btn-success btn-lg" role="button" >Crear Album</a>
                                <%}}%>
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Nombre</b></h4></th>
                                            <th><h4><b>Año</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                <%for (DtAlbum album : artista.getAlbumes()) {%>
                                        <tr>
                                            <td><h4><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= album.getNombre() + "&artista=" + album.getNombreArtista()%>"><%= album.getNombre()%></a></h4></td>
                                            <td><h4><%= album.getAnio() %></h4></td>
                                        </tr>
                                <%}%>
                                    </tbody>
                                </table>
                                <br>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <!--<h4 ><b>Cantidad: </b><%= seguidores.size()%></h4>-->
                                <% for (DtCliente seguidor : seguidores) {%>
                                <h4 class="lineaAbajo"><a class="link" href="ServletClientes?verPerfilCli=<%= seguidor.getNickname()%>"><%= seguidor.getNombre() + " " + seguidor.getApellido()%></a></h>
                                    <%
                                        if (controlSeguir && !perfilUsr.getNickname().equals(seguidor.getNickname())) {
                                            boolean control = false;
                                            for (int i = 0; i < dt.getUsuariosSeguidos().size(); i++) {
                                                if (dt.getUsuariosSeguidos().get(i).getNickname().equals(seguidor.getNickname())) {
                                                    control = true;
                                                }
                                            }
                                            if (control) {
                                    %>
                                    <a class="text-primary btn btn-danger glyphicon glyphicon-remove" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= seguidor.getNickname()%>"></a>
                                    <%} else {%>
                                    <a class="text-primary btn btn-success glyphicon glyphicon-ok" href="/EspotifyWeb/ServletClientes?seguir=<%=seguidor.getNickname()%>"></a>
                                    <%}
                            }%>
                                    <br>
                                    <%}%>
                                    </div>
                                    <div class="col-sm-2">

                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
        </div>

                <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

                <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
                <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>                  
                <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
                <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
                </body>
                </html>
