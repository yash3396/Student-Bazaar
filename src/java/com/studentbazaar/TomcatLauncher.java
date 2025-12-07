package com.studentbazaar;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import java.io.File;

public class TomcatLauncher {
    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT");
        if (port == null || port.isEmpty()) {
            port = "8080";
        }
        
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(port));
        tomcat.getConnector();
        
        // Point to the WAR file
        String warPath = "target/Student_Bazar.war";
        File warFile = new File(warPath);
        
        if (!warFile.exists()) {
            System.err.println("WAR file not found at: " + warFile.getAbsolutePath());
            System.exit(1);
        }
        
        Context context = tomcat.addWebapp("", warFile.getAbsolutePath());
        
        System.out.println("Starting Tomcat on port " + port);
        tomcat.start();
        tomcat.getServer().await();
    }
}
