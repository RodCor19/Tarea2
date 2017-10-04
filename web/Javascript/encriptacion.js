/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function(){ 
    $('#boton').click(function(){
        var input_pass = document.getElementById("pass");
        if(input_pass.value !== "")
        input_pass.value = sha1(input_pass.value);
    });
});