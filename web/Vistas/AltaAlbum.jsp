<%-- 
    Document   : AltaAlbum
    Created on : 19/09/2017, 04:50:59 PM
    Author     : Admin
--%>

<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="Logica.DtUsuario"%>
<%@page import="Logica.DtCliente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="Logica.DtArtista"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  DtArtista artista = null;
    if (request.getSession().getAttribute("Usuario")!=null && request.getSession().getAttribute("PerfilArt")!=null){
        DtUsuario dtu = (DtUsuario) request.getSession().getAttribute("Usuario");
        artista = (DtArtista) request.getSession().getAttribute("PerfilArt");
        if (artista.getNickname().equals(dtu.getNickname())){%>

<html>
    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
        }
    </style>
    <%  ArrayList<DtAlbum> alb = artista.getAlbumes(); %>
    <head >
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Espotify: Crear Album</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
    </head>
    <body >
        <% ArrayList<String> generos = (ArrayList<String>) session.getAttribute("Generos");%>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="container">
            <div class="row">
                <div class="col-sm-2">
                    <h3 id="aux">Nuevo Album De:<br><%=artista.getNombre() + " " + artista.getApellido()%></h3>
                    <p>Ingrese los datos correspondientes</p>
                </div>
                <div class="col-sm-7">
                    <!--            <h3>Column 2</h3>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                                <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>-->
                    <div class="form-group" >
                        <label for="nombrealbum">Nombre Album:</label>
                        <input name="nombrealbum" type="text" class="form-control" id="nombrealbum" style="width: 70%" >
                    </div>
                    <div class="form-group">
                        <label for="anioalbum">Año:</label>
                        <input type="number" min="1800" max="2017" name="anioalbum" class="form-control" id="anioalbum" style="width: 30%" >
                    </div>
                    <div align="left">
                        <select id="selectgenero" name="Sabe">
                            <option style=" font-family:Helvetica ; background-color: black; color:white">Géneros</option>
                            <%for (String gen : generos) {%>
                            <option><%=gen%></option>
                            <%}%>
                        </select>
                        <button type="button" class="btn btn-danger" id="eliminargen" >Eliminar Generos</button>
                        <ul id="listageneros" name="listageneros" >
                            <h5 style="color: green; font-weight: bold">Géneros Seleccionados</h5>
                        </ul>
                    </div>
                    <br><p style="color:green">------------------------------------</p><br>

                    <div class="container">
                        <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#modal">Agregar Tema</button>

                        <!-- Modal -->
                        <div class="modal fade" id="modal" role="dialog" >
                            <div class="modal-dialog modal-lg" >

                                <!-- Modal content-->
                                <div class="modal-content" style="background-color:blue;">
                                    <div class="modal-header">
                                        <h4 class="modal-title" style="font-weight:bold;color:white;font-size:30px">Nuevo Tema</h4>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label for="usr" style="color:white; ">Nombre:</label>
                                            <input type="text" class="form-control" style="width:100%;" id="nomtema">
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label for="pwd" style="color:white">Orden:</label>
                                            <input type="number" min="1" class="form-control" id="ordentema" style="width:30%;">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="sel1" style="color:white">Duración:</label>
                                            <div id="enlinea">
                                                <p style="color:white">Minutos:</p>
                                                <select class="form-control" id="sel1" style="width:20%">
                                                    <%for (int i = 0; i < 60; i++) {%>
                                                    <option><%=i%></option>
                                                    <%}%>
                                                </select>
                                                <p style="color:white">Segundos:</p>
                                                <select class="form-control" id="sel2" style="width:20%">
                                                    <%for (int i = 0; i < 60; i++) {%>
                                                    <option><%=i%></option>
                                                    <%}%>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label for="sel1" style="color:white">Archivo/URL:</label><br>
                                            <label style="color:white;">Es URL? <input type="checkbox" value="" id="checkurl"></label>
                                            <input type="text" class="form-control" style="width:80%;" id="url">
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <form  target="iframe" action="subir.jsp" id="myForm" enctype="MULTIPART/FORM-DATA" method="post">
                                            <input type="file" name="elegircancion" id="elegircancion" value="music" accept=".mp3" class="form-control" style="width:200%;" />
                                            <br>
                                            <input type="submit" value="Aceptar" id="aceptartema" class="btn btn-default" />
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cancelartema" >Cancelar</button>
                                        </form>
                                    </div>

                                    <div class="modal-footer">
                                        <!--<button type="button" class="btn btn-default" id="aceptartema" >Aceptar</button>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" >
                        <h4>Lista Temas</h4>
                        <table id="mitabla">
                            <tr>
                                <th>Nombre</th>
                                <th>Orden</th>
                                <th>Duración</th>
                                <th>Archivo/URL</th>
                            </tr>
                        </table>
                        <div id = "alert_placeholder"></div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <h3>Elegir Imagen Album</h3>        
                    <img id="imgalbum" src="/EspotifyWeb/Imagenes/iconoMusica.jpg" width="230" height="230" class="imgAlbum" />
                    <form  target="iframe" action="subir.jsp" id="formcrear" enctype="MULTIPART/FORM-DATA" method="post">
                        <input type="file" name="elegirimagen" id="elegirimagen" value="Img" accept="image/*"/>
                        <br><br><div class="form-group">
                            <input name="aceptar" type="submit" value="Crear Album" id="aceptar" style="width: 40%;background-color:dodgerblue;color:white">
                        </div>
                    </form>
                    <!--        <form  target="iframe" action="subir.jsp" id="myForm" enctype="MULTIPART/FORM-DATA" method="post">
                                    <input type="file" name="file" /><br/>
                                    <input type="submit" value="Upload" />
                                </form>-->
                    <iframe style="display:none" id="iframe" name="iframe"></iframe>
                </div>
            </div>
        </div>
        <script src="../Javascript/jquery.min.js"></script>
        <script src="../Javascript/Funciones.js"></script>
        <script src="../Bootstrap/js/bootstrap.min.js"></script>
    </body>
</html>
<%}else{%>
<script>alert("No puedes ingresar aquí");</script>
<meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}%>
<%}else{%>
<script>alert("No puedes ingresar aquí");</script>
<meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}%>
