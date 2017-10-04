<%-- 
    Document   : Iniciarsesion
    Created on : 13/09/2017, 06:50:13 PM
    Author     : ninoh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <style> 
        form {
            text-align: center;
        }
        </style>
        
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
        
            <form action="../ServletArtistas" method="post">
                
                Nickname o correo :<input type="text"  name="Join" /><br>
                Contraseña :<input type="password" name="Contraseña" /><br>
                <%
                HttpSession sesion = request.getSession();
                if(sesion.getAttribute("error")!=null){
                %>
                <label> Usuario o contraseña incorrecto </label><br>
                <%}%>
                <input type="submit" value="Iniciar sesión" /><br>
            </form>
            <br>
            ¿No tienes una cuenta?<a href="/EspotifyWeb/Vistas/Registrarse.jsp">Registrarse</a>
        </center> 
    </body>
</html>
