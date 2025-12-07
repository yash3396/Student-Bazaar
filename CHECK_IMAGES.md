# How to Check if Images are Actually Uploaded

## Step 1: Check NetBeans Output
After uploading an image, look for these messages in NetBeans Output window:

```
=== IMAGE UPLOAD DEBUG ===
App Path: C:\...\build\web\
Upload Path: C:\...\build\web\uploads
Generated filename: 1234567890_image.jpg
Saving file to: C:\...\build\web\uploads\1234567890_image.jpg
File saved successfully!
File exists: true
File size: 12345 bytes
Image path stored in DB: images/1234567890_image.jpg
=== END IMAGE UPLOAD DEBUG ===
```

## Step 2: Check Physical File Location
1. Navigate to: `[Your Project]/build/web/uploads/`
2. You should see files like: `1234567890_image.jpg`
3. If folder doesn't exist or is empty, images aren't being saved

## Step 3: Check Database
Run this SQL:
```sql
SELECT product_id, name, image FROM products ORDER BY product_id DESC LIMIT 5;
```

You should see paths like:
- `images/1234567890_image.jpg` ✅ (correct)
- `images/default` (no image uploaded)
- `https://via.placeholder.com/...` ❌ (old, needs fixing)

## Step 4: Test Image URL Directly
If database shows: `images/1234567890_image.jpg`

Try in browser: `http://localhost:8080/Student_Bazar/images/1234567890_image.jpg`

Should show:
- ✅ The actual image (if file exists)
- ❌ Default placeholder (if file doesn't exist)

## Step 5: Use Debug Page
Visit: `http://localhost:8080/Student_Bazar/testImage.jsp`

This shows:
- All product image paths from database
- Whether images load or fail
- Server path information

## Common Issues:

### Issue 1: Files saved but not found
**Cause**: Path mismatch between upload and retrieval
**Fix**: I've updated both servlets to use same path logic

### Issue 2: Files deleted on Clean/Build
**Cause**: `build/web/` folder is recreated
**Solution**: 
- Don't clean build after uploading
- OR use `web/uploads/` instead (but need to configure)

### Issue 3: Permission issues
**Cause**: Can't write to uploads folder
**Solution**: Check folder permissions, run as administrator

## What to Do Now:

1. **Upload a new product with image**
2. **Check NetBeans Output** for debug messages
3. **Check `build/web/uploads/` folder** - does file exist?
4. **Check database** - what path is stored?
5. **Try direct URL** - does image load?

Tell me what you see in each step!



