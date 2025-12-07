-- SQL Script to Update Old Placeholder Image URLs
-- Run this in your MySQL database to fix existing products

-- Update products with old placeholder.com URLs to use default image
UPDATE products 
SET image = 'images/default'
WHERE image LIKE '%via.placeholder.com%' 
   OR image LIKE '%placeholder.com%';

-- Update products with NULL or empty image to use default
UPDATE products 
SET image = 'images/default'
WHERE image IS NULL 
   OR image = '' 
   OR TRIM(image) = '';

-- Verify the update
SELECT product_id, name, image 
FROM products 
WHERE image LIKE '%placeholder%' 
   OR image IS NULL 
   OR image = '';

-- After running, all products should have either:
-- - images/filename.jpg (for uploaded images)
-- - images/default (for products without images)



