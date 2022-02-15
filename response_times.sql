select
   opportunity_candidates.opportunity_id as ID,
   date(opportunities.reviewed) as approved_date,
   date(opportunity_candidates.interested) as interested_date,
   `Tracking Codes`.`utm_medium` as utm_medium,
    (select timestampdiff(day, approved_date,min(interested_date)) where interested_date is not null and utm_medium = 'srh_jobs') as 'Response Time Job Search',
    (select timestampdiff(day, approved_date,min(interested_date)) where interested_date is not null and utm_medium = 'ja_mtc') as 'Response Time Job Alerts from Preferences Matches',
    (select timestampdiff(day, approved_date,min(interested_date)) where interested_date is not null and utm_medium = 'rc_trrx_inv') as 'Response Time Manual invite by Torrex of registered candidates (internal sourcing)',
    (select timestampdiff(day, approved_date,min(interested_date)) where interested_date is not null and utm_medium = 'rc_cb_rcdt') as 'Response Time Career Advisor'
FROM opportunity_candidates
LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Person` ON `opportunity_candidates`.`id` = `Tracking Code Candidates - Person`.`candidate_id`
LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Person`.`tracking_code_id` = `Tracking Codes`.`id`
LEFT JOIN opportunities on opportunities.id = opportunity_candidates.opportunity_id
group by  ID