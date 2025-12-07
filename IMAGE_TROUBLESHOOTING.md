# Image Display Troubleshooting Guide

## Quick Fix Steps

### Step 1: Clean and Build Project
1. In NetBeans: Right-click project → **Clean and Build**
2. This ensures ImageServlet is compiled and deployed

### Step 2: Check Uploads Folder
The uploads folder should be created automatically, but if images still don't show:

1. Navigate to: `[Your Project]/build/web/`
2. Create folder named: `uploads` (if it doesn't exist)
3. Make sure it has read/write permissions

### Step 3: Test Image Servlet
1. After running the application, visit:
   ```
   http://localhost:8080/Student_Bazar/images/default
   ```
2. You should see a purple SVG image with "No Image Available" text
3. If you see 404, the servlet isn't registered properly

### Step 4: Check Server Logs
Look in NetBeans Output window for:
- `ImageServlet - Looking for: [filename]`
- `ImageServlet - Upload path: [path]`
- `ImageServlet - File exists: true/false`

### Step 5: Use Debug Page
1. Visit: `http://localhost:8080/Student_Bazar/testImage.jsp`
2. This page shows:
   - All product images
   - Image paths from database
   - Direct links to test images
   - Server path information

## Common Issues & Solutions

### Issue 1: Images show broken icon
**Solution**: 
- Check browser console (F12) for errors
- Verify ImageServlet is deployed
- Check that image path in database starts with `images/`

### Issue 2: Images show placeholder but file exists
**Possible Causes**:
- Wrong file path in database
- File in wrong location
- Permission issues

**Solution**:
1. Check database: `SELECT image FROM products WHERE product_id = [id]`
2. Should be: `images/filename.jpg` (not `uploads/filename.jpg`)
3. Verify file exists at: `build/web/uploads/filename.jpg`

### Issue 3: ImageServlet not working
**Solution**:
1. Check if servlet is registered in `web.xml` (if using web.xml)
2. Verify `@WebServlet("/images/*")` annotation is present
3. Restart server after code changes

### Issue 4: Images work in IDE but not in browser
**Solution**:
- Clear browser cache (Ctrl+Shift+Delete)
- Try incognito/private mode
- Check browser console for CORS or other errors

## Database Fix

If you have existing products with wrong image paths:

```sql
-- Check current image paths
SELECT product_id, name, image FROM products;

-- Fix paths that don't start with 'images/'
UPDATE products 
SET image = CONCAT('images/', SUBSTRING_INDEX(image, '/', -1))
WHERE image NOT LIKE 'images/%' 
  AND image NOT LIKE 'http%'
  AND image IS NOT NULL;

-- Set default for NULL or empty
UPDATE products 
SET image = 'images/default'
WHERE image IS NULL OR image = '';
```

## Manual Testing

### Test 1: Upload New Image
1. Go to "Add Product"
2. Upload an image file (JPG/PNG, < 2MB)
3. Submit form
4. Check "My Listings" - image should appear
5. If not, check NetBeans Output for upload messages

### Test 2: Check Image File
1. After uploading, check: `build/web/uploads/`
2. File should be there with name like: `1234567890_filename.jpg`
3. Database should have: `images/1234567890_filename.jpg`

### Test 3: Direct URL Access
1. If image path is `images/1234567890_filename.jpg`
2. Try: `http://localhost:8080/Student_Bazar/images/1234567890_filename.jpg`
3. Should display the image or default placeholder

## Verification Checklist

- [ ] ImageServlet.java is compiled (check build/classes)
- [ ] Uploads folder exists at `build/web/uploads/`
- [ ] Image paths in database start with `images/`
- [ ] Image files exist in `build/web/uploads/`
- [ ] Server logs show ImageServlet activity
- [ ] Browser console shows no image errors
- [ ] Default image works: `/images/default`

## Still Not Working?

1. **Check NetBeans Output** for detailed error messages
2. **Use testImage.jsp** to see what's happening
3. **Verify servlet mapping** in server logs
4. **Try external image URL** in database to test if it's a path issue
5. **Check file permissions** on uploads folder

## Alternative: Use External Images

If file system approach doesn't work, you can temporarily use external image hosting:

1. Upload images to: https://imgur.com or https://imgbb.com
2. Get direct image URL
3. Store full URL in database: `https://i.imgur.com/xxxxx.jpg`
4. Images will load directly from external source

---

**Last Updated**: 2025
**Status**: Comprehensive troubleshooting guide



