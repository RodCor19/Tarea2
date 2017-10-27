/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function(){
    var global;
    var hola = [];
    
if (document.getElementById("checkurl").checked === true){
        document.getElementById("elegircancion").disabled = true;
        document.getElementById("url").disabled = false;
    }
if (document.getElementById("checkurl").checked === false){
        document.getElementById("elegircancion").disabled = false;
        document.getElementById("url").disabled = true;
    }    
    
$('#aceptar').click(function(e) {
        e.preventDefault();
        var photo = document.getElementById("elegirimagen");
        var listagen = $("#listageneros li");
        var tabla = document.getElementById("mitabla");
        var nombre = document.getElementById("nombrealbum").value;
        var anio = document.getElementById("anioalbum").value;
        if(anio < 1800 || anio >2017)
            alert("Año Inválido");
        else{
            if (tabla.rows.length === 1){
                alert("No se ha agregado ningun tema");
                e.preventDefault();
            }else{
                if (listagen.length === 0){
                    alert("No se ha agregagado ningun género");
                    e.preventDefault();
                }else{
                    if (nombre ===""){
                        alert("Nombre vacío");
                        e.preventDefault();
                    }else{
//                        if (photo.value !== ""){
//                            $("#formcrear").submit();
//                            photo = photo.files[0].name;
//                        }else{
//                            photo = "";
//                        }
//                        alert(photo);
                        var temas = [];
                        var generos = [];
                        for (var x=1, n = tabla.rows.length; x<n; x++){
                            var person = {nombre:tabla.rows[x].cells[0].innerHTML,orden:tabla.rows[x].cells[1].innerHTML,duracion:tabla.rows[x].cells[2].innerHTML,Archivo_Url:tabla.rows[x].cells[3].innerHTML};
                            temas.push(person); 
                        }
                        var x = document.getElementsByTagName("li");
                        var i;
                        for (i = 0; i < x.length; i++){
                            generos.push(x[i].innerHTML);
                        }
                         
                        $.ajax({
                        type : 'POST', //tipo de request
                        url : '/EspotifyWeb/ServletArtistas',
                        dataType : 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
                        data:{ // Parametros que se pasan en el request
                            //NombreAlbum : $('#nombrealbum').val()
                            //NombreAlbum : hola,
                            NombreAlbum : nombre,
                            anioalbum: anio,
                            json:JSON.stringify(temas),
                            generos: generos
//                            foto : photo
                        },
                        success : function(data){ //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                           if (data==='nomRepetido'){
                               alert("Este Artista ya tiene un album con ese nombre");
//                               e.preventDefault();
                           }
                           else{
                                                             
                               window.location.replace('/EspotifyWeb/Vistas/AlbumIngresado.jsp');
                               $("#formcrear").submit(); 
                           }
                        }
                        });
                        
                    }
                }
            }
        }
    });
    
    
