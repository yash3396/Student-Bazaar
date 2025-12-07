package com.studentbazaar.models;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String collegeId;
    private String department;
    private String year;
    private String phone;
    private String gender;
    private String address;
    private Timestamp dateRegistered;
    
    public User() {}
    
    public User(int userId, String name, String email, String collegeId, String department, 
                String year, String phone, String gender, String address) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.collegeId = collegeId;
        this.department = department;
        this.year = year;
        this.phone = phone;
        this.gender = gender;
        this.address = address;
    }
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getCollegeId() { return collegeId; }
    public void setCollegeId(String collegeId) { this.collegeId = collegeId; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    
    public String getYear() { return year; }
    public void setYear(String year) { this.year = year; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public Timestamp getDateRegistered() { return dateRegistered; }
    public void setDateRegistered(Timestamp dateRegistered) { this.dateRegistered = dateRegistered; }
}