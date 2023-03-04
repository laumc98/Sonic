/* AA : Sonic : autotrigg ext notifications: prod */
SELECT
    TRIM('"' FROM JSON_EXTRACT(`notifications`.`context`, '$.opportunityId')) as 'ID',
    count(*) as 'trigg_ext_notifications'
FROM
    `notifications`
WHERE
    (
        (
            `notifications`.`template` = 'talent-candidate-invited'
        )
        AND `notifications`.`status` = 'sent'
        AND `notifications`.`sent_at` >= date(date_add(now(6), INTERVAL -1 year))
    )
GROUP BY
    1