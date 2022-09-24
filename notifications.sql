/* AA : Sonic : jobs notifications: prod */ 
select
    opportunity_ref as AlfaID,
    sum(case when model = 'realistic' then 1 else 0 end) as realistic,
    sum(case when model = 'signal_person_all' or model = 'signal_person_relevant' then 1 else 0 end) as people,
    sum(case when model = 'signal_organization_all' or model = 'signal_organization_relevant' then 1 else 0 end) as organization
from com_torrelabs_match_distributed_3
group by AlfaID

