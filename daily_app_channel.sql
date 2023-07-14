/* AA : SONIC : daily app per channel : prod */ 
SELECT
    date(opportunity_candidates.created) AS started_date, 
    date(opportunity_candidates.interested) AS application_date,
    opportunities.id AS ID,
    IF(ISNULL(opportunity_candidates.interested), 'started', 'finished') AS status,
    tracking_codes.utm_medium AS utm_medium,
    tracking_codes.utm_source AS utm_source,
    count(distinct opportunity_candidates.id) AS applications
FROM
    opportunity_candidates
    INNER JOIN opportunities ON opportunity_candidates.opportunity_id = opportunities.id
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
WHERE
    opportunity_candidates.application_step IS NOT NULL
    AND opportunities.review = 'approved'
    AND DATE(opportunity_candidates.created) >= date(date_add(now(6), INTERVAL -3 month))
    AND opportunities.id = 1884566
GROUP BY 
    date(opportunity_candidates.created),
    date(opportunity_candidates.interested),
    opportunities.id,
    IF(ISNULL(opportunity_candidates.interested), 'started', 'finished'),
    tracking_codes.utm_medium,
    tracking_codes.utm_source