<%@page import="webservices.WSClientes"%>
<%@page import="webservices.WSClientesService"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="webservices.DtCliente"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Resultados</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <% DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
            
        try{
            WSClientes wscli = (WSClientes) session.getAttribute("WSClientes");

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
    </head>
    <body>
        <%
            List<DtUsuario> usus = wscli.buscarUsuarios(request.getParameter("BusquedaUsuarios")).getUsuarios();

        %>
        <%  if (session.getAttribute("Mensaje") != null) {%>
            <jsp:include page="mensajeModal.jsp" /> <%-- mostrar el mensaje --%>
        <%}%>
        <jsp:include page="Cabecera.jsp" />
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" ></div>
                <div class="col-sm-8 text-center">
                    <div  class="tab-pane ">
                        <h3><form id="formBuscar" action="/EspotifyWeb/Vistas/resultadosUsuarios.jsp" method="GET" class="navbar-form navbar-left">
                                <input id="buscar" name="BusquedaUsuarios" placeholder="Buscar usuarios" type="text" class="form-control">
                                <button class="btn" type="submit">
                                    <i class="glyphicon glyphicon-search"></i> <%-- Icono de buscar, lupa--%>
                                </button>
                            </form> </h3>
                        <br/>
                        <% if (usus.isEmpty()) { %>
                        <h4 class="lineaAbajo">No hay ningún resultado</h4>
                        <%} else {%>
                        <br>    
                        <table class="table text-left">
                            <thead>
                                <tr>
                                    <th onclick="ordenarTabla(0, this)"><h4><b>Nickname</b></h4></th>
                                    <th onclick="ordenarTabla(1, this)"><h4><b>Usuario</b></h4></th>
                                    <th onclick="ordenarTabla(2, this)"><h4><b>Tipo</b></h4></th>
                                    <th></th> <!-- Es para el boton seguir/dejar de seguir -->
                                </tr>
                            </thead>
                            <tbody>
                                <% for (DtUsuario u : usus) {
                                        String tipo;
                                        String servlet;
                                        if (u instanceof DtCliente) {
                                            tipo = "Cliente";
                                            servlet = "/EspotifyWeb/ServletClientes?verPerfilCli=";
                                        } else {
                                            tipo = "Artista";
                                            servlet = "/EspotifyWeb/ServletArtistas?verPerfilArt=";
                                        }
                                %>
                                <tr>
                                    <td><a class="link textoAcomparar" href="<%= servlet + u.getNickname()%>"><h4><%= u.getNickname() %></h4></a></td>
                                    <td><a class="link textoAcomparar" href="<%= servlet + u.getNickname()%>"><h4><%= u.getNombre() + " " + u.getApellido()%></h4></a></td>
                                    <td><h4 class="textoAcomparar"><%= tipo%></h4></td> 
                                    <td>
                                        <%
                                            if (controlSeguir && !perfilUsr.getNickname().equals(u.getNickname())) {
                                                boolean control = false;
                                                for (int i = 0; i < dt.getUsuariosSeguidos().size(); i++) {
                                                    if (dt.getUsuariosSeguidos().get(i).getNickname().equals(u.getNickname())) {
                                                        control = true;
                                                    }
                                                }
                                                if (control) {
                                        %>
                                        <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= u.getNickname()%>"> 
                                            <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de seguir</b>
                                        </a>
                                        <%} else {%>
                                        <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%= u.getNickname()%>">
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
                </div>
                <div class="col-sm-2"></div>
            </div>
        </div>

        <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script src="/EspotifyWeb/Javascript/ordenarTabEnviarPorAjax.js"></script>
    </body>
    <%} catch (Exception ex){
          response.sendRedirect("Error.html");
     }%>
</html>
