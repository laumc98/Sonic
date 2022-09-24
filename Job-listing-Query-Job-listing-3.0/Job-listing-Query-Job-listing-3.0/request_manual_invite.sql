/* AA : Sonic : manual invite request: prod */ 
select  
   opportunity_id as AlfaID,
   count(case when status = 'sent' then 1 end) as sent,
   count(case when status = 'pending' then 1 end) as pending,
   count(case when status = 'canceled' then 1 end) as canceled
from career_advisor_suggested_opportunities
group by AlfaID