create database ecommerce_db;
INSERT INTO Users (name, email) VALUES 
('Akshat', 'akshat@example.com'), 
('Priyanshu', 'priyanshu@example.com'),
('prashant', 'prashant@example.com'),
('Abhinandan', 'abhinandan@example.com');

select*from users;

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

select * from products;

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

select*from purcheses;

INSERT INTO user_product_aggregation (user_id, category, purchase_count)
SELECT Purchases.user_id, Products.category, COUNT(Purchases.product_id) AS purchase_count
FROM Purchases
JOIN Products ON Purchases.product_id = Products.product_id
GROUP BY Purchases.user_id, Products.category;
select*from user_product_aggregation;
