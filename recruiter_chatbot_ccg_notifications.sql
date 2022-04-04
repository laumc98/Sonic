SELECT TRIM('"' FROM JSON_EXTRACT(`notifications`.`context`, '$.opportunityId')) as 'Alfa ID', count(*) as 'rc_ccg_notifications'
FROM `notifications` INNER JOIN `person_flags` `Person Flags - To` ON `notifications`.`to` = `Person Flags - To`.`person_id`
WHERE (`notifications`.`template` = 'career-advisor-job-opportunity'
   AND `notifications`.`status` = 'sent'
   AND `Person Flags - To`.`community_created_claimed_at` is null)
GROUP BY 1