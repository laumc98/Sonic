/* AA : SONIC : mutual m by candidate recruiters : prod */ 
SELECT
    date(occh.created) AS 'mutualm_date',
    p.name AS 'Candidate Recruiter',
    tc.utm_medium,
    o.id AS 'ID',
    count(distinct occh.candidate_id) AS 'Mutual matches'
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
    AND o.candidate_recruiter_person_id IS NOT NULL
    AND (tc.utm_campaign = 'amdm'
        OR tc.utm_campaign = 'mcog'
        OR tc.utm_campaign = 'dffa'
        OR tc.utm_campaign = 'czp'
        OR tc.utm_campaign = 'jdpb'
        OR tc.utm_campaign = 'dmc'
        OR tc.utm_campaign = 'nsr'
        OR tc.utm_campaign = 'mmor'
    )
    AND tc.utm_medium IN ('src','rc_src','rc_src_trxx_inv','syn','rc_syn','rc_syn_trrx_inv','syn_paid','rc_syn_paid')
GROUP BY 
    date(occh.created),
    tc.utm_medium,
    p.name,
    o.id