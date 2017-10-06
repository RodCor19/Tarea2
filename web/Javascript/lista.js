function comprobar(){
        var text = $('#cLista').val();
        if (text === "") {
            $('#cLista').attr("placeholder", "Escriba el nombre de la lista");
            $('#cLista').addClass("has-error has-feedback");
            return false;
        } else {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    return true;
                }
            };
            xhttp.open("POST", "/EspotifyWeb/Vistas/SubirImagenLista.jsp", true);
            xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhttp.send("cLista=" + text);
        }
}
