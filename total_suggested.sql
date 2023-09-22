/* AA : Sonic : total suggested: prod */
select
   op.opportunity_id as 'ID',
   count(distinct op.person_id) as 'Suggested'
from
   opportunity_suggestions op
   inner join opportunities o on op.opportunity_id = o.id
where
   DATE(o.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
   AND o.objective not like '**%'
   AND o.active = TRUE
   AND o.crawled = FALSE 
   AND o.review = 'approved'
group by
   op.opportunity_id