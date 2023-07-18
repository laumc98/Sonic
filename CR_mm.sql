/* AA : SONIC : mutual m by candidate recruiters : prod */ 
SELECT
    date(mutual_matches.created) AS 'mutualm_date',
    mutual_matches.utm_campaign AS 'cr_campaign',
    mutual_matches.utm_medium,
    mutual_matches.id AS 'ID',
    count(*) AS 'Mutual matches'
FROM
(
    SELECT
        occh.candidate_id,
        min(occh.created) AS 'created',
        tc.utm_campaign,
        tc.utm_medium,
        o.id
    FROM
        opportunity_candidate_column_history occh
        INNER JOIN opportunity_columns oc ON occh.to = oc.id
        INNER JOIN opportunities o ON oc.opportunity_id = o.id
        LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
        LEFT JOIN tracking_code_candidates tcc ON oca.id = tcc.candidate_id
        LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
        LEFT JOIN people p ON o.candidate_recruiter_person_id = p.id
    WHERE
        oc.name = 'mutual matches'
        AND occh.created >= '2022-10-25'
        AND (tc.utm_campaign = 'amdm'
            OR tc.utm_campaign = 'mcog'
            OR tc.utm_campaign = 'dffa'
            OR tc.utm_campaign = 'czp'
            OR tc.utm_campaign = 'jdpb'
            OR tc.utm_campaign = 'dmc'
            OR tc.utm_campaign = 'nsr'
            OR tc.utm_campaign = 'mmor'
            OR tc.utm_campaign = 'JAMC'
            OR tc.utm_campaign = 'mgdd'
            OR tc.utm_campaign = 'mrh'
            OR tc.utm_campaign = 'srl'
            OR tc.utm_campaign = 'avs'
            OR tc.utm_campaign = 'sbr'
            OR tc.utm_campaign = 'tavp'
            OR tc.utm_campaign = 'rmr' 
            OR tc.utm_campaign = 'dgv'
            OR tc.utm_campaign = 'MER' 
            OR tc.utm_campaign = 'ACMP'
            OR tc.utm_campaign = 'dgc' 
            OR tc.utm_campaign = 'fcr' 
            OR tc.utm_campaign = 'mes' 
        )
        AND tc.utm_medium IN ('src','rc_src','rc_src_trxx_inv','syn','rc_syn','rc_syn_trrx_inv','syn_paid','rc_syn_paid','rc_syn_paid_trrx_inv')
    GROUP BY 
        occh.candidate_id
) AS mutual_matches
GROUP BY 
    date(mutual_matches.created),
    mutual_matches.utm_campaign,
    mutual_matches.utm_medium,
    mutual_matches.id