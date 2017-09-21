/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function artSeleccionado(elemento, opcion){
    if(opcion === true){
        var img = elemento.parentNode.querySelector("img");
        img.style.borderColor='#0080FF';
    }else{
        var img = elemento.parentNode.querySelector("img");
        img.style.borderColor='';
    }
}
$(document).ready(function(){   
    
    //Por defecto muestra seleccionado el botón artistas
    $('#btnGeneros').css("background-color","");
    $('#btnGeneros').css("color","");        
    $('#btnArtistas').css("background-color","#343333");
    $('#btnArtistas').css("color","#1ED760");
    
    //evento click del elemento con el id '#...'
    $('#btnArtistas').click(function() {
        //Cambiar colores de los botones
        $('#btnGeneros').css("background-color","");
        $('#btnGeneros').css("color","");        
        $('#btnArtistas').css("background-color","#343333");
        $('#btnArtistas').css("color","#1ED760");
        
        
        $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletArtistas',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                listarArtistas : true
            },
            success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
               $('#listaArtGen').load('/EspotifyWeb/Vistas/listaArtistas.jsp');
            }
        });
    });
    
    $('#btnGeneros').click(function() {
        //Cambiar colores de los botones
        $('#btnArtistas').css("background-color","");
        $('#btnArtistas').css("color","");                
        $('#btnGeneros').css("background-color","#343333");
        $('#btnGeneros').css("color","#1ED760");
        
        $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletArtistas',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                listarGeneros : true
            },
            success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
               $('#listaArtGen').load('/EspotifyWeb/Vistas/listaGeneros.jsp');
            }
        });
        
    });
});
