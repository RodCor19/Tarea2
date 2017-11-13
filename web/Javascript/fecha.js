/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function () {
    
    var fechac = document.getElementsByClassName("fechalista").value.split("-");
    
    $('#FechaC').click(function(){
            var swapped;
            do {
                swapped = false;
                for (var i = 0; i < fechac.length - 1; i++) {
                    if (fechac[i] > fechac[i + 1]) {
                        var temp = fechac[i];
                        fechac[i] = fechac[i + 1];
                        fechac[i + 1] = temp;
                        swapped = true;
                    }
                }
            } while (swapped);        
                
    });

        
});
    
    
    

