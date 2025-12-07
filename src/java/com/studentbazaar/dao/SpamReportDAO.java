package com.studentbazaar.dao;

import com.studentbazaar.database.DBConnection;
import com.studentbazaar.models.SpamReport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SpamReportDAO {
    
    public boolean addSpamReport(SpamReport report) {
        String sql = "INSERT INTO spam_reports (product_id, reporter_id, reason) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, report.getProductId());
            pstmt.setInt(2, report.getReporterId());
            pstmt.setString(3, report.getReason());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<SpamReport> getAllReports() {
        List<SpamReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM spam_reports ORDER BY report_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                SpamReport report = new SpamReport();
                report.setReportId(rs.getInt("report_id"));
                report.setProductId(rs.getInt("product_id"));
                report.setReason(rs.getString("reason"));
                report.setReportDate(rs.getTimestamp("report_date"));
                reports.add(report);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }
}