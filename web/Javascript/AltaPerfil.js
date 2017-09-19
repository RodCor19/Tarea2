/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function(){ 
$('#radioA').click(function(){
    $('#formArt').show();
});
$('#radioC').click(function(){
    $('#formArt').hide();
});

$('#bntAceptar').click(function(){

if( $('#radioC').is(':checked')){      
      $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletClientes',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                Registrarse : true,
                    nickname : $('#nickname').val(),
                    contrasenia : $('#contrasenia').val(),
                    nombre : $('#nombre').val(),
                    apellido : $('#apellido').val(),
                    fechanac : $('#fechanac').val(),
                    correo : $('#correo').val()
            },
            success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
               alert("Exito");
            }
        });       
    }else{      
      $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletArtistas',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                Registrarse : true,
                    nickname : $('#nickname').val(),
                    contrasenia : $('#contrasenia').val(),
                    nombre : $('#nombre').val(),
                    apellido : $('#apellido').val(),
                    fechanac : $('#fechanac').val(),
                    correo : $('#correo').val(),
                    biografia : $('#biografia').val(),
                    paginaweb : $('#paginaweb').val()
            },
            success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
               alert("Exito");
            }
        });       
    }
});

});
