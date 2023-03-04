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
        AND `notifications`.`sent_at` >= date(date_add(now(6), INTERVAL -1 year))
    )
GROUP BY 1