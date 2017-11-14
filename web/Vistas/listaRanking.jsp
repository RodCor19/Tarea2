<%-- 
    Document   : listaRanking
    Created on : 25/10/2017, 08:44:27 PM
    Author     : ninoh
--%>

<%@page import="webservices.WSClientes"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="webservices.DtCliente"%>
<%@page import="webservices.DtArtista"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  WSClientes wscli = (WSClientes) session.getAttribute("WSClientes"); %>
<%  List<DtUsuario> usuarios = (List<DtUsuario>) session.getAttribute("RankingUsuarios"); %>
<%  List<DtArtista> artistas = (List<DtArtista>) session.getAttribute("Artistas"); %>
<%  List<DtCliente> clientes = (List<DtCliente>) session.getAttribute("Clientes"); %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <% DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
            
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
        <title>Espotify: Resultados</title>
    </head>
<body>
     <%  if (session.getAttribute("Mensaje") != null) {%>
            <jsp:include page="mensajeModal.jsp" /> <%-- mostrar el mensaje --%>
        <%}%>
    <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
    <center>
        <h1><b>Ranking de Usuarios</b></h1>
            <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" ></div>
                <div class="btn-group-vertical col-sm-8" >
                    <ul class="nav nav-tabs">
                        <div class="tab-content text-left">
                        <div id="menu1" class="tab-pane fade in active">
                            <% if (usuarios.isEmpty()) { %>
                        <h4 class="lineaAbajo">No hay ningún resultado</h4>
                        <%} else {%>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th onclick="ordenarTabla(0, this)" class="tituloFila"><h4><b>Usuario</b></h4></th>
                                        <th onclick="ordenarTabla(1, this)" class="tituloFila"><h4><b>Tipo de Usuario</b></h4></th>
                                        <th onclick="ordenarTabla(2, this)" class="tituloFila"><h4><b>Seguidores</b></h4></th>
                                        <th></th> <!-- Es para el boton seguir/dejar de seguir -->
                                    </tr>
                                </thead>
                                
                                 <tbody> 
                                <%for(DtUsuario usr: usuarios){ %>
                                <tr>
                                    <%
                                        String tipo;
                                        String servlet;
                                        if (usr instanceof DtCliente) {
                                                    tipo = "Cliente";
                                                    servlet = "ServletClientes?verPerfilCli=";
                                        } else {
                                                    tipo = "Artista";
                                                    servlet = "ServletArtistas?verPerfilArt=";
                                                    
                                                }
                                        %>
                                    <td>
                                        <a class="link textoAcomparar" href="<%= servlet + usr.getNickname()%>"><%=usr.getNombre() + " " + usr.getApellido()%></a>
                                    </td>
                                    <td class=" textoAcomparar">
                                        <%= tipo %> 
                                    </td>
                                    <td class=" textoAcomparar">
                                        <%= wscli.getSeguidores(usr.getNickname()).getUsuarios().size()%>
                                        
                                    </td>
                                  
                                     <td>
                                        <%
                                            if (controlSeguir && !perfilUsr.getNickname().equals(usr.getNickname())) {
                                                boolean control = false;
                                                for (int i = 0; i < dt.getUsuariosSeguidos().size(); i++) {
                                                    if (dt.getUsuariosSeguidos().get(i).getNickname().equals(usr.getNickname())) {
                                                        control = true;
                                                    }
                                                }
                                                if (control) {
                                        %>
                                        <a class="text-primary btn btn-danger enviarPorAjax" href="/EspotifyWeb/ServletClientes?dejarSeguir=<%= usr.getNickname()%>"> 
                                            <span class="glyphicon glyphicon-remove pull-left" style="margin-right: 5px"></span><b>Dejar de seguir</b>
                                        </a>
                                        <%} else {%>
                                        <a class="text-primary btn btn-success enviarPorAjax" href="/EspotifyWeb/ServletClientes?seguir=<%= usr.getNickname()%>">
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
                    </ul>
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script src="/EspotifyWeb/Javascript/ordenarTabEnviarPorAjax.js"></script>

</body>
</html>