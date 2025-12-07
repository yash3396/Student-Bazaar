package com.studentbazaar.dao;

import com.studentbazaar.database.DBConnection;
import com.studentbazaar.models.Offer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OfferDAO {
    
    public boolean createOffer(Offer offer) {
        String sql = "INSERT INTO offers (product_id, buyer_id, seller_id, offered_price, message, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, offer.getProductId());
            pstmt.setInt(2, offer.getBuyerId());
            pstmt.setInt(3, offer.getSellerId());
            pstmt.setDouble(4, offer.getOfferedPrice());
            pstmt.setString(5, offer.getMessage());
            pstmt.setString(6, offer.getStatus());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Offer> getOffersBySeller(int sellerId) {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT o.*, u.name as buyer_name, u.email as buyer_email, u.phone as buyer_phone, " +
                     "p.name as product_name, p.price as product_price " +
                     "FROM offers o " +
                     "JOIN users u ON o.buyer_id = u.user_id " +
                     "JOIN products p ON o.product_id = p.product_id " +
                     "WHERE o.seller_id = ? " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, sellerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Offer offer = extractOfferFromResultSet(rs);
                offers.add(offer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offers;
    }
    
    public List<Offer> getOffersByBuyer(int buyerId) {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT o.*, p.name as product_name, p.price as product_price " +
                     "FROM offers o " +
                     "JOIN products p ON o.product_id = p.product_id " +
                     "WHERE o.buyer_id = ? " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, buyerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Offer offer = new Offer();
                offer.setOfferId(rs.getInt("offer_id"));
                offer.setProductId(rs.getInt("product_id"));
                offer.setBuyerId(rs.getInt("buyer_id"));
                offer.setSellerId(rs.getInt("seller_id"));
                offer.setOfferedPrice(rs.getDouble("offered_price"));
                offer.setMessage(rs.getString("message"));
                offer.setStatus(rs.getString("status"));
                offer.setCreatedAt(rs.getTimestamp("created_at"));
                offer.setProductName(rs.getString("product_name"));
                offer.setProductPrice(rs.getDouble("product_price"));
                offers.add(offer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offers;
    }
    
    public boolean updateOfferStatus(int offerId, String status) {
        String sql = "UPDATE offers SET status = ? WHERE offer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, offerId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getPendingOffersCount(int sellerId) {
        String sql = "SELECT COUNT(*) FROM offers WHERE seller_id = ? AND status = 'Pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, sellerId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Offer extractOfferFromResultSet(ResultSet rs) throws SQLException {
        Offer offer = new Offer();
        offer.setOfferId(rs.getInt("offer_id"));
        offer.setProductId(rs.getInt("product_id"));
        offer.setBuyerId(rs.getInt("buyer_id"));
        offer.setSellerId(rs.getInt("seller_id"));
        offer.setOfferedPrice(rs.getDouble("offered_price"));
        offer.setMessage(rs.getString("message"));
        offer.setStatus(rs.getString("status"));
        offer.setCreatedAt(rs.getTimestamp("created_at"));
        offer.setBuyerName(rs.getString("buyer_name"));
        offer.setBuyerEmail(rs.getString("buyer_email"));
        offer.setBuyerPhone(rs.getString("buyer_phone"));
        offer.setProductName(rs.getString("product_name"));
        offer.setProductPrice(rs.getDouble("product_price"));
        return offer;
    }
}
