<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%
        if(request.getParameter("cLista")!=null){
        session.setAttribute("cLista", request.getParameter("cLista"));
        }else{
        /*FileItemFactory es una interfaz para crear FileItem*/
        FileItemFactory file_factory = new DiskFileItemFactory();
        /*ServletFileUpload esta clase convierte los input file a FileItem*/
        ServletFileUpload servlet_up = new ServletFileUpload(file_factory);
        /*sacando los FileItem del ServletFileUpload en una lista */
        List items = servlet_up.parseRequest(request);
        String path = this.getClass().getClassLoader().getResource("").getPath();
        path = path.replace("build/web/WEB-INF/classes/","temporales/");
        if(session.getAttribute("imagen")!=null){
            session.removeAttribute("imagen");
        }
        for(int i=0;i<items.size();i++){
            /*FileItem representa un archivo en memoria que puede ser pasado al disco duro*/
            FileItem item = (FileItem) items.get(i);
            /*item.isFormField() false=input file; true=text field*/
            if (! item.isFormField()){
                File archivo_server = new File(path + item.getName());
                if(item.getName().contains(".jpg")){
                    session.setAttribute("imagen", path + item.getName());
                }
                item.write(archivo_server);
                response.sendRedirect("/EspotifyWeb/ServletClientes");
            }
        }
        }
%>