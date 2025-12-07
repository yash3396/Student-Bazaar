# 🚂 Railway Deployment Guide - Student Bazaar

## ✅ What We've Done

1. ✅ **Converted to Maven** - Created `pom.xml` with all dependencies
2. ✅ **Updated Database Connection** - Now uses environment variables for cloud database
3. ✅ **Created Deployment Files** - `Procfile`, `system.properties`, `Dockerfile`, `web.xml`
4. ✅ **Added PostgreSQL Support** - Can use Railway's PostgreSQL database

---

## 📋 Pre-Deployment Checklist

- [x] Project converted to Maven (`pom.xml` created)
- [x] Database connection updated for environment variables
- [x] Deployment files created
- [ ] Code committed and pushed to GitHub
- [ ] Railway account created
- [ ] Database set up on Railway

---

## 🚀 Step-by-Step Deployment Instructions

### Step 1: Commit and Push to GitHub

First, make sure all changes are committed and pushed to GitHub:

```bash
# Navigate to your project directory
cd "C:\Users\admin\Documents\NetBeansProjects\Student Bazar"

# Check status
git status

# Add all new files
git add .

# Commit changes
git commit -m "Add Maven configuration and Railway deployment files"

# Push to GitHub
git push origin main
```

**New files to commit:**
- `pom.xml` (Maven configuration)
- `Procfile` (Railway start command)
- `system.properties` (Java version)
- `Dockerfile` (Container configuration)
- `web/WEB-INF/web.xml` (Web application config)
- `railway.json` (Railway config)
- Updated `DBConnection.java` (Environment variables)

---

### Step 2: Create Railway Account

1. Go to: **https://railway.app**
2. Click **"Start a New Project"** or **"Login"**
3. Sign up with your **GitHub account** (recommended)
4. Authorize Railway to access your GitHub repositories

---

### Step 3: Create New Project on Railway

1. Click **"New Project"** button
2. Select **"Deploy from GitHub repo"**
3. Choose your repository: **`student-bazaar`** (or `Student-Bazaar`)
4. Railway will automatically detect it's a Java project (from `pom.xml`)

---

### Step 4: Set Up PostgreSQL Database

Railway provides PostgreSQL databases. Here's how to add one:

