package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/AddProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private static final String UPLOAD_DIR = "uploads";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                System.out.println("No session found, redirecting to login");
                response.sendRedirect("login.jsp");
                return;
            }
            
            int sellerId = (int) session.getAttribute("userId");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String description = request.getParameter("description");
            
            System.out.println("Adding product: " + name + ", Category: " + category + ", Price: " + priceStr);
            
            if (name == null || category == null || priceStr == null || description == null) {
                request.setAttribute("error", "All fields are required!");
                request.getRequestDispatcher("addProduct.jsp").forward(request, response);
                return;
            }
            
            double price = Double.parseDouble(priceStr);
            
            String imagePath = "images/default";
            Part filePart = request.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
                    
                    // Get the real path to the web directory
                    String appPath = request.getServletContext().getRealPath("");
                    String uploadPath = appPath + File.separator + UPLOAD_DIR;
                    
                    System.out.println("=== IMAGE UPLOAD DEBUG ===");
                    System.out.println("App Path: " + appPath);
                    System.out.println("Upload Path: " + uploadPath);
                    System.out.println("Original filename: " + getFileName(filePart));
                    System.out.println("Generated filename: " + fileName);
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        boolean created = uploadDir.mkdirs();
                        System.out.println("Upload directory created: " + created);
                        System.out.println("Upload directory exists now: " + uploadDir.exists());
                    }
                    
                    // Save file using InputStream (more reliable)
                    String fullPath = uploadPath + File.separator + fileName;
                    System.out.println("Saving file to: " + fullPath);
                    
                    java.io.InputStream fileContent = filePart.getInputStream();
                    java.io.FileOutputStream fos = new java.io.FileOutputStream(fullPath);
                    
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    long totalBytes = 0;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                        totalBytes += bytesRead;
                    }
                    
                    fos.flush();
                    fos.close();
                    fileContent.close();
                    
                    // Verify file was saved
                    File savedFile = new File(fullPath);
                    System.out.println("File saved successfully!");
                    System.out.println("File exists: " + savedFile.exists());
                    System.out.println("File size: " + (savedFile.exists() ? savedFile.length() : 0) + " bytes");
                    System.out.println("Total bytes written: " + totalBytes);
                    
                    // Store relative path for database
                    imagePath = "images/" + fileName;
                    System.out.println("Image path stored in DB: " + imagePath);
                    System.out.println("=== END IMAGE UPLOAD DEBUG ===");
                } catch (Exception e) {
                    System.err.println("Error uploading image: " + e.getMessage());
                    e.printStackTrace();
                    // Continue with default image
                    imagePath = "images/default";
                }
            }
            
            Product product = new Product();
            product.setSellerId(sellerId);
            product.setName(name);
            product.setCategory(category);
            product.setPrice(price);
            product.setDescription(description);
            product.setImage(imagePath);
            product.setStatus("Active");
            
            if (productDAO.addProduct(product)) {
                System.out.println("Product added successfully!");
                response.sendRedirect("myListings.jsp?success=Product added successfully!");
            } else {
                System.err.println("Failed to add product to database");
                request.setAttribute("error", "Failed to add product. Please try again.");
                request.getRequestDispatcher("addProduct.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid price format: " + e.getMessage());
            request.setAttribute("error", "Invalid price format!");
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}