/* AA : Sonic : ccg notifications: prod */ 
SELECT
    TRIM('"' FROM JSON_EXTRACT(`notifications`.`context`, '$.opportunityId')) as 'Alfa ID',
    count(*) as 'rc_ccg_notifications'
FROM
    `notifications`
    LEFT JOIN `people` `People - To` ON `notifications`.`to` = `People - To`.`id`
WHERE
    (
        (`notifications`.`template` = 'career-advisor-job-opportunity'
            or `notifications`.`template` = 'career-advisor-invited-job-opportunity')
        AND `notifications`.`status` = 'sent'
        AND `People - To`.`subject_identifier` IS NULL
        AND `People - To`.`name` not like '%test%'
    )
GROUP BY
    1