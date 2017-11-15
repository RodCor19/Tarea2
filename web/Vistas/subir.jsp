<%-- 
    Document   : subir
    Created on : 02/10/2017, 04:24:49 PM
    Author     : Admin
--%>

<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URL"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import="java.io.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 
<%

        /*FileItemFactory es una interfaz para crear FileItem*/
        FileItemFactory file_factory = new DiskFileItemFactory();
 
        /*ServletFileUpload esta clase convierte los input file a FileItem*/
        ServletFileUpload servlet_up = new ServletFileUpload(file_factory);
        /*sacando los FileItem del ServletFileUpload en una lista */
        List items = servlet_up.parseRequest(request);
        String path = this.getClass().getClassLoader().getResource("").getPath();
        
        // EN NETBEANS
        path = path.replace("build/web/WEB-INF/classes/", "temporales/");
        // EN TOMCAT
        path = path.replace("WEB-INF/classes/", "temporales/");
        
        path = path.replace( "%20", " ");
        if(session.getAttribute("imagen")!=null){
            session.removeAttribute("imagen");
        }
        for(int i=0;i<items.size();i++){
            /*FileItem representa un archivo en memoria que puede ser pasado al disco duro*/
            FileItem item = (FileItem) items.get(i);
            /*item.isFormField() false=input file; true=text field*/
            if (! item.isFormField() && item.getName().isEmpty() == false){
                /*cual sera la ruta al archivo en el servidor*/
                byte[] bytes = item.getName().getBytes(StandardCharsets.ISO_8859_1);
                String nom = new String(bytes, StandardCharsets.UTF_8);
                File archivo_server = new File(path + nom);
                archivo_server.getParentFile().mkdirs();
//                archivo_server.getParentFile().mkdirs();
//                archivo_server.createNewFile();
                /*y lo escribimos en el servidor*/
                item.write(archivo_server);
                out.print("Nombre --> " + item.getName() );
                out.print("<br> Tipo --> " + item.getContentType());
                out.print("<br> tamaño --> " + (item.getSize()/1240)+ "KB");
                out.print("<br>");
            }
        }
%>
