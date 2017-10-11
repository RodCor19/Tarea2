<%@page import="Logica.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
        <link type="image/x-icon" rel="shortcut icon"  href="/EspotifyWeb/Imagenes/espotifyIcono.ico">
        <title>Espotify: Resultados</title>
    </head>
    <body>
        <% String palabra = request.getParameter("busqueda");%>
        <%DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
            DtCliente dt = null;
            boolean control = false;
            if (perfilUsr != null && perfilUsr instanceof DtCliente) {
                if (Fabrica.getCliente().SuscripcionVigente(perfilUsr.getNickname())) {
                    control = true;
                    dt = Fabrica.getCliente().verPerfilCliente(perfilUsr.getNickname());
                    session.setAttribute("Usuario", dt);
                }
            }
            ArrayList<DtTema> temas = Fabrica.getCliente().resultadosT(palabra);
            ArrayList<DtLista> listas = Fabrica.getCliente().resultadosL(palabra);
            ArrayList<DtAlbum> albumes = Fabrica.getCliente().resultadosA(palabra);
        %>
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

    <center>
        <h1>Resultados de la búsqueda "<%= palabra%>"</h1>
        <div class="container">
            <div class="row">
                <div class="btn-group-vertical col-sm-2" ></div>
                <div class="btn-group-vertical col-sm-8" >
                    <ul class="nav nav-tabs">
                        <li class="active"><a data-toggle="tab" href="#menu1"><h4><b>Temas</b></h4></a></li>
                        <li><a data-toggle="tab" href="#menu2"><h4><b>Álbumes</b></h4></a></li>
                        <li><a data-toggle="tab" href="#menu3"><h4><b>Listas</b></h4></a></li>
                    </ul>
                    <div class="tab-content text-left">
                        <div id="menu1" class="tab-pane fade in active">
                            <% if (temas == null || temas.isEmpty()) { %>
                            <h4 class="lineaAbajo"><i>No hay coincidencias</i></h4>
                            <%} else {%>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th onclick="sortTable(0, this)" class="tituloFila"><h4><b>Tema</b></h4></th>
                                        <th onclick="sortTable(1, this)" class="tituloFila"><h4><b>Album</b></h4></th>
                                        <th onclick="sortTable(2, this)" class="tituloFila"><h4><b>Artista</b></h4></th>
                                        <th onclick="sortTable(3, this)" class="tituloFila"><h4><b>Duración</b></h4></th>
                                    </tr>
                                </thead>
                                <tbody> 
                                    <%
                                        for (DtTema tem : temas) {
                                            String nombre = tem.getNombre();
                                            String duracion = tem.getDuracion();
                                            boolean control2 = true;
                                            if (dt != null) {
                                                for (DtTema t : dt.getFavTemas()) {
                                                    if (t.getNombre().equals(nombre) && t.getArtista().equals(tem.getArtista()) && t.getAlbum().equals(tem.getAlbum())) {
                                                        control2 = false;
                                                    }
                                                }
                                            }
                                    %>
                                    <%if (control && control2) {%>
                                <td>
                                    <div class="row">
                                        <div class="span">
                                            <a style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?Artista=<%=tem.getArtista() + "&album=" + tem.getAlbum() + "&tema=" + nombre%>">
                                                <img onmouseover="hover(this, true)" onmouseout="hover(this, false)" src="/EspotifyWeb/Imagenes/guardar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                            </a>
                                            <div class="span" ><%= nombre%></div>
                                        </div>
                                    </div>
                                </td>
                                <%} else {%>
                                <td><%= nombre%></td>
                                <%}%>
                                <td><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= tem.getAlbum() + "&artista=" + tem.getArtista()%>"><%= tem.getAlbum()%></a></td>
                                <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= tem.getArtista()%>"><%= tem.getNomartista()%></td>
                                <%if (control) {%>
                                <%if (tem.getArchivo() != null) {%>
                                <td><%= duracion%> <a id="Descargar" href="/EspotifyWeb/ServletArchivos?tipo=audio&ruta=<%= tem.getArchivo()%>">Descargar</a></td>
                                <%} else {%>
                                <td><%= duracion%> <a id="Link" href="http://<%= tem.getDireccion()%>">Escuchar online</a></td>
                                <%}%>
                                <%} else {%>
                                <%if (tem.getDireccion() != null) {%>
                                <td><%= duracion%><br> <a id="Link" href="http://<%= tem.getDireccion()%>">Escuchar online</a></td>
                                    <%} else {%>
                                <td><%= duracion%></td>
                                <%}%>
                                <%}%>
                                </tr>
                                <%}%>
                                </tbody>
                            </table>
                            <%}%>
                        </div>
                        <div id="menu2" class="tab-pane fade">
                            <% if (albumes == null || albumes.isEmpty()) { %>
                            <h4 class="lineaAbajo"><i>No hay coincidencias</i></h4>
                            <%} else {%>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th onclick="sortTable(0, this)" class="tituloFila"><h4><b>Álbum</b></h4></th>
                                        <th onclick="sortTable(1, this)" class="tituloFila"><h4><b>Artista</b></h4></th>
                                        <th onclick="sortTable(2, this)" class="tituloFila"><h4><b>Año</b></h4></th>                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <%for (DtAlbum album : albumes) {
                                            String nombreAlb = album.getNombre();
                                            String nombreArt = album.getNombreArtista();
                                            boolean control2 = true;
                                            if (dt != null) {
                                                for (DtAlbum a : dt.getFavAlbumes()) {
                                                    if (a.getNombre().equals(nombreAlb) && a.getNombreArtista().equals(nombreArt)) {
                                                        control2 = false;
                                                    }
                                                }
                                            }

                                    %>
                                    <tr>
                                        <%if (control && control2) {%>
                                        <td>
                                            <div class="row">
                                                <div class="span">
                                                    <a style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?art=<%=album.getNombreArtista() + "&alb=" + album.getNombre()%>">
                                                        <img onmouseover="hover(this, true)" onmouseout="hover(this, false)" src="/EspotifyWeb/Imagenes/guardar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                                    </a>
                                                    <div class="span" ><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= nombreAlb + "&artista=" + nombreArt%>"><%= nombreAlb%></a></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%} else {%>
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?verAlbum=<%= nombreAlb + "&artista=" + nombreArt%>"><%= nombreAlb%></a></td>
                                            <%}%>   
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?verPerfilArt=<%= album.getNombreArtista()%>"><%= album.getNombreArtista()%></a></td>
                                        <td><%=album.getAnio()%></td>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </table>
                            <%}%>
                        </div>
                        <div id="menu3" class="tab-pane fade">
                            <% if (listas == null || listas.isEmpty()) { %>
                            <h4 class="lineaAbajo"><i>No hay coincidencias</i></h4>
                            <%} else {%>
                            <table class="table text-left">
                                <thead>
                                    <tr>
                                        <th onclick="sortTable(0, this)" class="tituloFila"><h4><b>Lista</b></h4></th>
                                        <th onclick="sortTable(1, this)" class="tituloFila"><h4><b>Creador/Género</b></h4></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DtLista lista : listas) { %>
                                        <% if (lista instanceof DtListaP) {
                                                DtListaP listaP = (DtListaP) lista;
                                                String nLista = lista.getNombre();
                                                byte[] bytes = nLista.getBytes(StandardCharsets.UTF_8);
                                                nLista = new String(bytes, StandardCharsets.ISO_8859_1);
                                                boolean control2 = true;
                                                if (dt != null) {
                                                    for (DtLista l : dt.getFavListas()) {
                                                        if (l instanceof DtListaP && l.getNombre().equals(listaP.getNombre())) {
                                                            if (((DtListaP) l).getUsuario().equals(listaP.getUsuario())) {
                                                                control2 = false;
                                                            }
                                                        }
                                                    }
                                                }
                                                if(!listaP.isPrivada()){
                                        %>
                                        <tr>
                                        <%if (control && control2) {%>
                                        <td>
                                            <div class="row">
                                                <div class="span">
                                                    <a style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?favLista=<%=nLista + "&cliente=" + listaP.getUsuario()%>">
                                                        <img onmouseover="hover(this, true)" onmouseout="hover(this, false)" src="/EspotifyWeb/Imagenes/guardar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                                    </a>
                                                    <div class="span" ><a class="link" href="/EspotifyWeb/ServletClientes?Lista=<%= nLista%>&Usuario=<%= listaP.getUsuario()%>"><%= listaP.getNombre()%></a></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%} else {%>
                                        <td><a class="link" href="/EspotifyWeb/ServletClientes?Lista=<%= nLista%>&Usuario=<%= listaP.getUsuario()%>"><%= listaP.getNombre()%></a></td>
                                            <%}%>
                                        <td><a class="link" href="/EspotifyWeb/ServletClientes?verPerfilCli=<%= listaP.getUsuario()%>"><%= listaP.getUsuario()%></a></td>
                                            <%}} else {
                                                DtListaPD listaPD = (DtListaPD) lista;
                                                String nLista = lista.getNombre();
                                                //se crea un array de bytes con la codificación que se envía en los parametros
                                                byte[] bytes = nLista.getBytes(StandardCharsets.UTF_8);
                                                // "normaliza" el texto
                                                nLista = new String(bytes, StandardCharsets.ISO_8859_1);
                                                boolean control2 = true;
                                                if (dt != null) {
                                                    for (DtLista l : dt.getFavListas()) {
                                                        if (l instanceof DtListaPD && l.getNombre().equals(listaPD.getNombre())) {
                                                            control2 = false;
                                                        }
                                                    }
                                                }
                                            %>
                                        <tr>
                                        <%if (control && control2) {%>
                                        <td>
                                            <div class="row">
                                                <div class="span">
                                                    <a style="float:left; margin-right: 5px" href="/EspotifyWeb/ServletClientes?favLista=<%=nLista%>">
                                                        <img onmouseover="hover(this, true)" onmouseout="hover(this, false)" src="/EspotifyWeb/Imagenes/guardar.png" width="20" alt="guardar" class="img-responsive imgGuardar" title="guardar"><!--Cambiar por imagen del usuario-->
                                                    </a>
                                                    <div class="span" ><a class="link" href="/EspotifyWeb/ServletClientes?Lista=<%= nLista%>"><%= listaPD.getNombre()%></a></div>
                                                </div>
                                            </div>
                                        </td>
                                        <%} else {%>
                                        <td><a class="link" href="/EspotifyWeb/ServletClientes?Lista=<%= nLista%>"><%= listaPD.getNombre()%></a></td>
                                            <%}%>
                                            <% String generoCodificado = URLEncoder.encode(listaPD.getGenero(), "UTF-8");%>
                                        <td><a class="link" href="/EspotifyWeb/ServletArtistas?consultarAlbum=<%= generoCodificado%>"><%= listaPD.getGenero()%></a></td>
                                            <%}%>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </table>
                            <%}%>
                        </div>
                    </div>
                </div>

                <div class="btn-group-vertical col-sm-2" ></div>
            </div>
        </div>
    </center>

    <jsp:include page="Pie.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>

    <script src="/EspotifyWeb/Javascript/jquery.min.js"></script>
    <script src="/EspotifyWeb/Bootstrap/js/bootstrap.min.js"></script>  
    <script src="/EspotifyWeb/Javascript/cargarDatos.js"></script>
    <table id="myTable2">

<script>
function sortTable(n, th) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  switching = true;
  table = th.parentElement.parentElement.parentElement;
  // Set the sorting direction to ascending:
  dir = "asc";
  /* Make a loop that will continue until
  no switching has been done: */
  while (switching) {
    // Start by saying: no switching is done:
    switching = false;
    rows = table.getElementsByTagName("TR");
    /* Loop through all table rows (except the
    first, which contains table headers): */
    for (i = 1; i < (rows.length - 1); i++) {
      // Start by saying there should be no switching:
      shouldSwitch = false;
      /* Get the two elements you want to compare,
      one from current row and one from the next: */
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      /* Check if the two rows should switch place,
      based on the direction, asc or desc: */
      if (dir === "asc") {
        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
          // If so, mark as a switch and break the loop:
          shouldSwitch= true;
          break;
        }
      } else if (dir === "desc") {
        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
          // If so, mark as a switch and break the loop:
          shouldSwitch= true;
          break;
        }
      }
    }
    if (shouldSwitch) {
      /* If a switch has been marked, make the switch
      and mark that a switch has been done: */
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      // Each time a switch is done, increase this count by 1:
      switchcount ++;
    } else {
      /* If no switching has been done AND the direction is "asc",
      set the direction to "desc" and run the while loop again. */
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}
</script>
</body>
</html>