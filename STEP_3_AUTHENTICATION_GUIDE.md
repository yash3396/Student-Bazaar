# 🔐 Step 3: Authentication Guide - Personal Access Token

## What is Step 3?
When you run `git push`, GitHub asks for your **username** and **password**. 
But GitHub doesn't accept your regular password anymore - you need a **Personal Access Token**.

---

## 📋 Step-by-Step: Create Personal Access Token

### Step 1: Go to GitHub Settings
1. Open: **https://github.com**
2. **Sign in** to your account
3. Click your **profile picture** (top right corner)
4. Click **"Settings"** from the dropdown menu

### Step 2: Navigate to Developer Settings
1. Scroll down the left sidebar
2. Find **"Developer settings"** (at the bottom)
3. Click on it

### Step 3: Go to Personal Access Tokens
1. In Developer settings, click **"Personal access tokens"**
2. Click **"Tokens (classic)"**
3. You'll see a list (might be empty if you haven't created any)

### Step 4: Generate New Token
1. Click the green button: **"Generate new token"**
2. Select **"Generate new token (classic)"**

### Step 5: Configure Token
Fill in the form:

1. **Note** (name for the token):
   - Type: `Student Bazaar Project`
   - (This is just a label to remember what it's for)

2. **Expiration**:
   - Choose: **90 days** (or whatever you prefer)
   - You can always create a new one later

3. **Select scopes** (permissions):
   - **IMPORTANT**: Check the box for **"repo"**
   - This gives full access to repositories
   - You can check "repo" and it will select all repo-related permissions

4. Scroll down and click: **"Generate token"** (green button at bottom)

### Step 6: Copy the Token
1. **GitHub will show you the token ONCE**
2. It looks like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
3. **COPY IT IMMEDIATELY** - you won't see it again!
4. Save it somewhere safe (like a text file)

---

## 🚀 Step 7: Use Token When Pushing

Now go back to your terminal and run:

```bash
git push -u origin main
```

When prompted:

1. **Username**: Enter your GitHub username (`yash3396`)
2. **Password**: **Paste your Personal Access Token** (NOT your GitHub password!)

**Important**: 
- The password field won't show what you type (for security)
- Just paste the token and press Enter
- It might look like nothing is happening, but it is!

---

## 🎯 Visual Guide:

### When you run `git push`, you'll see:

```
Username for 'https://github.com': yash3396
Password for 'https://github.com/yash3396': [paste token here]
```

**Just type your username and paste the token!**

---

## ⚠️ Common Issues:

### Issue 1: "Authentication failed"
- **Solution**: Make sure you copied the ENTIRE token
- Token should start with `ghp_` and be quite long

### Issue 2: "Token expired"
- **Solution**: Create a new token and use that

### Issue 3: "Permission denied"
- **Solution**: Make sure you checked "repo" scope when creating token

### Issue 4: Nothing happens when typing password
- **This is NORMAL!** Password field is hidden for security
- Just paste and press Enter

---

## ✅ Success Looks Like:

After entering credentials, you should see:

```
Enumerating objects: 68, done.
Counting objects: 100% (68/68), done.
Delta compression using up to 8 threads
Compressing objects: 100% (66/66), done.
Writing objects: 100% (68/68), done.
To https://github.com/yash3396/student-bazaar.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

**This means SUCCESS!** 🎉

---

## 🔄 If You Need to Try Again:

If something went wrong, just run:

```bash
git push -u origin main
```

Again and enter your credentials.

---

## 📝 Quick Checklist:

- [ ] Created Personal Access Token on GitHub
- [ ] Copied the token (starts with `ghp_`)
- [ ] Ran `git push -u origin main` in terminal
- [ ] Entered username: `yash3396`
- [ ] Pasted token as password
- [ ] Saw success message

---

## 🆘 Still Stuck?

Tell me:
1. What error message do you see?
2. At what step are you stuck?
3. Did you create the token successfully?

I'll help you fix it!

