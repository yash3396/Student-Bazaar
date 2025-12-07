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
        
        // Create base directory for Tomcat
        File baseDir = new File("tomcat-temp");
        baseDir.mkdirs();
        
        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir(baseDir.getAbsolutePath());
        tomcat.setPort(Integer.parseInt(port));
        tomcat.getConnector(); // Initialize connector
        
        // Point to the WAR file
        String warPath = "target/Student_Bazar.war";
        File warFile = new File(warPath);
        
        if (!warFile.exists()) {
            System.err.println("WAR file not found at: " + warFile.getAbsolutePath());
            System.exit(1);
        }
        
        System.out.println("Starting Tomcat on port " + port);
        System.out.println("WAR file: " + warFile.getAbsolutePath());
        
        // Add webapp with context path "/"
        Context context = tomcat.addWebapp("", warFile.getAbsolutePath());
        
        tomcat.start();
        System.out.println("Tomcat started successfully!");
        tomcat.getServer().await();
    }
}
