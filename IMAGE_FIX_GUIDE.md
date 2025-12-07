# Image Loading Fix Guide

## Problem
Images uploaded by users are not displaying on the website.

## Solution Implemented

### 1. Created ImageServlet
- **File**: `ImageServlet.java`
- **Purpose**: Serves uploaded images from the uploads folder
- **URL Pattern**: `/images/*`
- This servlet intercepts all requests to `/images/` and serves the actual files from the `uploads` folder

### 2. Updated Image Paths
- Changed from `uploads/filename.jpg` to `images/filename.jpg`
- The ImageServlet maps `/images/` URLs to the physical `uploads/` folder

### 3. Default Image
- Using placeholder image service for products without images
- URL: `https://via.placeholder.com/400x300/667eea/ffffff?text=No+Image`

## How It Works

1. **Upload Process**:
   - User uploads image via form
   - Image saved to: `[webapp]/uploads/123456789_image.jpg`
   - Database stores: `images/123456789_image.jpg`

2. **Display Process**:
   - JSP shows: `<img src="images/123456789_image.jpg">`
   - Browser requests: `http://localhost:8080/StudentBazaar/images/123456789_image.jpg`
   - ImageServlet intercepts and serves from `uploads/` folder

## Steps to Test

### 1. Clean and Build
```
Right-click project → Clean and Build
```

### 2. Create uploads folder manually (if needed)
```
Location: build/web/uploads/
```

### 3. Run the application
```
Press F6 or Right-click → Run
```

### 4. Test Image Upload
1. Login to the application
2. Go to "Add Product"
3. Fill in details and upload an image (JPG or PNG, max 2MB)
4. Submit the form
5. Check if image displays in "My Listings"

## Troubleshooting

### If images still don't load:

#### Option 1: Check Console Logs
Look for these messages in NetBeans Output:
```
App Path: C:\...\build\web\
Upload Path: C:\...\build\web\uploads
Upload directory created: true
Saving file to: C:\...\build\web\uploads\123456789_image.jpg
Image uploaded successfully: images/123456789_image.jpg
```

#### Option 2: Manually create uploads folder
1. Navigate to: `[Your Project]/build/web/`
2. Create folder named: `uploads`
3. Set permissions to read/write

#### Option 3: Check existing products
If you have old products with wrong image paths:
1. Go to database
2. Update products table:
```sql
UPDATE products 
SET image = 'https://via.placeholder.com/400x300/667eea/ffffff?text=No+Image'
WHERE image LIKE 'images/default%';
```

#### Option 4: Use absolute path (temporary fix)
If nothing works, you can temporarily use external images:
- Upload images to a free image hosting service
- Store the full URL in database

## Files Modified

1. `AddProductServlet.java` - Updated image path handling
2. `EditProductServlet.java` - Updated image path handling
3. `ImageServlet.java` - NEW - Serves uploaded images

## Important Notes

- Images are stored in `build/web/uploads/` (not `web/uploads/`)
- When you Clean and Build, the uploads folder is recreated
- For production, consider using external storage (AWS S3, Cloudinary, etc.)
- Default placeholder image requires internet connection

## Alternative: Use Database BLOB (Not Recommended)
If file system approach doesn't work, you can store images as BLOB in database, but this is not recommended for performance reasons.

---

**Status**: Image loading should now work correctly! 🎉