1. In your Railway project dashboard, click **"+ New"**
2. Select **"Database"** → **"Add PostgreSQL"**
3. Railway will create a PostgreSQL database
4. **Copy the connection details** (you'll need them in Step 5)

**Important:** Railway provides connection details as:
- `DATABASE_URL` (full connection string)
- Or separate: `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`

---

### Step 5: Configure Environment Variables

1. In your Railway project, click on your **service** (the web app)
2. Go to **"Variables"** tab
3. Add these environment variables:

#### Option A: Using DATABASE_URL (Recommended)
```
DATABASE_URL=postgresql://user:password@host:port/database
```

Railway automatically provides this when you add PostgreSQL!

#### Option B: Using Separate Variables
If Railway doesn't provide `DATABASE_URL`, add:
```
DB_USER=your_postgres_user
DB_PASSWORD=your_postgres_password
DATABASE_URL=jdbc:postgresql://host:port/database
```

**How to get connection details:**
1. Click on your PostgreSQL database in Railway
2. Go to **"Variables"** tab
3. Copy the connection string or individual values

**Example DATABASE_URL format:**
```
postgresql://postgres:password@containers-us-west-123.railway.app:5432/railway
```

**Convert to JDBC format:**
```
jdbc:postgresql://containers-us-west-123.railway.app:5432/railway?user=postgres&password=password
```

---

### Step 6: Update Database Schema

Your local MySQL database needs to be migrated to PostgreSQL. Here's how:

#### Option A: Use Railway's Database GUI
1. Click on your PostgreSQL database in Railway
2. Go to **"Data"** tab
3. Use the SQL editor to run your schema

#### Option B: Use psql (Command Line)
1. Install PostgreSQL client tools
2. Connect using Railway's connection string
3. Run your SQL scripts

#### Option C: Use a Database Tool
- **DBeaver** (Free, cross-platform)
- **pgAdmin** (PostgreSQL official)
- Connect using Railway's connection details

**Important SQL Changes for PostgreSQL:**
- `AUTO_INCREMENT` → `SERIAL` or `GENERATED ALWAYS AS IDENTITY`
- `DATETIME` → `TIMESTAMP`
- `TEXT` types are similar
- Remove MySQL-specific syntax

**Quick Migration Script:**
```sql
-- Example: Convert MySQL to PostgreSQL
-- MySQL: AUTO_INCREMENT
-- PostgreSQL: SERIAL

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    -- ... other fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

### Step 7: Deploy!

1. Railway will **automatically detect** your `pom.xml` and start building
2. Watch the **"Deployments"** tab for build progress
3. Build process:
   - Installs Java 8
   - Runs `mvn clean package`
   - Builds WAR file
   - Starts the application

**Expected build output:**
```
✓ Detected Java project
✓ Installing Java 8
✓ Running: mvn clean package
✓ Building WAR file...
✓ Starting application...
```

---

### Step 8: Get Your Live Link!

Once deployment completes:

1. Go to **"Settings"** tab in your service
2. Under **"Networking"**, you'll see:
   - **Public Domain**: `https://your-app-name.railway.app`
3. Click **"Generate Domain"** if not already generated
4. **Copy the URL** - this is your deployed link! 🎉

**Your deployed link will look like:**
```
https://student-bazaar-production.up.railway.app
```

---

## 🔧 Troubleshooting

### Issue 1: Build Fails

**Error:** `Maven build failed`

**Solution:**
- Check Railway logs for specific errors
- Ensure `pom.xml` is valid
- Verify all dependencies are available
- Check Java version compatibility

### Issue 2: Database Connection Fails

**Error:** `Database connection failed`

**Solution:**
1. Verify environment variables are set correctly
2. Check `DATABASE_URL` format (should be JDBC format)
3. Ensure database is running in Railway
4. Check database credentials

**Test connection:**
- Use Railway's database GUI to verify connection
- Check application logs for connection errors

### Issue 3: Application Won't Start

**Error:** `Application failed to start`

**Solution:**
- Check `Procfile` format
- Verify WAR file is built correctly
- Check port configuration (Railway sets `PORT` automatically)
- Review application logs

### Issue 4: Images Not Loading

**Problem:** Uploaded images don't display

**Solution:**
- Railway uses **ephemeral file system** (files are lost on restart)
- **Option 1:** Use cloud storage (AWS S3, Cloudinary, Railway Volumes)
- **Option 2:** Store images in database as BLOB (not recommended for large files)
- **Option 3:** Use Railway Volumes for persistent storage

**Quick Fix - Use Railway Volumes:**
1. Add a **Volume** to your service
2. Mount it to `/app/uploads`
3. Update `ImageServlet` to use the volume path

---

## 📝 Important Notes

### File Uploads on Railway

Railway's file system is **ephemeral** - files are deleted when the app restarts or redeploys.

**Solutions:**
1. **Railway Volumes** (Recommended for small files)
   - Add a Volume in Railway
   - Mount to `/app/uploads`
   - Files persist across deployments

2. **Cloud Storage** (Recommended for production)
   - AWS S3
   - Cloudinary
   - Railway's object storage (if available)

3. **Database Storage** (Not recommended)
   - Store images as BLOB in database
   - Works but not scalable

### Database Migration

Your current database is **MySQL**. Railway uses **PostgreSQL**.

**Key differences:**
- Syntax differences (see migration guide above)
- Data types may need adjustment
- Some MySQL-specific features won't work

**Migration tools:**
- **pgloader** - Automated MySQL to PostgreSQL migration
- **Manual migration** - Export SQL, convert, import

### Environment Variables

Always use environment variables for:
- Database credentials
- API keys
- Secret keys
- Configuration that differs between environments

**Never commit:**
- Passwords
- API keys
- Database credentials
- Secret tokens

---

## 🎯 After Deployment

### 1. Test Your Application

Visit your deployed link and test:
- [ ] User registration
- [ ] User login
- [ ] Add product
- [ ] View products
- [ ] Image upload (if configured)
- [ ] Search functionality
- [ ] All major features

### 2. Monitor Logs

- Go to **"Deployments"** tab
- Click on latest deployment
- View **"Logs"** for real-time application logs

### 3. Set Up Custom Domain (Optional)

1. Go to **"Settings"** → **"Networking"**
2. Click **"Custom Domain"**
3. Add your domain name
4. Follow DNS configuration instructions

### 4. Enable HTTPS

Railway automatically provides HTTPS for all domains! ✅

---

## 📊 Railway Pricing

- **Free Tier:** $5 credit/month
- **Hobby Plan:** $5/month (if you exceed free tier)
- **Pro Plan:** $20/month (for production apps)

**Your app will likely stay in free tier** for development/testing.

---

## 🔄 Updating Your Application

After making changes:

1. **Commit changes:**
   ```bash
   git add .
   git commit -m "Your update message"
   git push origin main
   ```

2. **Railway auto-deploys:**
   - Railway detects GitHub push
   - Automatically rebuilds and redeploys
   - Your changes go live in 2-5 minutes

3. **Manual deploy:**
   - Go to Railway dashboard
   - Click **"Redeploy"** button

---

## 📞 Need Help?

### Railway Resources:
- **Documentation:** https://docs.railway.app
- **Community:** https://discord.gg/railway
- **Support:** support@railway.app

### Common Issues:
- Check Railway status: https://status.railway.app
- Review application logs in Railway dashboard
- Check environment variables are set correctly

---

## ✅ Success Checklist

- [ ] Code pushed to GitHub
- [ ] Railway account created
- [ ] Project deployed on Railway
- [ ] PostgreSQL database added
- [ ] Environment variables configured
- [ ] Database schema migrated
- [ ] Application running successfully
- [ ] Live link obtained
- [ ] Application tested
- [ ] File uploads configured (if needed)

---

## 🎉 You're Done!

Once all steps are complete, you'll have:
- ✅ Live website URL: `https://your-app.railway.app`
- ✅ Cloud database (PostgreSQL)
- ✅ Automatic deployments from GitHub
- ✅ HTTPS enabled
- ✅ Production-ready application

**Share your link:**
```
https://your-app.railway.app
```

Congratulations! Your Student Bazaar is now live! 🚀

