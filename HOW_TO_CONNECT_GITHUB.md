# 🔗 How to Connect and Push to GitHub

## Important: These are COMMANDS, not buttons!

You need to run these commands in your **terminal/command prompt**, not click buttons on GitHub.

---

## 📍 Where to Run the Commands:

### Option 1: In Cursor/VSCode Terminal (Easiest)
1. Open your project in Cursor/VSCode
2. Press **`Ctrl + ~`** (or go to **Terminal → New Terminal**)
3. Make sure you're in the project folder
4. Run the commands there

### Option 2: Git CMD or PowerShell
1. Open **Git CMD** or **PowerShell**
2. Navigate to your project:
   ```bash
   cd "C:\Users\admin\Documents\NetBeansProjects\Student Bazar"
   ```
3. Run the commands

### Option 3: Command Prompt
1. Open **Command Prompt** (cmd)
2. Navigate to your project:
   ```bash
   cd "C:\Users\admin\Documents\NetBeansProjects\Student Bazar"
   ```
3. Run the commands

---

## 🚀 Step-by-Step Process:

### STEP 1: Create Repository on GitHub (Web Interface)
1. Go to: **https://github.com**
2. Sign in
3. Click **"+" icon** (top right corner) → **"New repository"**
4. Fill in details and click **"Create repository"**

### STEP 2: After Creating Repository (Terminal/Command Line)

GitHub will show you a page with instructions. You need to run these commands in your **TERMINAL**:

```bash
git remote add origin https://github.com/yash3396/student-bazaar.git
git branch -M main
git push -u origin main
```

**Where to run these:**
- In Cursor/VSCode: Open terminal (Ctrl + ~)
- In Git CMD: Just type the commands
- In PowerShell: Just type the commands

---

## 📸 Visual Guide:

### In Cursor/VSCode:
1. Look at the bottom of the screen
2. You'll see a **"Terminal"** tab
3. Click on it
4. Type the commands there

### In Git CMD:
1. Open Git CMD (search "Git CMD" in Windows)
2. You'll see a black window with `C:\Users\admin>`
3. Navigate to project: `cd "C:\Users\admin\Documents\NetBeansProjects\Student Bazar"`
4. Type the commands

---

## ⚠️ Important Notes:

1. **These are NOT buttons on GitHub** - they are commands you type
2. **You must be in the project folder** when running commands
3. **Replace `yash3396`** with your actual GitHub username
4. **You'll be asked for password** - use Personal Access Token

---

## 🎯 Quick Copy-Paste Commands:

After creating the GitHub repository, copy and paste these (one by one):

```bash
git remote add origin https://github.com/yash3396/student-bazaar.git
```

Press Enter, then:

```bash
git branch -M main
```

Press Enter, then:

```bash
git push -u origin main
```

Press Enter, then enter your credentials when asked.

---

## ❓ Still Confused?

**The commands go in:**
- ✅ Terminal window (black/colored text window)
- ✅ Command prompt
- ✅ PowerShell
- ✅ Git CMD

**NOT in:**
- ❌ GitHub website (no buttons there)
- ❌ NetBeans interface
- ❌ File Explorer

---

## 🔍 How to Know You're in the Right Place:

When you open terminal, you should see something like:
```
C:\Users\admin\Documents\NetBeansProjects\Student Bazar>
```

If you see this, you're in the right place! Just type the commands.

