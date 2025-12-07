## Offer System Troubleshooting Guide

### Issue: Inbox and Offer System Not Working

## Step 1: Verify Database Table

Run these commands in MySQL:

```sql
USE student_bazaar;

-- Check if table exists
SHOW TABLES LIKE 'offers';

-- If table doesn't exist, create it:
CREATE TABLE IF NOT EXISTS offers (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    offered_price DECIMAL(10,2) NOT NULL,
    message TEXT,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (buyer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Verify table structure
DESCRIBE offers;
```

## Step 2: Clean and Build Project

1. In NetBeans: Right-click project → **Clean and Build**
2. Wait for build to complete
3. Check Output window for any errors

## Step 3: Test Each Feature

### Test 1: Access Inbox Page
1. Login to application
2. Click "Inbox" in navigation
3. **Expected**: Page loads showing "Received Offers" and "Sent Offers" tabs
4. **If Error**: Check NetBeans Output window for error details

### Test 2: Make an Offer
1. Go to any product details page (not your own product)
2. Click "Make an Offer" button
3. **Expected**: Modal popup appears
4. Enter offer price and message
5. Click "Send Offer"
6. **Expected**: Redirects to product page with success message

### Test 3: View Offers in Inbox
1. Login as the seller
2. Go to Inbox
3. **Expected**: See the offer in "Received Offers" tab
4. **Expected**: Red badge on Inbox link showing count

### Test 4: Accept/Reject Offer
1. In Inbox, click "Accept" or "Reject" button
2. **Expected**: Status updates and page refreshes

### Test 5: Mark as Sold
1. Go to "My Listings"
2. Find an active product
3. Click "Mark as Sold" button
4. **Expected**: Product status changes to "Sold"

## Common Errors and Solutions

### Error 1: "Table 'student_bazaar.offers' doesn't exist"
**Solution**: Run the CREATE TABLE command above

### Error 2: "Cannot find symbol: class OfferDAO"
**Solution**: 
1. Clean and Build project
2. Check that OfferDAO.java is in correct package
3. Restart NetBeans if needed

### Error 3: Inbox page shows blank/error
**Solution**:
1. Check browser console (F12) for JavaScript errors
2. Check NetBeans Output for Java errors
3. Verify you're logged in (session exists)

### Error 4: "Make Offer" button doesn't appear
**Solution**:
1. Make sure you're NOT the owner of the product
2. Make sure product status is "Active" (not "Sold")
3. Clear browser cache (Ctrl+F5)

### Error 5: Notification badge doesn't show
**Solution**:
1. Make sure there are pending offers
2. Refresh the page
3. Check if OfferDAO.getPendingOffersCount() returns correct value

## Manual Testing Checklist

- [ ] Database table 'offers' exists
- [ ] Can access inbox.jsp without errors
- [ ] Can see "Make Offer" button on product details
- [ ] Can submit an offer successfully
- [ ] Offer appears in seller's inbox
- [ ] Notification badge shows correct count
- [ ] Can accept/reject offers
- [ ] Can mark products as sold
- [ ] Sold products don't show "Make Offer" button

## Debug Mode

Add these debug statements to check if code is working:

### In MakeOfferServlet.java (after line 30):
```java
System.out.println("Making offer - Product ID: " + productId);
System.out.println("Buyer ID: " + buyerId);
System.out.println("Offered Price: " + offeredPrice);
```

### In OfferDAO.java createOffer method (after line 15):
```java
System.out.println("Creating offer in database...");
int result = pstmt.executeUpdate();
System.out.println("Offer created: " + (result > 0));
return result > 0;
```

### Check NetBeans Output Window
Look for these messages when testing:
- "Making offer - Product ID: X"
- "Creating offer in database..."
- "Offer created: true"

## Still Not Working?

### Option 1: Check File Locations
Verify these files exist:
- `src/java/com/studentbazaar/models/Offer.java`
- `src/java/com/studentbazaar/dao/OfferDAO.java`
- `src/java/com/studentbazaar/servlets/MakeOfferServlet.java`
- `src/java/com/studentbazaar/servlets/ManageOfferServlet.java`
- `src/java/com/studentbazaar/servlets/MarkAsSoldServlet.java`
- `web/inbox.jsp`

### Option 2: Restart Everything
1. Stop GlassFish server
2. Close NetBeans
3. Reopen NetBeans
4. Clean and Build
5. Run project

### Option 3: Check Browser Console
1. Press F12 in browser
2. Go to Console tab
3. Look for JavaScript errors
4. Go to Network tab
5. Try making an offer
6. Check if request succeeds (status 200)

## Quick Test SQL

Insert a test offer manually:
```sql
INSERT INTO offers (product_id, buyer_id, seller_id, offered_price, message, status)
VALUES (1, 2, 1, 500.00, 'Test offer', 'Pending');

-- Check if it appears
SELECT * FROM offers;
```

Then check if it shows in inbox.jsp

---

**If you're still having issues, check the exact error message in NetBeans Output window and share it for specific help.**
