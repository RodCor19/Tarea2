<%-- 
    Document   : reproductor
    Created on : 07/10/2017, 03:43:59 PM
    Author     : Kevin
--%>

<%@page import="webservices.DtTema"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  //DtAlbum album = (DtAlbum) session.getAttribute("Album");
    List<DtTema> temas = (List<DtTema>) session.getAttribute("temasAReproducir"); 
    DtTema repTema = (DtTema) session.getAttribute("reproducirTema");
    String ImagenReproductor = null;
    if (session.getAttribute("ImagenAlbumReproductor")!=null){
        ImagenReproductor = (String) session.getAttribute("ImagenAlbumReproductor");
    }
%>
<style>
    
    contenedorReproductor{
        /*height: 100%;*/
        width: 100%;
        background-color: #262626;
        color: #999999;
        font-family: proxima_nova,"Helvetica Neue",Helvetica,Arial,sans-serif;
    }

    #trackImage{
        width: 100%;
    }

    .song{
        color: #e6e6e6;
    }

    
    #music {
        text-align: left;
        border-collapse: collapse;
    }
    #music tr{
        border-bottom: solid 1px #e6e6e6;
        line-height: 170%;
        background-color: #262626;
    }

    #music tr.last{
        border-bottom: none;
    }

    #btnPrev, #btnNext{
        width: 100%;
        color: #262626;
    }

    #aurepr{
        width: 100%;
    }
    
    .btnVerTemas{
        margin-bottom:0;
        background:#1ED760;
        color:#fff;
        border:none;
        width:100%;
    }

    .btnVerTemas:hover{
            background:#0EBF4C;
            cursor:pointer;
    }
    
    .btnOcultarTemas{
        margin-bottom:0;
        background:#FE2E2E;
        color:#fff;
        border:none;
        width:100%;
    }

    .btnOcultarTemas:hover{
            background:#F61F1F;
            cursor:pointer;
    }
    audio::-internal-media-controls-download-button {
    display:none;
    }
    audio::-webkit-media-controls-enclosure {
        overflow:hidden;
    }

    audio::-webkit-media-controls-panel {
        width: calc(100% + 30px); /* Adjust as needed */
    }
</style>
    <div id="contenedorReproductor" class="text-right">
        <button onclick="cerrarRep(this.parentElement)" class="btn btn-xs btn-danger glyphicon glyphicon-remove"></button>
        <div id="audiocontrol">
            <div id="trackImageContainer">
                <img id="trackImage" src= "/EspotifyWeb/Imagenes/albumReproductor.jpg">
            </div>
            <div id="nowPlay" class="text-center" >
                <div id="auTitle" style="padding-bottom: 5px; background: #1ED760; color: whitesmoke">---</div>
                <audio id="aurepr" preload="auto" controls controlsList="nodownload" onended="get_next(1)"></audio>
            </div>            
            <div id="auExtraControls" style="background: red">
                <div  class="col-sm-6 text-center" style="padding: 0px;">
                    <button id="btnPrev" class="ctrlbtn" onclick="get_next(-1);">
                        <i class="glyphicon glyphicon-step-backward" aria-hidden="true"></i>
                    </button>
                </div>
                <div  class="col-sm-6 text-center" style="padding: 0px;">
                    <button id="btnNext" class="ctrlbtn" onclick="get_next(1);">
                        <i class="glyphicon glyphicon-step-forward" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
        </div>
        <button class="btnVerTemas" data-toggle="collapse" data-target="#mostrarTemas" onclick="mostrarOcultarTemas(this)">Ver temas</button>
        <div id="mostrarTemas" class="collapse">
            <table id="music" width="100%">  
                <thead>
                    <tr>
                        <th width="5" style="color: #e6e6e6; padding-left: 3px"><strong>#</strong></th>
                        <th width="75" style="color: #e6e6e6"><strong>Tema</strong></th>
                    </tr>
                </thead>
                <tbody style="padding-left: 5px;">
                    <%  for (DtTema tema : temas) { 
                            //String cargarImagen = "/EspotifyWeb/ServletArchivos?tipo=imagen&ruta="+album.getRutaImagen();
                            //if(album.getRutaImagen() == null){ //Si no tiene imagen se carga una por defecto
                            
                            String cargarImagen = "/EspotifyWeb/Imagenes/albumReproductor.jpg";
                            if (ImagenReproductor!=null)
                                cargarImagen = "/EspotifyWeb/ServletArchivos?tipo=imagen&ruta=" + ImagenReproductor;
                           // }
                            if(tema.getArchivo() != null){
                                boolean controlRepTema = false;
                                if(repTema!=null && repTema.getArchivo() != null && repTema.getArchivo().equals(tema.getArchivo())){
                                    controlRepTema = true;
                                }
                    %>
                    <tr <%if(controlRepTema){%>class="reproducirTema"<%}%> id="/EspotifyWeb/ServletArchivos?tipo=audio&ruta=<%= tema.getArchivo() %>|<%= cargarImagen %>" onclick="play(this)">
                    <%}else{
                        boolean controlRepTema = false;
                        if(repTema!=null && repTema.getDireccion() != null && repTema.getDireccion().equals(tema.getDireccion())){
                            controlRepTema = true;
                        }%>
                    <tr <%if(controlRepTema){%>class="reproducirTema"<%}%> id="/EspotifyWeb/ServletArchivos?tipo=audio&direccion=<%= tema.getDireccion() %>|<%= cargarImagen %>" onclick="play(this)">
                    <%}%>
                    <td style="padding-left: 3px; color: #e6e6e6;"><%= tema.getOrden() %></td>
                        <td class="song"><%= tema.getNombre()+" - "+tema.getNomartista() %></td>
                    </tr>
                    <%       
                        }
                    //Se elimina porque ya se cargo el album y se reproducio el tema por defecto
                    session.removeAttribute("reproducirTema"); %>
                </tbody>      
            </table>
        </div>
    </div> 
    <script>$('.reproducirTema').click(); //reproducir el tema seleccionaro, click</script>


