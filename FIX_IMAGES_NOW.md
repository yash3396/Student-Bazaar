# URGENT: Fix Images Not Showing

## The Problem
Your database has products with old `via.placeholder.com` URLs that can't load because:
1. No internet connection, OR
2. The service is blocked

## IMMEDIATE FIX - Choose One:

### Option 1: Update Database (RECOMMENDED)
Run this SQL in your MySQL database:

```sql
UPDATE products 
SET image = 'images/default'
WHERE image LIKE '%via.placeholder.com%' 
   OR image LIKE '%placeholder.com%';
```

This will fix all existing products instantly!

### Option 2: Use the SQL File
1. Open `update_image_paths.sql` (I just created it)
2. Copy the UPDATE statement
3. Run it in your MySQL database

### Option 3: Manual Fix via Code
I've already updated the code to automatically replace placeholder URLs, but you need to:
1. **Clean and Build** your project
2. **Restart** your server
3. The code will now automatically convert old URLs to `images/default`

## What I Fixed in Code:

✅ **ImageServlet.java** - Now detects and replaces placeholder.com URLs
✅ **All JSP pages** - Automatically convert placeholder URLs to `images/default`
✅ **AddProductServlet.java** - No longer uses external placeholder URLs

## Steps to Fix RIGHT NOW:

1. **Open your MySQL database** (phpMyAdmin, MySQL Workbench, or command line)

2. **Run this SQL:**
```sql
UPDATE products 
SET image = 'images/default'
WHERE image LIKE '%placeholder.com%';
```

3. **Refresh your browser** - Images should now show!

4. **If still not working:**
   - Clean and Build project
   - Restart server
   - Clear browser cache (Ctrl+Shift+Delete)

## Test It:

1. Visit: `http://localhost:8080/Student_Bazar/images/default`
   - Should show purple placeholder (works offline!)

2. Visit: `http://localhost:8080/Student_Bazar/home.jsp`
   - All products should show images or default placeholder

3. Check browser console (F12)
   - Should have NO errors about placeholder.com

## Why This Happened:

When products were created without images, they got:
- `https://via.placeholder.com/400x300/...` (requires internet)

Now they should have:
- `images/default` (works offline, served by ImageServlet)

---

**DO THIS NOW:** Run the SQL update and refresh your browser!



