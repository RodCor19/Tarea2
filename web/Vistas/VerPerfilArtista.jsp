<%-- 
    Document   : VerPerfilArtista
    Created on : 14/09/2017, 08:02:51 PM
    Author     : Kevin
--%>

<%@page import="webservices.DataUsuarios"%>
<%@page import="webservices.DtAlbum"%>
<%@page import="java.util.List"%>
<%@page import="webservices.WSArtistas"%>
<%@page import="webservices.WSArtistasService"%>
<%@page import="webservices.WSClientes"%>
<%@page import="webservices.WSClientesService"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="webservices.DtCliente"%>
<%@page import="webservices.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%  DtArtista artista = (DtArtista) session.getAttribute("PerfilArt"); %>   
    <%
//        WSArtistas wsart = (WSArtistas) session.getAttribute("WSArtistas");
        if (artista != null) {
            try {
                WSClientes wscli = (WSClientes) session.getAttribute("WSClientes");

                List<DtCliente> seguidores = (List<DtCliente>) session.getAttribute("SeguidoresArt");

//        List<DtUsuario> seguidores = wsart.listarSeguidores(artista.getNickname()).getUsuarios();
//        DataUsuarios seguidores = wsart.listarSeguidores(artista.getNickname());
                DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
                DtCliente dt = null;
                boolean controlSeguir = false;
                if (perfilUsr != null && perfilUsr instanceof DtCliente) {
                    if (wscli.suscripcionVigente(perfilUsr.getNickname())) {
                        controlSeguir = true;
                        dt = wscli.verPerfilCliente(perfilUsr.getNickname());
                        session.setAttribute("Usuario", dt);
                    }
                }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Artista</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
    </head>
    <body>
        <%  if (session.getAttribute("Mensaje") != null) {%>
            <jsp:include page="mensajeModal.jsp" /> <%-- mostrar el mensaje --%>
        <%}%>
        
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

        <div class="container">
            <div class="row">
                <div class="col-xs-12 text-center">
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
                        <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= artista.getNickname()%>"> 
                                            <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de seguir</b>
                                        </a>
                        <%} else {%>
                        <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%= artista.getNickname()%>">
                                            <span class="glyphicon glyphicon-ok pull-left" style="margin-right: 5px"></span><b>Seguir</b>
                                        </a>
                        <%}
                            }
                            if (perfilUsr!=null && artista.getNickname().equals(perfilUsr.getNickname())) {%>
                        <button id="btn" class="text-primary btn btn-danger" >
                            <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span>
                            <b> Darse de baja</b></button>
                        <%}%>
                        <br><br>
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
                                <a  href="/EspotifyWeb/Vistas/AltaAlbum.jsp"  class="btn boton" style="font-size: 15px; margin-top: 10px;" role="button" >Crear Album</a>
                                <%}
                                    }%>
                                <%if (artista.getAlbumes().isEmpty()) {%>
                                <h4 class="lineaAbajo"><i>No tiene álbumes</i></h4>
                                <%} else { %>
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Nombre</b></h4></th>
                                            <th><h4><b>Año</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtAlbum album : artista.getAlbumes()) {
                                                String albumCod = java.net.URLEncoder.encode(album.getNombre(), "UTF-8");%>
                                        <tr>
                                            <td><h4><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= albumCod + "&artista=" + album.getNombreArtista()%>"><%= album.getNombre()%></a></h4></td>
                                            <td><h4><%= album.getAnio()%></h4></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                                <br>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <% if (seguidores.isEmpty()) { %>
                                <h4 class="lineaAbajo"><i>No tiene seguidores</i></h4>
                                <%} else {%>
                                <% for (DtCliente seguidor : seguidores) {%>
                                <h4 class="lineaAbajo row" style="margin-left:0px; margin-right:0px;">
                                    <div class="col-sm-8 text-left">
                                        <a class="link" href="ServletClientes?verPerfilCli=<%= seguidor.getNickname()%>"><%= seguidor.getNombre() + " " + seguidor.getApellido()%></a>
                                    </div>
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
                                        <div class="col-sm-4 text-right">
                                            <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= seguidor.getNickname()%>">
                                                <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de Seguir</b>
                                            </a>
                                        </div>
                                        <%} else {%>
                                        <div class="col-sm-4 text-right">
                                            <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%=seguidor.getNickname()%>">
                                                <span class="glyphicon glyphicon-ok pull-left" style="margin-right: 5px"></span><b>Seguir</b>
                                            </a>
                                        </div>
                                        <%}
                                            }%>
                                    </h4>
                                    <%}%>
                                    <%}%>
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
            <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>                  
            <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
            <script src="/EspotifyWeb/Javascript/ordenarTabEnviarPorAjax.js"></script>
            <script>
                            $(document).ready(function(){
                                $('#btn').click(function() {
                                var confirmar = confirm("¿Está seguro de darse de baja?");
                                console.log(confirmar)
                                if (confirmar){
                                    location.replace("/EspotifyWeb/ServletArtistas?desactivar=true")
                                }
                            });});
            </script>
    </body>
</html><%
        } catch (Exception ex) {
            response.sendRedirect("/EspotifyWeb/Vistas/Error.html");
        }
    } else {
        response.sendRedirect("/EspotifyWeb/ServletArtistas?Inicio=true");
    }
%>
