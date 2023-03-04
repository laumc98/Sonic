/* AA : Sonic : incomplete app by channel: prod */ 
SELECT
    opportunity_candidates.opportunity_id AS ID,
    tracking_codes.utm_medium AS UTM,
    count(distinct opportunity_candidates.id) AS incompletes
FROM
    opportunity_candidates
    INNER JOIN opportunities ON opportunity_candidates.opportunity_id = opportunities.id
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
WHERE
    application_step IS NOT NULL
    AND opportunity_candidates.interested IS NULL
    AND DATE(opportunities.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
GROUP BY
    opportunity_candidates.opportunity_id,
    tracking_codes.utm_medium