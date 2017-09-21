<%-- 
    Document   : listarTema
    Created on : 15-sep-2017, 19:09:52
    Author     : usuario
--%>

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
    <% 
    DtAlbum album = (DtAlbum) session.getAttribute("Album");
    DtArtista artista = Fabrica.getArtista().ElegirArtista(album.getNombreArtista());
    HttpSession sesion = request.getSession();
    DtUsuario usuario = (DtUsuario) sesion.getAttribute("Usuario");

    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
         <title>Espotify:Temas </title>
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
                            <img src="/EspotifyWeb/Imagenes/iconoMusica.jpg" alt="foto del genero" class="img-responsive imgAlbum" title="Generos"><!--Cambiar por imagen del usuario-->
                        </div>
                        <div class="col-sm-8 text-left">
                            <br> <br>
                            <h3 class="tituloAlbum"><%= album.getNombre() %></h3> 
                            <a href="ServletArtistas?verPerfilArt=<%= album.getNombreArtista() %>">  <h3 class="tituloArtista"><%= artista.getNombre()+ " " + artista.getApellido() %></h3></a>                            
                            <%if(usuario != null && usuario instanceof DtCliente){%>
                            <a id="Guardar" href="http://www.google.com">Guardar</a>
                            <%}%>
                            <%if(usuario != null && usuario instanceof DtCliente){%>
                            <a id="Descargar" href="http://www.google.com">Descargar</a>
                            <%}%>
                            <br> <br>
                            <table class="table text-left">
                            <thead>
                                <tr>
                                    <th>Orden</th>
                                    <th>Nombre</th>
                                    <th>Duración</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%for(DtTema tem: album.getTemas()){ 
                                int orden = tem.getOrden();
                                String nombre = tem.getNombre();
                                String durac = tem.getDuracion();
                                %>
                                <tr>
                                    <%if(usuario != null && usuario instanceof DtCliente){%>
                                    <td><%= orden %>     <a href="ServletClientes?Artista=<%=album.getNombreArtista() +"&album="+album.getNombre()+"&tema="+ nombre %>">+</a></td>
                                    <%}else{%>
                                    <td><%= orden %> </td>
                                    <%}%>
                                    <td><%= nombre %></td>
                                    <td><%= durac %> </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                          
                        </div>
                        <div class="col-sm-0 text-left"> 
                        </div>
                    </div>
                </div>
                 <div class="btn-group-vertical col-sm-2">
                <h3> Géneros: </h3> 
                <%for (String genero: album.getGeneros()) {%>
                <h4 class="list-group-item"><a href="/EspotifyWeb/ServletArtistas?consultarAlbum=<%= genero%>"><%= genero %></a></h4>
                <%}%>
                </div>
            </div> 
        </div>
                    
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
    </body>
</html>
