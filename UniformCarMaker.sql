-- @block prompt

/*
Given a table of cars with columns id and make, write a query that outputs a random manufacturer’s name with an equal probability of selecting any name.

Example:

cars table

id	make
1	Ford
2	Toyota
3	Toyota
4	Honda
5	Honda
6	Honda

Output:

Column	Type
make	Text
*/

-- @block create table

CREATE TABLE cars (
    id SERIAL PRIMARY KEY
    ,make VARCHAR
)


-- @block insert data

INSERT INTO cars 
    ( make )
VALUES
    ( 'Ford' )
    ,( 'Toyota' )
    ,( 'Toyota' )
    ,( 'Honda' )
    ,( 'Honda' )
    ,( 'Honda' )
;


-- @block solution

SELECT 
    make
FROM 
    cars
ORDER BY
    random()
LIMIT
    1
;