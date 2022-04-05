select o.id as 'OppID', count(*) as 'views'
from views v 
inner join opportunities o on o.id = v.target_id
inner join opportunity_members omp on omp.opportunity_id = v.target_id 
inner join person_flags pf on pf.person_id = omp.person_id 
where o.objective not like '***%' and omp.poster = true and pf.opportunity_crawler = false and v.target_type = 'opportunity' 
group by 1