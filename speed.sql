/* AA : Sonic : speed metrics: prod */ 
SELECT
    opportunity_candidates.opportunity_id AS 'ID',
    tracking_codes.utm_medium AS utm,
    tracking_codes.utm_campaign AS utm_campaign, 
    opportunity_candidates.interested AS 'app_date'
FROM
    opportunity_candidates
    INNER JOIN opportunities ON opportunity_candidates.opportunity_id = opportunities.id 
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
WHERE
    DATE(opportunities.last_reviewed) >= date(date_add(now(6), INTERVAL -1 year))
    AND opportunity_candidates.interested IS NOT NULL
    AND tracking_codes.utm_medium IN (
            'syn_paid',
            'rc_syn_paid',
            'rc_syn_paid_trxx_inv',
            'syn',
            'rc_syn',
            'rc_syn_trxx_inv',
            'src',
            'rc_src',
            'rc_src_trxx_inv'
        )
GROUP BY
    opportunity_candidates.opportunity_id,
    utm,
    utm_campaign