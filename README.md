# case_studey-E-commerce-Product-Recommendation-System-Amazon-Flipkart-
E-commerce Product Recommendation System Real-Life Example • Amazon and Flipkart utilize recommendation systems to personalize the shopping experience by analyzing user profiles, browsing history, purchase history, and preferences. • Example: When a user views a smartphone, the system might recommend accessories like cases, screen protectors, 


# Recommendation System Query Explanation

This README explains how the recommendation query works step-by-step, including the logic, SQL structure, and the expected output. The purpose of this query is to recommend products to a specific user based on the categories of products they have already purchased, while excluding items they have already bought.

---

## Table Structures
![Screenshot 2025-01-13 030956](https://github.com/user-attachments/assets/16b63707-4e3e-4229-9c3c-bcd58c191a5b)


### 1. **`Purchases` Table**
This table stores information about product purchases made by users.

| Field         | Type   | Description                           |
|---------------|--------|---------------------------------------|
| `id`          | INT    | Unique ID for each purchase.          |
| `user_id`     | INT    | ID of the user who made the purchase. |
| `product_id`  | INT    | ID of the purchased product.          |
| `purchase_date` | DATE | Date when the purchase was made.      |
![Screenshot 2025-01-13 031110](https://github.com/user-attachments/assets/991c34d0-efe1-433c-85a5-ba7d711d1707)



### 2. **`Products` Table**
This table stores information about the products available for purchase.

| Field      | Type         | Description                                   |
|------------|--------------|-----------------------------------------------|
| `product_id` | INT        | Unique ID for each product.                  |
| `name`     | VARCHAR(100) | Name of the product.                         |
| `category` | VARCHAR(100) | Category to which the product belongs.       |
| `price`    | DECIMAL(10,2)| Price of the product.                        |

---
![Screenshot 2025-01-13 031030](https://github.com/user-attachments/assets/582d9906-9631-484f-b117-c5769bad2c41)

## Query Goal
To recommend products that:
- Belong to the same category as products the user has already purchased.
- Have not yet been purchased by the user.

---

## Query
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

## Step-by-Step Explanation
![Screenshot 2025-01-13 031751](https://github.com/user-attachments/assets/57bfa3dd-3ab1-4914-848b-3fa20708e1e1)

### 1. **Filter Purchases by the Target User**
The subquery `FROM Purchases p1 WHERE p1.user_id = 1` selects all purchases made by `user_id = 1`. This forms the basis for identifying the categories of interest.

#### Example Data:
| user_id | product_id | purchase_date |
|---------|------------|---------------|
| 1       | 1          | 2025-01-01    |
| 1       | 2          | 2025-01-03    |
| 1       | 5          | 2025-01-10    |

---

### 2. **Join with Products to Identify Categories**
The query joins `Purchases` (`p1`) with the `Products` table (`p1p`) on `p1.product_id = p1p.product_id`. This allows access to the category information for the purchased products.

#### Matching Data:
| product_id | name       | category     | price   |
|------------|------------|--------------|---------|
| 1          | Laptop     | Electronics  | 50000.00 |
| 2          | Mouse      | Electronics  |   500.00 |
| 5          | Smartphone | Electronics  | 30000.00 |

---

### 3. **Find All Products in the Same Categories**
The query performs another join with the `Products` table (`p2`) to find other products in the same category as those identified in Step 2.

#### Example Data for `category = 'Electronics'`:
| product_id | name           | category     | price   |
|------------|----------------|--------------|---------|
| 1          | Laptop         | Electronics  | 50000.00 |
| 2          | Mouse          | Electronics  |   500.00 |
| 3          | Keyboard       | Electronics  |  1000.00 |
| 5          | Smartphone     | Electronics  | 30000.00 |
| 6          | Charger        | Electronics  |  1500.00 |
| 9          | Gaming Console | Electronics  | 40000.00 |
| 10         | Tablet         | Electronics  | 20000.00 |

---

### 4. **Exclude Products Already Purchased**
The condition:
```sql
p2.product_id NOT IN (
    SELECT product_id FROM Purchases WHERE user_id = 1
)
```
filters out products that the user (`user_id = 1`) has already purchased.

#### Excluded Product IDs for `user_id = 1`:
| product_id |
|------------|
| 1          |
| 2          |
| 5          |

Remaining products:
| product_id | name           | category     | price   |
|------------|----------------|--------------|---------|
| 3          | Keyboard       | Electronics  |  1000.00 |
| 6          | Charger        | Electronics  |  1500.00 |
| 9          | Gaming Console | Electronics  | 40000.00 |
| 10         | Tablet         | Electronics  | 20000.00 |

---

### 5. **Select Recommended Products**
The `DISTINCT` keyword ensures that only unique product names are returned as recommendations.

---

## Expected Output
| recommended_product |
|---------------------|
| Keyboard            |
| Charger             |
| Gaming Console      |
| Tablet              |

These are the products that belong to the same category (`Electronics`) as those purchased by `user_id = 1` but have not been purchased by them yet.

---

## Summary
This query provides a simple product recommendation system by:
1. Identifying the categories of products a user has purchased.
2. Finding other products in those categories.
3. Excluding products the user has already purchased.

### Benefits:
- Personalized recommendations based on user preferences.
- Ensures no duplicate or irrelevant recommendations.

### Limitations:
- Assumes category-based recommendations are sufficient.
- Does not account for user-specific preferences like price or brand.

