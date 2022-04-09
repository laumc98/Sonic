SELECT TRIM('"' FROM JSON_EXTRACT(no.context, '$.opportunityId')) as AlfaID, count(*) as 'rc_syn_notifications'
FROM notifications no
WHERE no.template like 'career-advisor-syndication-first-evaluation' and no.status = 'sent'
GROUP BY 1