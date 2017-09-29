
     function seguir(nick){
        var o = document.getElementById(nick+"DS");
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                if (this.responseText !== "ok") {
                    alert(this.responseText);
                }else{
                    o.style.display='block';                  
                }
                return false;
            }
        };
        xhttp.open("POST", "/EspotifyWeb/ServletClientes", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("seguir=" + nick);
     }
     
     function dejarSeguir(nick){
        var o = document.getElementById(nick+"S");
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                if (this.responseText === "ok") {
                    o.style.display='block';
                }
                return false;
            }
        };
        xhttp.open("POST", "/EspotifyWeb/ServletClientes", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("dejarSeguir=" + nick);
     }
     
     function seguir2(nick){
        var o = document.getElementById(nick+"DS1");
        var p = document.getElementById(nick+"DS2");
        var q = document.getElementById(nick+"S1");
        var r = document.getElementById(nick+"S2");
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                if (this.responseText !== "ok") {
                    alert(this.responseText);
                }else{
                    if(o!==null)
                    o.style.display='block';
                    if(q!==null)
                    q.style.display='none';
                    if(p!==null)
                    p.style.display='block';
                    if(r!==null)
                    r.style.display='none';                 
                }
                return false;
            }
            
        };
        xhttp.open("POST", "/EspotifyWeb/ServletClientes", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("seguir=" + nick);
     }
     
     function dejarSeguir2(nick){
        var o = document.getElementById(nick+"S1");
        var p = document.getElementById(nick+"S2");
        var q = document.getElementById(nick+"DS1");
        var r = document.getElementById(nick+"DS2");
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                if (this.responseText === "ok") {
                    if(o!==null)
                    o.style.display='block';
                    if(p!==null)
                    p.style.display='block';
                    if(q!==null)
                    q.style.display='none';
                    if(r!==null)
                    r.style.display='none';
            }
            return false;
        }};
        xhttp.open("POST", "/EspotifyWeb/ServletClientes", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("dejarSeguir=" + nick);
     }