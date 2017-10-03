<%-- 
    Document   : ConsultadeListadeReproducción
    Created on : 02/10/2017, 01:25:29 AM
    Author     : ninoh
--%>
<%@page import="Logica.DtCliente"%>
<%@page import="Logica.DtUsuario"%>
<%@page import="Logica.DtTema"%>
<%@page import="Logica.DtLista"%>
<%@page import="Logica.DtArtista"%>
<%@page import="Logica.DtListaP"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.DtGenero"%>
<%@page import="Logica.DtListaPD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        DtLista dt = (DtLista) session.getAttribute("Lista");
    %>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <title>Espotify: Lista de Reproduccion</title>
        <%if( dt == null){
        %>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}  DtListaP aux =(DtListaP)dt;
            DtUsuario aux2 = (DtUsuario)session.getAttribute("Usuario");
            if(aux.isPrivada() && aux2!=null && aux2 instanceof DtArtista){%>
            <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}else{
           DtCliente dtc = (DtCliente)session.getAttribute("Usuario"); ;
        if( !dtc.getNickname().equals(aux.getUsuario()) && aux.isPrivada()){
        %>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}}%>
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" />
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2">

                </div>
                <div class="col-sm-8 text-center">
                    <div class="row">
                        <img src="/EspotifyWeb/Imagenes/iconoLista.png" alt="Foto de la Lista" class="img-responsive imgAlbum" title="Listas"><!--Cambiar por imagen del usuario-->
                        <% if (dt instanceof DtListaPD) {%>
                        <h3 class="tituloLista text-primary"><b><%= dt.getNombre()%></b></h3>
                        <h4 class="text-center">Lista Por Defecto</h4>
                        <%} else {%>
                        <h3 class="tituloLista text-primary"><b><%= dt.getNombre()%></b></h3>
                        <h4 class="text-center">Lista Particular</h4>
                        <%}%>
                        <br>
                        <div class="tab-pane">
                            <% if (dt instanceof DtListaPD) {
                                    DtListaPD dtpd = (DtListaPD) dt;
                            %>
                            <h4 class="lineaAbajo"><b>Género:</b> <%= dtpd.getGenero()%></h4>
                            <%} else {
                                DtListaP dtp = (DtListaP) dt;
                                String tipo = "Privada";
                            %>
                            <h4 class="lineaAbajo"><b>Cliente:</b> <%= dtp.getUsuario()%></h4>
                            <%if (!dtp.isPrivada()) {
                                    tipo = "Pública";
                                }
                            %>
                            <h4 class="lineaAbajo"><b>Tipo: </b><%= tipo%></h4>
                            <%}%>
                        </div>
                        <br>
                        <div class="tab-pane">
                            <% if(dt.getTema()!=null && dt.getTema().isEmpty()){ %>
                                <h4 class="lineaAbajo"><i>No tiene temas</i></h4>
                                <%}else{%>
                                <table class="table text-left">
                                    <thead>
                                        <tr>
                                            <th><h4><b>Tema</b></h4></th>
                                            <th><h4><b>Álbum</b></h4></th>
                                            <th><h4><b>Artista</b></h4></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for (DtTema tema : dt.getTema()) {%>
                                        <tr>
                                            <td><h4><%= tema.getNombre()%></h4></td>
                                            <td><a class="link" href="#"><h4><%= tema.getAlbum()%></h4></a></td>
                                            <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= tema.getArtista()%>"><h4><%= tema.getArtista()%></h4></a></td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                                <%}%>
                            
                        </div>
                    </div>
                </div>
                <div class="btn-group-vertical col-sm-2">

                </div>
            </div> 
        </div>
        <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/ListaReproduccion.js"></script>
        <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
    </body>
</html>
