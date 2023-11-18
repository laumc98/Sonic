/* AA : Sonic : src connections: prod */
SELECT 
    opportunities.opportunity_id AS 'Alfa ID',
    IF(
        ISNULL(tasks.completed), 
        'SRC_requests_Not_Completed', 
        'SRC_requests_Completed'
    ) AS task_status,
    count(tasks.id) AS number_tasks
FROM 
    tasks
    LEFT JOIN opportunities ON tasks.opportunity_id = opportunities.id
WHERE 
    (tasks.trigger = 'sourcing-connection-request'
        OR tasks.trigger = 'sourcing-connection-request-agile'
        OR tasks.trigger = 'sourcing-connection-request-boost'
        OR tasks.trigger = 'sourcing-connection-request-pro'
        OR tasks.trigger = 'sourcing-connection-request-ss')
GROUP BY 
   opportunities.opportunity_id,
   task_status