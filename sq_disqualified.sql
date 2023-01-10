/* AA : Sonic : SQ disqualified: prod */
SELECT
    `max_rank`.`id` AS `candidate_id`,
    `max_rank`.`Opportunity_ID` AS `Opportunity ID`,
    `max_rank`.`name` AS `People__name`,
    `max_rank`.`username` AS `People__username`,
    `max_rank`.`not_interested` AS `not_interested`,
    `tracking_codes`.`utm_medium` AS `Tracking Codes__utm_medium`,
    `max_rank`.`reason` AS `reason`,
    `opportunity_questions`.`question_id`,
    `max_rank`.`rank`,
    `opportunity_candidate_responses`.`id` AS `answer_id`,
    `questions`.`title` AS `Questions_title`,
    `questions`.`purpose` AS `Questions_purpose`,
    `questions`.`type` AS `Questions_type`,
    `questions`.`locale` AS `Questions_locale`,
    `max_rank`.`text` AS `Notes`
FROM
    (
        SELECT
            `opportunity_candidates`.`id`,
            `opportunity_questions`.`opportunity_id` AS `Opportunity_ID`,
            max(`opportunity_questions`.`rank`) AS `rank`,
            `people`.`name`,
            `people`.`username`,
            `member_evaluations`.`not_interested`,
            `member_evaluations_reason`.`reason`,
            `comments`.`text`
        FROM
            `opportunity_candidates`
            INNER JOIN `opportunity_questions` ON (`opportunity_candidates`.`opportunity_id` = `opportunity_questions`.`opportunity_id`) AND `opportunity_questions`.`active` IS TRUE
            LEFT JOIN `member_evaluations` ON `member_evaluations`.`candidate_id` = `opportunity_candidates`.`id`
            LEFT JOIN `member_evaluations_reason` ON `member_evaluations`.`id` = `member_evaluations_reason`.`member_evaluation_id`
            LEFT JOIN `questions` ON `opportunity_questions`.`question_id` = `questions`.`id`
            LEFT JOIN `opportunity_candidate_responses` ON (`opportunity_candidates`.`id` = `opportunity_candidate_responses`.`candidate_id` AND `opportunity_questions`.`question_id` = `opportunity_candidate_responses`.`question_id`) AND `opportunity_candidate_responses`.`active` IS TRUE
            LEFT JOIN `people` ON `opportunity_candidates`.`person_id` = `people`.`id`
            LEFT JOIN `comments` ON (`people`.`id` = `comments`.`candidate_person_id` AND `opportunity_candidates`.`opportunity_id` = `comments`.`opportunity_id`)
        WHERE
            (
                `questions`.`purpose` = 'filter'
                AND `opportunity_candidate_responses`.`id` IS NOT NULL
                AND `member_evaluations`.`not_interested` IS NOT NULL
                AND `member_evaluations_reason`.`reason` = 'screening-questions'
            )
        GROUP BY
            `opportunity_candidates`.`id`,
            `opportunity_candidates`.`opportunity_id`
    ) AS `max_rank`
    INNER JOIN `opportunity_questions` ON (`max_rank`.`rank` = `opportunity_questions`.`rank` AND `max_rank`.`Opportunity_ID` = `opportunity_questions`.`opportunity_id`) AND `opportunity_questions`.`active` IS TRUE
    LEFT JOIN `questions` ON `opportunity_questions`.`question_id` = `questions`.`id`
    LEFT JOIN `opportunity_candidate_responses` ON (`max_rank`.`id` = `opportunity_candidate_responses`.`candidate_id` AND `opportunity_questions`.`question_id` = `opportunity_candidate_responses`.`question_id`) AND `opportunity_candidate_responses`.`active` IS TRUE
    LEFT JOIN `tracking_code_candidates`  ON `max_rank`.`id` = `tracking_code_candidates`.`candidate_id`
    LEFT JOIN `tracking_codes` ON `tracking_code_candidates`.`tracking_code_id` = `tracking_codes`.`id`    
WHERE
    `max_rank`.`not_interested` >= date(date_add(now(6), INTERVAL -90 day))
ORDER BY
    `Opportunity ID` DESC