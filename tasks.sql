/* AA : Sonic : tasks by candidate recruiters: prod */ 
SELECT
    tasks.*,
    opportunities.opportunity_id AS 'Alfa ID'
FROM
    tasks
    LEFT JOIN opportunities ON tasks.opportunity_id = opportunities.id
WHERE
    tasks.completed_by IN ('1164202','50406','1072288','163315','1135927','1072337','1205587','218202','879186','1217202','1558464','46223','1485590','1446790','1566080','1558709','1573613','1576877','1514679','1578431','709519','275690','1461284','1494405','2b7d8bed692749fd8e698aad0bd424b6','1109045','1373785','1392028','1575208','31195','1558904','1185377','1558542','1334308','1568148','1183460','1233729','1199351','1558306','1603354','36942','e7c625164d7e49738f8fc15f5ce85796','1426784','257012','1574150','1702055','1605413','5e15d57beb8248e793094d9ee94e7b50','441131')       
    AND tasks.trigger IN ('paid-ext-networks','paid-ext-networks-pro','paid-ext-networks-ss','paid-ext-networks-boost','ext-networks','ext-networks-pro','ext-networks-ss','ext-networks-boost','ext-sourcing','ext-sourcing-pro','ext-sourcing-ss','ext-sourcing-boost','manual-task-creation','recruiter-bot-conversation-email','recruiter-bot-conversation-messenger','recruiter-bot-conversation-whatsapp','recruiter-bot-manual-reassign','otto-recruiter-bot-email','otto-recruiter-bot-messenger','otto-recruiter-bot-whatsapp')
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
            LOWER(tasks.completion_comment) LIKE '%completed with manual update.%'
    )
    AND tasks.id NOT IN (163193, 165664,243374,246776,364527,158197)