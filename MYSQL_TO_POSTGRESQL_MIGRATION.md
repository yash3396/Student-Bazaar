# 🔄 MySQL to PostgreSQL Migration Guide

## Overview

Your current database is **MySQL**, but Railway uses **PostgreSQL**. You need to migrate your schema and data.

---

## Key Differences

| MySQL | PostgreSQL |
|-------|------------|
| `AUTO_INCREMENT` | `SERIAL` or `GENERATED ALWAYS AS IDENTITY` |
| `DATETIME` | `TIMESTAMP` |
| `TEXT` | `TEXT` (same) |
| `VARCHAR(255)` | `VARCHAR(255)` (same) |
| `INT` | `INTEGER` (same) |
| `DOUBLE` | `DOUBLE PRECISION` |
| `ENGINE=InnoDB` | (Remove - not needed) |

---

## Step 1: Export MySQL Schema

### Using MySQL Workbench or Command Line:

```sql
-- Export schema only (no data)
mysqldump -u root -p --no-data student_bazaar > schema.sql

-- Export with data
mysqldump -u root -p student_bazaar > full_export.sql
```

---

## Step 2: Convert Schema

### Common Conversions:

#### 1. AUTO_INCREMENT → SERIAL
```sql
-- MySQL
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    ...
);

-- PostgreSQL
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    ...
);
```

#### 2. DATETIME → TIMESTAMP
```sql
-- MySQL
created_at DATETIME DEFAULT CURRENT_TIMESTAMP

-- PostgreSQL
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

#### 3. Remove MySQL-specific syntax
```sql
-- MySQL
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci

-- PostgreSQL (remove these lines)
```

---

## Step 3: Example Converted Schema

### Original MySQL Schema:
```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    college_id VARCHAR(50),
    department VARCHAR(100),
    year VARCHAR(20),
    phone VARCHAR(20),
    gender VARCHAR(10),
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Converted PostgreSQL Schema:
```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    college_id VARCHAR(50),
    department VARCHAR(100),
    year VARCHAR(20),
    phone VARCHAR(20),
    gender VARCHAR(10),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Step 4: Import to Railway PostgreSQL

### Option A: Using Railway Database GUI
1. Go to your PostgreSQL database in Railway
2. Click **"Data"** tab
3. Use SQL editor to paste and run your converted schema

### Option B: Using psql Command Line
```bash
# Connect to Railway PostgreSQL
psql "postgresql://user:password@host:port/database"

# Run your SQL file
\i schema.sql
```

### Option C: Using Database Tool (DBeaver, pgAdmin)
1. Connect to Railway PostgreSQL using connection details
2. Run your converted SQL script

---

## Step 5: Migrate Data (Optional)

If you have existing data:

### Using pgloader (Automated)
```bash
# Install pgloader
# Then run:
pgloader mysql://user:password@localhost/student_bazaar \
         postgresql://user:password@railway-host:port/database
```

### Manual Export/Import
1. Export MySQL data to CSV
2. Import CSV to PostgreSQL

---

## Quick Reference: Your Tables

Based on your codebase, you likely have these tables:

### users
```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    college_id VARCHAR(50),
    department VARCHAR(100),
    year VARCHAR(20),
    phone VARCHAR(20),
    gender VARCHAR(10),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### products
```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    seller_id INTEGER REFERENCES users(user_id),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DOUBLE PRECISION NOT NULL,
    description TEXT,
    image VARCHAR(500),
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### transactions
```sql
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    buyer_id INTEGER REFERENCES users(user_id),
    product_id INTEGER REFERENCES products(product_id),
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### offers
```sql
CREATE TABLE offers (
    offer_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    buyer_id INTEGER REFERENCES users(user_id),
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### spam_reports
```sql
CREATE TABLE spam_reports (
    report_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    reporter_id INTEGER REFERENCES users(user_id),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Testing Migration

After importing:

1. **Test connection:**
   ```sql
   SELECT COUNT(*) FROM users;
   ```

2. **Verify tables:**
   ```sql
   \dt  -- List all tables
   ```

3. **Check data:**
   ```sql
   SELECT * FROM users LIMIT 5;
   ```

---

## Tools for Migration

1. **pgloader** - Automated MySQL to PostgreSQL migration
2. **DBeaver** - Database management tool with migration features
3. **pgAdmin** - PostgreSQL official admin tool
4. **Manual conversion** - Edit SQL files manually

---

## Common Issues

### Issue 1: Syntax Errors
**Error:** `syntax error at or near "AUTO_INCREMENT"`

**Solution:** Replace all `AUTO_INCREMENT` with `SERIAL`

### Issue 2: Character Set
**Error:** `invalid input syntax for type`

**Solution:** Ensure UTF-8 encoding in PostgreSQL

### Issue 3: Foreign Keys
**Error:** `foreign key constraint fails`

**Solution:** Import tables in correct order (users first, then products, etc.)

---

## Alternative: Use MySQL on Railway

If migration is too complex, you can:
1. Use Railway's MySQL addon (if available)
2. Use external MySQL hosting (PlanetScale, AWS RDS)
3. Keep using PostgreSQL but convert schema

---

## Need Help?

- **PostgreSQL Docs:** https://www.postgresql.org/docs/
- **Migration Tools:** https://www.postgresql.org/docs/current/migration.html
- **pgloader:** https://pgloader.readthedocs.io/

---

**After migration, update your `DATABASE_URL` in Railway environment variables!**

