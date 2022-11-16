/* AA : Sonic : rc_syn_trrx_inv_notifications: prod */ 
SELECT
    TRIM('"' FROM JSON_EXTRACT(no.context, '$.opportunityId')) as 'Alfa ID',
    count(*) as 'rc_syn_trrx_inv_notifications'
FROM
    notifications no
WHERE
    no.template like 'career-advisor-syndication-already-exist'
    and no.status = 'sent'
GROUP BY
    1