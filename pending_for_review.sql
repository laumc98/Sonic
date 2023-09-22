/* AA : Sonic : # of pending for review users by utm: prod */ 
SELECT 
    date(opportunity_candidates.interested) AS application_date,
    opportunities.id,
    opportunities.fulfillment,
    tracking_codes.utm_medium,
    count(distinct opportunity_candidates.id) AS pending_review
FROM
    opportunity_candidates
    INNER JOIN opportunities ON opportunity_candidates.opportunity_id = opportunities.id
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id 
    LEFT JOIN opportunity_candidate_column_history ON opportunity_candidates.id = opportunity_candidate_column_history.candidate_id
    LEFT JOIN member_evaluations ON opportunity_candidates.id = member_evaluations.candidate_id
    LEFT JOIN people ON opportunity_candidates.person_id = people.id
WHERE
    opportunity_candidates.interested IS NOT NULL
    AND opportunity_candidate_column_history.created IS NULL
    AND member_evaluations.not_interested IS NULL
    AND opportunities.review = 'approved'
    AND opportunities.crawled = FALSE 
    AND DATE(opportunities.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
    AND DATE(opportunity_candidates.interested) > date(date_add(now(6), INTERVAL -1 year))
GROUP BY
    application_date,
    opportunities.id,
    opportunities.fulfillment,
    tracking_codes.utm_medium