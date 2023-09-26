/* AA : Sonic : tasks by candidate recruiters: prod */ 
SELECT
    tasks.*,
    opportunities.opportunity_id AS 'Alfa ID'
FROM
    tasks
    LEFT JOIN opportunities ON tasks.opportunity_id = opportunities.id
WHERE
    tasks.completed_by IN ('1164202','1227372','50406','1465392','1072288','163315','1148423','257012','1171237','1135927','1328036','1201446','1072337','1205587','218202','879186','1217202','1558464','46223','1485590','1446790','1566080','1558709','1573613','1576877','1514679','1578431','709519')
    AND tasks.trigger IN ('paid-ext-networks','paid-ext-networks-pro','paid-ext-networks-ss','ext-networks','ext-networks-pro','ext-networks-ss','ext-sourcing','ext-sourcing-pro','ext-sourcing-ss','manual-task-creation','recruiter-bot-conversation-email','recruiter-bot-conversation-messenger','recruiter-bot-conversation-whatsapp','recruiter-bot-manual-reassign','otto-recruiter-bot-email','otto-recruiter-bot-messenger','otto-recruiter-bot-whatsapp')
    AND tasks.created >= '2023-01-01'
    AND tasks.id NOT IN (
        SELECT 
            tasks.parent_task_id
        FROM 
            tasks  
        WHERE 
            tasks.trigger = 'inspection-task-completed-without-execution'
    )
    AND tasks.id NOT IN (
        SELECT 
            tasks.id
        FROM 
            tasks  
        WHERE 
            tasks.completion_comment = 'Completed with manual update. Reason: inactivity.'
    )