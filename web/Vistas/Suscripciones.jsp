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
    <script>alert("No es un cliente con suscripción, no puede acceder a esta página");</script>
    <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}else{
    ArrayList<DtTipoSuscripcion> tiposSus = Fabrica.getCliente().listarTipoDeSus(); %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Contratar Suscrcipción</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <style>
/*            .button {
                padding: 5px 8px;
                font-size: 24px;
                text-align: center;
                cursor: pointer;
                outline: none;
                color: #fff;
                background-color: #1ED760;
                border: none;
                border-radius: 5px;
                box-shadow: 0 9px #999;
                width: 50%;
            }

            .button:hover {background-color: #3e8e41}

            .button:active {
                background-color: #3e8e41;
                box-shadow: 0 5px #666;
                transform: translateY(4px);
            }*/
        </style>
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
                        <table class="table table-striped text-left">
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
                                    <td><%= sus.getCuota() %></td>
                                    <td><%= sus.getMonto() %></td>
                                    <td><input id="<%= sus.getId() %>" class="checkboxSus" type="checkbox" value="tipoSus"></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                            <button id="btnConfirmarSus" class="btn btn-block" style=""><h4>Confirmar</h4></button>
                    </div>                        
                </div>
                <div class="btn-group-vertical col-sm-2">

                </div>
            </div>
                    
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
                    alert("Ha elegidor una suscripcion "+susSelec);
                }
              }); 
            </script>
    </body>
</html>
<%}%>
