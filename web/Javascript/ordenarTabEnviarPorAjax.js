/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function ordenarTabla(columna, th) {
    var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
    switching = true;
    table = th.parentElement.parentElement.parentElement;
    // Set the sorting direction to ascending:
    dir = "asc";
    /* Make a loop that will continue until
     no switching has been done: */
    while (switching) {
        // Start by saying: no switching is done:
        switching = false;
        rows = table.getElementsByTagName("TR");
        /* Loop through all table rows (except the
         first, which contains table headers): */
        for (i = 1; i < (rows.length - 1); i++) {
            // Start by saying there should be no switching:
            shouldSwitch = false;
            /* Get the two elements you want to compare,
             one from current row and one from the next: */
            x = rows[i].getElementsByTagName("TD")[columna];
            y = rows[i + 1].getElementsByTagName("TD")[columna];
            /* Check if the two rows should switch place,
             based on the direction, asc or desc: */
            
            var textoAcomparar1 =  $(x).find(".textoAcomparar");
            if(textoAcomparar1.length === 0){
                textoAcomparar1 = x.innerHTML.toLowerCase();
            }else{
                textoAcomparar1 = $(textoAcomparar1).html().toLowerCase();
            }
            
            var textoAcomparar2 = $(y).find(".textoAcomparar");
            if(textoAcomparar2.length === 0){
                textoAcomparar2 = y.innerHTML.toLowerCase();
            }else{
                textoAcomparar2 = $(textoAcomparar2).html().toLowerCase();
            }
            
            if (dir === "asc") {
                if (textoAcomparar1 > textoAcomparar2) {
                    // If so, mark as a switch and break the loop:
                    shouldSwitch = true;
                    break;
                }
            } else if (dir === "desc") {
                if (textoAcomparar1 < textoAcomparar2) {
                    // If so, mark as a switch and break the loop:
                    shouldSwitch = true;
                    break;
                }
            }
        }
        if (shouldSwitch) {
            /* If a switch has been marked, make the switch
             and mark that a switch has been done: */
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
            // Each time a switch is done, increase this count by 1:
            switchcount++;
        } else {
            /* If no switching has been done AND the direction is "asc",
             set the direction to "desc" and run the while loop again. */
            if (switchcount === 0 && dir === "asc") {
                dir = "desc";
                switching = true;
            }
        }
    }
}
$(document).ready(function () {

    $("#mostrarmodal").modal("show");
    
    $(".enviarPorAjax").on("click", function(e){
        e.preventDefault();

        $.ajax({
            type: 'GET', //tipo de request
            url: $(this).attr("href"),
            dataType: 'text', // tipo de dato esperado en la respuesta(text, json, etc.)
            data: {// Parametros que se pasan en el request
            },
            success: function (data) { //en el success ponemos lo que queremos hacer cuando obtenemos la respuesta
                location.reload(); // se recarga la pantalla para mostrar el mensaje( en el modal)
            }
        });
    });
});


