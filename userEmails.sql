/*
PROMPT
- a table has a row for each user 
- a user can have multiple email addresses
- how do you get the number of email addresses for each user?
*/

SELECT 
    user_id
    ,COUNT(DISTINCT email_address) AS email_count
FROM users
GROUP BY user_id;
