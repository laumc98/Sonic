/* AA : Sonic : quality check: prod */ 
SELECT
    `member_evaluations`.`candidate_id` AS `candidate_id`,
    `People`.`gg_id` AS `gg_id`,
    `People`.`name` AS `People__name`,
    `People`.`username` AS `People__username`,
    `Opportunity Candidates - Candidate`.`opportunity_id` AS `Opportunity ID`,
    (select `people`.`name` FROM `people`  WHERE `opportunities`.`candidate_recruiter_person_id` = `people`.`id`) as `Candidate Recruiter`,
    max(`Opportunity Candidates - Candidate`.`interested`) AS `interested`,
    max(`member_evaluations`.`not_interested`) AS `not_interested`,
    max(`member_evaluations_reason`.`reason`) AS `reason_2`,
    `Tracking Codes`.`utm_medium` AS `Tracking Codes__utm_medium`,
    `Opportunity Columns - Column`.`name` AS `Pipeline`,
    `Opportunity Columns - Column`.`funnel_tag` AS `Funnel tag`,
    max(`Member Evaluation Feedback - Feedback`.`feedback`) AS `Reason - Others`,
    `Comments`.`text` AS `Notes`
FROM
    `member_evaluations`
    LEFT JOIN `opportunity_candidates` `Opportunity Candidates - Candidate` ON `member_evaluations`.`candidate_id` = `Opportunity Candidates - Candidate`.`id`
    LEFT JOIN `opportunities` ON `opportunities`.`id` = `Opportunity Candidates - Candidate`.`opportunity_id`
    LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Candidate` ON `member_evaluations`.`candidate_id` = `Tracking Code Candidates - Candidate`.`candidate_id`
    LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Candidate`.`tracking_code_id` = `Tracking Codes`.`id`
    LEFT JOIN `people` `People` ON `Opportunity Candidates - Candidate`.`person_id` = `People`.`id`
    LEFT JOIN `opportunity_columns` `Opportunity Columns - Column` ON `Opportunity Candidates - Candidate`.`column_id` = `Opportunity Columns - Column`.`id`
    LEFT JOIN `member_evaluations_reason` ON `member_evaluations`.`id` = `member_evaluations_reason`.`member_evaluation_id`
    LEFT JOIN `member_evaluation_feedback` `Member Evaluation Feedback - Feedback` ON `member_evaluations_reason`.`feedback_id` = `Member Evaluation Feedback - Feedback`.`id` 
    LEFT JOIN `comments` `Comments` ON `People`.`id` = `Comments`.`candidate_person_id` AND `Opportunity Candidates - Candidate`.`opportunity_id` = `Comments`.`opportunity_id`
WHERE
    `Opportunity Candidates - Candidate`.`interested` >= date(date_add(now(6), INTERVAL -60 day))
GROUP BY `member_evaluations`.`candidate_id`,`Opportunity Candidates - Candidate`.`opportunity_id`
ORDER BY `member_evaluations`.`not_interested` DESC
