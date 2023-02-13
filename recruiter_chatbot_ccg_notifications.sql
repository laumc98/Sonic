/* AA : Sonic : ccg notifications: prod */
SELECT
    TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.opportunityId')) as 'Alfa ID',
    count(*) as 'rc_ccg_notifications'
FROM
    notifications
    LEFT JOIN people ON notifications.to = people.id
WHERE
    (
        (
            notifications.template = 'career-advisor-job-opportunity'
            or notifications.template = 'career-advisor-invited-job-opportunity'
        )
        AND notifications.status = 'sent'
        AND (
            people.subject_identifier IS NULL
            OR people.subject_identifier != people.gg_id
        )
        AND date(notifications.sent_at) >= '2023-02-14'
        AND people.name not like '%test%'
    )