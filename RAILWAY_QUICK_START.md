# 🚀 Railway Quick Start - 5 Minute Deploy

## Prerequisites
- ✅ Code pushed to GitHub
- ✅ Railway account (sign up at https://railway.app)

## Steps

### 1. Create Project (2 minutes)
1. Go to https://railway.app
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose **`student-bazaar`** repository

### 2. Add Database (1 minute)
1. Click **"+ New"** → **"Database"** → **"Add PostgreSQL"**
2. Wait for database to be created
3. Copy the `DATABASE_URL` from database **"Variables"** tab

### 3. Configure Environment (1 minute)
1. Click on your **web service** (not database)
2. Go to **"Variables"** tab
3. Add:
   ```
   DATABASE_URL=jdbc:postgresql://[host]:[port]/[database]?user=[user]&password=[password]
   ```
   (Convert Railway's `DATABASE_URL` to JDBC format)

### 4. Deploy (1 minute)
1. Railway auto-detects Java and starts building
2. Watch **"Deployments"** tab
3. Wait for "Deployed successfully" ✅

### 5. Get Your Link!
1. Go to **"Settings"** → **"Networking"**
2. Click **"Generate Domain"**
3. Copy your URL: `https://your-app.railway.app` 🎉

---

## ⚠️ Important: Database Migration

Your database is currently MySQL. Railway uses PostgreSQL.

**Quick fix:**
1. Export your MySQL schema
2. Convert to PostgreSQL (see full guide)
3. Import to Railway PostgreSQL

**Or:** Use Railway's MySQL addon (if available) instead of PostgreSQL.

---

## 📝 File Uploads Note

Railway's file system is temporary. Files are lost on restart.

**Solutions:**
- Use Railway Volumes (for persistent storage)
- Use cloud storage (AWS S3, Cloudinary)
- Store in database (not recommended)

See `RAILWAY_DEPLOYMENT_GUIDE.md` for details.

---

## 🆘 Troubleshooting

**Build fails?** Check logs in Railway dashboard
**Database error?** Verify `DATABASE_URL` format
**App won't start?** Check `Procfile` and logs

---

**Full guide:** See `RAILWAY_DEPLOYMENT_GUIDE.md`

