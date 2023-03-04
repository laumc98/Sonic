/* AA : Sonic : total suggested: prod */
select
   o.id as 'ID',
   count(distinct p.username) as 'Suggested'
from
   opportunity_suggestions op
   inner join opportunities o on op.opportunity_id = o.id
   inner join people p on op.person_id = p.id
where
   DATE(o.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
group by
   opportunity_id