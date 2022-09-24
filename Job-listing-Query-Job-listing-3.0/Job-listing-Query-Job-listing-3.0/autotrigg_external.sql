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
        AND `notifications`.`sent_at` >= '2021-08-15'
    )
GROUP BY
    1