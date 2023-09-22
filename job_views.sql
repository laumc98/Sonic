/* AA : Sonic : job views: prod */
select
    o.id as 'ID',
    count(*) as 'views'
from
    views v
    inner join opportunities o on o.id = v.target_id
    inner join opportunity_members omp on omp.opportunity_id = v.target_id and omp.poster = true
    inner join person_flags pf on pf.person_id = omp.person_id and pf.opportunity_crawler = false
where
    v.target_type = 'opportunity'
    and DATE(v.created) > date(date_add(now(6), INTERVAL -1 year))
    and o.objective not like '***%'
    and o.review = 'approved'
    AND o.active = TRUE
    AND o.crawled = FALSE 
group by
    o.id