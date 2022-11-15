SELECT
    `opportunities`.`id` AS `ID`,
    `opportunity_members`.`sharing_token` AS `sharing_token`,
    `people`.`name` AS `Name`,
    `people`.`username` AS `Username`,
    `Opportunity Candidates`.`interested` AS `Interested_date`,
    max(`member_evaluations`.`not_interested`) AS `Disqualified_date`,
    `member_evaluations_reason`.`reason` AS `reason_2_Syn`,
    `Member Evaluation Feedback - Feedback`.`feedback` AS `Other reason disqualified`,
    `Tracking Codes`.`utm_medium` AS `UTM`
FROM
    `opportunities`
    LEFT JOIN `opportunity_candidates` `Opportunity Candidates` ON `opportunities`.`id` = `Opportunity Candidates`.`opportunity_id`
    LEFT JOIN `people` ON `Opportunity Candidates`.`person_id` = `people`.`id`
    LEFT JOIN `member_evaluations` ON `Opportunity Candidates`.`id` = `member_evaluations`.`candidate_id` 
    LEFT JOIN `member_evaluations_reason` ON `member_evaluations`.`id` = `member_evaluations_reason`.`member_evaluation_id`
    LEFT JOIN `member_evaluation_feedback` `Member Evaluation Feedback - Feedback` ON `member_evaluations_reason`.`feedback_id` = `Member Evaluation Feedback - Feedback`.`id`
    LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates` ON `Opportunity Candidates`.`id` = `Tracking Code Candidates`.`candidate_id`
    LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates`.`tracking_code_id` = `Tracking Codes`.`id` 
    LEFT JOIN `opportunity_members` ON `opportunities`.`id` = `opportunity_members`.`opportunity_id` AND (`opportunity_members`.`manager` = true AND `opportunity_members`.`status` = 'accepted')
WHERE
   (
       `Tracking Codes`.`utm_medium` = 'rc_syn'
       OR `Tracking Codes`.`utm_medium` = 'syn'
       OR `Tracking Codes`.`utm_medium` = 'rc_src'
   )
   AND `Opportunity Candidates`.`interested` IS NOT NULL
   AND `member_evaluations`.`not_interested` IS NOT NULL
   AND `Opportunity Candidates`.`interested` >= date(date_add(now(6), INTERVAL -90 day))
GROUP BY 
   `opportunities`.`id`,
   `people`.`username`