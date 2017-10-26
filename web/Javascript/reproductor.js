/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function get_next(pos){
    var audios = document.getElementById("music");
    var repr = document.getElementById("aurepr");
    var length = audios.rows.length;
    var selected = audios.getElementsByClassName("selected");
    if (selected.length > 0){
        index = selected[0].rowIndex;
        next = Math.abs((index + pos) % length);
        if (next === 0) //para excluir el titulo
            next += 1;
        play(audios.rows[next]);
    };
};
function set_play(value,lab_title){
    var trackData = value.split("|"); 
    var title = document.getElementById("auTitle");
    title.textContent = lab_title;
    var image = document.getElementById("trackImage");
    image.src = trackData[1];
};
function play(row){
    var repr = document.getElementById("aurepr"),
        trackData = row.id.split("|"),
        label = row.getElementsByClassName("song")[0].innerText;
    repr.src = trackData[0];
    set_play(row.id, label);
    var audios = document.getElementById("music");
    for (var i=1; i<audios.rows.length; i++){
        audios.rows[i].style.backgroundColor = "#262626";
        audios.rows[i].classList.remove("selected");
    }
    row.style.backgroundColor = '#3f3f3f';
    row.classList.add("selected");
    repr.play();
};

function mostrarOcultarTemas(boton){
    if(boton.innerHTML === "Ver temas"){
        boton.innerHTML = "Ocultar temas";
        boton.classList.remove("btnVerTemas");
        boton.classList.add("btnOcultarTemas");
    }else{
        boton.innerHTML = "Ver temas";
        boton.classList.remove("btnOcultarTemas");
        boton.classList.add("btnVerTemas");
    }
}


function reproducirAlbum(album, artista){
    $.ajax({
        type : 'POST', //tipo de request
        url : '/EspotifyWeb/ServletArchivos',
        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
        data:{ // Parametros que se pasan en el request
            reproducirAlbum : album,
            artista: artista
        },
        success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
            $('#divReproductor').load("/EspotifyWeb/Vistas/reproductor.jsp");
//            $('.reproducirTema').click(); //reproducir el tema seleccionaro, click
//            location.href = "/EspotifyWeb/Vistas/reproductor.jsp";
        }
    });
}

function reproducirTema(tema, album, artista){
    $.ajax({
        type : 'GET', //tipo de request
        url : '/EspotifyWeb/ServletArchivos',
        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
        data:{ // Parametros que se pasan en el request
            reproducirAlbum : album,
            artista: artista,
            tema : tema
        },
        success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
            $('#divReproductor').load("/EspotifyWeb/Vistas/reproductor.jsp");
        }
    });
}

function reproducirTemaLista(tema, lista, creador, genero){
    /* Distinguir entre listas particulares y por defecto */
    if(creador !== null){
        $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletArchivos',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                reproducirLista : lista,
                creador: creador,
                tema : tema
            },
            success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                $('#divReproductor').load("/EspotifyWeb/Vistas/reproductor.jsp");
            }
        });
    }else{
        $.ajax({
            type : 'POST', //tipo de request
            url : '/EspotifyWeb/ServletArchivos',
            dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data:{ // Parametros que se pasan en el request
                reproducirLista : lista,
                genero: genero,
                tema : tema
            },
            success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                $('#divReproductor').load("/EspotifyWeb/Vistas/reproductor.jsp");
            }
        });
    }
}

function cerrarRep(rep){
    var audioRep = $("#aurepr")[0];
    audioRep.pause();
    rep.style.display = 'none';
    $.ajax({
        type : 'POST', //tipo de request
        url : '/EspotifyWeb/ServletArchivos',
        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
        data:{ // Parametros que se pasan en el request
            cerrarReproductor : true
        },
        success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
            
        }
    });
}

function reproducirListaP(lista, cliente){
    $.ajax({
        type : 'POST', //tipo de request
        url : '/EspotifyWeb/ServletArchivos',
        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
        data:{ // Parametros que se pasan en el request
            reproducirLista : lista,
            creador: cliente
        },
        success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
            $('#divReproductor').load("/EspotifyWeb/Vistas/reproductor.jsp");
//            $('.reproducirTema').click(); //reproducir el tema seleccionaro, click
//            location.href = "/EspotifyWeb/Vistas/reproductor.jsp";
        }
    });
}

function reproducirListaPD(lista, genero){
    $.ajax({
        type : 'POST', //tipo de request
        url : '/EspotifyWeb/ServletArchivos',
        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
        data:{ // Parametros que se pasan en el request
            reproducirLista : lista,
            creador: genero
        },
        success : function(){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
            $('#divReproductor').load("/EspotifyWeb/Vistas/reproductor.jsp");
//            $('.reproducirTema').click(); //reproducir el tema seleccionaro, click
//            location.href = "/EspotifyWeb/Vistas/reproductor.jsp";
        }
    });
}


