package com.studentbazaar.servlets;

import com.studentbazaar.dao.UserDAO;
import com.studentbazaar.models.User;
import utils.PasswordUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String collegeId = request.getParameter("collegeId");
        String department = request.getParameter("department");
        String year = request.getParameter("year");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        //user.setPassword(password);

        user.setCollegeId(collegeId);
        user.setDepartment(department);
        user.setYear(year);
        user.setPhone(phone);
        user.setGender(gender);
        user.setAddress(address);
        
        if (userDAO.registerUser(user)) {
            response.sendRedirect("login.jsp?success=Registration successful! Please login.");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}