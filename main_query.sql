/* AA : Sonic : main query: prod */ 
WITH 
groupped_services AS (
    SELECT
        opportunity_id,
        GROUP_CONCAT(service_code) AS services
    FROM
        opportunity_services
    WHERE
        deleted IS NULL
    GROUP BY
        opportunity_id
),
opps_services AS (
    SELECT
        o.id AS opportunity_id,
        CASE
            WHEN crawled THEN 'crawled'
            WHEN (
                 FIND_IN_SET('1', gs.services)>0 /* agile */
                 OR FIND_IN_SET('7', gs.services)>0 /* staff augmentation */
                 OR FIND_IN_SET('20', gs.services)>0 /* hunt */
            ) THEN 'rpo'
            WHEN (
                FIND_IN_SET('8', gs.services)>0 /* ats */
                OR FIND_IN_SET('9', gs.services)>0 /* pro */
                OR FIND_IN_SET('16', gs.services)>0 /* torre_os */
            ) THEN 'torre_os'
            WHEN (
                (
                 FIND_IN_SET('2', gs.services)>0 /* essentials */
                 OR FIND_IN_SET('6', gs.services)>0 /* self service */
                 OR services = ''
                 OR services IS NULL
                 )
            ) THEN 'torre_free'
            WHEN (
                FIND_IN_SET('11', gs.services)>0 /* boost */
                OR FIND_IN_SET('12', gs.services)>0 /* boost hqa */
            ) THEN 'boost'
            ELSE 'others'
        END AS business_line,
        (
            FIND_IN_SET('17', gs.services)>0 /* torre_reach_essential */
            OR FIND_IN_SET('18', gs.services)>0 /* torre_reach_syndication */
            OR FIND_IN_SET('19', gs.services)>0 /* torre_reach_sourcing */
        ) AS reach,
        services
    FROM
        groupped_services gs
        INNER JOIN opportunities o ON gs.opportunity_id=o.id
), main_opps AS (
SELECT
    -- ID
    o.id as 'ID',
    -- Job title
    o.objective as 'Job title',
    -- Company
   (select organization_id from opportunity_organizations where opportunity_id =  o.id and active = 1 group by organization_id limit 1) as 'Company_id',
    -- location
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'Location',
    -- timezones
    (select o.timezones having Location is null) as 'Timezones',
    -- Type of job
    o.commitment_id as 'Type of job',
    -- business_line,
    IFNULL(os.business_line,'torre_free') AS business_line,
    os.reach, 
    os.services,
    -- Agreement type
    o.agreement_type as 'Agreement type',
    -- Opportunity details
    (select opportunity_details.content from opportunity_details where opportunity_details.active = true and opportunity_details.code = 'additional' limit 1) as 'Opportunity detail',
   -- Created date 
    DATE(o.created) as 'Created date',
    -- Approved date
    coalesce(null, o.first_reviewed, o.last_reviewed) as 'Approved date',
    o.review as 'Approved',
    -- Status
    o.status as 'Status',
    -- Reason
    (select Reason from opportunity_changes_history as och where true and type = 'close' and Reason is not null and o.id = och.opportunity_id order by och.created desc limit 1) as 'Reason',
    -- Completed applications
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'Completed applications',
    -- Completed applications yesterday
    sum(case when oc.id is not null and oc.interested is not null and DATE(oc.interested) = DATE(DATE(NOW()) - INTERVAL 1 DAY) then 1 else 0 end) as 'Completed applications yesterday',
    -- Incomplete applications
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as  'Incomplete applications',
    -- Mutual matches pipeline
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and (oc2.name = 'mutual matches' or oc2.name = 'coincidencia mutua')
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Mutual matches',
    -- Real mutual matches
    (select count(distinct occh.candidate_id) from opportunity_candidate_column_history occh inner join opportunity_columns oc ON occh.to = oc.id where oc.name = 'mutual matches' and o.id = oc.opportunity_id)
    as 'Real Mutual matches',
    -- Ready for interview
    (select count(distinct occh.candidate_id) from opportunity_candidate_column_history occh inner join opportunity_columns oc ON occh.to = oc.id where oc.funnel_tag = 'ready_for_interview' and o.id = oc.opportunity_id)
    as 'Ready for interview',
    -- Active
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and (oc2.funnel_tag = 'ready_for_interview'
        or oc2.funnel_tag = 'interview'
        or  oc2.funnel_tag = 'client_testing')
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Real Active',
    -- Others
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and (oc2.name <> 'mutual matches')
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Others',
    -- Hires pipeline
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and (SUBSTRING(oc2.name, 1,5) = 'hired'
    or SUBSTRING(oc2.name, 1,10) = 'contratado')
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Hires pipeline',
    -- Disqualified
    sum(case when oc.id is not null and oc.interested is not null
    and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Disqualified',
    -- Changes history, last updated
    DATE(o.last_updated) as 'Last changes',
    -- Closing date
    DATE(o.deadline) as 'Closing Date',
    -- Closed Date
    (select DATE(och.created) from opportunity_changes_history as och where type = 'close' and o.id = och.opportunity_id and o.status = 'closed' group by och.opportunity_id) as 'Closed date',
    -- Language
    o.locale as 'Language of the post',
    -- Languages required
    (select group_concat(concat(lan.language_code,' : ',lan.fluency)) from opportunity_languages lan where o.id = lan.opportunity_id and lan.active = 1) as 'Languages',
    -- Hires
    (select sum(case when osh.hiring_date is not null then 1 else 0 end) from opportunity_operational_hires osh where o.id=osh.opportunity_id) as 'Hires',
    -- Hires yesterday
    (select sum(case when osh.hiring_date is not null and DATE(osh.hiring_date) = DATE(DATE(NOW()) - INTERVAL 1 DAY) then 1 else 0 end) from opportunity_operational_hires osh where o.id=osh.opportunity_id) as 'Hires yesterday',
    -- First hire date 
    (select min(osh.hiring_date) from opportunity_operational_hires osh where o.id=osh.opportunity_id) as 'First hire date',
    -- Opportunity approved yesterday
   case when DATE(o.last_reviewed) = DATE(DATE(NOW()) - INTERVAL 1 DAY) then TRUE else null end as 'Opportunity approved yesterday',
    -- Completed applications in the last 14 days
    sum(case when oc.id is not null and oc.interested is not null and DATE(oc.created) >= DATE(DATE(NOW()) - INTERVAL 14 DAY) then 1 else 0 end) as 'Completed applications in the last 14 days',
    -- Sharing token
    (select sharing_token from opportunity_members where manager = true and status = 'accepted' and opportunity_id =  o.id  limit 1) as 'Sharing token',
    -- Compensation
    (select GROUP_CONCAT(CONCAT(ifnull(opportunity_compensations.currency,'nan'),' ',ifnull(round(opportunity_compensations.min_amount,0),''),if(opportunity_compensations.code = 'range',' - ',''),ifnull(round(opportunity_compensations.max_amount,0),''),'/',ifnull(opportunity_compensations.periodicity,'nan'))) from opportunity_compensations where opportunity_compensations.active = true and opportunity_compensations.opportunity_id = o.id) as 'Compensation'
FROM 
    opportunities o 
    LEFT JOIN opps_services os ON o.id = os.opportunity_id
    LEFT JOIN opportunity_candidates oc on o.id=oc.opportunity_id
    LEFT JOIN opportunity_columns oc2 on oc.column_id = oc2.id
    LEFT JOIN (
        select me.candidate_id, max(me.interested) as last_interest, max(me.not_interested) as last_not_interest
        from member_evaluations me
        group by me.candidate_id) last_evaluation on last_evaluation.candidate_id = oc.id
WHERE
    o.id IN (
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
    AND DATE(o.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
    AND o.active = TRUE
    AND o.crawled = FALSE 
    AND o.published = TRUE
GROUP BY 
    o.id
ORDER BY 
    o.created desc
) SELECT * FROM main_opps;