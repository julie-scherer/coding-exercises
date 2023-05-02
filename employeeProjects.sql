/*
PROMPT
- you have a table with employees and projects
- an employee can be working on multiple projects at one time
- how do you get the most recent project(s) an employee worked on?
*/

-- APPROACH 1: using a window function
WITH project_ranks AS (
    SELECT
        employee_id
        ,employee_name
        ,project_id
        ,project_name
        ,start_date
        ,end_date
        -- use DENSE_RANK() window function so that rows with the same partition receive the same ranks
        ,DENSE_RANK () OVER ( 
            PARTITION BY 
                employee_id
                ,project_id
            ORDER BY start_date DESC
        ) AS project_num
    FROM employees
)
SELECT *
FROM project_ranks
WHERE project_num = 1;



-- APPROACH 2.1: using an array, postgreSQL syntax
CREATE TYPE agg_projects (
    project_id INT
    ,project_name TEXT
    ,start_date DATE
    ,end_date DATE
)
CREATE TABLE employee_projects (
    employee_id INT
    ,employee_name TEXT
    ,projects agg_projects[]
)
WITH last_project AS (
    SELECT * FROM employee_projects ep
    WHERE year = 2022
)
,current_projects AS (
    SELECT * FROM employees e
    WHERE year = 2023
)
INSERT INTO employee_projects
SELECT
    COALESCE(lp.employee_id, cp.employee_id) 
    ,COALESCE(lp.employee_name, cp.employee_name)
    ,COALESCE(lp.project_id, cp.project_id)
    ,COALESCE(lp.project_name, cp.project_name)
    ,COALESCE(lp.projects, ARRAY[]::agg_projects[]) || 
        ARRAY_AGG(
            ROW(project_id, project_name, start_date, end_date)::agg_projects
        ) AS projects
FROM last_project lp
    FULL OUTER JOIN current_projects cp
    ON lp.employee_id = cp.employee_id;



-- APPROACH 2.2: MSSQL-syntax equivalent
-- step 1: create a table type agg_projects that defines the structure of the projects array
CREATE TYPE agg_projects AS TABLE (
    project_id INT,
    project_name TEXT,
    start_date DATE,
    end_date DATE
);

-- step 2: create a table employee_projects that will hold the results of the query
CREATE TABLE employee_projects (
    employee_id INT,
    employee_name TEXT,
    projects agg_projects
);

-- step 3: define two CTEs last_project and current_projects to get all projects for the year 2022 and 2023 respectively.
WITH last_project AS (
    SELECT * FROM employee_projects ep
    WHERE year(project_date) = 2022
)
,current_projects AS (
    SELECT * FROM employees e
    WHERE year(project_date) = 2023
),
INSERT INTO employee_projects
SELECT
    COALESCE(lp.employee_id, cp.employee_id) 
    ,COALESCE(lp.employee_name, cp.employee_name)
    ,COALESCE(lp.project_id, cp.project_id)
    ,COALESCE(lp.project_name, cp.project_name)
    -- use TOP and ORDER BY in subquery to ensure that the most recent project is selected for each employee
    ,COALESCE(lp.projects, (SELECT TOP 0 * FROM agg_projects)) +
        (SELECT project_id, project_name, start_date, end_date
            FROM current_projects cp_sub
            WHERE current_projects.employee_id = COALESCE(lp.employee_id, cp.employee_id)
            ORDER BY start_date DESC 
            -- generate an XML document from the result set of the subquery
            FOR XML PATH(''), TYPE).value('(/)/agg_projects[1]', 'agg_projects[]'
                -- the value() method is then used to extract the value of the XML document as an array of agg_projects
                -- the XPath expression (/)/agg_projects[1] selects the first <agg_projects> element in the document (which corresponds to the most recent project)
                -- 		and the second argument ('agg_projects[]') specifies the data type of the value to be returned
                -- the resulting XML document will contain one <agg_projects> element for each row in the result set, with the values of the four columns as attributes of the element
        ) AS projects

FROM last_project lp
    FULL OUTER JOIN current_projects cp
    ON lp.employee_id = cp.employee_id;
