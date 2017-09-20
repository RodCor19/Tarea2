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
        <link rel="stylesheet" href="Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="CSS/estilos.css">
        <title>Espotify</title>        
    </head>
    <body>
        <jsp:include page="Vistas/Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" >
                    <button id="btnArtistas" type="button" class="btn btn-default btn-block btnOpcion">Artistas</button>
                    <button id="btnGeneros" type="button" class="btn btn-default btn-block btnOpcion">Géneros</button>
                </div>
                <div class="col-sm-8 text-center">
                    <div id="listaArtGen" class="row">
                        <%for(int i=0; i < 10; i++){ %>
                        <div class="col-md-4" style="padding: 2px;">
                            <a href="http://www.google.com">
                                <img src="/EspotifyWeb/Imagenes/iconoArtista.png" alt="foto del usuario" class="img-responsive imgAlbum" title="Artista"><!--Cambiar por imagen del usuario-->
                                <h3 class="img-text">Artista</h3>
                            </a>  
                        </div>
                        
                        <%}%>
                    </div>
                </div>
                <div class="col-sm-2">
                    <h3>Columna 3</h3>
                </div>
            </div>
        </div>
        <%
                HttpSession sesion = request.getSession();
                if(sesion.getAttribute("Usuario")!=null){
        %>
         inicio de 
        <%}%>
        <footer class="container-fluid text-center">
            <h3>Pie de página</h3>
        </footer>
                    
        <script src="Javascript/jquery.min.js"></script>
        <script src="Javascript/artistasGeneros.js"></script>
    </body>
</html>
