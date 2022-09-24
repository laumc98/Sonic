/* AA : Sonic : invited from suggested: prod */ 
select 
    distinct(o.id) as 'ID',
    count(p.name) as 'Invited from suggested'
from opportunity_candidates oc
    inner join member_evaluations mem on mem.candidate_id = oc.id
    inner join opportunities o on oc.opportunity_id = o.id
    inner join people p on oc.person_id = p.id
where true
and oc.interested is null
and mem.interested is not null 
group by opportunity_id