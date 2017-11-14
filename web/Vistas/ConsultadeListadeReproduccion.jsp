<%-- 
    Document   : ConsultadeListadeReproducción
    Created on : 02/10/2017, 01:25:29 AM
    Author     : ninoh
--%>
<%@page import="java.net.URLEncoder"%>
<%@page import="javax.xml.ws.WebServiceException"%>
<%@page import="java.util.List"%>
<%@page import="webservices.WSArtistas"%>
<%@page import="webservices.WSArtistasService"%>
<%@page import="webservices.DtTema"%>
<%@page import="webservices.WSClientes"%>
<%@page import="webservices.WSClientesService"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="webservices.DtArtista"%>
<%@page import="webservices.DtCliente"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="webservices.DtLista"%>
<%@page import="webservices.DtListaP"%>
<%@page import="webservices.DtListaPD"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        try {
            DtLista dt = (DtLista) session.getAttribute("Lista");
            session.removeAttribute("temasAReproducir");
            
            WSClientes wscli = (WSClientes) session.getAttribute("WSClientes");
            WSArtistas wsart = (WSArtistas) session.getAttribute("WSArtistas");
    %>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <title>Espotify: Lista de Reproduccion</title>
        <%if (dt == null) {
        %>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}else{
            DtUsuario aux2 = (DtUsuario) session.getAttribute("Usuario");
            boolean cliente = false;
            DtCliente dtcontrol = null;
            if (dt instanceof DtListaP) {
                DtListaP aux = (DtListaP) dt;
                dt = wscli.listaP(aux.getUsuario(), aux.getNombre());
                if (aux.isPrivada() && (aux2 == null || aux2 instanceof DtArtista || !aux2.getNickname().equals(aux.getUsuario()))) {%>
        <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
        <%}} if (aux2 != null && aux2 instanceof DtCliente) {
                    if (aux2 != null && wscli.suscripcionVigente(aux2.getNickname())) {
                        cliente = true;
                        dtcontrol = wscli.verPerfilCliente(aux2.getNickname());
                    }

                }%>
    </head>
    <body>
        <%  if (session.getAttribute("Mensaje") != null) {%>
        <jsp:include page="mensajeModal.jsp" /> <%-- mostrar el mensaje --%>
        <%}%>
        <jsp:include page="Cabecera.jsp" />
        <div class="container">
            <div class="row">
                <div class="col-sm-9 text-center">
                    <div class="row">
                        <%if (dt.getRutaImagen() != null) {
                        String rutaImg = URLEncoder.encode(dt.getRutaImagen(), "UTF-8");
                        %>
                        <img src="/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=<%= rutaImg%>" alt="Foto de la Lista" class="img-responsive imgAlbum" title="Listas"><!--Cambiar por imagen del usuario-->
                        <%} else {%>
                        <img src="/EspotifyWeb/Imagenes/IconoLista.png" alt="Foto de la Lista" class="img-responsive imgAlbum" title="Listas"><!--Cambiar por imagen del usuario-->
                        <%}
                            if (dt instanceof DtListaPD) {
                                boolean control2 = true;
                                if (dtcontrol != null) {
                                    for (DtLista l : dtcontrol.getFavListas()) {
                                        if (l instanceof DtListaPD && l.getNombre().equals(dt.getNombre())) {
                                            control2 = false;
                                        }
                                    }
                                }
                        %>
                        <h3 class="titulo text-primary"><b><%= dt.getNombre()%></b></h3>
                        <h4 class="text-center">Lista Por Defecto</h4>
                        <a onclick="reproducirListaPD('<%= dt.getNombre()%>', '<%= ((DtListaPD) dt).getGenero()%>')" href="#" class="btn boton" style="font-size: 15px;">Reproducir</a>
                        <%if (cliente && control2) {%>
                            <a href="/EspotifyWeb/ServletClientes?favLista=<%= dt.getNombre()%>" class="btn boton enviarPorAjax" style="font-size: 15px; margin-left: 5px;">Guardar</a>
                        <%}%>
                        <%} else {
                            DtListaP listaP = (DtListaP) dt;
                            boolean control2 = true;
                            if (dtcontrol != null) {
                                for (DtLista l : dtcontrol.getFavListas()) {
                                    if (l instanceof DtListaP && l.getNombre().equals(listaP.getNombre())) {
                                        if (((DtListaP) l).getUsuario().equals(listaP.getUsuario())) {
                                            control2 = false;
                                        }
                                    }
                                }
                            }
                        %>
                        <h3 class="tituloLista text-primary"><b><%= dt.getNombre()%></b></h3>
                        <h4 class="text-center">Lista Particular</h4>
                        <a onclick="reproducirListaP('<%= dt.getNombre()%>', '<%= ((DtListaP) dt).getUsuario()%>')" href="#" class="btn boton" style="font-size: 15px;">Reproducir</a>
                        <%if (cliente && control2) {%>
                            <a href="/EspotifyWeb/ServletClientes?favLista=<%= dt.getNombre() + "&cliente=" + listaP.getUsuario()%>" class="btn boton enviarPorAjax" style="font-size: 15px; margin-left: 5px;">Guardar</a>
                        <%}%>
                        <br>
                        <div class="tab-pane">
                            <%} if (dt instanceof DtListaPD) {
                                    DtListaPD dtpd = (DtListaPD) dt;
                                    String gen = dtpd.getGenero();
                                    if (gen.contains("&")) {
                                        gen = java.net.URLEncoder.encode(gen, "UTF-8");
                                    }
                            %>
                            <h4 class="lineaAbajo"><b>Género:</b> <a href="/EspotifyWeb/ServletArtistas?consultarAlbum=<%= gen%>"><%= dtpd.getGenero()%></a></h4>
                                <%} else {
                                    DtListaP dtp = (DtListaP) dt;
                                    String tipo = "Privada";
                                    DtCliente cli = wscli.verPerfilCliente(dtp.getUsuario());
                                %>
                            <h4 class="lineaAbajo"><b>Cliente:</b> <a href="/EspotifyWeb/ServletClientes?verPerfilCli=<%= dtp.getUsuario()%>"><%= cli.getNombre() + " " + cli.getApellido()%></a></h4>
                                <%if (!dtp.isPrivada()) {
                                        tipo = "Pública";
                                %>
                            <h4 class="lineaAbajo"><b>Tipo: </b><%= tipo%></h4>
                            <%} else {%>
                            <h4 class="lineaAbajo"><b>Tipo: </b><%= tipo%> <button style="font-size: 15px; margin-left: 5px;" id="btnPublicar" class="btn boton" onclick="publicarLista('<%= dtp.getNombre()%>')">Publicar</button></h4>
                            <%}
                                }%>
                        </div>
                        <br>
                        
                    </div>
                </div>
                <div class="btn-group-vertical col-sm-3">
                    <div id="divReproductor">
                        <% if (session.getAttribute("temasAReproducir") != null) { %>
                        <jsp:include page="reproductor.jsp" /> <%-- Importar codigo desde otro archivo .jsp --%>
                        <%}%>
                    </div>
                </div>
            </div> 
            <div class="row">
                <div class="col-sm-1">
                </div>
                <div class="tab-pane col-sm-10">
                            <% if (dt.getTemas() == null || dt.getTemas().isEmpty()) { %>
                            <h4 class="lineaAbajo"><i>No tiene temas</i></h4>
                            <%} else {%>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th><h4><b>Tema</b></h4></th>
                                        <th><h4><b>Album</b></h4></th>
                                        <th><h4><b>Artista</b></h4></th>
                                        <th><h4><b>Duración</b></h4></th>
                                        <th> </th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <%  List<DtTema> arr = dt.getTemas();
                                        int indic = 0;
                                        for (DtTema tem : arr) {
                                            String nombre = tem.getNombre();
                                            String durac = tem.getDuracion();
                                            String desc = tem.getArchivo();
                                            String nomTema = URLEncoder.encode(tem.getNombre(), "UTF-8");
                                            String nomAlbum = URLEncoder.encode(tem.getNomalbum(), "UTF-8");
                                            String nickArt = URLEncoder.encode(tem.getNomartista(), "UTF-8");
                                            DtArtista a = wsart.elegirArtista(tem.getNomartista());
                                            boolean control2 = true;
                                            if (dtcontrol != null) {
                                                for (DtTema t : dtcontrol.getFavTemas()) {
                                                    if (t.getNombre().equals(nombre) && t.getNomartista().equals(tem.getNomartista()) && t.getNomalbum().equals(tem.getNomalbum())) {
                                                        control2 = false;
                                                    }
                                                }
                                            }
                                    %>
                                    <tr class="filaTema">
                                        <%if (dt instanceof DtListaP) {
                                            DtListaP aux = (DtListaP) dt;%>
                                            <td onclick="reproducirTemaLista('<%= tem.getNombre()%>', '<%= aux.getNombre()%>', '<%= aux.getUsuario()%>', null)">                                                                                        
                                        <%}else {
                                            DtListaPD aux = (DtListaPD) dt;%>
                                            <td onclick="reproducirTemaLista('<%= tem.getNombre()%>', '<%= aux.getNombre()%>', null, '<%= aux.getGenero()%>')">                                                                               
                                        <%}%>
                                            <% if (cliente && control2) {%>
                                                <div class="row">
                                                    <div class="span">
                                                        <a class="enviarPorAjax glyphicon glyphicon-plus" style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?Artista=<%=tem.getNomartista() + "&album=" + tem.getNomalbum() + "&tema=" + nombre%>"></a>
                                                        <div class="span" ><%= nombre%></div>
                                                    </div>
                                                </div>
                                             
                                            <%}else {%>
                                            <%= nombre%> 
                                            <%}%></td>
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= tem.getNomalbum() + "&artista=" + tem.getNomartista()%>"><%= tem.getNomalbum()%></a></td>
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= tem.getNomartista()%>"><%= a.getNombre() + " " + a.getApellido()%></td>
                                        <td><%= durac%></td>
                                        <%if (cliente) {%>
                                        <% if(tem.getArchivo() != null) {%>
                                        <td class="text-right">
                                             <a id="Descargar" href="/EspotifyWeb/ServletArchivos?descargar=<%= tem.getArchivo()%>&tema=<%= nomTema %>&album=<%= nomAlbum %>&artista=<%= nickArt %>" class="glyphicon glyphicon-download" ></a>
                                        </td>
                                        <%}else{%>
                                        <td class="text-right">
                                            <a id="Link" href="http://<%= tem.getDireccion()%>" class="glyphicon glyphicon-new-window" onclick="nuevaReproduccion('<%= tem.getNomartista()%>', '<%= tem.getNomalbum()%>', '<%= tem.getNombre()%>')"></a>
                                        </td> 
                                        <%}}else{%>
                                        <% if(tem.getArchivo()!=null ){ %>
                                        <td class="text-right"><a id="Descargar" href="/EspotifyWeb/ServletArchivos?descargar=<%= tem.getArchivo()%>&tema=<%= nomTema %>&album=<%= nomAlbum %>&artista=<%= nickArt %>" class="glyphicon glyphicon-download" ></a></td>
                                        <%}else{%>
                                        <td class="text-right">
                                            <a id="Link" href="http://<%= tem.getDireccion()%>" class="glyphicon glyphicon-new-window" onclick="nuevaReproduccion('<%= tem.getNomartista()%>', '<%= tem.getNomalbum()%>', '<%= tem.getNombre()%>')"></a>
                                        </td> 
                                        <%}}%>
                                    <td>
                                        <a class="link" data-popover-content="#<%= indic%>" data-toggle="popover" data-trigger="focus" tabindex="0"><b>...</b></a>
                                    </td>
                                    <div class="hidden" id="<%=indic%>">
                                        <div class="popover-heading">
                                            Titulo
                                        </div>
                                        <div class="popover-body" >
                                            <ul style="padding: 0px; margin: 0px;">
                                                <%--<li class="list-group-item"><%=tem.getNombre()%></li>--%>
                                                <li class="list-group-item" style="border-color: #1ED760; color: #1ED760"><b>Reproducciones: <br> <%=tem.getCantReproduccion()%></b></li>
                                                <li class="list-group-item" style="border-color: #1ED760; color: #1ED760"><b>Descargas: <br> <%=tem.getCantDescarga()%></b></li>
                                            </ul>
                                        </div>
                                    </div>
                            </tr>
                                <%indic++;  }%>
                        </tbody>
                        </table>
                            <%}%>

                </div>
                            <div class="col-sm-1">
                </div>
            </div>
        </div>

        <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
        <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>  
        <script src="/EspotifyWeb/Javascript/reproductor.js"></script>
        <script src="/EspotifyWeb/Javascript/artistasGeneros.js"></script>        
        <script src="/EspotifyWeb/Javascript/ordenarTabEnviarPorAjax.js"></script>
        <script>
            $(function () {
                $("[data-toggle=popover]").popover({
                    html: true,
                    placement: 'left',
                    content: function () {
                        var content = $(this).attr("data-popover-content");
                        return $(content).children(".popover-body").html();
                    }/*,
                     title: function() {
                     var title = $(this).attr("data-popover-content");
                     return $(title).children(".popover-heading").html();
                     }*/
                });
            });
        </script>
    </body>
    <%}%>
    <%}catch (WebServiceException ex) {

            response.sendRedirect("Error.html");
        }%>
</html>
