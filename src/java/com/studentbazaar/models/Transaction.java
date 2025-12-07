package com.studentbazaar.models;

import java.sql.Timestamp;

public class Transaction {
    private int txnId;
    private int buyerId;
    private int sellerId;
    private int productId;
    private String mode;
    private Timestamp date;
    
    public Transaction() {}
    
    public Transaction(int txnId, int buyerId, int sellerId, int productId, String mode) {
        this.txnId = txnId;
        this.buyerId = buyerId;
        this.sellerId = sellerId;
        this.productId = productId;
        this.mode = mode;
    }
    
    // Getters and Setters
    public int getTxnId() { return txnId; }
    public void setTxnId(int txnId) { this.txnId = txnId; }
    
    public int getBuyerId() { return buyerId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }
    
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }
    
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
}