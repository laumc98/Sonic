select TRIM('"' FROM JSON_EXTRACT(no.context, '$.opportunityId')) as 'Alfa ID', count(*) as 'rc_src_notifications'
from notifications no
WHERE no.template like 'career-advisor-sourcing-first-evaluation' and no.status = 'sent'
GROUP BY 1