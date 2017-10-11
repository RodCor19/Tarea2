/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function(){
    $('#btnCargarDP').click(function() {
        $('#btnCargarDP').html('Cargando...');
        $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletArchivos',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                cargarDatosPrueba : true
            },
            success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                alert("Se cargaron los datos de prueba correctamente");
                $('#btnCargarDP').html('Cargar datos de prueba');

                //Redirigir al inicio
                location.href = "/EspotifyWeb/ServletArtistas?Inicio=true";
            }
        });

    });
});