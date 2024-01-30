/* AA : Sonic : job views: prod */
select
    o.id as 'ID',
    count(*) as 'views'
from
    views v
    left join opportunities o on o.id = v.target_id
where
    v.target_type = 'opportunity'
    and DATE(v.created) > date(date_add(now(6), INTERVAL -1 year))
    and o.objective not like '***%'
    and o.review = 'approved'
    AND o.active = TRUE
    AND o.crawled = FALSE 
    AND o.published = TRUE  
group by
    o.id