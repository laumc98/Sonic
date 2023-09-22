/* AA : Sonic : started/finished app: prod */ 
select
    o.id as ID,
    IF(ISNULL(interested), 'started', 'finished') as finished,
    tc.utm_medium as UTM,
    count(distinct opportunity_candidates.id) as applications
from
    opportunity_candidates
    inner join opportunities as o on opportunity_candidates.opportunity_id = o.id
    left join tracking_code_candidates as tcc
    left join tracking_codes as tc on tcc.tracking_code_id = tc.id on tcc.candidate_id = opportunity_candidates.id
    left join opportunity_members on o.id = opportunity_members.opportunity_id and poster = 1
    left join people on opportunity_members.person_id = people.id
    left join person_flags on people.id = person_flags.person_id
where
    date(opportunity_candidates.created) > date(date_add(now(6), INTERVAL -1 year))
    AND o.objective not like '***%'
    AND o.crawled = FALSE 
    and tc.utm_medium in (
        'srh_jobs',
        'ja_mtc',
        'am_sug',
        'rc_am_sug',
        'am_inv',
        'rc_cb_rcdt',
        'rc_trrx_inv',
        'ro_sug',
        'rc_syn',
        'rc_src',
        'rc_ccg',
        'pr_sml_jobs',
        'syn',
        'src',
        'sml_jobs',
        'rc_sml_jobs',
        'trr_crg',
        'trr_webinars',
        'google_jobs',
        'syn_rqt',
        'rc_syn_rqt',
        'shr_ts',
        'ref_ts',
        'ref_ptn',
        'ref_cdt',
        'ref_vst_imp',
        'ja_rlvsgl_prs',
        'ja_allsgl_prs',
        'ja_rlvsgl_org',
        'ja_allsgl_org',
        'syn_paid',
        'rc_syn_paid',
        'rc_src_trrx_inv',
        'rc_syn_trrx_inv',
        'rc_syn_paid_trrx_inv'
    )
group by ID,finished,UTM