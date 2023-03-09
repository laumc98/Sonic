/* AA : Sonic : tasks by candidate recruiters: prod */ 
SELECT
    tasks.*,
    opportunities.opportunity_id AS 'Alfa ID'
FROM
    tasks
    LEFT JOIN opportunities ON tasks.opportunity_id = opportunities.id
