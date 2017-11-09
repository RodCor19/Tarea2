package Clases;


import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Kevin
 */
public class Configuraciones {
    private Properties propiedades;

    public Configuraciones() {
        propiedades = null;
        try {
            propiedades = new Properties();
            String rutaConfWS = this.getClass().getClassLoader().getResource("").getPath();
            
            // EN NETBEANS
            rutaConfWS = rutaConfWS.replace("build/web/WEB-INF/classes/", "webservices.properties");
            // EN TOMCAT
            rutaConfWS = rutaConfWS.replace("WEB-INF/classes/", "webservices.properties");
            
            rutaConfWS = rutaConfWS.replace("%20", " ");
            InputStream entrada = new FileInputStream(rutaConfWS);
            propiedades.load(entrada);// cargamos el archivo de propiedades
        } catch (IOException ex) {
            Logger.getLogger(Configuraciones.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public URL getUrlWSArtistas(){
        try {
            URL url = new URL("http://" + propiedades.getProperty("ipServidor") + ":" + propiedades.getProperty("puertoWSArt") + "/" + propiedades.getProperty("nombreWSArt")+"?wsdl");
            return url;
        } catch (Exception ex) {
            Logger.getLogger(Configuraciones.class.getName()).log(Level.SEVERE, null, ex);
            
            return null;
        }
    }
    
    public URL getUrlWSClientes(){
        try {
            URL url = new URL("http://"+ propiedades.getProperty("ipServidor") +":"+ propiedades.getProperty("puertoWSCli")+"/"+propiedades.getProperty("nombreWSCli")+"?wsdl");
            return url;
        } catch (Exception ex) {
            Logger.getLogger(Configuraciones.class.getName()).log(Level.SEVERE, null, ex);
            
            return null;
        }
    }
    
    public URL getUrlWSArchivos(){
        try {
            URL url = new URL("http://" + propiedades.getProperty("ipServidor") + ":" + propiedades.getProperty("puertoWSArch") + "/" + propiedades.getProperty("nombreWSArch")+"?wsdl");
            return url;
        } catch (Exception ex) {
            Logger.getLogger(Configuraciones.class.getName()).log(Level.SEVERE, null, ex);
            
            return null;
        }
    }
    
    public String getPath(){
//        String path = this.getClass().getResource("").getPath();
        String path = this.getClass().getClassLoader().getResource("").getPath();
        path = path.replace("%20", " ");
//            rutaConfWS = rutaConfWS.replace("build/web/WEB-INF/classes/", "webservices.properties");
        return path;
    }
        
}
