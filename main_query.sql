SELECT
    -- ID
    o.id as 'ID',
    -- Job title
    o.objective as 'Job title',
    -- Company
   (select organization_id from opportunity_organizations where opportunity_id =  o.id  group by organization_id limit 1) as 'Company_id',
    -- location
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'location',
    -- Type of service
    o.fulfillment as 'Type of service',
    -- Type of job
    o.commitment_id as 'Type of job',
   -- Created date 
    DATE(o.created) as 'Created date',
    -- Approved date
    DATE(o.reviewed) as 'Approved date',
    -- Applicant Acquisition Coordinator
    (select name FROM people p WHERE o.applicant_coordinator_person_id=p.id) as 'Applicant Acquisition Coordinator',
    -- Commited date
    (select DATE(och.created) FROM opportunity_changes_history och WHERE och.opportunity_id = o.id group by opportunity_id ) as 'Commited date',
    -- Status
    o.status as 'Status',
    -- Completed applications
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'Completed applications',
    -- Completed applications yesterday
    sum(case when oc.id is not null and oc.interested is not null and DATE(oc.created) = DATE(DATE(NOW()) - INTERVAL 1 DAY) then 1 else 0 end) as 'Completed applications yesterday',
    -- Incomplete applications
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as  'Incomplete applications',
    -- Mutual matches
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name = 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Mutual matches',
    -- Others
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name <> 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Others',
    -- Disqualified
    sum(case when oc.id is not null and oc.interested is not null
    and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Disqualified',
    -- Changes history, last updated
    DATE(o.last_updated) as 'Last changes',
    -- Closing date
    DATE(o.deadline) as 'Closing Date',
    o.locale as 'Language of the post',
    -- Hires
    (select sum(case when osh.hiring_date is not null then 1 else 0 end) from opportunity_stats_hires osh where o.id=osh.opportunity_id) as 'Hires',
    -- Hires yesterday
    (select sum(case when osh.hiring_date is not null and DATE(osh.hiring_date) = DATE(DATE(NOW()) - INTERVAL 1 DAY) then 1 else 0 end) from opportunity_stats_hires osh where o.id=osh.opportunity_id) as 'Hires yesterday',
    -- Opportunity approved yesterday
   case when DATE(o.reviewed) = DATE(DATE(NOW()) - INTERVAL 1 DAY) then TRUE else null end as 'Opportunity approved yesterday',
    -- Completed applications in the last 14 days
    sum(case when oc.id is not null and oc.interested is not null and DATE(oc.created) >= DATE(DATE(NOW()) - INTERVAL 14 DAY) then 1 else 0 end) as 'Completed applications in the last 14 days',
    -- Sharing token
    (select sharing_token from opportunity_members where manager = true and status = 'accepted' and opportunity_id =  o.id  limit 1) as 'Sharing token'


FROM opportunities o 
LEFT JOIN opportunity_candidates oc on o.id=oc.opportunity_id
left join opportunity_columns oc2 on oc.column_id = oc2.id
left join (
  select me.candidate_id, max(me.interested) as last_interest, max(me.not_interested) as last_not_interest
  from member_evaluations me
  group by me.candidate_id) last_evaluation on last_evaluation.candidate_id = oc.id



    
WHERE true
    and o.id IN (
        SELECT
            DISTINCT o.id AS opportunity_id
        FROM
            opportunities o 
            INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
            AND omp.poster = TRUE
            INNER JOIN person_flags pf ON pf.person_id = omp.person_id
            AND pf.opportunity_crawler = false
            and o.review = 'approved'
            and o.status <> 'opening-soon'
            )
    AND o.Objective not like '**%' 
    AND o.created >= '2021-01-01'
    
GROUP BY o.id
ORDER BY o.created desc;