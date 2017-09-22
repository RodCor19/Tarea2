<%-- 
    Document   : index
    Created on : 07/09/2017, 07:40:03 PM
    Author     : Kevin
--%>

<%@page import="Logica.DtUsuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <title>Espotify</title>        
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" >
                    <button id="btnArtistas" type="button" class="btn btn-default btn-block opcionSelec">Artistas</button>
                    <button id="btnGeneros" type="button" class="btn btn-default btn-block opcionNoSelec">Géneros</button>
                </div>
                <div class="col-sm-8 text-center">
                    <div id="listaArtGen" class="row">
                        <jsp:include page="listaArtistas.jsp" /> <%-- Importar codigo desde otro archivo .jsp --%>
                    </div>
                </div>
                <div class="col-sm-2">
                    <%  HttpSession sesion = request.getSession();
                        if(sesion.getAttribute("Mensaje")!=null){%>
                            <h3 class="text-center text-primary"><%=sesion.getAttribute("Mensaje")%></h3>
                        <%}
                        sesion.removeAttribute("Mensaje");
                        %>
  
                </div>
            </div>
        </div>
        
        <footer class="container-fluid text-center">
            <h3>Pie de página</h3>
        </footer>
                    
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>
    </body>
</html>
