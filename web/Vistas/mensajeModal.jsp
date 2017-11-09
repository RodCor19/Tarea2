<%-- 
    Document   : mensajeModal
    Created on : 03/11/2017, 10:46:42 PM
    Author     : Kevin
--%>

<div class="modal fade" id="mostrarmodal" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background-color: #E6FFEF; border-bottom-color: #1ED760; padding: 5px">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3 style="margin-left: 40%"><b>Mensaje</b></h3>
            </div>
            <div class="modal-body text-center">
                <h4><%=session.getAttribute("Mensaje")%></h4>   
            </div>
        </div>
    </div>
</div>
<%session.removeAttribute("Mensaje");%>
