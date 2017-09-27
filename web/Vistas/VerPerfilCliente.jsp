<%-- 
    Document   : VerPerfilCliente
    Created on : 16/09/2017, 10:01:19 PM
    Author     : Kevin
--%>

<%@page import="Logica.DtSuscripcion"%>
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
        DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
        DtCliente dt = null;
        boolean controlSeguir = false;
        if (perfilUsr != null && perfilUsr instanceof DtCliente) {
            if (Fabrica.getCliente().SuscripcionVigente(perfilUsr.getNickname())) {
                controlSeguir = true;
                dt = (DtCliente) perfilUsr;
            }
        }

    %>

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
                                    if (controlSeguir && !perfilUsr.getNickname().equals(cliente.getNickname())) {
                                        boolean control = false;
                                        for (int i = 0; i < dt.getUsuariosSeguidos().size(); i++) {
                                            if (dt.getUsuariosSeguidos().get(i).getNickname().equals(cliente.getNickname())) {
                                                control = true;
                                            }
                                        }
                                        if (control) {
                                %>
                        <a class="text-primary btn btn-danger" href="ServletClientes?dejarSeguir=<%= cliente.getNickname()%>">Dejar de seguir</a>
                        <%} else {%>
                        <a class="text-primary btn btn-success" href="ServletClientes?seguir=<%= cliente.getNickname()%>">Seguir</a>
                        <%}
                            }%>

                        <ul class="nav nav-tabs">
                            <!-- Si inicio sesión -->
                            <%if (perfilUsr != null) {%>
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Información</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu1"><h4><b>Listas</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu2"><h4><b>Seguidores(<%= seguidores.size()%>)</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu3"><h4><b>Siguiendo</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu4"><h4><b>Suscripciones</b></h4></a></li>
                                            <%} else {%>
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Listas</b></h4></a></li> 
                                            <%}%>
                        </ul>

                        <div class="tab-content text-left">
                            <!-- Si inicio sesión -->
                            <%if (perfilUsr != null) {%>
                            <div id="home" class="tab-pane fade in active">
                                <h4 class="lineaAbajo"><b>Nickname:</b> <%= cliente.getNickname()%></h4>
                                <h4 class="lineaAbajo"><b>Nombre:</b> <%= cliente.getNombre()%></h4>
                                <h4 class="lineaAbajo"><b>Apellido:</b> <%= cliente.getApellido()%></h4>                        
                                <h4 class="lineaAbajo"><b>Fecha de Nacimiento:</b> <%= cliente.getFechaNac()%></h4>
                                <h4 class="lineaAbajo"><b>Correo:</b> <%= cliente.getCorreo()%></h4>
                                <br>
                            </div>
                            <div id="menu1" class="tab-pane fade">
                                <% if (cliente.getListas().isEmpty()) { %>
                                <h4 class="lineaAbajo">No tiene listas creadas</h4>
                                <%} else {%>
                                <% if (controlSeguir && perfilUsr.getNickname().equals(cliente.getNickname())) { %>
                                <br>
                                <h3><label class="texto">Crear lista de reproducción</label>    
                                    <form id="formLista" action="/EspotifyWeb/ServletClientes" method="GET" class="navbar-form navbar-left input-group">
                                        <input id="cLista" name="cLista" placeholder="Nombre de lista" type="text" class="form-control"/><button class="btn glyphicon glyphicon-edit" type="submit">
                                        </button>
                                    </form> </h3>
                                    <% }%>
                                <br>
                                <table class="table text-left">
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
                                            <td><h4><a class="link" href="#"><%= lista.getNombre()%></h4></a></td>
                                            <td><h4><%= tipo%></h4></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <% if (seguidores.isEmpty()) { %>
                                <h4 class="lineaAbajo">No tiene seguidores</h4>
                                <%} else {%>
                                <%  for (DtCliente seguidor : seguidores) {%>
                                <h4 class="lineaAbajo"><a class="link" href="ServletClientes?verPerfilCli=<%= seguidor.getNickname()%>"><%= seguidor.getNombre() + " " + seguidor.getApellido()%></a>
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
                                    <a class="text-primary btn btn-danger" href="ServletClientes?dejarSeguir=<%= seguidor.getNickname()%>">Dejar de seguir</a>
                                    <%} else {%>
                                    <a class="text-primary btn btn-success" href="ServletClientes?seguir=<%= seguidor.getNickname()%>">Seguir</a>
                                    <%}
                                        }%>
                                </h4>
                                <% }
                                    }%>

                                <br>
                            </div>
                            <div id="menu3" class="tab-pane fade">
                                <% if (controlSeguir && perfilUsr.getNickname().equals(cliente.getNickname())) { %>
                                <h3><form id="formBuscar" action="/EspotifyWeb/Vistas/resultadosUsuarios.jsp" method="GET" class="navbar-form navbar-left">
                                        <input id="buscar" name="BusquedaUsuarios" placeholder="Buscar usuarios" type="text" class="form-control">
                                        <button class="btn" type="submit">
                                            <i class="glyphicon glyphicon-search"></i>
                                        </button>
                                    </form> </h3>
                                    <% }
                                        if (cliente.getUsuariosSeguidos().isEmpty()) { %>
                                <h4 class="lineaAbajo">No está siguiendo a ningún usuario</h4>
                                <%} else {%>
                                <br>    
                                <table class="table text-left">
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
                                            <td><a class="link" href="<%= servlet + seguido.getNickname()%>"><h4><%= seguido.getNombre() + " " + seguido.getApellido()%></h4></a>
                                                        <%
                                                            if (controlSeguir && !perfilUsr.getNickname().equals(seguido.getNickname())) {
                                                                boolean control = false;
                                                                for (int i = 0; i < dt.getUsuariosSeguidos().size(); i++) {
                                                                    if (dt.getUsuariosSeguidos().get(i).getNickname().equals(seguido.getNickname())) {
                                                                        control = true;
                                                                    }
                                                                }
                                                                if (control) {
                                                        %>
                                                <a class="text-primary btn btn-danger" href="ServletClientes?dejarSeguir=<%= seguido.getNickname()%>">Dejar de seguir</a>
                                                <%} else {%>
                                                <a class="text-primary btn btn-success" href="ServletClientes?seguir=<%= seguido.getNickname()%>">Seguir</a>
                                                <%}
                                                    }%>
                                            </td>
                                            <td><h4><%= tipo%></h4></td> 
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>                                    
                            </div>
                            <div id="menu4" class="tab-pane fade">
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Tipo</b></h4></th>
                                            <th><h4><b>Monto</b></h4></th>
                                            <th><h4><b>Fecha de inicio</b></h4></th>
                                            <th><h4><b>Estado</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtSuscripcion suscripcion : cliente.getSuscripciones()) {%>
                                        <tr>
                                            <td><h4><%= suscripcion.getTipo()%></h4></td>
                                            <td><h4><%= suscripcion.getMonto()%></h4></td>
                                            <td><h4><%= suscripcion.getFecha()%></h4></td>
                                            <td><h4><%= suscripcion.getEstado()%></h4></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <br>
                            </div>   
                        </div>
                        <%} else {%>
                        <div id="home" class="tab-pane fade in active">
                            <%  int cantListPub = 0;
                                for (DtListaP lista : cliente.getListas()) {
                                    if (lista.isPrivada() == false) {
                                        cantListPub++;
                            %>    
                            <h4 class="lineaAbajo"><a class="link" href="#"><%= lista.getNombre()%></a></h4>
                                <%}
                                    }
                                    if (cantListPub == 0) {%>
                            <h4 class="lineaAbajo">No tiene listas públicas</h4> 
                            <%}
                                }%>
                        </div>
                    </div>
                </div>
                <div class="col-sm-2">

                </div>
            </div>
        </div>

        <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>                  
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
        <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
        <script src="/EspotifyWeb/Javascript/lista.js"></script>
    </body>
</html>
