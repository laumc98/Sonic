/* AA : Sonic : job views: prod */
select
    o.id as 'ID',
    count(*) as 'views'
from
    views v
    inner join opportunities o on o.id = v.target_id
    inner join opportunity_members omp on omp.opportunity_id = v.target_id
    inner join person_flags pf on pf.person_id = omp.person_id
where
    o.objective not like '***%'
    and omp.poster = true
    and pf.opportunity_crawler = false
    and v.target_type = 'opportunity'
    and DATE(o.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
    and o.review = 'approved'
    AND o.objective not like '**%'
    AND o.active = TRUE
group by
    o.id