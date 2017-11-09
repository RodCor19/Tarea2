<%-- 
    Document   : index
    Created on : 07/09/2017, 07:40:03 PM
    Author     : Kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <title>Espotify</title>        
    </head>
    <body>
        <%  if (session.getAttribute("Mensaje") != null) {%>
            <jsp:include page="mensajeModal.jsp" /> <%-- mostrar el mensaje --%>
        <%}%>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="container">
            <div class="btn-group-vertical col-sm-2" ></div>
            <div class="col-sm-8 text-center"><h3><form id="formBuscar" action="/EspotifyWeb/Vistas/resultadosUsuarios.jsp" method="GET" class="navbar-form navbar-left">
                        <input id="buscar" name="BusquedaUsuarios" style="width: 80%; margin-left:5%" placeholder="Buscar usuarios" type="text" class="form-control">
                        <button class="btn" type="submit"><i class="glyphicon glyphicon-search"></i></button>
                    </form> </h3></div>
            <div class="col-md-4 text-right" ></div>
        </div>
        <!--<br>-->
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" >
                    <button id="btnArtistas" type="button" class="btn btn-default btn-block opcionSelec">Artistas</button>
                    <button id="btnGeneros" type="button" class="btn btn-default btn-block opcionNoSelec">Géneros</button><br>
                    <a class="btn btn-default btn-block opcionNoSelec " style="color:#ffffff; text-decoration: none" href="/EspotifyWeb/ServletArtistas?VerRanking=true">Ver Ranking</a>
                </div>
                <div class="col-sm-8 text-center">
                    <div id="listaArtGen" class="row">
                        <jsp:include page="listaArtistas.jsp" /> <%-- Importar codigo desde otro archivo .jsp --%>
                    </div>
                </div>
                <div class="col-sm-2" style="padding-right: 0px;">
                    <%--
                    <% if (session.getAttribute("temasAReproducir") != null) { %>
                    <jsp:include page="reproductor.jsp" />
                    <%}%>
                    
                    <%  if (session.getAttribute("Mensaje") != null) {%>
                    <h3 class="text-center text-info"><%=session.getAttribute("Mensaje")%></h3>
                    <%}
                        session.removeAttribute("Mensaje");
                    %>--%>
                </div>
            </div>
        </div>

        <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
        <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
        <script src="/EspotifyWeb/Javascript/reproductor.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>
        <script>$(document).ready(function () {

                 $("#mostrarmodal").modal("show");

            });
        </script>

    </body>
</html>
