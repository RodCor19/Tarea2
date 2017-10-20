<%-- 
    Document   : Pie
    Created on : 22/09/2017, 01:15:44 PM
    Author     : Kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<footer class="container-fluid text-center" style="margin-bottom: 5px; margin-top: 5px;">
    <div class="row">
<!--    <div class="col-md-4">
            <main>
            <audio controls="controls">
                <source src="\EspotifyWeb\Imagenes\Linkin Park - Numb Lyrics [HQ] [HD].mp3" type="audio/mpeg">
                <source src="\EspotifyWeb\Imagenes\02 Linkin Park - Dont Stay.mp3" type="audio/mpeg">
                Your browser does not support the audio element.
            </audio>
            </main>
        </div>-->
        <div class="col-md-4">
            <!-- Solo muestra el mensaje si es un cliente el que inicio sesion -->
            <%-- <% if(session.getAttribute("Usuario") != null && session.getAttribute("Usuario") instanceof DtCliente ){ %>
            <a class="link" href="/EspotifyWeb/ServletClientes?contratarSuscripcion=true">¿No tienes suscripción? Haz click para obtener una</a>
            <%}%> --%>
        </div>
        <div class="col-md-4">
            
        </div>
        <div class="col-md-4">
            <button id="btnCargarDP" class="btn btn-primary">Cargar datos de prueba</button>
        </div>
    </div>
</footer>
