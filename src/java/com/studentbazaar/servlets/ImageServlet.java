package com.studentbazaar.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet(name = "ImageServlet", urlPatterns = {"/images/*"})
public class ImageServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String pathInfo = request.getPathInfo();
            
            // Handle default image request
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/default")) {
                serveDefaultImage(response);
                return;
            }
            
            String filename = pathInfo.substring(1); // Remove leading /
            
            // Handle old placeholder.com URLs - serve default instead
            if (filename.contains("via.placeholder.com") || filename.contains("placeholder.com")) {
                System.out.println("ImageServlet - Detected old placeholder URL, serving default image");
                serveDefaultImage(response);
                return;
            }
            
            // Handle external URLs (other than placeholder.com)
            if (filename.startsWith("http://") || filename.startsWith("https://")) {
                // For other external URLs, try to redirect, but if it fails, serve default
                try {
                    response.sendRedirect(filename);
                    return;
                } catch (Exception e) {
                    System.err.println("ImageServlet - Failed to redirect to external URL, serving default");
                    serveDefaultImage(response);
                    return;
                }
            }
            
            // Get the real path to uploads directory - MUST match AddProductServlet logic
            String appPath = getServletContext().getRealPath("");
            String uploadPath = null;
            
            if (appPath != null) {
                uploadPath = appPath + File.separator + "uploads";
            } else {
                // Fallback: try /uploads directly
                uploadPath = getServletContext().getRealPath("/uploads");
            }
            
            System.out.println("ImageServlet - Looking for: " + filename);
            System.out.println("ImageServlet - App path: " + appPath);
            System.out.println("ImageServlet - Upload path: " + uploadPath);
            
            if (uploadPath == null) {
                System.err.println("ImageServlet - Cannot determine upload path, serving default");
                serveDefaultImage(response);
                return;
            }
            
            // Ensure uploads directory exists
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                System.out.println("ImageServlet - Creating upload directory: " + uploadPath);
                boolean created = uploadDir.mkdirs();
                System.out.println("ImageServlet - Directory created: " + created);
            }
            
            // List all files in uploads directory for debugging
            if (uploadDir.exists() && uploadDir.isDirectory()) {
                File[] files = uploadDir.listFiles();
                System.out.println("ImageServlet - Files in uploads directory: " + (files != null ? files.length : 0));
                if (files != null && files.length > 0) {
                    System.out.println("ImageServlet - Sample files:");
                    for (int i = 0; i < Math.min(5, files.length); i++) {
                        System.out.println("  - " + files[i].getName());
                    }
                }
            }
            
            // Get the image file
            File file = new File(uploadPath, filename);
            System.out.println("ImageServlet - Looking for file: " + file.getAbsolutePath());
            System.out.println("ImageServlet - File exists: " + file.exists());
            System.out.println("ImageServlet - File is file: " + (file.exists() ? file.isFile() : "N/A"));
            
            if (!file.exists() || !file.isFile()) {
                System.out.println("ImageServlet - File not found, serving default image");
                System.out.println("ImageServlet - Expected filename: " + filename);
                serveDefaultImage(response);
                return;
            }
            
            // Determine content type
            String contentType = getServletContext().getMimeType(filename);
            if (contentType == null || !contentType.startsWith("image/")) {
                // Try to determine from file extension
                if (filename.toLowerCase().endsWith(".png")) {
                    contentType = "image/png";
                } else if (filename.toLowerCase().endsWith(".gif")) {
                    contentType = "image/gif";
                } else {
                    contentType = "image/jpeg";
                }
            }
            
            // Set response headers
            response.setContentType(contentType);
            response.setHeader("Cache-Control", "public, max-age=31536000");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");
            
            // Stream the file
            try (InputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
            }
            
            System.out.println("ImageServlet - Successfully served: " + filename);
            
        } catch (Exception e) {
            System.err.println("ImageServlet - Error serving image: " + e.getMessage());
            e.printStackTrace();
            serveDefaultImage(response);
        }
    }
    
    private void serveDefaultImage(HttpServletResponse response) throws IOException {
        // Create a nice default image SVG
        String svg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"400\" height=\"300\" viewBox=\"0 0 400 300\">" +
                    "<defs>" +
                    "<linearGradient id=\"grad\" x1=\"0%\" y1=\"0%\" x2=\"100%\" y2=\"100%\">" +
                    "<stop offset=\"0%\" style=\"stop-color:#667eea;stop-opacity:1\" />" +
                    "<stop offset=\"100%\" style=\"stop-color:#764ba2;stop-opacity:1\" />" +
                    "</linearGradient>" +
                    "</defs>" +
                    "<rect fill=\"url(#grad)\" width=\"400\" height=\"300\"/>" +
                    "<circle cx=\"200\" cy=\"120\" r=\"40\" fill=\"white\" opacity=\"0.3\"/>" +
                    "<path d=\"M 180 120 L 200 100 L 220 120 L 200 140 Z\" fill=\"white\" opacity=\"0.5\"/>" +
                    "<text fill=\"#ffffff\" font-family=\"Arial, sans-serif\" font-size=\"24\" font-weight=\"bold\" " +
                    "x=\"200\" y=\"180\" text-anchor=\"middle\">No Image</text>" +
                    "<text fill=\"#ffffff\" font-family=\"Arial, sans-serif\" font-size=\"16\" " +
                    "x=\"200\" y=\"205\" text-anchor=\"middle\">Available</text>" +
                    "</svg>";
        
        response.setContentType("image/svg+xml");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "public, max-age=3600");
        response.getWriter().write(svg);
        response.getWriter().flush();
    }
}
