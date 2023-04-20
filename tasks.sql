/* AA : Sonic : tasks by candidate recruiters: prod */ 
SELECT
    tasks.*,
    opportunities.opportunity_id AS 'Alfa ID'
FROM
    tasks
    LEFT JOIN opportunities ON tasks.opportunity_id = opportunities.id
WHERE
    (tasks.completed_by IN ('1227372','1070313','50406','1072288','163315','1148423','1062012','257012','1171237','1169806','1135927','49062','1051308','1328036','1201446','122371','1072337','1205587','615269','218202','879186','1217202','87455','22645','903146')
        OR tasks.completed_by IS NULL)