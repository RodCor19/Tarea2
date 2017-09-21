<%-- 
    Document   : Suscripciones
    Created on : 20/09/2017, 04:59:28 PM
    Author     : Kevin
--%>

<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%  ArrayList<String> tiposSus = new ArrayList<>();
    tiposSus.add("Semanal"); tiposSus.add("Mensual"); tiposSus.add("Anual"); %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Contratar Suscrcipción</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2">

                </div>
                <div class="col-sm-8 text-center">
                    <div class="row">
                        <h4 class="list-group-item">Eliga un tipo de suscripción:</h4>
                        <%  for (String sus : tiposSus) {%>
                                <h3 class="list-group-item"><%= sus %></h3>
                        <% } %>
                    </div>                        
                </div>
                <div class="btn-group-vertical col-sm-2">

                </div>
            </div>
    </body>
</html>
