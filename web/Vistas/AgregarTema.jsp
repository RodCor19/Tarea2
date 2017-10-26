<%-- 
    Document   : AgregarTema
    Created on : 10/10/2017, 04:53:18 PM
    Author     : Admin
--%>

<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="webservices.WSClientes"%>
<%@page import="webservices.WSClientesService"%>
<%@page import="java.net.URL"%>
<%@page import="webservices.DtUsuario"%>
<%@page import="webservices.DtListaPD"%>
<%@page import="webservices.DtAlbum"%>
<%@page import="java.util.List"%>
<%@page import="webservices.DtListaP"%>
<%@page import="webservices.DtCliente"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%  DtCliente cliente = (DtCliente) session.getAttribute("PerfilCli"); 
            List<DtListaP> listascliente = cliente.getListas();
            List<DtAlbum> albumes = (List<DtAlbum>)session.getAttribute("todosalbumes");
            List<DtListaPD> listaspd = (List<DtListaPD>)session.getAttribute("todaslistaspd");
            List<DtListaP> listasp = (List<DtListaP>)session.getAttribute("todaslistasp");
            
            WSClientes wscli = (WSClientes)session.getAttribute("WSClientes"); 
            %>   
            <%  DtUsuario perfilUsr = (DtUsuario) session.getAttribute("Usuario");
                boolean controlSeguir = false;
                if (perfilUsr != null && perfilUsr instanceof DtCliente) {
                    if (wscli.suscripcionVigente(perfilUsr.getNickname())) {
                        controlSeguir = true;
                    }
                }
                if (controlSeguir && perfilUsr.getNickname().equals(cliente.getNickname()) && (!(cliente.getListas().isEmpty()))) {
                 
            %>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agregar Tema a Lista</title>
        <link rel="stylesheet" href="/EspotifyWeb/Bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="/EspotifyWeb/CSS/estilos.css">
    </head>
    <body>
        
        <jsp:include page="Cabecera.jsp" /> <%-- Importar la cabecera desde otro archivo .jsp --%>
        <div class="container">
            <div class="row">
                <div class="col-sm-2">
                    <p id="nickcliente0" class="hidden"><%=cliente.getNickname()%></p>
                    <h3 id="aux" style="color: green; font-weight: bold">Agregar Tema a Lista del Cliente:<br><%=cliente.getNombre() + " " + cliente.getApellido()%></h3>
                    <br><br>
                    <h3 id="aux">Elegir Lista:</h3>
                    <select id="listadelistas">
                        <option>Listas Particulares</option>
                        <%for (int i=0;i<listascliente.size();i++) { %>
                        <option><%=listascliente.get(i).getNombre()%></option>
                        <%}%>
                    </select>
                    <input type="text" placeholder="Nombre de la lista" id="nombrelista" value="Nombre de la lista" disabled="true" style="width: 80%">
                </div>
                <div class="col-sm-9">
                    <h3>Elegir de donde se desea agregar tema:</h3>
                    <div class="radio">
                       <label><input type="radio" id="radioalbum" name="optradio">Album</label>
                    </div>
                    <div class="radio">
                      <label><input type="radio" id="radiolpd" name="optradio">Lista Por Defecto</label>
                    </div>
                    <div class="radio">
                      <label><input type="radio" id="radiolp" name="optradio">Lista Particular</label>
                      <br><br>
                      <div class="text-left">
                          <select id="listaalbumes" style="visibility: hidden ">
                          <%for (int i=0;i<albumes.size();i++) { %>
                          <option><%=albumes.get(i).getNombre()%> - <%=albumes.get(i).getNombreArtista()%> </option>
                        <%}%>
                      </select>
                      </div>
                      <div class="text-left">
                          <select id="listalistaspd" style="visibility: hidden;">
                          <%for (int i=0;i<listaspd.size();i++) { %>
                        <option><%=listaspd.get(i).getNombre()%></option>
                        <%}%>
                      </select>
                      </div>
                      <div class="text-left">
                      <select id="listalistasp" style="visibility: hidden ">
                          <%for (int i=0;i<listasp.size();i++) { %>
                          <option><%=listasp.get(i).getNombre()%> - <%=listasp.get(i).getUsuario()%></option>
                        <%}%>
                      </select>
                      </div>
                    </div>
                    <div id="listatemas">
                        
                    </div>
                </div>

        </div>
        <script src="../Javascript/jquery.min.js"></script>
        <script src="../Bootstrap/js/bootstrap.min.js"></script>
        <script src="../Javascript/AgregarTemaLista.js"></script>
            
    </body>
</html>
<%}
else{%>
    <script>alert("No puedes ingresar aquí");</script>
    <meta http-equiv="refresh" content="0; URL=/EspotifyWeb/ServletArtistas?Inicio=true">
<%}%>
        
    
