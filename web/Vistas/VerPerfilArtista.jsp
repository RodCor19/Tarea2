<%-- 
    Document   : VerPerfilArtista
    Created on : 14/09/2017, 08:02:51 PM
    Author     : Kevin
--%>

<%@page import="Logica.DtCliente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.Fabrica"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="Logica.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%  DtArtista artista = (DtArtista) session.getAttribute("Perfil"); %>       
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
                        <img src="/EspotifyWeb/Imagenes/iconoArtista.png" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista"><!--Cambiar por imagen del usuario-->
                        <h3 class="tituloPerfil"><%= artista.getNombre()+" "+artista.getApellido() %></h3>
                        <div class="row text-left list-group">
                            <h4 class="list-group-item"><b>Nickname:</b> <%= artista.getNickname() %></h4>
                            <h4 class="list-group-item"><b>Nombre:</b> <%= artista.getNombre() %></h4>
                            <h4 class="list-group-item"><b>Apellido:</b> <%= artista.getApellido() %></h4>                        
                            <h4 class="list-group-item"><b>Fecha de Nacimiento:</b> <%= artista.getFechaNac() %></h4>
                            <h4 class="list-group-item"><b>Correo:</b> <%= artista.getCorreo() %></h4>
                            
                            <%String biografia = artista.getBiografia(); 
                            if(biografia == null){ 
                                biografia = "";
                            }%>
                            <h4 class="list-group-item"><b>Biografia:</b> <%= biografia %></h4>
                            
                            <%String pagina = artista.getPagWeb(); 
                            if(pagina == null){ 
                                pagina = "";
                            }%>
                            <h4 class="list-group-item"><b>Página:</b> <a href="http://<%= pagina %>"><%= pagina %></a></h4>
                            
                            <h4 class="list-group-item tituloLista"><b>Álbumes: </b></h4>
                            <div class="list-group">   
                                <%for(DtAlbum album: artista.getAlbumes()){ %>
                                    <li class="list-group-item">
                                        <h4><a href="#"><%= album.getNombre() %></a></h4>
                                    </li>
                                <%}%>
                            </div>
                            
                            <% ArrayList<DtCliente> seguidores =  Fabrica.getArtista().listarSeguidores(artista.getNickname()); %>
                            <h4 class="list-group-item tituloLista"><b>Seguidores (<%= seguidores.size() %>): </b></h4>
                            <div class="list-group">   
                                <% for(DtCliente seguidor: seguidores){ %>
                                    <li class="list-group-item">
                                        <h4><a id="<%= seguidor.getNickname()  %>" href="#"><%= seguidor.getNombre()+" "+seguidor.getApellido() %></a></h4>
                                    </li>
                                <%}%>
                            </div> 
                        </div>
                    </div>
                </div>
                <div class="col-sm-2">
                    
                </div>
            </div>
        </div>
                
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
    </body>
</html>
