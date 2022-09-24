/* AA : Sonic : personal reach out to candidates of similar jobs notifications: prod */ 
SELECT
    TRIM('"' FROM JSON_EXTRACT(no.context, '$.opportunityId')) as 'Alfa ID',
    count(*) as 'rc_sml_jobs_notifications'
FROM
    notifications no
WHERE
    no.template like 'career-advisor-invited-similar-job-opportunity'
    and no.status = 'sent'
GROUP BY
    1