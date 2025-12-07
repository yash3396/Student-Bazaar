package com.studentbazaar.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Use environment variables for cloud deployment, fallback to local MySQL
    private static final String DB_URL = System.getenv("DATABASE_URL") != null 
            ? System.getenv("DATABASE_URL") 
            : "jdbc:mysql://localhost:3306/student_bazaar?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    
    private static final String DB_USER = System.getenv("DB_USER") != null 
            ? System.getenv("DB_USER") 
            : "root";
    
    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD") != null 
            ? System.getenv("DB_PASSWORD") 
            : "root";
    
    // Detect database type from URL
    private static final boolean isPostgreSQL = DB_URL.startsWith("jdbc:postgresql://");
    private static final boolean isMySQL = DB_URL.startsWith("jdbc:mysql://");
    
    static {
        try {
            if (isPostgreSQL) {
                Class.forName("org.postgresql.Driver");
                System.out.println("PostgreSQL JDBC Driver loaded successfully!");
            } else if (isMySQL) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                System.out.println("MySQL JDBC Driver loaded successfully!");
            } else {
                // Default to MySQL for backward compatibility
                Class.forName("com.mysql.cj.jdbc.Driver");
                System.out.println("MySQL JDBC Driver loaded (default)!");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("JDBC Driver not found", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("Attempting to connect to database...");
            System.out.println("Database type: " + (isPostgreSQL ? "PostgreSQL" : "MySQL"));
            System.out.println("URL: " + (DB_URL.contains("@") ? "***" : DB_URL)); // Hide credentials in logs
            
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connection successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}