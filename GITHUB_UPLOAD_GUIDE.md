# Step-by-Step GitHub Upload Guide

## ✅ What We've Done So Far:
1. ✅ Created `.gitignore` file
2. ✅ Created `README.md` file  
3. ✅ Initialized Git repository
4. ✅ Added all files to Git

## 📋 Next Steps - Follow These Exactly:

### Step 1: Configure Git (If Not Already Done)

Open terminal and run these commands (replace with YOUR information):

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Example:**
```bash
git config --global user.name "Yash Verma"
git config --global user.email "yash.verma@example.com"
```

### Step 2: Make Your First Commit

```bash
git commit -m "Initial commit: Student Bazaar marketplace project"
```

### Step 3: Create GitHub Repository

1. **Go to GitHub**: https://github.com
2. **Sign in** to your account
3. **Click the "+" icon** (top right) → **"New repository"**
4. **Fill in details:**
   - Repository name: `student-bazaar` (or `Student-Bazaar`)
   - Description: "A Java-based marketplace for students to buy and sell products"
   - Visibility: Choose **Private** (recommended) or **Public**
   - **DO NOT** check:
     - ❌ Add a README file
     - ❌ Add .gitignore
     - ❌ Choose a license
5. **Click "Create repository"**

### Step 4: Connect Your Local Project to GitHub

After creating the repository, GitHub will show you commands. Use these:

```bash
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/student-bazaar.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

**Example:**
```bash
git remote add origin https://github.com/yashverma/student-bazaar.git
git branch -M main
git push -u origin main
```

### Step 5: Authentication

When you run `git push`, you'll be asked for:
- **Username**: Your GitHub username
- **Password**: Use a **Personal Access Token** (NOT your GitHub password)

**To create Personal Access Token:**
1. Go to GitHub → Settings → Developer settings
2. Click "Personal access tokens" → "Tokens (classic)"
3. Click "Generate new token (classic)"
4. Give it a name: "Student Bazaar Project"
5. Select scope: Check **"repo"** (this gives full repository access)
6. Click "Generate token"
7. **COPY THE TOKEN** (you won't see it again!)
8. Use this token as your password when pushing

### Step 6: Verify Upload

1. Go to your GitHub repository page
2. Refresh the page
3. You should see all your files!

---

## 🎉 Success Checklist

- [ ] Git repository initialized
- [ ] Files added and committed
- [ ] GitHub repository created
- [ ] Local project connected to GitHub
- [ ] Code pushed successfully
- [ ] Files visible on GitHub

---

## 📝 Important Notes

1. **The warnings about LF/CRLF are normal** - Git is just normalizing line endings for Windows
2. **Uploads folder is ignored** - User-uploaded images won't be uploaded (this is correct)
3. **Build files are ignored** - Compiled files won't be uploaded (this is correct)
4. **Your source code IS uploaded** - All Java, JSP, CSS files are included

---

## 🔄 Future Updates

After making changes to your project:

```bash
git add .
git commit -m "Description of changes"
git push origin main
```

---

## ❓ Need Help?

If you encounter any errors, check:
1. GitHub repository URL is correct
2. Personal Access Token is valid
3. Internet connection is working
4. You're in the correct directory

