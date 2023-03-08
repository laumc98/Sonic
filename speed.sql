/* AA : Sonic : speed metrics: prod */ 
SELECT 
    semiraw.ID,
    min(IF(
        utm IN (
            'syn_paid',
            'rc_syn_paid',
            'rc_syn_paid_trxx_inv'
        ),
        first_app_date,
        NULL
    )) AS paid_syn_first_app_date,
    min(IF(
        utm IN (
            'syn',
            'rc_syn',
            'rc_syn_paid_trxx_inv'
        ),
        first_app_date,
        NULL
    )) AS syn_first_app_date,
    min(IF(
        utm IN (
            'src',
            'rc_src',
            'rc_src_trxx_inv'
        ),
        first_app_date,
        NULL
    )) AS src_first_app_date
FROM
    (
        SELECT
            opportunity_candidates.opportunity_id AS 'ID',
            tracking_codes.utm_medium AS utm,
            min(opportunity_candidates.interested) AS 'first_app_date'
        FROM
            opportunity_candidates
            LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
            LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
        WHERE
            DATE(opportunity_candidates.created) >= date(date_add(now(6), INTERVAL -1 YEAR))
            AND tracking_codes.utm_medium IN (
                'syn_paid',
                'rc_syn_paid',
                'rc_syn_paid_trxx_inv',
                'syn',
                'rc_syn',
                'rc_syn_paid_trxx_inv',
                'src',
                'rc_src',
                'rc_src_trxx_inv'
            )
        GROUP BY
            opportunity_candidates.opportunity_id,
            utm
    ) semiraw
    INNER JOIN opportunities ON semiraw.ID = opportunities.id AND opportunities.review = 'approved'
GROUP BY 
    semiraw.ID