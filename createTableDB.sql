create database ecommerce_db;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

describe users;

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);
describe products;

CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    purchase_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)

    
);
describe purcheses;

CREATE TABLE user_product_aggregation (
    user_id INT NOT NULL,
    category VARCHAR(255) NOT NULL,
    purchase_count INT NOT NULL,
    PRIMARY KEY (user_id, category)
);
describe user_product_aggregation;

