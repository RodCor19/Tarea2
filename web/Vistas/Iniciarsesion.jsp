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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">

        <title>Espotify: Iniciar sesion</title>
    </head>
    <body>
        <jsp:include page="/Vistas/Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
    <center>
        <h1>Iniciar sesion</h1>

        <form id="iniciar" action="../ServletArtistas"  method="post">

            Nickname o correo :<input type="text"  name="Join"/><br>
            Contraseña :<input type="password" name="Contrasenia" id="pass"/><br>
            <%
                HttpSession sesion = request.getSession();
                if (sesion.getAttribute("error") != null) {
            %>
            <label> <%=sesion.getAttribute("error")%></label><br>
            <%}%>
            <input type="submit" value="Iniciar sesión" id="boton" /><br>
        </form>
        <br>
        ¿No tienes una cuenta?<a href="/EspotifyWeb/Vistas/Registrarse.jsp">Registrarse</a>
    </center>
            
    <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
    
    <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
    <script src="/EspotifyWeb/Javascript/sha1.js"></script>
    <Script src="/EspotifyWeb/Javascript/encriptacion.js"></script>
    <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
</body>
</html>
