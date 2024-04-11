/* AA : SONIC : mutual m by candidate recruiters : prod */ 
SELECT
    date(applications.timestamp) AS 'mutualm_date',
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.utm_medium AS 'utm_medium',
    applications.utm_campaign AS 'cr_campaign',
    count(*) AS 'unique_hqa_mm'
FROM
    applications
    LEFT JOIN opportunity ON applications.opportunity_reference_id = opportunity.ref_id
    LEFT JOIN mutual_matches ON (mutual_matches.gg_id = applications.gg_id AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id)
WHERE
    (applications.filters_passed = true
    OR mutual_matches.timestamp IS NOT NULL)
    AND (applications.utm_campaign = 'amdm'
        OR applications.utm_campaign = 'mcog'
        OR applications.utm_campaign = 'dffa'
        OR applications.utm_campaign = 'czp'
        OR applications.utm_campaign = 'jdpb'
        OR applications.utm_campaign = 'dmc'
        OR applications.utm_campaign = 'nsr'
        OR applications.utm_campaign = 'mmor'
        OR applications.utm_campaign = 'JAMC'
        OR applications.utm_campaign = 'mgdd'
        OR applications.utm_campaign = 'mrh'
        OR applications.utm_campaign = 'srl'
        OR applications.utm_campaign = 'avs'
        OR applications.utm_campaign = 'sbr'
        OR applications.utm_campaign = 'tavp'
        OR applications.utm_campaign = 'rmr' 
        OR applications.utm_campaign = 'dgv'
        OR applications.utm_campaign = 'MER' 
        OR applications.utm_campaign = 'ACMP'
        OR applications.utm_campaign = 'dgc'
        OR applications.utm_campaign = 'fcr'
        OR applications.utm_campaign = 'mes'
        OR applications.utm_campaign = 'mcmn'
        OR applications.utm_campaign = 'mfo'
        OR applications.utm_campaign = 'smfp'
        OR applications.utm_campaign = 'gebj'
        OR applications.utm_campaign = 'aamf'
        OR applications.utm_campaign = 'eb'
        OR applications.utm_campaign = 'kglm'
        OR applications.utm_campaign = 'sm'
        OR applications.utm_campaign = 'brc'
        OR applications.utm_campaign = 'vaio'
        OR applications.utm_campaign = 'exrm'
        OR applications.utm_campaign = 'jsmn'
        OR applications.utm_campaign = 'lfas'
        OR applications.utm_campaign = 'malm'
        OR applications.utm_campaign = 'lbmp'
        OR applications.utm_campaign = 'capi'
        OR applications.utm_campaign = 'cals'
        OR applications.utm_campaign = 'bb'
        OR applications.utm_campaign = 'jcmv'
        OR applications.utm_campaign = 'egc'
        OR applications.utm_campaign = 'mdr'
        OR applications.utm_campaign = 'grtt'
    )
    AND applications.utm_medium IN ('src','rc_src','rc_src_trrx_inv','syn','rc_syn','rc_syn_trrx_inv','syn_paid','rc_syn_paid','rc_syn_paid_trrx_inv','syn_rqt','rc_syn_rqt')
GROUP BY
    date(applications.timestamp),
    applications.opportunity_reference_id,
    applications.utm_medium,
    applications.utm_campaign