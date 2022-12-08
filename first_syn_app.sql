SELECT
    opportunity_candidates.opportunity_id AS 'ID',
    tracking_codes.utm_medium,
    min(opportunity_candidates.interested) AS 'first_app_date'
FROM 
    opportunity_candidates
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
WHERE
    opportunity_candidates.interested IS NOT NULL
    AND (tracking_codes.utm_medium = 'syn'
            OR tracking_codes.utm_medium = 'rc_syn'
            OR tracking_codes.utm_medium = 'syn_paid'
            or tracking_codes.utm_medium = 'rc_syn_paid')
    AND tracking_codes.utm_campaign IN ('amdm','mcog','dffa','czp','jdpb','dmc','nsr','mmor')
GROUP BY
    opportunity_candidates.opportunity_id,
    tracking_codes.utm_medium