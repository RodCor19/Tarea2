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
        <title>Espotify: Resultados</title>
    </head>
<body>
    <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
    <center>
        <h1>Ranking de Usuarios</h1>
            <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" ></div>
                <div class="btn-group-vertical col-sm-8" >
                    <ul class="nav nav-tabs">
                        <div class="tab-content text-left">
                        <div id="menu1" class="tab-pane fade in active">
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th onclick="sortTable(0, this)" class="tituloFila"><h4><b>Nombre</b></h4></th>
                                        <th onclick="sortTable(1, this)" class="tituloFila"><h4><b>Apellido</b></h4></th>
                                        <th onclick="sortTable(2, this)" class="tituloFila"><h4><b>Tipo de Usuario</b></h4></th>
                                        <th onclick="sortTable(3, this)" class="tituloFila"><h4><b>Seguidores</b></h4></th>
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
                                        <a class="link" href="<%= servlet + usr.getNickname()%>"><%=usr.getNombre()%></a>
                                    </td>
                                    <td>
                                        <a class="link" href="<%= servlet + usr.getNickname()%>"><%=usr.getApellido()%></a>
                                    </td>
                                    <td>
                                        <%= tipo %> 
                                    </td>
                                    <td>
                                        <%= wscli.getSeguidores(usr.getNickname()).getUsuarios().size()%>
                                        
                                    </td>
                                </tr>
                                <%}%>
                                
                                
                            </tbody>
                                
                                
                                
                            </div>
                        </div>   
                    </ul>
                    

</body>
</html>