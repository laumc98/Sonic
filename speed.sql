/* AA : Sonic : speed metrics: prod */ 
SELECT
    opportunities.id AS 'ID',
    src_applications.first_app_date AS 'src_first_app_date',
    syn_applications.first_app_date AS 'syn_first_app_date',
    paid_syn_applications.first_app_date AS 'paid_syn_first_app_date'
FROM 
    opportunities
    LEFT JOIN (
        SELECT
            opportunity_candidates.opportunity_id AS 'ID',
            min(opportunity_candidates.interested) AS 'first_app_date'
        FROM 
            opportunity_candidates
            LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
            LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
        WHERE
            opportunity_candidates.interested IS NOT NULL
            AND (tracking_codes.utm_medium = 'rc_src'
                    OR tracking_codes.utm_medium = 'rc_src_trxx_inv')
        GROUP BY
            opportunity_candidates.opportunity_id
    ) AS src_applications ON opportunities.ID = src_applications.ID
    LEFT JOIN (
        SELECT
            opportunity_candidates.opportunity_id AS 'ID',
            min(opportunity_candidates.interested) AS 'first_app_date'
        FROM 
            opportunity_candidates
            LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
            LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
        WHERE
            opportunity_candidates.interested IS NOT NULL
            AND (tracking_codes.utm_medium = 'syn'
                    OR tracking_codes.utm_medium = 'rc_syn'
                    OR tracking_codes.utm_medium = 'rc_syn_trrx_inv')
        GROUP BY
            opportunity_candidates.opportunity_id
    ) AS syn_applications ON opportunities.ID = syn_applications.ID
    LEFT JOIN (
        SELECT
            opportunity_candidates.opportunity_id AS 'ID',
            min(opportunity_candidates.interested) AS 'first_app_date'
        FROM 
            opportunity_candidates
            LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
            LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
        WHERE
            opportunity_candidates.interested IS NOT NULL
            AND (tracking_codes.utm_medium = 'syn_paid'
                    OR tracking_codes.utm_medium = 'rc_syn_paid'
                    OR tracking_codes.utm_medium = 'rc_syn_paid_trxx_inv')
        GROUP BY
            opportunity_candidates.opportunity_id
    ) AS paid_syn_applications ON opportunities.ID = paid_syn_applications.ID
WHERE
    opportunities.review = 'approved'
    AND opportunities.active = TRUE
    AND opportunities.candidate_recruiter_person_id IS NOT NULL
    AND DATE(opportunities.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
GROUP BY 
    opportunities.id