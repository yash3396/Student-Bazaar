# 🚂 Railway Deployment - Step by Step (First Time Guide)

## What We're Going to Do

1. Create Railway account
2. Create new project
3. Connect to GitHub
4. Add PostgreSQL database
5. Configure environment variables
6. Deploy and get your live link!

---

## Step 1: Create Railway Account

### Option A: Sign Up with GitHub (Recommended)
1. Go to: **https://railway.app**
2. Click **"Start a New Project"** or **"Login"**
3. Click **"Login with GitHub"**
4. Authorize Railway to access your GitHub account
5. You're in! ✅

### Option B: Sign Up with Email
1. Go to: **https://railway.app**
2. Click **"Sign Up"**
3. Enter your email
4. Verify your email
5. Create a password
6. You're in! ✅

---

## Step 2: Create New Project

1. In Railway dashboard, click **"+ New Project"** button (top right)
2. You'll see options:
   - **"Deploy from GitHub repo"** ← Click this!
   - "Empty Project"
   - "Deploy a template"

---

## Step 3: Connect GitHub Repository

1. Railway will show your GitHub repositories
2. **Search for:** `Student-Bazaar` or `student-bazaar`
3. **Click on your repository**
4. Railway will start setting up automatically

**What happens:**
- Railway detects it's a Java project (from `pom.xml`)
- Starts building your application
- Shows build progress

---

## Step 4: Wait for Initial Build

Railway will:
- ✅ Detect Java project
- ✅ Install Java 8
- ✅ Run `mvn clean package`
- ✅ Build your WAR file
- ⏳ This takes 2-5 minutes

**Watch the "Deployments" tab** to see progress.

**First build might fail** - that's okay! We'll fix it.

---

## Step 5: Add PostgreSQL Database

1. In your Railway project, click **"+ New"** button
2. Select **"Database"**
3. Click **"Add PostgreSQL"**
4. Wait for database to be created (30 seconds)

**What you'll see:**
- A new service called "Postgres"
- Database is being created

---

## Step 6: Get Database Connection Details

1. Click on the **"Postgres"** service (the database)
2. Go to **"Variables"** tab
3. You'll see connection details:
   - `PGHOST`
   - `PGPORT`
   - `PGDATABASE`
   - `PGUSER`
   - `PGPASSWORD`
   - `DATABASE_URL` ← This is what we need!

**Copy the `DATABASE_URL` value** - it looks like:
```
postgresql://postgres:password@containers-us-west-123.railway.app:5432/railway
```

---

## Step 7: Configure Environment Variables

1. Go back to your **web service** (not the database)
2. Click on your service name
3. Go to **"Variables"** tab
4. Click **"+ New Variable"**

### Add This Variable:

**Name:** `DATABASE_URL`

**Value:** Convert Railway's DATABASE_URL to JDBC format:

**Railway gives you:**
```
postgresql://postgres:password@host:port/database
```

**Convert to JDBC format:**
```
jdbc:postgresql://host:port/database?user=postgres&password=password
```

**Example:**
If Railway gives you:
```
postgresql://postgres:abc123@containers-us-west-123.railway.app:5432/railway
```

You convert to:
```
jdbc:postgresql://containers-us-west-123.railway.app:5432/railway?user=postgres&password=abc123
```

5. Click **"Add"**

---

## Step 8: Redeploy Application

After adding environment variable:
1. Go to **"Deployments"** tab
2. Click **"Redeploy"** button (or Railway auto-redeploys)
3. Wait for new deployment (2-3 minutes)

---

## Step 9: Get Your Live Link!

1. Go to **"Settings"** tab
2. Scroll to **"Networking"** section
3. Under **"Public Domain"**, click **"Generate Domain"**
4. Railway will create a URL like:
   ```
   https://student-bazaar-production.up.railway.app
   ```
5. **Copy this URL** - This is your deployed link! 🎉

---

## Step 10: Test Your Application

1. Open your deployed link in a browser
2. You should see your Student Bazaar homepage
3. Try logging in (if you've migrated your database)

**Note:** If you see errors, check the logs (next section).

---

## 🔍 How to Check Logs

1. Go to **"Deployments"** tab
2. Click on the latest deployment
3. Click **"View Logs"**
4. You'll see:
   - Build logs
   - Application logs
   - Any errors

---

## ⚠️ Common Issues & Fixes

### Issue 1: Build Fails
**Error:** "Maven build failed"

**Solution:**
- Check logs for specific error
- Make sure `pom.xml` is valid
- Railway might need a few minutes

### Issue 2: Database Connection Error
**Error:** "Database connection failed"

**Solution:**
- Verify `DATABASE_URL` format is correct (JDBC format)
- Check database is running (green status)
- Make sure you converted the URL correctly

### Issue 3: Application Won't Start
**Error:** "Application failed to start"

**Solution:**
- Check `Procfile` format
- Verify Java version (should be 1.8)
- Check application logs

### Issue 4: 404 Error on Website
**Error:** "Page not found"

**Solution:**
- Check if build completed successfully
- Verify WAR file was created
- Check application logs

---

## 📝 Database Migration Reminder

**Important:** Your database is currently MySQL, but Railway uses PostgreSQL.

**You need to:**
1. Export your MySQL schema
2. Convert to PostgreSQL (see `MYSQL_TO_POSTGRESQL_MIGRATION.md`)
3. Import to Railway PostgreSQL

**Or:** Start fresh with a new database on Railway.

---

## ✅ Success Checklist

- [ ] Railway account created
- [ ] Project created from GitHub
- [ ] PostgreSQL database added
- [ ] Environment variables configured
- [ ] Application deployed successfully
- [ ] Live link obtained
- [ ] Website accessible

---

## 🎉 You're Done!

Once you have your live link, share it:
```
https://your-app.railway.app
```

**Congratulations! Your app is now live on the internet!** 🚀

---

## 📞 Need Help?

- **Railway Docs:** https://docs.railway.app
- **Railway Discord:** https://discord.gg/railway
- **Check logs** in Railway dashboard

**Let's start! Go to https://railway.app and follow the steps above!**

