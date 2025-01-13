
--Collaborative Filtering Query
create database ecommerce_db;
SELECT pr.name AS recommended_product, COUNT(*) AS popularity
FROM Purchases p1
JOIN Purchases p2 ON p1.user_id != p2.user_id 
                  AND p1.product_id = p2.product_id
JOIN Products pr ON p2.product_id = pr.product_id
WHERE p1.user_id = 1
GROUP BY pr.name
ORDER BY popularity DESC;




--Content-Based Recommendations

SELECT DISTINCT p2.name AS recommended_product
FROM Purchases p1
JOIN Products p1p ON p1.product_id = p1p.product_id
JOIN Products p2 ON p1p.category = p2.category
WHERE p1.user_id = 1 
  AND p2.product_id NOT IN (
      SELECT product_id FROM Purchases WHERE user_id = 1
  );