$('#aceptartema').click(function(e){
    e.preventDefault();
    var archivo = "";
    if(document.getElementById("elegircancion").value !== ""){
        archivo = document.getElementById("elegircancion").files[0].name;
    }
    var url = document.getElementById("url").value;
    var nombre = document.getElementById("nomtema").value;
    var orden = document.getElementById("ordentema");
    var min = parseInt(document.getElementById("sel1").value);
    var sec = parseInt(document.getElementById("sel2").value);
    var tabla = document.getElementById("mitabla");
    var x = 0;
    var z = 0;
    nombre = ConvertirCadena(nombre);
    for (var r = 1, n = tabla.rows.length; r < n; r++) {
                if (tabla.rows[r].cells[0].innerHTML === nombre)
                    x = 1;
        }
    for (var y = 1, n = tabla.rows.length; y < n; y++) {
                if (tabla.rows[y].cells[3].innerHTML === archivo)
                    z = 1;
        }
   if (!((orden.value)==(tabla.rows.length))){
        alert("Número de orden incorrecto");
    }
    else{
        if (sec<30 && min==0)
            alert("Duración mínima 30 segundos");
        else{
            if ((archivo==="" && url==="") || (document.getElementById("checkurl").checked === true && url==="") || (document.getElementById("checkurl").checked === false && archivo==="") ){
                alert("Archivo o Url vacío");
            }
            else{
                if (nombre ==="" || x===1 ){
                    alert("Nombre de tema vacío ó ya existente dentro del album");
                    }
                else{
                    if ((z == 1) && document.getElementById("checkurl").checked === false){
                        alert("El Archivo elegido ya esta asociado a otro tema del album");
                    }
                    else{
                        //document.getElementById["myForm"].action = "subir.jsp";
                        var row = tabla.insertRow(tabla.rows.length);
                        var cell1 = row.insertCell(0);
                        var cell2 = row.insertCell(1);
                        var cell3 = row.insertCell(2);
                        var cell4 = row.insertCell(3);
                        cell1.innerHTML = nombre;
                        cell2.innerHTML = orden.value;
                        cell3.innerHTML = min + ":" + sec;
                        if (document.getElementById("checkurl").checked === true){
                            cell4.innerHTML = url;
//                            alert("url");
                        }else{
                            cell4.innerHTML = archivo;
                            $("#myForm").submit();
//                            alert("arch");
                        }
                        $('#modal').modal('hide');
                        document.getElementById("elegircancion").value = "";
                        document.getElementById("url").value = "";
                        document.getElementById("nomtema").value = "";
                        document.getElementById("ordentema").value = "";
                        document.getElementById("sel1").value = "0";
                        document.getElementById("sel2").value = "0";
                    }
                }
            }
        }
    }
});
$('#cancelartema').click(function(){
   document.getElementById("elegircancion").value = "";
   document.getElementById("url").value = "";
   document.getElementById("nomtema").value = "";
   document.getElementById("ordentema").value = "";
   document.getElementById("sel1").value = "0";
   document.getElementById("sel2").value = "0";
});
$('#checkurl').change(function(){
    if (document.getElementById("checkurl").checked === true){
        document.getElementById("elegircancion").disabled = true;
        document.getElementById("url").disabled = false;
    }
    if (document.getElementById("checkurl").checked === false){
        document.getElementById("elegircancion").disabled = false;
        document.getElementById("url").disabled = true;
    }
});

$('#eliminargen').click(function(){
    var lista = document.getElementById('listageneros');
    lista.innerHTML = '';

});

$('#selectgenero').change(function(){
    var e = document.getElementById("selectgenero");
    var nomgen = e.options[e.selectedIndex].text;
    if (nomgen!=="Géneros"){
        var lista = document.getElementById("listageneros");
        var li = document.createElement("li");
        li.appendChild(document.createTextNode(nomgen));
        var x = document.getElementsByTagName("li");
        var i;
        var h;
        for (i = 0; i < x.length; i++){
            if (x[i].innerHTML === nomgen){
                alert("Género ya seleccionado");
                h = 'si';
            }
        }
        if (h!=='si')
            lista.appendChild(li);
    }
});
function ConvertirCadena(hola) {
    var listapalabras = hola.split(" ");
    var cadena = "";
    for (var x=0 , h = listapalabras.length; x < h ; x++){
    	var j = listapalabras[x];
        var j = j.toLowerCase();
        j = j.substring(0, 1).toUpperCase() + j.substring(1);
        if (x==0){
        	cadena = cadena + j;
            }
        else{
        	cadena = cadena + " " + j;
        	}
        }
    return cadena;
}
function dividirstring(cadena){
    var inicio = 0;
    var fin = 1970000;
    
    do {
        var cad = cadena.substring(inicio,fin);
        hola.push(cad);
        inicio = inicio+1970000;
        fin = fin+1970000;
        alert(cad.length);
        }while(inicio < cadena.length);
}

$("#elegirimagen").change(function(){
    var x = document.getElementById("elegirimagen");
    if (x.files && x.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#imgalbum').attr('src', e.target.result);
            //global = e.target.result;
            //global = global.match(/,(.*)$/)[1];
            //document.getElementById("imagedata").innerHTML = global;
            //alert(global.length);
        };
        reader.readAsDataURL(x.files[0]);
    }
});
$("#elegircancion").change(function(){
    var x = document.getElementById("elegircancion");
    if (x.files && x.files[0]) {
        var reader = new FileReader();
        
        reader.onload = function (e) {
            //global = e.target.result;
            //global = global.match(/,(.*)$/)[1];
            //alert(global.length);
            //dividirstring(global);
            //global = global.substring(0, 1970000);
            //document.getElementById("imagedata").innerHTML = global;
            //alert(global.length);
            //alert(global);
        };
        reader.readAsDataURL(x.files[0]);
    }
});
});

