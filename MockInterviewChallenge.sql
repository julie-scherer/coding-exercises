-- @block instructions
/*
Create an ERD for the following information to be stored in a SQL database
- Products, Customers, and Salespeople

- Each salesperson works on one and only one product X
- Each product has only one salesperson X
- Each product can be purchased by multiple customers X
- Each customer can purchase multiple products X

After creating the ERD, write a query to retrieve the following information:
- each product owned by each customer along with the customer name and salesperson name for that product
*/


-- @block create tables ddl
-- DROP TABLE IF EXISTS salespeople;
-- DROP TABLE IF EXISTS products_customers;
-- DROP TABLE IF EXISTS products cascade;
-- DROP TABLE IF EXISTS customers cascade;

-- sp |-| prod >-| prod_cust_join |-< cust

CREATE TABLE IF NOT EXISTS products(
    id SERIAL PRIMARY KEY
    ,product VARCHAR
);

CREATE TABLE IF NOT EXISTS customers(
    id SERIAL PRIMARY KEY
    ,first_name VARCHAR
    ,last_name VARCHAR
);

CREATE TABLE IF NOT EXISTS products_customers(
    product_id INT
    ,FOREIGN KEY (product_id) REFERENCES products(id)
    ,customer_id INT
    ,FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE IF NOT EXISTS salespeople(
    id SERIAL PRIMARY KEY
    ,first_name VARCHAR
    ,last_name VARCHAR
    ,product_id INT
    ,FOREIGN KEY (product_id) REFERENCES products(id)
);



-- @block insert dml

INSERT INTO products
    (product)
VALUES
    ('chair') --1
    ,('sofa') --2
    ,('console') --3
    ,('dresser') --4
    ,('coffee table') --5
    ,('lamp') --6
;
SELECT * FROM products;

INSERT INTO salespeople
    (first_name, last_name, product_id)
VALUES
    ('Jane', 'Doe', 1) --1
    ,('John', 'Smith', 6) --2
    ,('Helen', 'Keller', 4) --3
;
SELECT * FROM salespeople;

INSERT INTO customers
    (first_name, last_name)
VALUES
    ('Tom', 'Perry') --1
    ,('Jack', 'Ryan') --2
    ,('Santa', 'Claus') --3
;
SELECT * FROM customers;

INSERT INTO products_customers
    (customer_id, product_id)
VALUES
    (1, 1)
    ,(1, 5)
    ,(2, 6)
    ,(3, 4)
;
SELECT * FROM products_customers;



-- @block query dml

-- each product owned by each customer along with the customer name and salesperson name for that product

SELECT 
    p.product
    ,c.first_name AS customer_first
    ,c.last_name AS customer_last
    ,s.first_name AS sales_first
    ,s.last_name AS sales_last
FROM products_customers pc
JOIN products p
    ON p.id = pc.product_id
JOIN salespeople s
    ON p.id = s.product_id
JOIN customers c
    ON c.id = pc.customer_id
;