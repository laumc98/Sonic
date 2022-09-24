/* AA : Sonic : rc_src notifications: prod */ 
SELECT
    TRIM('"'FROM JSON_EXTRACT(`notifications`.`context`, '$.opportunityId')) as `Alfa ID`,
    count(*) as `rc_src_notifications`
FROM
    `notifications`
WHERE
    (
        (
            `notifications`.`template` = 'career-advisor-sourcing-first-evaluation-matrix-a'
            OR `notifications`.`template` = 'career-advisor-sourcing-first-evaluation-matrix-b'
            OR `notifications`.`template` = 'career-advisor-sourcing-first-evaluation-matrix-c'
            OR `notifications`.`template` = 'career-advisor-sourcing-first-evaluation'
        )
        AND `notifications`.`status` = 'sent'
    )
GROUP BY 1