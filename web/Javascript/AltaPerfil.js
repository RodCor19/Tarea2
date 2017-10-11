/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function () {
    var glo1 = 1;
    var glo0 = 1;

    $('#radioA').click(function () {
        $('#formArt').show();
    });
    $('#radioC').click(function () {
        $('#formArt').hide();
    });
    
    $('#bntAceptar').click(function () {
        var photo = document.getElementById("elegirimagen");
        if (photo.value !== "")
            $("#formcrear").submit();
    });
    

    $('#bntAceptar').click(function () {
        var nickname = $('#nickname').val(),
                    contrasenia = sha1($('#contrasenia').val()),
                    vcontrasenia = sha1($('#vcontrasenia').val()),
                    nombre = $('#nombre').val(),
                    apellido = $('#apellido').val(),
                    fechanac = $('#fechanac').val(),
                    correo = $('#correo').val(),
                    //biografia = $('#biografia').val(),
                    //paginaweb = $('#paginaweb').val(),
                    photo = "";
        if(document.getElementById("elegirimagen").value !== ""){
            photo = document.getElementById("elegirimagen").files[0].name;
        }
        if (contrasenia === vcontrasenia){
        if(nickname !== "" && $('#contrasenia').val() !== "" && nombre!== "" && apellido !== "" && fechanac !== "" && correo !== ""){
//        if (photo.value !== "")
//            $("#formcrear").submit();
        if ($('#radioC').is(':checked')) {
            $.ajax({
                type: 'POST', //tipo de request
                url: '/EspotifyWeb/ServletClientes',
                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                data: {// Parametros que se pasan en el request
                    Registrarse: true,
                    nickname: nickname,
                    contrasenia: contrasenia,
                    nombre: nombre,
                    apellido: apellido,
                    fechanac: fechanac,
                    correo: correo,
                    foto: photo
                },
                success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                    if (data==='si'){	//aca con el data que devuelve compruebo si existe o no y muestro el alert en la página
                        alert("el nickname y/o correo ya esta en uso");
                    }
                    if (data==='no'){
                    alert("El Cliente ha sido registrado");
                        $.ajax({
                            type: 'POST', //tipo de request
                            url: '/EspotifyWeb/ServletArtistas',
                            dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                            data: {// Parametros que se pasan en el request
                                Join: $('#nickname').val(),
                                Contrasenia: contrasenia
                            },
                            success: function (data) {
                                window.location.href = "/EspotifyWeb/ServletArtistas?Inicio=true";
                            }
                        });
                    }
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
                    contrasenia: contrasenia,
                    nombre: $('#nombre').val(),
                    apellido: $('#apellido').val(),
                    fechanac: $('#fechanac').val(),
                    correo: $('#correo').val(),
                    biografia: $('#biografia').val(),
                    paginaweb: $('#paginaweb').val(),
                    foto: photo
                },
                success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                    if (data==='si'){	//aca con el data que devuelve compruebo si existe o no y muestro el alert en la página
                        alert("el nickname y/o correo ya esta en uso");
                    }
                    if (data==='no'){
                        alert("El Artista ha sido registrado");          
                        $.ajax({
                            type: 'POST', //tipo de request
                            url: '/EspotifyWeb/ServletArtistas',
                            dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                            data: {// Parametros que se pasan en el request
                                Join: $('#nickname').val(),
                                Contrasenia: contrasenia
                            },
                            success: function (data) {
                                window.location.href = "/EspotifyWeb/ServletArtistas?Inicio=true";
                            }
                        });
                    }
                }
            });
        }
    }else{
        alert("No debe haber campos vacios");
    }
        }
        else
            alert("Las contraseñas no coinciden");
    });

    $('#correo').focusout(function () {
        console.log(correo);
        var correo = $('#correo').val();
        if(correo !== ""){
        var caract = new RegExp(/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/);

        if (caract.test(correo) === false) {
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

        if (caract.test(fechanac) === false) {
            console.log(fechanac);
            alert("la fecha es incorrecta");
            $('#fechanac').val("");
        } else {
            console.log(fechanac);
        }
        var dia = fechanac.substr(0,fechanac.indexOf("-"));
        var mes = fechanac.substr(fechanac.indexOf("-")+1, (fechanac.indexOf("-", fechanac.indexOf("-")+1))-(fechanac.indexOf("-")+1));
        var anio = fechanac.substr(fechanac.indexOf("-", fechanac.indexOf("-")+1)+1);
        
        
        if ((mes === "1" || mes === "3" ||mes === "5" ||mes === "7" ||mes === "8" ||mes === "10" ||mes === "12" || mes === "01" || mes === "03" ||mes === "05" ||mes === "07" ||mes === "08" ) && (dia>31)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((mes=== "4"||mes==="6"||mes==="9"||mes==="11" || mes=== "04" || mes==="06"||mes==="09")&&(dia>30)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((mes==="2" || mes==="02")&&(dia>28)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((mes>12 || mes <1)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        if((anio<1900 || anio>2016)){
            alert("El formato de la fecha es incorrecto");
            $('#fechanac').val("");
        }
        }
    });
    
    $('#correo').focusout(function () {
        var nick = document.getElementById("correo");
        var boton = document.getElementById("bntAceptar");
        $.ajax({
                type: 'POST', //tipo de request
                url: '/EspotifyWeb/ServletArtistas',
                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                data: {// Parametros que se pasan en el request
                    correoenuso: nick.value
                },
                success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                    if (data==='si'){	//aca con el data que devuelve compruebo si existe o no y muestro el alert en la página
                        nick.style.backgroundColor = "red";
                        nick.style.color = "white";
                        boton.disabled = true;
                        glo1 = 0;
                    }
                    if (data==='no'){
                        nick.style.backgroundColor = "white";
                        nick.style.color = "black";
                        glo1 = 1;
                        if (glo0===1 && glo1===1){
                            boton.disabled = false;
                        }
                    }
               }
            });
        
    });
    
    $('#nickname').focusout(function () {
        var nick = document.getElementById("nickname");
        var boton = document.getElementById("bntAceptar");
        $.ajax({
                type: 'POST', //tipo de request
                url: '/EspotifyWeb/ServletArtistas',
                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                data: {// Parametros que se pasan en el request
                    nickenuso: nick.value
                },
                success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                    if (data==='si'){	//aca con el data que devuelve compruebo si existe o no y muestro el alert en la página
                        nick.style.backgroundColor = "red";
                        nick.style.color = "white";
                        boton.disabled = true;
                        glo0 = 0;
                    }
                    if (data==='no'){
                        nick.style.backgroundColor = "white";
                        nick.style.color = "black";
                        glo0 = 1;
                        if (glo0===1 && glo1===1){
                            boton.disabled = false;
                        }
                    }
               }
            });
        
    });
    
    $('#vcontrasenia').focusout(function () {
        var contrasenia = sha1($('#contrasenia').val());
        var vcontrasenia = sha1($('#vcontrasenia').val());
        var boton = document.getElementById("bntAceptar");
        if(vcontrasenia !== ""){
        if(contrasenia !== vcontrasenia){
             boton.disabled = true;
            $('#error').show();
            $('#vcontrasenia').val(vcontrasenia);
            $('#vcontrasenia').parent().addClass("input-group has-error has-feedback");
        }else{
            boton.disabled = false;
            $('#vcontrasenia').parent().removeClass("has-error has-feedback");
            $('#error').hide();
            
        }
        }
    });

$("#elegirimagen").change(function(){
    var x = document.getElementById("elegirimagen");
    if (x.files && x.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#imgalbum').attr('src', e.target.result);
            
        };
        reader.readAsDataURL(x.files[0]);
    }
});

});
