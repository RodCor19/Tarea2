/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function () {
    var glo1 = 1;
    var glo0 = 1;

    $('#radioA').click(function () {
        $('#opcionesArt').show();
    });
    $('#radioC').click(function () {
        $('#opcionesArt').hide();
    });
    
//    $('#bntAceptar').click(function () {
//        var photo = document.getElementById("elegirimagen");
//        if (photo.value !== "")
//            $("#formcrear").submit();
//    });
    

    $('#formRegistrarse').on("submit", function (e) {
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
                $('#contrasenia').val(contrasenia);
                $('#vcontrasenia').val(contrasenia);
        }else{
            alert("No debe haber campos vacios");
            e.preventDefault();
        }
    }else{
        alert("Las contraseñas no coinciden");
        e.preventDefault();
    }
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
    
    $('#correo').on("input", function () {
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
                        boton.disabled = true;
                        glo1 = 0;
                        $('#correo').parent().addClass("input-group has-error has-feedback");               
                    }
                    if (data==='no'){
                        glo1 = 1;
                        if (glo0===1 && glo1===1){
                            boton.disabled = false;
                        }
                        $('#correo').parent().removeClass("has-error has-feedback");     
                    }
               }
            });
        
    });
    
    $('#nickname').on("input", function () {
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
//                        nick.style.backgroundColor = "red";
//                        nick.style.color = "white";
                        boton.disabled = true;
                        glo0 = 0;
                        $('#nickname').parent().addClass("input-group has-error has-feedback");
                    }
                    if (data==='no'){
                        nick.style.backgroundColor = "white";
                        nick.style.color = "black";
                        glo0 = 1;
                        if (glo0===1 && glo1===1){
                            boton.disabled = false;
                        }
                        $('#nickname').parent().removeClass("has-error has-feedback");
                    }
               }
            });
        
    });
    
    $('#vcontrasenia').focusout(function () {
        var boton = document.getElementById("bntAceptar");
        var contrasenia = sha1($('#contrasenia').val());
        var vcontrasenia = sha1($('#vcontrasenia').val());
        if(vcontrasenia !== ""){
        if(contrasenia !== vcontrasenia){
            $('#error').show();
            $('#vcontrasenia').val("");
            $('#vcontrasenia').parent().addClass("input-group has-error has-feedback");
            boton.disabled = true;
        }else{
            $('#vcontrasenia').parent().removeClass("has-error has-feedback");
            $('#error').hide();
            boton.disabled = false;
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
