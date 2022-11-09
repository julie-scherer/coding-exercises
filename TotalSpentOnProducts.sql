/*
Let’s say you work at Costco. Costco has a database with two tables. The first is users composed of user information, including their registration date, and the second is purchases that has the entire item purchase history (if any) for those users.

Write a query to get the total amount spent on each item in the ‘purchases’ table by users that registered in 2022.

Expected output
-- item         total_amount_spent
-- "wine"       106
-- "chocolate"  37
-- "chips"      20
-- "beer"       90
*/


-- @block create users table

CREATE TABLE IF NOT EXISTS users(
    user_id INTEGER,
    user_name VARCHAR(100),
    registration_date DATE,
    PRIMARY KEY (user_id)
);


-- @block create purchases table
CREATE TABLE IF NOT EXISTS  purchases(
    order_id INTEGER,
    user_id INTEGER,
    item VARCHAR,
    price FLOAT,
    purchase_date DATE,
    PRIMARY KEY (order_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- @block first attempt

/*
PSEUDO CODE
- total amnt spent (purchases.price) on each item (purchases.item)
- JOIN users (purchases.user_id, users.user_id)
- BY users registered in 2022 (users.registration_date)
*/

SELECT 
    p.item, 
    SUM( p.price ) AS total_amount_spent
FROM 
    purchases AS p
    JOIN users AS u 
    ON CAST( p.user_id AS INT ) = CAST( u.user_id AS INT)
GROUP BY 
    p.item,
    u.registration_date
HAVING 
    u.registration_date BETWEEN '2022-01-01' AND '2022-12-31'
;

/*
OUTPUT
item	total_amount_spent
"chips"	20
"beer"	50
"wine"	65
"chocolate"	7
"beer"	40
"wine"	41
"chocolate"	30
*/


-- @block reflect
/*
WHAT WENT WRONG
- grouped by registration date when we only need to group items, FOR users who registered in 2022

    **think: total amnt spent ON/BY each item**

CHANGES TO MAKE
- use WHERE users registered in 2022 instead of HAVING
*/


-- @block correct solution

SELECT 
    p.item, 
    SUM( p.price ) AS total_amount_spent
FROM 
    purchases AS p
    JOIN users AS u 
    ON CAST( p.user_id AS INT ) = CAST( u.user_id AS INT)
WHERE 
    u.registration_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY 
    p.item
    -- u.registration_date
;