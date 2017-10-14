<%-- 
    Document   : listarTema
    Created on : 15-sep-2017, 19:09:52
    Author     : usuario
--%>

<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Collections"%>
<%@page import="Logica.DtSuscripcion"%>
<%@page import="Logica.DtCliente"%>
<%@page import="Logica.DtUsuario"%>
<%@page import="Logica.DtGenero"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="Logica.DtArtista"%>
<%@page import="Logica.Fabrica"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.DtTema"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%  DtAlbum album = (DtAlbum) session.getAttribute("Album");
        DtArtista artista = Fabrica.getArtista().ElegirArtista(album.getNombreArtista());
        HttpSession sesion = request.getSession();
        DtUsuario usuario = (DtUsuario) sesion.getAttribute("Usuario");
        DtCliente cli = (DtCliente) sesion.getAttribute("Cli"), dt = null;

        Boolean cliente = false;
        if (usuario != null && usuario instanceof DtCliente) {
            if (Fabrica.getCliente().SuscripcionVigente(usuario.getNickname())) {
                cliente = true;
                dt = Fabrica.getCliente().verPerfilCliente(usuario.getNickname());
            }
        }

        boolean control2 = true;
        if (dt != null) {
            for (DtAlbum a : dt.getFavAlbumes()) {
                if (a.getNombre().equals(album.getNombre()) && a.getNombreArtista().equals(album.getNombreArtista())) {
                    control2 = false;
                }
            }
        }

    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
         <title>Espotify: Ver Álbum </title>
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-0">

                </div>
                <div class="col-sm-10 text-center">

                    <div class="row">
                        <div class="col-sm-4 text-left">
                            <%if (album.getRutaImagen() != null) {%>
                            <img src="/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=<%= album.getRutaImagen()%>" alt="foto del álbum" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
                            <%} else {%>
                            <img src="/EspotifyWeb/Imagenes/iconoMusica.jpg" alt="foto del álbum" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
                            <%}%>
                            <h3> Géneros: </h3> 
                            <%for (String genero : album.getGeneros()) {
                                    String generoCodificado = URLEncoder.encode(genero, "UTF-8");
                            %>
                            <h4 class="lineaAbajo"><a class="link" href="/EspotifyWeb/ServletArtistas?consultarAlbum=<%= generoCodificado%>"><%= genero%></a></h4>
                                <%}%>
                        </div>
                        <div class="col-sm-8 text-left">
                            <br> <br>
                            <h3 class="tituloAlbum"><%= album.getNombre()%></h3>
                            <a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= album.getNombreArtista()%>">  <h3><%= artista.getNombre() + " " + artista.getApellido()%></h3></a>                            
                            <h3 class="anio"><%= album.getAnio()%></h3>
                            <a onclick="reproducirAlbum('<%= album.getNombre().replace("\'", "\\'")%>', '<%= album.getNombreArtista()%>')" href="#" class="btn boton" style="font-size: 15px;">Reproducir</a>
                            <%if (cliente && control2) {%>
                            <a href="/EspotifyWeb/ServletClientes?art=<%=album.getNombreArtista() + "&alb=" + album.getNombre()%>" class="btn boton" style="font-size: 15px; margin-left: 5px;">Guardar</a>
                            <%}%>
                            <br> <br>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th>Orden</th>
                                        <th>Nombre</th>
                                        <th>Duración</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% ArrayList<DtTema> arr = album.getTemas();
                                        Collections.reverse(arr);
                                        for (DtTema tem : arr) {
                                            int orden = tem.getOrden();
                                            String nombre = tem.getNombre();
                                            String durac = tem.getDuracion();
                                            control2 = true;
                                            if (dt != null) {
                                                for (DtTema t : dt.getFavTemas()) {
                                                    if (t.getNombre().equals(nombre) && t.getArtista().equals(tem.getArtista()) && t.getAlbum().equals(tem.getAlbum())) {
                                                        control2 = false;
                                                    }
                                                }
                                            }
                                    %>
                                    <tr class="filaTema">
                                        <%if (usuario != null && usuario instanceof DtCliente && cliente && control2) {%>
                                        <td>
                                            <div>
                                                <div class="span">
                                                    <a style="float:left; margin-right: 5px" href="ServletClientes?Artista=<%=album.getNombreArtista() + "&album=" + album.getNombre() + "&tema=" + nombre%>">
                                                        <img onmouseover="hover(this, true)" onmouseout="hover(this, false)" src="/EspotifyWeb/Imagenes/guardar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                                    </a>
                                                    <div class="span" ><%= orden%></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%} else {%>
                                        <td>
                                            <div>
                                                <div class="span">
                                                    <!--<a style="float:left; margin-right: 5px; opacity: 0" href="#">-->
                                                        <img style="float:left; margin-right: 5px; opacity: 0" src="/EspotifyWeb/Imagenes/eliminar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                                    <!--</a>-->
                                                    <div class="span" ><%= orden%></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%}%>
                                        <td onclick="reproducirTema('<%= tem.getNombre().replace("\'", "\\'") %>', '<%= tem.getAlbum().replace("\'", "\\'")%>', '<%= tem.getArtista()%>')"><%= nombre%></td>
                                        <%if (cliente) {%>
                                        <td><%= durac%></td>
                                        <%if (tem.getArchivo() != null) {%>
                                        <td><a id="Descargar" href="/EspotifyWeb/ServletArchivos?tipo=audio&ruta=<%= tem.getArchivo()%>" class="glyphicon glyphicon-download"></a></td>
                                        <%} else {%>
                                        <td><a id="Link" href="http://<%= tem.getDireccion()%>" class="glyphicon glyphicon-new-window"></a></td>
                                        <%}%>
                                        <%} else {%>
                                        <td><%= durac%></td>
                                        <%if (tem.getDireccion() != null) {%>
                                        <td><a id="Link" href="http://<%= tem.getDireccion()%>" class="glyphicon glyphicon-new-window"></a></td>
                                        <%} else {%>
                                        <td></td>
                                        <%}%>
                                        <%}%>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </table>

                        </div>
                        <div class="col-sm-0 text-left"> 
                        </div>
                    </div>
                </div>
                <div class="btn-group-vertical col-sm-2" style="padding-right: 0px;">
                    <div id="divReproductor">
                        <% if (session.getAttribute("temasAReproducir") != null) { %>
                        <jsp:include page="reproductor.jsp" /> <%-- Importar codigo desde otro archivo .jsp --%>
                        <%}%>
                    </div>
                </div>
            </div> 
        </div>

        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/reproductor.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script>
//            function hover(elemento, esHover){
//                if(esHover){
//                    elemento.setAttribute('src', '/EspotifyWeb/Imagenes/eliminar.png'); 
//                }else{
//                    elemento.setAttribute('src', '/EspotifyWeb/Imagenes/guardado.png');
//                }
//            };
        </script>
    </body>
</html>
