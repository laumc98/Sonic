/* AA : Sonic : tasks by candidate recruiters: prod */ 
SELECT
    tasks.*,
    opportunities.opportunity_id AS 'Alfa ID'
FROM
    tasks
    LEFT JOIN opportunities ON tasks.opportunity_id = opportunities.id
WHERE
    tasks.assigned_to IN ('1227372','1070313','50406','1072288','163315','1148423','1062012','257012')