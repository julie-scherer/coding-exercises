-- @block instructions

/*
Write a query to determine the top 5 actions performed during the month of November 2020, for actions performed on an Apple platform (iPhone, iPad).

The events table tracks every time a user performs a certain action (like post_enter, etc.) on a platform (android, web, etc.).

The output should include the action performed and it’s rank in ascending order. If two actions are performed equally, they should have the same rank. 
*/


-- @block create table

-- Input: events table
CREATE TABLE IF NOT EXISTS events (
    user_id INTEGER,
    created_at DATE,
    action VARCHAR,
    platform VARCHAR,
    PRIMARY KEY ( user_id )
);

-- @block preview data

/*
id	user_id	created_at	action	platform
1	59	"2020-12-21T00:00:00"	"post_cancel"	"iphone"
2	84	"2020-12-21T00:00:00"	"like"	"android"
3	21	"2020-12-21T00:00:00"	"like"	"web"
4	47	"2020-10-31T00:00:00"	"email_opened"	"iphone"
5	100	"2020-11-01T00:00:00"	"email_opened"	"android"
6	45	"2020-11-03T00:00:00"	"post_submit"	"web"
7	44	"2020-11-05T00:00:00"	"like"	"iphone"
8	38	"2020-11-07T00:00:00"	"like"	"android"
9	45	"2020-11-08T00:00:00"	"like"	"web"
10	16	"2020-11-08T00:00:00"	"post_submit"	"iphone"
11	17	"2020-11-09T00:00:00"	"like"	"android"
12	41	"2020-11-11T00:00:00"	"post_cancel"	"ipad"
13	34	"2020-11-12T00:00:00"	"email_opened"	"iphone"
14	78	"2020-11-12T00:00:00"	"like"	"android"
15	17	"2020-11-13T00:00:00"	"like"	"web"
16	4	"2020-11-13T00:00:00"	"email_opened"	"iphone"
17	25	"2020-11-14T00:00:00"	"like"	"android"
18	71	"2020-11-15T00:00:00"	"post_enter"	"web"
19	3	"2020-11-15T00:00:00"	"like"	"iphone"
20	19	"2020-11-16T00:00:00"	"like"	"android"
21	23	"2020-11-17T00:00:00"	"post_enter"	"ipad"
22	4	"2020-11-19T00:00:00"	"post_cancel"	"iphone"
23	26	"2020-11-20T00:00:00"	"post_enter"	"android"
24	21	"2020-11-22T00:00:00"	"like"	"web"
25	47	"2020-11-23T00:00:00"	"email_opened"	"iphone"
26	100	"2020-11-25T00:00:00"	"email_opened"	"android"
27	45	"2020-11-25T00:00:00"	"post_submit"	"iphone"
28	44	"2020-11-25T00:00:00"	"unsubscribe"	"iphone"
29	38	"2020-11-25T00:00:00"	"post_opened"	"android"
30	45	"2020-11-25T00:00:00"	"like"	"web"
31	16	"2020-11-26T00:00:00"	"post_submit"	"iphone"
32	17	"2020-11-26T00:00:00"	"like"	"android"
33	59	"2020-11-26T00:00:00"	"post_cancel"	"iphone"
34	84	"2020-11-26T00:00:00"	"email_opened"	"iphone"
35	21	"2020-11-27T00:00:00"	"unsubscribe"	"ipad"
36	47	"2020-11-27T00:00:00"	"like"	"web"
37	100	"2020-11-27T00:00:00"	"email_opened"	"iphone"
38	45	"2020-11-27T00:00:00"	"feed_viewed"	"ipad"
39	44	"2020-11-27T00:00:00"	"post_enter"	"web"
40	38	"2020-11-28T00:00:00"	"unsubscribe"	"iphone"
41	45	"2020-11-29T00:00:00"	"post_cancel"	"android"
*/

-- @block

/*
PSEUDO CODE
- OUTPUT top 5 actions performed (e.action)
   >> return action and it's rank
- during Nov 2022 ()
- for actions on platform "iPhone" or "iPad"
*/

WITH tbl AS (
    SELECT 
        action
        ,COUNT( action ) AS ranks
    FROM 
        events
    WHERE
        -- (platform ILIKE 'iphone' OR platform ILIKE 'ipad')
        ( platform IN ('iphone', 'ipad') )
        AND 
        -- (created_at BETWEEN '2020-11-01T00:00:00' AND '2020-11-30T00:00:00')
        ( EXTRACT(month FROM created_at)=11 AND EXTRACT(year FROM created_at)=2020 )
    GROUP BY
        action
    ORDER BY
        ranks DESC
    LIMIT 
        5
    )

SELECT 
    action, 
    -- use DENSE_RANK(), not RANK()
    DENSE_RANK() over (
        ORDER BY ranks DESC
    ) ranks
FROM 
    tbl
LIMIT 
    5
;