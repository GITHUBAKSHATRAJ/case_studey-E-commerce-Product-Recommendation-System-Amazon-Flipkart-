import mysql.connector

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="akshat@123",
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
def content_based_with_aggregation(user_id):
    query = """
    SELECT DISTINCT p2.name AS recommended_product
    FROM user_product_aggregation upa
    JOIN Products p2 ON upa.category = p2.category
    WHERE upa.user_id = %s
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
    content_recommendations = content_based_with_aggregation(user_id)

    print("Collaborative Filtering Recommendations:", collab_recommendations)
    print("Content-Based Recommendations:", content_recommendations)

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    # Close connection
    cursor.close()
    db.close()
