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
        AND TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.utmMedium')) = 'rc_ccg'
        AND people.name not like '%test%'
        AND date(notifications.sent_at) >= date(date_add(now(6), INTERVAL -1 year))
    )