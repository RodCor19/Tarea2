<%-- 
    Document   : Iniciarsesion
    Created on : 13/09/2017, 06:50:13 PM
    Author     : ninoh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <title>Espotify: Iniciar sesión</title>
    </head>
    <body>
        <jsp:include page="/Vistas/Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
    
        <center>
            <div class="container">
                <div class="row">
                    <div class="btn-group-vertical col-sm-2">
                    
                    </div>
                    <div class="col-sm-8 text-left">
                        <center><h1>Iniciar sesión</h1></center>
                        <ul class="list-group">
                            <form id="iniciar" action="../ServletArtistas" method="post">
                                <div class="input-group">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                                    <input type="text" class="form-control" name="Join" placeholder="Nickname o correo"><br>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                                    <input id="pass" type="password" class="form-control" name="Contrasenia" placeholder="Contraseña">
                                </div>
                            <%
                                HttpSession sesion = request.getSession();
                                if (sesion.getAttribute("error") != null) {
                            %>
                            <label> <%=sesion.getAttribute("error")%></label><br>
                            <%}%>
                            <br class="x"><center><input type="submit" value="Iniciar sesión" id="boton" class="boton" style="font-size: 20px" /></center>
                            </form>
                        </ul>
                        <br>
                        <center><h4>¿No tienes una cuenta?<a href="/EspotifyWeb/Vistas/Registrarse.jsp"> Registrarse</a></h4></center>
                    </div>
                    <div class="col-sm-2">
                   
                    </div>
                </div>
            </div>
        </center>
            
    
    <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
    <script src="/EspotifyWeb/Javascript/sha1.js"></script>
    <Script src="/EspotifyWeb/Javascript/encriptacion.js"></script>
</body>
</html>
