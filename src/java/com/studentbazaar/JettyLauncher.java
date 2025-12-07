package com.studentbazaar;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;
import java.io.File;

public class JettyLauncher {
    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT");
        if (port == null || port.isEmpty()) {
            port = "8080";
        }
        
        int portNumber = Integer.parseInt(port);
        Server server = new Server(portNumber);
        
        // Point to the WAR file
        String warPath = "target/Student_Bazar.war";
        File warFile = new File(warPath);
        
        if (!warFile.exists()) {
            System.err.println("WAR file not found at: " + warFile.getAbsolutePath());
            System.exit(1);
        }
        
        WebAppContext webapp = new WebAppContext();
        webapp.setContextPath("/");
        webapp.setWar(warFile.getAbsolutePath());
        
        server.setHandler(webapp);
        
        System.out.println("Starting Jetty on port " + port);
        System.out.println("WAR file: " + warFile.getAbsolutePath());
        
        server.start();
        System.out.println("Jetty started successfully!");
        server.join();
    }
}
