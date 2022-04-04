SELECT 
`member_evaluations`.`candidate_id` AS `candidate_id`, 
`People`.`name` AS `People__name`, 
`People`.`username` AS `People__username`,
`Opportunity Candidates - Candidate`.`opportunity_id` AS `Opportunity ID`,
`Opportunity Candidates - Candidate`.`interested` AS `Opportunity Candidates - Candidate__interested`,
`member_evaluations`.`interested` AS `interested`, 
`member_evaluations`.`not_interested` AS `not_interested`, 
`member_evaluations`.`reason` AS `reason`, 
`Tracking Codes`.`utm_medium` AS `Tracking Codes__utm_medium`,
`Opportunity columns - pipeline`.`name` AS `Pipeline`
FROM `member_evaluations`
LEFT JOIN `opportunity_candidates` `Opportunity Candidates - Candidate` ON `member_evaluations`.`candidate_id` = `Opportunity Candidates - Candidate`.`id` 
LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Candidate` ON `member_evaluations`.`candidate_id` = `Tracking Code Candidates - Candidate`.`candidate_id` 
LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Candidate`.`tracking_code_id` = `Tracking Codes`.`id` 
LEFT JOIN `people` `People` ON `Opportunity Candidates - Candidate`.`person_id` = `People`.`id`
LEFT JOIN `opportunity_columns` `Opportunity columns - pipeline` ON `Opportunity Candidates - Candidate`.`column_id` = `Opportunity columns - pipeline`.`id`
WHERE `Opportunity Candidates - Candidate`.`interested` >= date(date_add(now(6), INTERVAL -262 day))