select 
   TRIM('"' FROM JSON_EXTRACT(context, '$.opportunityId')) as AlfaID,
   count(JSON_EXTRACT(context, '$.opportunityId')) as 'Requests from automated sourcing'
from career_advisor 
where JSON_EXTRACT(context, '$.opportunityId')!='' and current = 'career-advisor-sourcing-first-evaluation'
group by AlfaID