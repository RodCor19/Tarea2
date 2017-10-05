<%-- 
    Document   : Suscripciones
    Created on : 20/09/2017, 04:59:28 PM
    Author     : Kevin
--%>

<%@page import="Logica.DtTipoSuscripcion"%>
<%@page import="Logica.Fabrica"%>
<%@page import="Logica.DtArtista"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Si es un usuario sin suscripcion que lo redirija al inicio -->
<%  if(session.getAttribute("Usuario") == null || session.getAttribute("Usuario") instanceof DtArtista ){ %>
    <script>alert("No es un cliente, no puede acceder a esta página");</script>
    <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}else{
    ArrayList<DtTipoSuscripcion> tiposSus = (ArrayList<DtTipoSuscripcion>) session.getAttribute("TiposDeSus"); %>
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
                        <h3 class="lineaAbajo">Eliga un tipo de suscripción:</h3>
                        <table class="table text-left">
                            <thead>
                                <tr>
                                    <th><h4><b>Tipo</b></h4></th>
                                    <th><h4><b>Monto</b></h4></th>
                                    <th><h4><b></b></h4></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%  for (DtTipoSuscripcion sus : tiposSus) {%>
                                <tr>
                                    <td><h4><%= sus.getCuota() %></h4></td>
                                    <td><h4>$<%= sus.getMonto() %></h4></td>
                                    <td><input id="<%= sus.getId() %>" class="checkboxSus" type="checkbox" value="tipoSus"></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                            <button id="btnConfirmarSus" class="btn-block boton" style="">Confirmar</button>
                    </div>                        
                </div>
                <div class="btn-group-vertical col-sm-2">

                </div>
            </div>
                      
            <br>
            <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
                    
            <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
            <script>
            $('.checkboxSus').click(function() {
                $('.checkboxSus').not(this).prop('checked', false);
              }); 
              
              $('#btnConfirmarSus').click(function() {
                var haySelec = $('input[class="checkboxSus"]').is(':checked');
                if(haySelec === false){
                    alert("Debe seleccionar un tipo");
                }else{
                    var susSelec = $('input[class="checkboxSus"]:checked').attr("id"); 
                    $.ajax({
                        type : 'POST', //tipo de request
                        url : '/EspotifyWeb/ServletClientes',
                        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                        data:{ // Parametros que se pasan en el request
                            nuevaSuscripcion: susSelec
                        },
                        success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                           if(data === 'ok'){
                               alert("Se ha contratado la suscripción correctamente");
                           }else{
                               alert("Ya tiene una suscripción Vigente o Pendiente. Si tiene una Pendiente, cancelela para poder contratar otra");
                           }
                        }
                    });
                }
              }); 
            </script>            
            <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
    </body>
</html>
<%}%>
