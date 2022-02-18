select
   opportunity_candidates.opportunity_id as ID,
   date(opportunities.reviewed) as approved_date,
   date(opportunity_candidates.interested) as interested_date,
   `Tracking Codes`.`utm_medium` as utm_medium,
   min(IF (date(opportunities.reviewed) < date(opportunity_candidates.interested), timestampdiff(day, date(opportunities.reviewed),date(opportunity_candidates.interested)), (timestampdiff(day, date(opportunity_candidates.interested),date(opportunities.reviewed))*-1))) AS 'RT'
FROM opportunity_candidates
LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Person` ON `opportunity_candidates`.`id` = `Tracking Code Candidates - Person`.`candidate_id`
LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Person`.`tracking_code_id` = `Tracking Codes`.`id`
LEFT JOIN opportunities on opportunities.id = opportunity_candidates.opportunity_id
WHERE opportunity_candidates.interested is not null AND utm_medium IN ('srh_jobs','ja_mtc','rc_trrx_inv','rc_cb_rcdt')
group by ID, utm_medium
order by ID desc