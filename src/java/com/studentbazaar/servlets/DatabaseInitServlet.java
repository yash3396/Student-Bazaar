package com.studentbazaar.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import java.sql.Connection;
import java.sql.Statement;
import com.studentbazaar.database.DBConnection;

@WebServlet(name = "DatabaseInitServlet", urlPatterns = {"/init-db"}, loadOnStartup = 1)
public class DatabaseInitServlet extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("=== Initializing Database Tables ===");
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create users table
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                "user_id SERIAL PRIMARY KEY," +
                "name VARCHAR(100) NOT NULL," +
                "email VARCHAR(100) UNIQUE NOT NULL," +
                "password VARCHAR(255) NOT NULL," +
                "phone VARCHAR(20)," +
                "address TEXT," +
                "registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            System.out.println("✓ Users table created");
            
            // Create products table
            stmt.execute("CREATE TABLE IF NOT EXISTS products (" +
                "product_id SERIAL PRIMARY KEY," +
                "seller_id INTEGER NOT NULL," +
                "name VARCHAR(200) NOT NULL," +
                "category VARCHAR(50) NOT NULL," +
                "price DECIMAL(10,2) NOT NULL," +
                "description TEXT," +
                "image VARCHAR(500)," +
                "status VARCHAR(20) DEFAULT 'Active'," +
                "date_posted TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("✓ Products table created");
            
            // Create transactions table
            stmt.execute("CREATE TABLE IF NOT EXISTS transactions (" +
                "transaction_id SERIAL PRIMARY KEY," +
                "product_id INTEGER NOT NULL," +
                "buyer_id INTEGER NOT NULL," +
                "seller_id INTEGER NOT NULL," +
                "transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "amount DECIMAL(10,2) NOT NULL," +
                "status VARCHAR(20) DEFAULT 'Completed'," +
                "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE," +
                "FOREIGN KEY (buyer_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("✓ Transactions table created");
            
            // Create offers table
            stmt.execute("CREATE TABLE IF NOT EXISTS offers (" +
                "offer_id SERIAL PRIMARY KEY," +
                "product_id INTEGER NOT NULL," +
                "buyer_id INTEGER NOT NULL," +
                "seller_id INTEGER NOT NULL," +
                "offered_price DECIMAL(10,2) NOT NULL," +
                "message TEXT," +
                "status VARCHAR(20) DEFAULT 'Pending'," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE," +
                "FOREIGN KEY (buyer_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("✓ Offers table created");
            
            // Create spam_reports table
            stmt.execute("CREATE TABLE IF NOT EXISTS spam_reports (" +
                "report_id SERIAL PRIMARY KEY," +
                "reporter_id INTEGER NOT NULL," +
                "reported_user_id INTEGER NOT NULL," +
                "product_id INTEGER," +
                "reason TEXT NOT NULL," +
                "report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "status VARCHAR(20) DEFAULT 'Pending'," +
                "FOREIGN KEY (reporter_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "FOREIGN KEY (reported_user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE SET NULL)");
            System.out.println("✓ Spam reports table created");
            
            System.out.println("=== Database initialization completed successfully! ===");
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to initialize database tables");
            e.printStackTrace();
            throw new ServletException("Database initialization failed", e);
        }
    }
}
