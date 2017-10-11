<%-- 
    Document   : tablatemas
    Created on : 10/10/2017, 08:10:49 PM
    Author     : Admin
--%>

<%@page import="Logica.DtListaPD"%>
<%@page import="Logica.DtListaP"%>
<%@page import="Logica.DtAlbum"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <style>
        .modal-content{
            background-image: url("/EspotifyWeb/Imagenes/fondo3.jpg");
        }
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
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% if (request.getSession().getAttribute("TipoAgregarTema").equals("0")){%>    
        <%DtAlbum aux = (DtAlbum)request.getSession().getAttribute("ColeccionTemas");%>
        <h4  style=" border: appworkspace; color: #2b542c">Nombre Album: <%=aux.getNombre()%></h4>
        <div class="form-group">
        <table id="tablaalbumes">
            <thead>
                <tr>
                <th>Nombre Tema</th>
                <th>Album</th>
                <th>Artista</th>
                <th>Elegir</th>
                </tr>
            </thead>
            <tbody>
                <%for (int i=0;i<aux.getTemas().size();i++){%>
                <tr>
                    <td><%=aux.getTemas().get(i).getNombre()%></td>
                    <td><%=aux.getTemas().get(i).getAlbum()%></td>
                    <td><%=aux.getTemas().get(i).getArtista()%></td>
                    <td><input type="radio" name="opt" value="<%=aux.getTemas().get(i).getNombre()+" - "+aux.getTemas().get(i).getAlbum()+" - "+aux.getTemas().get(i).getArtista()%>" onclick="chooser();"></td>
                </tr>
                <%}%>
            </tbody>
        </table>
        </div>
            <%}
        if (request.getSession().getAttribute("TipoAgregarTema").equals("1")){%>
        <%DtListaP aux = (DtListaP)request.getSession().getAttribute("ColeccionTemas");%>
        <h4  style=" border: appworkspace; color: #2b542c">Nombre Lista: <%=aux.getNombre()%></h4>
        <div class="form-group">
        <table id="tablalistasp">
            <thead>
                <tr>
                <th>Nombre Tema</th>
                <th>Propietario</th>
                <th>Elegir</th>
                </tr>
            </thead>
            <tbody>
                <%for (int i=0;i<aux.getTema().size();i++){%>
                <tr>
                    <td><%=aux.getTema().get(i).getNombre()%></td>
                    <td><%=aux.getUsuario()%></td>
                    <td><input type="radio" name="opt" value="<%=aux.getTema().get(i).getNombre()+" - "+aux.getUsuario()+" - "+aux.getNombre()+" - "+aux.getTema().get(i).getAlbum()+" - "+aux.getTema().get(i).getNomartista()%>" onclick="chooser();"></td>
                </tr>
                <%}%>
            </tbody>
        </table>
        </div>
        <%}
        if (request.getSession().getAttribute("TipoAgregarTema").equals("2")){%>
        <%DtListaPD aux = (DtListaPD)request.getSession().getAttribute("ColeccionTemas");%>
        <h4  style=" border: appworkspace; color: #2b542c">Nombre Lista: <%=aux.getNombre()%></h4>
        <div class="form-group">
        <table id="tablalistaspd">
            <thead>
                <tr>
                <th>Nombre Tema</th>
                <th>Género</th>
                <th>Elegir</th>
                </tr>
            </thead>
            <tbody>
                <%for (int i=0;i<aux.getTema().size();i++){%>
                <tr>
                    <td><%=aux.getTema().get(i).getNombre()%></td>
                    <td><%=aux.getGenero()%></td>
                    <td><input type="radio" name="opt" value="<%=aux.getTema().get(i).getNombre()+" - "+aux.getNombre()+" - "+aux.getTema().get(i).getAlbum()+" - "+aux.getTema().get(i).getNomartista()%>"  onclick="chooser();"></td>
                </tr>
                <%}%>
            </tbody>
        </table>
        </div>
        <%}%>
            
            
    <script src="../Javascript/jquery.min.js"></script>
    <script src="../Bootstrap/js/bootstrap.min.js"></script>
    <script src="../Javascript/AgregarTemaLista.js"></script>    
    </body>
</html>
