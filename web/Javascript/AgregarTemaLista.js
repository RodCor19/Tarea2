/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function chooser() {
    var botones = document.getElementsByName("opt");
    var n = botones.length;
    for (var i = 0; i < n; i++) {
        if (botones[i].checked) {
            var elegido = botones[i].value;
        }
    }
    if ($('#nombrelista').val() === "Nombre de la lista") {
        alert("Debes elegir una lista del cliente a la cual agregar el tema");
    } else {
        var listaelegida = $('#nombrelista').val();
        var data = elegido.split(" - ");
        var radalbum = document.getElementById("radioalbum");
        var radlistasp = document.getElementById("radiolp");
        var radlistaspd = document.getElementById("radiolpd");
        if (radalbum.checked) {
            var mensaje = ("Agregar Tema: ".concat(data[0])).concat("\r\nDel Album: ").concat(data[1]).concat("\r\nDel Artista: ").concat(data[2]).concat("\r\nEn La Lista: ").concat(listaelegida);
            var r = confirm(mensaje);
            if (r === true) {
                $.ajax({
                    type: 'POST', //tipo de request
                    url: '../ServletClientes',
                    dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                    data: {// Parametros que se pasan en el request
                        AgregarTemaNombreTema: data[0],
                        AgregarTemaNombreAlbum: data[1],
                        AgregarTemaNombreArtista: data[2],
                        AgregarTemaListaElegida: listaelegida
                    },
                    success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                        if (data === 'no') {
                            alert("Esta Lista ya tiene este tema");
                        } else {
                            var nickaux = document.getElementById("nickcliente0").innerHTML;
                            $.ajax({
                                type: 'POST', //tipo de request
                                url: '../ServletClientes',
                                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                                data: {// Parametros que se pasan en el request
                                    Inicio: true
                                },
                                success: function (data) {
                                    window.location.href = '/EspotifyWeb/ServletArtistas?Inicio=true';
                                }
                            });

                        }
                    }
                });
            }
        }
        if (radlistasp.checked) {
            var mensaje = ("Agregar Tema: ".concat(data[0])).concat("\r\nDe La Lista Privada: ").concat(data[2]).concat("\r\nDel Usuario: ").concat(data[1]).concat("\r\nEn La Lista: ").concat(listaelegida);
            var r = confirm(mensaje);
            if (r === true) {
                $.ajax({
                    type: 'POST', //tipo de request
                    url: '../ServletClientes',
                    dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                    data: {// Parametros que se pasan en el request
                        AgregarTemaNombreTema: data[0],
                        AgregarTemaNombreAlbum: data[3],
                        AgregarTemaNombreArtista: data[4],
                        AgregarTemaListaElegida: listaelegida
                    },
                    success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                        if (data === 'no') {
                            alert("Esta Lista ya tiene este tema");
                        } else {
                            var nickaux = document.getElementById("nickcliente0").innerHTML;
                            $.ajax({
                                type: 'POST', //tipo de request
                                url: '../ServletClientes',
                                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                                data: {// Parametros que se pasan en el request
                                    Inicio: true
                                },
                                success: function (data) {
                                    window.location.href = '/EspotifyWeb/ServletArtistas?Inicio=true';
                                }
                            });

                        }
                    }
                });
            }
        }
        if (radlistaspd.checked) {
            var mensaje = ("Agregar Tema: ".concat(data[0])).concat("\r\nDe La Lista Pública: ").concat(data[1]).concat("\r\nEn La Lista: ").concat(listaelegida);
            var r = confirm(mensaje);
            if (r === true) {
                $.ajax({
                    type: 'POST', //tipo de request
                    url: '../ServletClientes',
                    dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                    data: {// Parametros que se pasan en el request
                        AgregarTemaNombreTema: data[0],
                        AgregarTemaNombreAlbum: data[2],
                        AgregarTemaNombreArtista: data[3],
                        AgregarTemaListaElegida: listaelegida
                    },
                    success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                        if (data === 'no') {
                            alert("Esta Lista ya tiene este tema");
                        } else {
                            var nickaux = document.getElementById("nickcliente0").innerHTML;
                            $.ajax({
                                type: 'POST', //tipo de request
                                url: '../ServletClientes',
                                dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                                data: {// Parametros que se pasan en el request
                                    Inicio: true
                                },
                                success: function (data) {
                                    window.location.href = '/EspotifyWeb/ServletArtistas?Inicio=true';
                                }
                            });

                        }

                    }
                });
            }
        }
    }
}

