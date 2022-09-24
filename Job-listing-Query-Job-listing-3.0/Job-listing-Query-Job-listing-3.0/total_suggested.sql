/* AA : Sonic : total suggested: prod */ 
select 
   o.id as 'ID', 
   count(distinct p.username) as 'Suggested'
from opportunity_suggestions op
inner join opportunities o on op.opportunity_id = o.id
inner join people p on op.person_id = p.id
group by opportunity_id
