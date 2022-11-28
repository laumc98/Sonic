/* AA : SONIC : hires by candidate recruiters : prod */ 
SELECT
   `opportunity_operational_hires`.`opportunity_id` AS `ID`,
   `opportunity_operational_hires`.`opportunity_candidate_id` AS `candidate_id`,
   `opportunity_operational_hires`.`hiring_date` AS `hiring_date`,
   `People - Candidate Recruiter Person`.`name` AS `Candidate Recruiter`
FROM
   `opportunity_operational_hires`
   LEFT JOIN `opportunities` `Opportunities` ON `opportunity_operational_hires`.`opportunity_id` = `Opportunities`.`id`
   LEFT JOIN `people` `People - Candidate Recruiter Person` ON `Opportunities`.`candidate_recruiter_person_id` = `People - Candidate Recruiter Person`.`id`
   LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Opportunity Candidate` ON `opportunity_operational_hires`.`opportunity_candidate_id` = `Tracking Code Candidates - Opportunity Candidate`.`candidate_id`
WHERE
   (
      `Opportunities`.`candidate_recruiter_person_id` IS NOT NULL
      AND `opportunity_operational_hires`.`hiring_date` >= '2022-10-23'
   )
ORDER BY
   `opportunity_operational_hires`.`opportunity_id` DESC