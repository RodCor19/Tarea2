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
    
    
    //Borrar para la tarea 3
    
    $.ajax({
        type : 'POST', //tipo de request
        url : 'ServletArtistas',
        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
        data:{ // Parametros que se pasan en el request
            listarArtistas : true,
            listarGeneros : true
        },
        success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
           $('#listaArtGen').load('/EspotifyWeb/Vistas/listaArtistas.jsp');
        }
    });
    
    //
    
    //evento click del elemento con el id '#...'
    $('#btnArtistas').click(function() {
        $('#btnArtistas').removeClass("opcionNoSelec");
        $('#btnArtistas').addClass("opcionSelec");
        $('#btnGeneros').removeClass("opcionSelec");
        $('#btnGeneros').addClass("opcionNoSelec");
        
        
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
        $('#btnGeneros').removeClass("opcionNoSelec");
        $('#btnGeneros').addClass("opcionSelec");
        $('#btnArtistas').removeClass("opcionSelec");
        $('#btnArtistas').addClass("opcionNoSelec");
        
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

function publicarLista (nombLista) { 
      $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletClientes',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                publicarLista : nombLista
            },
            success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
              $('#btnPublicar').hide();
            }
        }); 
       
   }


