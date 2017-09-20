<%-- 
    Document   : VerPerfilCliente
    Created on : 16/09/2017, 10:01:19 PM
    Author     : Kevin
--%>

<%@page import="Logica.DtListaPD"%>
<%@page import="Logica.DtLista"%>
<%@page import="Logica.DtTema"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="Logica.DtUsuario"%>
<%@page import="Logica.DtListaP"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.Fabrica"%>
<%@page import="Logica.DtCliente"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%  DtCliente cliente = (DtCliente) session.getAttribute("PerfilCli"); %>   
    <% ArrayList<DtCliente> seguidores = Fabrica.getCliente().getSeguidores(cliente.getNickname());
        DtUsuario perfilUsr = (DtUsuario)session.getAttribute("Usuario");%>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Cliente</title>
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
                        <h3 class="tituloPerfil text-primary"><b><%= cliente.getNombre() + " " + cliente.getApellido()%></b></h3>
                        <%
                        if(session.getAttribute("Usuario")!=null && !((DtUsuario)session.getAttribute("Usuario")).getNickname().equals(cliente.getNickname())){
                        if(session.getAttribute("Usuario") instanceof DtCliente){
                            boolean control = false;
                            DtCliente dt = (DtCliente)session.getAttribute("Usuario");
                            for(int i=0; i<dt.getUsuariosSeguidos().size();i++){
                                if(dt.getUsuariosSeguidos().get(i).getNickname().equals(cliente.getNickname()))
                                    control = true;
                            }
                            if(control){
                        %>
                        <a class="text-primary btn btn-danger" href="ServletClientes?dejarSeguir=<%= cliente.getNickname() %>">Dejar de seguir</a>
                        <%}else{%>
                        <a class="text-primary btn btn-success" href="ServletClientes?seguir=<%= cliente.getNickname() %>">Seguir</a>
                        <%}}}%>

                        <ul class="nav nav-tabs">
                            <!-- Si inicio sesión -->
                            <%if(perfilUsr!=null){%>
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Información</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu1"><h4><b>Listas</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu2"><h4><b>Seguidores(<%= seguidores.size()%>)</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu3"><h4><b>Siguiendo</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu4"><h4><b>Favoritos</b></h4></a></li>
                            <%}else{%>
                               <li class="active"><a data-toggle="tab" href="#home"><h4><b>Listas</b></h4></a></li> 
                            <%}%>
                        </ul>

                        <div class="tab-content text-left">
                            <!-- Si inicio sesión -->
                            <%if(perfilUsr!=null){%>
                            <div id="home" class="tab-pane fade in active">
                                <h4 class="list-group-item"><b>Nickname:</b> <%= cliente.getNickname()%></h4>
                                <h4 class="list-group-item"><b>Nombre:</b> <%= cliente.getNombre()%></h4>
                                <h4 class="list-group-item"><b>Apellido:</b> <%= cliente.getApellido()%></h4>                        
                                <h4 class="list-group-item"><b>Fecha de Nacimiento:</b> <%= cliente.getFechaNac()%></h4>
                                <h4 class="list-group-item"><b>Correo:</b> <%= cliente.getCorreo()%></h4>
                                <br>
                            </div>
                            <div id="menu1" class="tab-pane fade">
                                <% if (cliente.getListas().isEmpty()) { %>
                                <h4 class="list-group-item">No tiene listas creadas</h4>
                                <%} else {%>
                                <br>    
                                <table class="table table-striped text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Nombre</b></h4></th>
                                            <th><h4><b>Tipo</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtListaP lista : cliente.getListas()) {
                                                String tipo;
                                                if (lista.isPrivada()) {
                                                    tipo = "Privada";
                                                } else {
                                                    tipo = "Pública";
                                                }
                                        %>
                                        <tr>
                                            <td><h4><a href="#"><%= lista.getNombre()%></h4></a></td>
                                            <td><h4><%= tipo%></h4></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <% if (seguidores.isEmpty()) { %>
                                <h4 class="list-group-item">No tiene seguidores</h4>
                                <%} else {%>
                                <%  for (DtCliente seguidor : seguidores) {%>
                                <h4 class="list-group-item"><a href="ServletClientes?verPerfilCli=<%= seguidor.getNickname()%>"><%= seguidor.getNombre() + " " + seguidor.getApellido()%></a></h4>
                                    <%  }
                                        }%>
                                <br>
                            </div>
                            <div id="menu3" class="tab-pane fade">
                                <% if (cliente.getUsuariosSeguidos().isEmpty()) { %>
                                <h4 class="list-group-item">No está siguiendo a ningún usuario</h4>
                                <%} else {%>
                                <br>    
                                <table class="table table-striped text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Usuario</b></h4></th>
                                            <th><h4><b>Tipo</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (DtUsuario seguido : cliente.getUsuariosSeguidos()) {
                                                String tipo;
                                                String servlet;
                                                if (seguido instanceof DtCliente) {
                                                    tipo = "Cliente";
                                                    servlet = "ServletClientes?verPerfilCli=";
                                                } else {
                                                    tipo = "Artista";
                                                    servlet = "ServletArtistas?verPerfilArt=";
                                                }
                                        %>
                                        <tr>
                                            <td><h4><a href="<%= servlet + seguido.getNickname()%>"><%= seguido.getNombre() + " " + seguido.getApellido()%></h4></a></td>
                                            <td><h4><%= tipo%></h4></td> 
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>                                    
                            </div>
                            <div id="menu4" class="tab-pane fade">
                                <ul class="nav nav-tabs" style="padding-top: 0px;">
                                    <li class="active"><a data-toggle="tab" href="#home2"><h4><b>Álbumes</b></h4></a></li>
                                    <li><a data-toggle="tab" href="#menu5"><h4><b>Temas</b></h4></a></li>
                                    <li><a data-toggle="tab" href="#menu6"><h4><b>Listas</b></h4></a></li>
                                </ul>

                                <div class="tab-content text-left">
                                    <div id="home2" class="tab-pane fade in active">
                                        <table class="table table-striped text-left">
                                            <thead>
                                                <tr>
                                                    <th><h4><b>Álbum</b></h4></th>
                                                    <th><h4><b>Artista</b></h4></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%for(DtAlbum album: cliente.getFavAlbumes()){ %>
                                                <tr>
                                                    <td><h4><%= album.getNombre() %></h4></td>
                                                    <td><h4><a href="ServletArtistas?verPerfilArt=<%= album.getNombreArtista() %>"><%= album.getNombreArtista() %></h4></a></td>
                                                </tr>
                                                <%}%>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div id="menu5" class="tab-pane fade">
                                        <table class="table table-striped text-left">
                                            <thead>
                                                <tr>
                                                    <th><h4><b>Tema</b></h4></th>
                                                    <th><h4><b>Álbum</b></h4></th>
                                                    <th><h4><b>Artista</b></h4></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%for(DtTema tema: cliente.getFavTemas()){ %>
                                                <tr>
                                                    <td><a href="#"><h4><%= tema.getNombre() %></h4></a></td>
                                                    <td><a href="#"><h4><%= tema.getAlbum() %></h4></a></td>
                                                    <td><a href="ServletArtistas?verPerfilArt=<%= tema.getArtista() %>"><h4><%= tema.getArtista() %></h4></a></td>
                                                </tr>
                                                <%}%>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div id="menu6" class="tab-pane fade">
                                        <table class="table table-striped text-left">
                                            <thead>
                                                <tr>
                                                    <th><h4><b>Lista</b></h4></th>
                                                    <th><h4><b>Creador/Género</b></h4></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for(DtLista lista: cliente.getFavListas()){ %>
                                                <tr>
                                                    <% if(lista instanceof DtListaP){
                                                        DtListaP listaP = (DtListaP)lista; %>
                                                    <td><a href="#"><h4><%= listaP.getNombre() %></h4></a></td>
                                                    <td><a href="ServletClientes?verPerfilCli=<%= listaP.getUsuario() %>"><h4><%= listaP.getUsuario() %></h4></a></td>
                                                    <%}else{
                                                        DtListaPD listaPD = (DtListaPD)lista; %>
                                                    <td><a href="#"><h4><%= listaPD.getNombre() %></h4></a></td>
                                                    <td><a href="ServletClientes?verPerfilCli=<%= listaPD.getGenero() %>"><h4><%= listaPD.getGenero() %></h4></a></td>
                                                    <%}%>
                                                </tr>
                                                <%}%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <br>
                            </div>
                            <%}else{%>
                            <div id="home" class="tab-pane fade in active">
                                <%  int cantListPub = 0;
                                    for (DtListaP lista : cliente.getListas()) {
                                    if (lista.isPrivada() == false) {
                                        cantListPub++;
                                %>    
                                    <h4 class="list-group-item"><a href="#"><%= lista.getNombre()%></a></h4>
                                <%}
                                }
                                if(cantListPub == 0){%>
                                    <h4 class="list-group-item">No tiene listas públicas</h4> 
                                <%}}%>
                            </div>
                    </div>
                </div>
                <div class="col-sm-2">

                </div>
            </div>
        </div>

        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>                  
        <script src="/EspotifyWeb/Javascript/clientesGeneros.js"></script>
    </body>
</html>
