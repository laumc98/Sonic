/* AA : Sonic : recruiter chatbot notifications: prod */ 
SELECT
    TRIM('"' FROM JSON_EXTRACT(no.context, '$.opportunityId')) as 'Alfa ID',
    count(*) as 'rc_cb_rcdt_notifications'
FROM
    notifications no
WHERE
    no.template like 'career-advisor-job-opportunity'
    and no.status = 'sent'
    AND date(no.sent_at) >= date(date_add(now(6), INTERVAL -1 year))
GROUP BY
    1