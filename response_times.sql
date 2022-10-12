/* AA : Sonic : response times: prod */ 
select
   opportunity_candidates.opportunity_id as ID,
   date(opportunities.last_reviewed) as approved_date,
   date(opportunity_candidates.interested) as interested_date,
   tracking_codes.utm_medium as utm_medium,
   min(
      IF (
         date(opportunities.last_reviewed) < date(opportunity_candidates.interested),
         timestampdiff(
            day,
            date(opportunities.last_reviewed),
            date(opportunity_candidates.interested)
         ),
         (
            timestampdiff(
               day,
               date(opportunity_candidates.interested),
               date(opportunities.last_reviewed)
            ) * -1
         )
      )
   ) AS 'RT'
FROM
   opportunity_candidates
   LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
   LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
   LEFT JOIN opportunities on opportunities.id = opportunity_candidates.opportunity_id
WHERE
   opportunity_candidates.interested is not null
   AND opportunities.last_reviewed > date(date_add(now(6), INTERVAL -1 year))
   AND utm_medium IN (
      'ja_mtc',
      'ja_rlvsgl_prs',
      'ja_allsgl_prs',
      'ja_rlvsgl_org',
      'ja_allsgl_org',
      'rc_cb_rcdt',
      'rc_ccg',
      'rc_syn',
      'rc_src',
      'am_sug',
      'srh_jobs',
      'sml_jobs',
      'am_inv',
      'google_jobs',
      'fb_jobs',
      'ref_ts',
      'shr_ts',
      'ro_sug',
      'pr_sml_jobs',
      'rc_trrx_inv',
      'syn',
      'src',
      'ref_ptn',
      'ref_cdt',
      'ref_vst_imp',
      'syn_rqt',
      'trr_webinars'
   )
group by
   ID,
   utm_medium
order by
   ID desc