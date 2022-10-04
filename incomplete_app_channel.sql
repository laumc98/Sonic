/* AA : Sonic : incomplete app by channel: prod */ 
SELECT
    opportunity_candidates.opportunity_id AS ID,
    tracking_codes.utm_medium AS UTM,
    count(distinct opportunity_candidates.id) AS incompletes
FROM
    opportunity_candidates
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
WHERE
    application_step IS NOT NULL
    AND opportunity_candidates.interested IS NULL
GROUP BY
    opportunity_candidates.opportunity_id,
    tracking_codes.utm_medium