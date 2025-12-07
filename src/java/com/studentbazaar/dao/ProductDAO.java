package com.studentbazaar.dao;

import com.studentbazaar.database.DBConnection;
import com.studentbazaar.models.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (seller_id, name, category, price, description, image, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, product.getSellerId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getCategory());
            pstmt.setDouble(4, product.getPrice());
            pstmt.setString(5, product.getDescription());
            pstmt.setString(6, product.getImage());
            pstmt.setString(7, product.getStatus());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, u.name as seller_name, u.email as seller_email, u.phone as seller_phone " +
                     "FROM products p JOIN users u ON p.seller_id = u.user_id " +
                     "WHERE p.status = 'Active' ORDER BY p.date_posted DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = extractProductFromResultSet(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public Product getProductById(int productId) {
        String sql = "SELECT p.*, u.name as seller_name, u.email as seller_email, u.phone as seller_phone " +
                     "FROM products p JOIN users u ON p.seller_id = u.user_id WHERE p.product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractProductFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Product> getProductsBySeller(int sellerId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, u.name as seller_name, u.email as seller_email, u.phone as seller_phone " +
                     "FROM products p JOIN users u ON p.seller_id = u.user_id " +
                     "WHERE p.seller_id = ? ORDER BY p.date_posted DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, sellerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Product product = extractProductFromResultSet(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Product> searchProducts(String keyword, String category) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, u.name as seller_name, u.email as seller_email, u.phone as seller_phone " +
            "FROM products p JOIN users u ON p.seller_id = u.user_id WHERE p.status = 'Active'"
        );
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ?)");
        }
        if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
            sql.append(" AND p.category = ?");
        }
        sql.append(" ORDER BY p.date_posted DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }
            if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
                pstmt.setString(paramIndex, category);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Product product = extractProductFromResultSet(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name=?, category=?, price=?, description=?, image=?, status=? WHERE product_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getCategory());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getDescription());
            pstmt.setString(5, product.getImage());
            pstmt.setString(6, product.getStatus());
            pstmt.setInt(7, product.getProductId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Product extractProductFromResultSet(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setSellerId(rs.getInt("seller_id"));
        product.setName(rs.getString("name"));
        product.setCategory(rs.getString("category"));
        product.setPrice(rs.getDouble("price"));
        product.setDescription(rs.getString("description"));
        product.setImage(rs.getString("image"));
        product.setStatus(rs.getString("status"));
        product.setDatePosted(rs.getTimestamp("date_posted"));
        product.setSellerName(rs.getString("seller_name"));
        product.setSellerEmail(rs.getString("seller_email"));
        product.setSellerPhone(rs.getString("seller_phone"));
        return product;
    }
}