# Recommendation System: Implementation and Explanation

This README file explains the implementation of a recommendation system using SQL and Python, which employs both collaborative filtering and content-based recommendation techniques. The system uses a MySQL database to store user, product, and purchase data.

---

## Database Schema

### Tables

1. **`user_product_aggregation`**
   - Aggregates purchase data by user and category.
   
   ```sql
   CREATE TABLE user_product_aggregation (
       user_id INT NOT NULL,
       category VARCHAR(255) NOT NULL,
       purchase_count INT NOT NULL,
       PRIMARY KEY (user_id, category)
   );
   ```

2. **`Users`**
   - Stores user information.
   
   ```sql
   CREATE TABLE Users (
       user_id INT PRIMARY KEY AUTO_INCREMENT,
       name VARCHAR(100),
       email VARCHAR(100)
   );
   ```

3. **`Products`**
   - Stores product information.
   
   ```sql
   CREATE TABLE Products (
       product_id INT PRIMARY KEY AUTO_INCREMENT,
       name VARCHAR(100),
       category VARCHAR(50),
       price DECIMAL(10, 2)
   );
   ```

4. **`Purchases`**
   - Stores user purchase data.
   
   ```sql
   CREATE TABLE Purchases (
       purchase_id INT PRIMARY KEY AUTO_INCREMENT,
       user_id INT,
       product_id INT,
       purchase_date DATE,
       FOREIGN KEY (user_id) REFERENCES Users(user_id),
       FOREIGN KEY (product_id) REFERENCES Products(product_id)
   );
   ```

---

## Data Initialization

### Insert Sample Data

1. **Insert Users**

   ```sql
   INSERT INTO Users (name, email) VALUES
   ('Akshat', 'akshat@example.com'),
   ('Priyanshu', 'priyanshu@example.com'),
   ('Prashant', 'prashant@example.com'),
   ('Abhinandan', 'abhinandan@example.com');
   ```

2. **Insert Products**

   ```sql
   INSERT INTO Products (name, category, price) VALUES
   ('Laptop', 'Electronics', 50000),
   ('Mouse', 'Electronics', 500),
   ('Keyboard', 'Electronics', 1000),
   ('Headphones', 'Accessories', 2000),
   ('Smartphone', 'Electronics', 30000),
   ('Charger', 'Electronics', 1500),
   ('Desk Lamp', 'Accessories', 1200),
   ('Backpack', 'Accessories', 3000),
   ('Gaming Console', 'Electronics', 40000),
   ('Tablet', 'Electronics', 20000);
   ```

3. **Insert Purchases**

   ```sql
   INSERT INTO Purchases (user_id, product_id, purchase_date) VALUES
   (1, 1, '2025-01-01'), -- Laptop
   (1, 2, '2025-01-03'), -- Mouse
   (1, 5, '2025-01-10'), -- Smartphone

   (2, 3, '2025-01-05'), -- Keyboard
   (2, 4, '2025-01-06'), -- Headphones
   (2, 6, '2025-01-08'), -- Charger

   (3, 7, '2025-01-09'), -- Desk Lamp
   (3, 8, '2025-01-11'), -- Backpack
   (3, 9, '2025-01-12'), -- Gaming Console

   (4, 10, '2025-01-13'), -- Tablet
   (4, 4, '2025-01-14'), -- Headphones
   (4, 5, '2025-01-15'); -- Smartphone
   ```

4. **Insert Aggregated Data**

   ```sql
   INSERT INTO user_product_aggregation (user_id, category, purchase_count)
   SELECT Purchases.user_id, Products.category, COUNT(Purchases.product_id) AS purchase_count
   FROM Purchases
   JOIN Products ON Purchases.product_id = Products.product_id
   GROUP BY Purchases.user_id, Products.category;
   ```

---

## Recommendation Queries

### 1. Collaborative Filtering Query

Recommends products based on items purchased by other users who have bought the same products as the target user.

```sql
SELECT pr.name AS recommended_product, COUNT(*) AS popularity
FROM Purchases p1
JOIN Purchases p2 ON p1.user_id != p2.user_id
                  AND p1.product_id = p2.product_id
JOIN Products pr ON p2.product_id = pr.product_id
WHERE p1.user_id = 1
GROUP BY pr.name
ORDER BY popularity DESC;
```

### 2. Content-Based Recommendation Query

Recommends products from the same categories as the products purchased by the target user, excluding already purchased items.

```sql
SELECT DISTINCT p2.name AS recommended_product
FROM Purchases p1
JOIN Products p1p ON p1.product_id = p1p.product_id
JOIN Products p2 ON p1p.category = p2.category
WHERE p1.user_id = 1
  AND p2.product_id NOT IN (
      SELECT product_id FROM Purchases WHERE user_id = 1
  );
```

---

## Python Integration

### Connecting Python to MySQL Database

```python
import mysql.connector

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="password",
    database="ecommerce_db"
)

cursor = db.cursor()

# Collaborative Filtering Recommendation
def collaborative_filtering(user_id):
    query = """
    SELECT DISTINCT pr.name AS recommended_product
    FROM Purchases p1
    JOIN Purchases p2 ON p1.user_id != p2.user_id
                      AND p1.product_id = p2.product_id
    JOIN Products pr ON p2.product_id = pr.product_id
    WHERE p1.user_id = %s;
    """
    cursor.execute(query, (user_id,))
    results = cursor.fetchall()
    return [row[0] for row in results]

# Content-Based Recommendation
def content_based(user_id):
    query = """
    SELECT DISTINCT p2.name AS recommended_product
    FROM Purchases p1
    JOIN Products p1p ON p1.product_id = p1p.product_id
    JOIN Products p2 ON p1p.category = p2.category
    WHERE p1.user_id = %s
      AND p2.product_id NOT IN (
          SELECT product_id FROM Purchases WHERE user_id = %s
      );
    """
    cursor.execute(query, (user_id, user_id))
    results = cursor.fetchall()
    return [row[0] for row in results]

# Example Usage
try:
    user_id = 1
    collab_recommendations = collaborative_filtering(user_id)
    content_recommendations = content_based(user_id)

    print("Collaborative Filtering Recommendations:", collab_recommendations)
    print("Content-Based Recommendations:", content_recommendations)

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    # Close connection
    cursor.close()
    db.close()
```

---

## Summary
This recommendation system combines collaborative filtering and content-based techniques to provide personalized product suggestions. It integrates seamlessly with a MySQL database and Python for real-time recommendations.

