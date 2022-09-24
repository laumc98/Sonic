/* AA : Sonic : autotrigg sugg notifications: prod */ 
SELECT
    TRIM('"' FROM JSON_EXTRACT(`notifications`.`context`, '$.opportunityId')) as 'ID',
    count(*) as 'trigg_sugg_notifications'
FROM
    `notifications`
WHERE
    (
        (
            `notifications`.`template` = 'talent-candidate-manually-invited'
        )
        AND `notifications`.`status` = 'sent'
        AND `notifications`.`sent_at` >= '2021-08-15'
    )
GROUP BY 1