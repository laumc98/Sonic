SELECT
   TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.opportunityId')) AS 'Alfa ID',
   people.gg_id,
   notifications.template,
   notifications.send_at AS date,
   notifications.context
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
        AND people.subject_identifier IS NULL
        AND notifications.send_at > date(date_add(now(6), INTERVAL -1 year))
    )