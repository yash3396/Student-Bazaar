package com.studentbazaar.servlets;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/EditProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EditProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private static final String UPLOAD_DIR = "uploads";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);
        
        if (product == null || product.getSellerId() != (int)session.getAttribute("userId")) {
            response.sendRedirect("myListings.jsp?error=Unauthorized access");
            return;
        }
        
        request.setAttribute("product", product);
        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int userId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            Product existingProduct = productDAO.getProductById(productId);
            if (existingProduct == null || existingProduct.getSellerId() != userId) {
                response.sendRedirect("myListings.jsp?error=Unauthorized access");
                return;
            }
            
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            
            String imagePath = existingProduct.getImage();
            Part filePart = request.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
                    String appPath = request.getServletContext().getRealPath("");
                    String uploadPath = appPath + UPLOAD_DIR;
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    String fullPath = uploadPath + File.separator + fileName;
                    java.io.InputStream fileContent = filePart.getInputStream();
                    java.io.FileOutputStream fos = new java.io.FileOutputStream(fullPath);
                    
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                    
                    fos.close();
                    fileContent.close();
                    
                    imagePath = "images/" + fileName;
                } catch (Exception e) {
                    System.err.println("Error uploading image: " + e.getMessage());
                }
            }
            
            Product product = new Product();
            product.setProductId(productId);
            product.setName(name);
            product.setCategory(category);
            product.setPrice(price);
            product.setDescription(description);
            product.setImage(imagePath);
            product.setStatus(status);
            
            if (productDAO.updateProduct(product)) {
                response.sendRedirect("myListings.jsp?success=Product updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update product");
                request.setAttribute("product", product);
                request.getRequestDispatcher("editProduct.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("editProduct.jsp").forward(request, response);
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
