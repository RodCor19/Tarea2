/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function () {
    $('#radioA').click(function () {
        $('#formArt').show();
    });
    $('#radioC').click(function () {
        $('#formArt').hide();
    });

    $('#bntAceptar').click(function () {
        var nickname = $('#nickname').val(),
                    contrasenia = $('#contrasenia').val(),
                    nombre = $('#nombre').val(),
                    apellido = $('#apellido').val(),
                    fechanac = $('#fechanac').val(),
                    correo = $('#correo').val(),
                    biografia = $('#biografia').val(),
                    paginaweb = $('#paginaweb').val();
        if(nickname !== "" && contrasenia !== "" && nombre!== "" && apellido !== "" && fechanac !== "" && correo !== ""){
        if ($('#radioC').is(':checked')) {
            
            
            $.ajax({
                type: 'POST', //tipo de request
                url: '/EspotifyWeb/ServletClientes',
                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                data: {// Parametros que se pasan en el request
                    Registrarse: true,
                    nickname: $('#nickname').val(),
                    contrasenia: $('#contrasenia').val(),
                    nombre: $('#nombre').val(),
                    apellido: $('#apellido').val(),
                    fechanac: $('#fechanac').val(),
                    correo: $('#correo').val()
                },
                success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                    alert("El Cliente ha sido registrado");
                    $('#nickname').val("");
                    $('#contrasenia').val("");  
                    $('#nombre').val("");   
                    $('#apellido').val(""); 
                    $('#fechanac').val("");
                    $('#correo').val("");
                }
            });
        } else {
            $.ajax({
                type: 'POST', //tipo de request
                url: '/EspotifyWeb/ServletArtistas',
                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                data: {// Parametros que se pasan en el request
                    Registrarse: true,
                    nickname: $('#nickname').val(),
                    contrasenia: $('#contrasenia').val(),
                    nombre: $('#nombre').val(),
                    apellido: $('#apellido').val(),
                    fechanac: $('#fechanac').val(),
                    correo: $('#correo').val(),
                    biografia: $('#biografia').val(),
                    paginaweb: $('#paginaweb').val()
                },
                success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                    alert("El Artista ha sido registrado");
                    $('#nickname').val("");
                    $('#contrasenia').val("");  
                    $('#nombre').val("");   
                    $('#apellido').val(""); 
                    $('#fechanac').val("");
                    $('#correo').val("");
                    $('#biografia').val("");     
                    $('#paginaweb').val("");
                }
            
            });
        }
    }else{
        alert("No debe haber campos vacios");
    }


    });

    $('#correo').focusout(function () {
        console.log(correo);
        var correo = $('#correo').val();
        if(correo !== ""){
        var caract = new RegExp(/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/);

        if (caract.test(correo) == false) {
            console.log(correo);
            alert("El Email es incorrecto");
            $('#correo').val("");
        } else {
            console.log(correo);
        }}
    });
        $('#fechanac').focusout(function () {
        console.log(fechanac);
        var fechanac = $('#fechanac').val();
        if(fechanac !== ""){
        var caract = new RegExp(/^([0-9]{1,2})+\-(([0-9]{1,2})+\-)+([0-9]{4})+$/);

        if (caract.test(fechanac) == false) {
            console.log(fechanac);
            alert("la fecha es incorrecta");
            $('#fechanac').val("");
        } else {
            console.log(fechanac);
        }
        var dia = fechanac.substr(0,fechanac.indexOf("-"));
        var mes = fechanac.substr(fechanac.indexOf("-")+1, (fechanac.indexOf("-", fechanac.indexOf("-")+1))-(fechanac.indexOf("-")+1));
        var anio = fechanac.substr(fechanac.indexOf("-", fechanac.indexOf("-")+1)+1);
        
        if((mes === "1" || mes === "3" ||mes === "5" ||mes === "7" ||mes === "8" ||mes === "10" ||mes === "12" ) && (dia>31)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((mes=== "4"||mes==="6"||mes==="9"||mes==="11")&&(dia>30)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((mes==="2")&&(dia>28)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((mes>12)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((anio<1900 && anio>2016)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        }
    });
    
    $('#vcontrasenia').focusout(function () {
        var contrasenia = $('#contrasenia').val();
        var vcontrasenia = $('#vcontrasenia').val();
        if(vcontrasenia !== ""){
        if(contrasenia !== vcontrasenia){
            $('#error').show();
            $('#vcontrasenia').val("");
            $('#vcontrasenia').parent().addClass("input-group has-error has-feedback");
        }else{
            $('#vcontrasenia').parent().removeClass("has-error has-feedback");
            $('#error').hide();
        }
        }
    });

});
