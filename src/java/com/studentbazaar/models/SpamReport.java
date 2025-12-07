package com.studentbazaar.models;

import java.sql.Timestamp;

public class SpamReport {
    private int reportId;
    private int productId;
    private int reporterId;
    private String reason;
    private Timestamp reportDate;
    
    public SpamReport() {}
    
    public SpamReport(int reportId, int productId, int reporterId, String reason) {
        this.reportId = reportId;
        this.productId = productId;
        this.reporterId = reporterId;
        this.reason = reason;
    }
    
    // Getters and Setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public int getReporterId() { return reporterId; }
    public void setReporterId(int reporterId) { this.reporterId = reporterId; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public Timestamp getReportDate() { return reportDate; }
    public void setReportDate(Timestamp reportDate) { this.reportDate = reportDate; }
}