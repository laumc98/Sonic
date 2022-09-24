/* AA : Sonic : manual invite notifications: prod */ 
SELECT
    TRIM('"' FROM JSON_EXTRACT(no.context, '$.opportunityId')) as 'Alfa ID',
    count(*) as 'rc_trrx_inv_notifications'
FROM
    notifications no
WHERE
    no.template like 'career-advisor-invited-job-opportunity'
    and no.status = 'sent'
GROUP BY
    1