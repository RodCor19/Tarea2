$(document).ready(function () {
    $('#formLista').submit(function () {
        var text = $('#cLista').val();
        if (text === "") {
            $('#cLista').attr("placeholder", "Escriba el nombre de la lista");
            $('#cLista').parent().addClass("has-error has-feedback");
            return false;
        }
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                if (this.responseText !== "ok") {
                    $('#cLista').attr("placeholder", this.responseText);
                    $('#cLista').parent().addClass("has-error has-feedback");
                    $('#cLista').val("");
                    console.log(this.responseText);
                    return false;
                }
            }
        };
        xhttp.open("POST", "/EspotifyWeb/ServletClientes", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("nomLista=" + text);
    });
});