$(document).ready(function () {



    $('#listalistaspd').change(function () {
        var e = document.getElementById("listalistaspd");
        var nomgen = e.options[e.selectedIndex].text;
        $.ajax({
            type: 'POST', //tipo de request
            url: '../ServletArtistas',
            dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data: {// Parametros que se pasan en el request
                NombreElementoAgregarTema: nomgen,
                TipoAgregarTema: 2
            },
            success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
            $("#listatemas").load("/EspotifyWeb/Vistas/tablatemas.jsp");
            }
        });
        
    });
    $('#listalistasp').change(function () {
        var e = document.getElementById("listalistasp");
        var nomgen = e.options[e.selectedIndex].text;
        var datos = nomgen.split(" - ");
        $.ajax({
            type: 'POST', //tipo de request
            url: '../ServletArtistas',
            dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data: {// Parametros que se pasan en el request
                NombreElementoAgregarTema: datos[0],
                NombreCreadorAgregarTema: datos[1],
                TipoAgregarTema: 1
            },
            success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta

                $("#listatemas").load("/EspotifyWeb/Vistas/tablatemas.jsp");
            }
        });
    });
    $('#listaalbumes').change(function () {
        var e = document.getElementById("listaalbumes");
        var nomgen = e.options[e.selectedIndex].text;
        var datos = nomgen.split(" - ");
        $.ajax({
            type: 'POST', //tipo de request
            url: '../ServletArtistas',
            dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data: {// Parametros que se pasan en el request
                NombreElementoAgregarTema: datos[0],
                NombreCreadorAgregarTema: datos[1],
                TipoAgregarTema: 0
            },
            success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                $("#listatemas").load("/EspotifyWeb/Vistas/tablatemas.jsp");
            }
        });

    });
    $('#listadelistas').change(function () {
        var e = document.getElementById("listadelistas");
        var nomgen = e.options[e.selectedIndex].text;
        var l = document.getElementById("nombrelista");
        if (nomgen !== "Listas Particulares") {
            l.value = nomgen;
        }
    });
    $('#radioalbum').click(function () {
        var lial = document.getElementById("listaalbumes");
        var lipd = document.getElementById("listalistaspd");
        var lip = document.getElementById("listalistasp");
        lip.style.visibility = 'hidden';
        lipd.style.visibility = 'hidden';
        lial.style.visibility = 'visible';
        var botones = document.getElementsByName("opt");
        var n = botones.length;
        for (var i = 0; i < n; i++) {
            botones[i].disabled = true;
        }
    });
    $('#radiolpd').click(function () {
        var lial = document.getElementById("listaalbumes");
        var lipd = document.getElementById("listalistaspd");
        var lip = document.getElementById("listalistasp");
        lip.style.visibility = 'hidden';
        lipd.style.visibility = 'visible';
        lial.style.visibility = 'hidden';
        var botones = document.getElementsByName("opt");
        var n = botones.length;
        for (var i = 0; i < n; i++) {
            botones[i].disabled = true;
        }
    });
    $('#radiolp').click(function () {
        var lial = document.getElementById("listaalbumes");
        var lipd = document.getElementById("listalistaspd");
        var lip = document.getElementById("listalistasp");
        lip.style.visibility = 'visible';
        lipd.style.visibility = 'hidden';
        lial.style.visibility = 'hidden';
        var botones = document.getElementsByName("opt");
        var n = botones.length;
        for (var i = 0; i < n; i++) {
            botones[i].disabled = true;
        }
    });

});