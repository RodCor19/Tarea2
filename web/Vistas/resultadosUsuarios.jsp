<%@page import="Logica.Fabrica"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.DtCliente"%>
<%@page import="Logica.DtUsuario"%>
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
    </head>
    <body>
        <%
            ArrayList<DtUsuario> usus = Fabrica.getCliente().BuscarUsuarios(request.getParameter("BusquedaUsuarios"));

        %>
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
                                    <th><h4><b>Nickname</b></h4></th>
                                    <th><h4><b>Usuario</b></h4></th>
                                    <th><h4><b>Tipo</b></h4></th>
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
                                    <td><a class="link" href="<%= servlet + u.getNickname()%>"><h4><%= u.getNickname() %></h4></a></td>
                                    <td><a class="link" href="<%= servlet + u.getNickname()%>"><h4><%= u.getNombre() + " " + u.getApellido()%></h4></a></td>
                                    <td><h4><%= tipo%></h4></td> 
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
                                        <a class="text-primary btn btn-danger glyphicon glyphicon-remove" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= u.getNickname()%>"></a>
                                        <%} else {%>
                                        <a class="text-primary btn btn-success glyphicon glyphicon-ok" href="/EspotifyWeb/ServletClientes?seguir=<%= u.getNickname()%>"></a>
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
    </body>
</html>
