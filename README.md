# Student Bazaar 🛒

A Java-based marketplace web application for students to buy and sell products within their campus community.

## 📋 Project Overview

Student Bazaar is a full-stack web application built with Java JSP/Servlets that enables students to:
- List products for sale
- Browse and search products
- Make offers and negotiate prices
- Complete transactions
- Manage their listings and purchases

## 🛠️ Technology Stack

- **Backend**: Java (JSP/Servlets)
- **Database**: MySQL
- **Frontend**: HTML, CSS, JavaScript, Bootstrap 5
- **Server**: GlassFish / Apache Tomcat
- **IDE**: NetBeans

## ✨ Features

### For Buyers
- 🔍 Advanced search and filtering
- 💰 Make offers on products
- 🛒 Buy products directly
- 📦 View purchase history
- 🚩 Report spam listings

### For Sellers
- ➕ Add product listings with images
- ✏️ Edit product details
- 📊 View dashboard with statistics
- 📬 Manage offers in inbox
- ✅ Mark products as sold

### General Features
- 👤 User registration and authentication
- 🎨 Modern, responsive UI with animations
- 📱 Mobile-friendly design
- 🔔 Toast notifications
- 📈 Activity dashboard
- 🎯 Quick search options

## 📁 Project Structure

```
Student Bazar/
├── src/java/com/studentbazaar/
│   ├── dao/              # Data Access Objects
│   ├── models/           # Data Models
│   ├── servlets/         # Servlet Controllers
│   ├── database/         # Database Connection
│   └── utils/            # Utility Classes
├── web/                  # JSP Pages and Static Resources
│   ├── *.jsp            # View Pages
│   ├── style.css        # Stylesheet
│   └── WEB-INF/         # Configuration
├── build/                # Compiled Files (Auto-generated)
└── nbproject/           # NetBeans Project Files
```

## 🚀 Getting Started

### Prerequisites
- Java JDK 8 or higher
- MySQL Database
- NetBeans IDE (or any Java IDE)
- GlassFish Server or Apache Tomcat

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/student-bazaar.git
   cd student-bazaar
   ```

2. **Set up Database**
   - Create MySQL database
   - Import database schema
   - Update database connection in `DBConnection.java`

3. **Configure Server**
   - Deploy to GlassFish/Tomcat
   - Configure database connection pool

4. **Run the Application**
   - Start your server
   - Access: `http://localhost:8080/Student_Bazar`

## 📸 Screenshots

*Add screenshots of your application here*

## 🔐 Database Schema

- `users` - User accounts
- `products` - Product listings
- `transactions` - Purchase records
- `offers` - Offer management
- `spam_reports` - Spam reporting

## 👥 Contributors

- Yash Verma
- Utkarsh Singh
- Anushka Kashiv
- Tarun Asharma

## 📝 License

This project is developed for educational purposes.

## 🔮 Future Enhancements

- AI-powered product recommendations
- Smart price suggestions
- Image recognition for auto-categorization
- Chatbot assistant
- Real-time notifications
- Advanced analytics

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

**Developed with ❤️ by CSE (AI & ML) students at Acropolis Institute of Technology & Research (AITR), Indore**

