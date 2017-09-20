<%-- 
    Document   : Registrarse
    Created on : 13/09/2017, 06:59:11 PM
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
                        <style>
                            .button {
                              padding: 7px 12px;
                              font-size: 24px;
                              text-align: center;
                              cursor: pointer;
                              outline: none;
                              color: #fff;
                              background-color: #1ED760;
                              border: none;
                              border-radius: 5px;
                              box-shadow: 0 9px #999;
                            }

                            .button:hover {background-color: #3e8e41}

                            .button:active {
                              background-color: #3e8e41;
                              box-shadow: 0 5px #666;
                              transform: translateY(4px);
                            }
                        </style>
        <title>Espotify: Registrarse</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
    </head>
    <body>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
       
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2">
                    
                </div>
                <div class="col-sm-8 text-left">
                    <div class="row">
                        <ul class="list-group">
                            <form>
                                <div class="input-group">
                                  <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                                  <input id="nickname" type="text" class="form-control" name="nickname" placeholder="Nickname">
                                </div>
                                <div class="input-group">
                                  <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                                  <input id="contrasenia" type="password" class="form-control" name="contrasenia" placeholder="Contraseña">
                                </div>
                                <div class="input-group">
                                  <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                                  <input id="vcontrasenia" type="password" class="form-control" name="vcontrasenia" placeholder="Verificacion de Contraseña">
                                </div>
                                <div class="input-group">
                                  <span class="input-group-addon">Nombre: </span>
                                  <input id="nombre" type="text" class="form-control" name="nombre" placeholder="">
                                </div>
                                <div class="input-group">
                                  <span class="input-group-addon">Apellido: </span>
                                  <input id="apellido" type="text" class="form-control" name="apellido" placeholder="">
                                </div>
                                <div class="input-group">
                                  <span class="input-group-addon">Fecha de Nacimiento: </span>
                                  <input id="fechanac" type="text" class="form-control" name="fecha" placeholder="">
                                </div>
                                <div class="input-group">
                                  <span class="input-group-addon">Email: </span>
                                  <input id="correo" type="text" class="form-control" name="correo" placeholder="">
                                </div>
                                
                             </form>

                        </ul>
                        <label class="radio-inline"><input type="radio" name="optradio" value="Cliente" id="radioC" checked>Cliente</label>
                        <label class="radio-inline"><input type="radio" name="optradio" value="Artista" id="radioA">Artista</label>
                        <ul class="list-group">
                            <form hidden="" id="formArt">
                                <div class="input-group" >
                                  <span  class="input-group-addon">Biografia: </span>
                                  <input id="biografia" type="text" class="form-control" name="biografia" placeholder="">
                                </div>
                                <div class="input-group" >
                                  <span class="input-group-addon">Pagina Web: </span>
                                  <input id="paginaweb" type="text" class="form-control" name="paginaweb" placeholder="">
                                </div>
                            </form>
                        </ul>

                                <button type="button" class="button btn-block" id="bntAceptar" >Aceptar</button>
                
                    </div>
                </div>
                <div class="col-sm-2">
                    
                </div>
            </div>
        </div>
        
        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Javascript/AltaPerfil.js"></script>
    </body>
</html>
