<%-- 
    Document   : VerPerfilCliente
    Created on : 16/09/2017, 10:01:19 PM
    Author     : Kevin
--%>

<%@page import="webservices.DtLista"%>
<%@page import="webservices.DtSuscripcion"%>
<%@page import="webservices.DtListaP"%>
<%@page import="java.util.List"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="webservices.WSClientes"%>
<%@page import="webservices.WSClientesService"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="webservices.DtCliente"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%  DtCliente cliente = (DtCliente) session.getAttribute("PerfilCli");
        try{
        WSClientes wscli = (WSClientes) session.getAttribute("WSClientes");

        List<DtUsuario> seguidores = wscli.getSeguidores(cliente.getNickname()).getUsuarios();
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
        <title>Espotify: Cliente</title>
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
                        <% if (cliente.getRutaImagen() == null) { %>
                        <img src="/EspotifyWeb/Imagenes/iconoUsuario.jpg" alt="foto del usuario" class="img-responsive imgAlbum" title="Cliente"><!--Cambiar por imagen del usuario-->
                        <%} else {%>
                        <img src="/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=<%= cliente.getRutaImagen()%>" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista">
                        <%}%>
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
                        <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= cliente.getNickname()%>">
                           <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de seguir</b>
                        </a>
                        <%} else {%>
                        <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%= cliente.getNickname()%>">
                            <span class="glyphicon glyphicon-ok pull-left" style="margin-right: 5px"></span><b>Seguir</b>
                        </a>
                        <%}
                            }%>
                            <br><br>
                        <ul class="nav nav-tabs">
                            <!-- Si inicio sesión -->
                            <%if (perfilUsr != null) {%>
                            <li class="active"><a data-toggle="tab" href="#home"><h4><b>Información</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu1"><h4><b>Listas</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu2"><h4><b>Seguidores(<%= seguidores.size()%>)</b></h4></a></li>
                            <li><a data-toggle="tab" href="#menu3"><h4><b>Siguiendo</b></h4></a></li>
                                            <% if (perfilUsr != null && perfilUsr.getNickname().equals(cliente.getNickname())) { %>
                            <li><a data-toggle="tab" href="#menu4"><h4><b>Suscripciones</b></h4></a></li>
                                            <%}%>
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
                                <% if (controlSeguir && perfilUsr.getNickname().equals(cliente.getNickname())) { %>
                                <br>
                                <h4><label class="texto">Crear lista de reproducción</label>    
                                    <div >
                                        <input id="cLista" name="cListaAux" placeholder="Nombre de lista" type="text" class="form-control"/>
                                    </div> 
                                    <form  id="formImagen" name="formImagen" onsubmit="return comprobar()" action="/EspotifyWeb/ServletClientes" enctype="multipart/form-data" method="post">
                                        <input type="file" name="imagen" value="Imagen" accept=".jpg" class="form-control inputImg" />
                                        <input type="submit" value="Crear lista" class="btn inputImg boton" style="font-size: 15px"/>
                                    </form>
                                    <br><br>
                                    <%if (!(cliente.getListas().isEmpty())) {%>
                                    <button type="button" class="btn boton" style="font-size: 20px" onclick = "window.location.href = '/EspotifyWeb/ServletArtistas?agregartemalista=true'" >Agregar tema a lista</button>
                                    <%}%>
                                </h4>
                                <!--<br class="x">-->
                                <% }%>
                                <% int cantLPub = 0;
                                    for (DtListaP lista : cliente.getListas()) {
                                        if (lista.isPrivada() == false) {
                                            cantLPub++;
                                        }
                                    } %>
                                <% if (cliente.getListas().isEmpty()) { %>
                                <h4 class="lineaAbajo"><i>No tiene listas creadas</i></h4>
                                <%} else {
                                    if (cantLPub == 0 && perfilUsr.getNickname().equals(cliente.getNickname()) == false) {%>
                                <h4 class="lineaAbajo"><i>No tiene listas públicas</i></h4>
                                <%      } else { %>
                                <br>
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th onclick="ordenarTabla(0, this)"><h4><b>Nombre</b></h4></th>
                                            <th onclick="ordenarTabla(1, this)"><h4><b>Tipo</b></h4></th>
                                            <th id="FechaC" onclick="ordenarTabla(2, this)"><h4><b>Fecha</b></h4></th>
                                            <th><h4><b> </b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtListaP lista : cliente.getListas()) {
                                                String tipo;
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
                                                if (lista.isPrivada()) {
                                                    tipo = "Privada";
                                                } else {
                                                    tipo = "Pública";
                                                }
                                                boolean control2 = true;
                                                if (dt != null) {
                                                for (DtLista l : dt.getFavListas()) {
                                                    if (l instanceof DtListaP && l.getNombre().equals(lista.getNombre())) {
                                                        if (((DtListaP) l).getUsuario().equals(lista.getUsuario())) {
                                                            control2 = false;
                                                        }
                                                    }
                                                }
                                                }
                                            %>
                                    <tr>
                                        <!-- Si es publica o es privada pero el perfil es del cliente que inicio sesion -->
                                        <% if (lista.isPrivada() == false || perfilUsr.getNickname().equals(cliente.getNickname())) {%>
                                        <tr>
                                            <%if (controlSeguir && control2 && lista.isPrivada() == false) {%>
                                        <td>
                                            <div class="row">
                                                <div class="span">
                                                    <a class="enviarPorAjax glyphicon glyphicon-plus" style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?favLista=<%=nombre + "&cliente=" + lista.getUsuario()%>""></a>
                                                    <div class="span" ><h4><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre %>&Usuario=<%= lista.getUsuario()%>"><%= lista.getNombre()%></h4></a></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%} else {%>
                                        <td><h4><a class="link textoAcomparar" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre %>&Usuario=<%= lista.getUsuario()%>"><%= lista.getNombre()%></h4></a></td>
                                        <%}%>
                                            <td id="td<%= lista.getNombre()%>"><h4><%= tipo%></h4></td>
                                            <td class="fechalista" id="td<%= lista.getNombre()%>"><h4><%= lista.getFechacreacion() %></h4></td>
                                                    <% if (lista.isPrivada() && controlSeguir) {%>
                                            <td><button style="font-size: 15px" id="btnPublicar" class="btn boton" onclick="publicarLista('<%= lista.getNombre()%>')">Publicar</button></td>

                                            <%} else {%> 
                                            <td> </td>
                                            <%}%>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                                <%}
                                    }%>
                            </div>
                            <div id="menu2" class="tab-pane fade">
                                <% if (seguidores.isEmpty()) { %>
                                <h4 class="lineaAbajo"><i>No tiene seguidores</i></h4>
                                <%} else {%>
                                <%  for (DtUsuario seguidorAux : seguidores) {
                                        DtCliente seguidor = (DtCliente) seguidorAux;%>
                                <h4 class="lineaAbajo row" style="margin-left:0px; margin-right:0px;">
                                    <div class="col-sm-8 text-left">

                                        <a class="link" href="ServletClientes?verPerfilCli=<%= seguidor.getNickname()%>"><%= seguidor.getNombre() + " " + seguidor.getApellido()%></a>
                                    </div>
                                    <div class="col-sm-4 text-right">
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
                                        <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= seguidor.getNickname()%>">
                                           <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de seguir</b>
                                        </a>
                                        <%} else {%>
                                        <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%=seguidor.getNickname()%>">
                                            <span class="glyphicon glyphicon-ok pull-left" style="margin-right: 5px"></span><b>Seguir</b>
                                        </a>
                                        <%}
                                            }%>
                                    </div>
                                </h4>
                                <% }
                                    }%>

                                <br>
                            </div>
                            <div id="menu3" class="tab-pane fade"> 
                                <% if(perfilUsr.getNickname().equals(cliente.getNickname())){%>
                                <form id="formBuscar" action="/EspotifyWeb/Vistas/resultadosUsuarios.jsp" method="GET" class="navbar-form navbar-left" style="width: 100%">
                                    <h3>    
                                        <input id="buscar" name="BusquedaUsuarios" placeholder="Buscar usuarios" type="text" class="form-control" style="width: 50%">
                                        <button class="btn" type="submit">
                                            <i class="glyphicon glyphicon-search"></i> <%-- Icono de buscar, lupa--%>
                                        </button>
                                    </h3>
                                </form> 
                                
                                <% }%>
                                    <%if (cliente.getUsuariosSeguidos().isEmpty()) { %>
                                    <br>
                                    <h4 class="lineaAbajo"><i>No sigue a ningún usuario</i></h4>
                                    <%} else {%>
                                <br>    
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Usuario</b></h4></th>
                                            <th><h4><b>Tipo</b></h4></th>
                                            <th></th> <!-- Es para el boton seguir/dejar de seguir -->
                                        </tr>
                                    </thead>
                                    <tbody id="agregar">
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
                                            <td><a class="link" href="<%= servlet + seguido.getNickname()%>"><h4><%= seguido.getNombre() + " " + seguido.getApellido()%></h4></a></td>
                                            <td><h4><%= tipo%></h4></td> 
                                            <td class="text-right">
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
                                                <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= seguido.getNickname()%>"> 
                                                    <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de seguir</b>
                                                </a>
                                                <%} else {%>
                                                <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%=seguido.getNickname()%>"> 
                                                    <span class="glyphicon glyphicon-ok pull-left" style="margin-right: 5px"></span><b>Seguir</b>
                                                </a>
                                                <%}
                                            }%>
                                            </td> 
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>                                    
                            </div>
                            <% if (perfilUsr != null && perfilUsr.getNickname().equals(cliente.getNickname())) { %>
                            <div id="menu4" class="tab-pane fade">
                                <% if (cliente.getSuscripciones().isEmpty() == false) { %>
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Tipo</b></h4></th>
                                            <th><h4><b>Monto</b></h4></th>
                                            <th><h4><b>Fecha</b></h4></th>
                                            <th><h4><b>Estado</b></h4></th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtSuscripcion suscripcion : cliente.getSuscripciones()) {%>
                                        <tr>
                                            <td><h4><%= suscripcion.getTipo()%></h4></td>
                                            <td><h4>$<%= suscripcion.getMonto()%></h4></td>
                                            <td><h4><%= suscripcion.getFecha()%></h4></td>
                                            <td><h4><%= suscripcion.getEstado()%></h4></td>
                                            <td>
                                                <% if(suscripcion.getEstado().equals("")){ %>
                                                <button class="btn btn-success" style="font-size: 15px">Renovar</button> 
                                                <button class="btn btn-danger" style="font-size: 15px">Cancelar</button> 
                                                <%}%>
                                            </td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%} else {%>
                                <h4 class="lineaAbajo"><i>No tiene suscripciones</i></h4>
                                <%}%>
                                <br>
                            </div>   
                            <%}%>
                        </div>
                        <%} else {%>
                        <div id="home" class="tab-pane fade in active">
                            <%  int cantListPub = 0;
                                for (DtListaP lista : cliente.getListas()) {
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
                                    if (lista.isPrivada() == false) {
                                        cantListPub++;
                                        
                            %>    
                            <h4 class="lineaAbajo"><a class="link" href="/EspotifyWeb/ServletClientes?Lista=<%= nombre%>&Usuario=<%= lista.getUsuario()%>"><%= lista.getNombre()%></a></h4>
                                <%}
                                    }
                                    if (cantListPub == 0) {%>
                            <h4 class="lineaAbajo"><i>No tiene listas públicas</i></h4> 
                            <%}
                                }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
           
        <script src="/EspotifyWeb/Javascript/fecha.js"></script>
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>                  
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
        <script src="/EspotifyWeb/Javascript/lista.js"></script>
        <script src="/EspotifyWeb/Javascript/ordenarTabEnviarPorAjax.js"></script>
    </body>
</html>
<%}catch (Exception ex) {

            response.sendRedirect("Error.html");
        }%>
