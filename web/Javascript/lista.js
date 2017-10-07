function comprobar(){
        var text = $('#cLista').val();
        if (text === "") {
            $('#cLista').attr("placeholder", "Escriba el nombre de la lista");
            $('#cLista').addClass("has-error has-feedback");
            return false;
        } else {
            $('#formImagen').append('<input type="text" name="cLista" value="'+text+'" hidden=""/>');
        }
}
